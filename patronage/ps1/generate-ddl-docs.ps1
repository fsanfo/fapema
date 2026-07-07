param(
    [string]$DdlsPath = ".\patronage\ddls",
    [string]$DocsPath = ".\patronage\docs",
    [string]$TemplatePath = ".\patronage\docs\processos.md",
    [switch]$OverwriteProcessos
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Convert-ToLines {
    param([string]$Text)
    return ($Text -split "`r?`n")
}

function Get-CreateTableSql {
    param([string]$Raw)

    $match = [regex]::Match($Raw, 'Create Table:\s*(CREATE TABLE[\s\S]+)$', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if (-not $match.Success) {
        return $null
    }

    return $match.Groups[1].Value.Trim()
}

function Get-BalancedBody {
    param([string]$CreateSql)

    $openPos = $CreateSql.IndexOf('(')
    if ($openPos -lt 0) { return $null }

    $depth = 0
    $inString = $false
    for ($i = $openPos; $i -lt $CreateSql.Length; $i++) {
        $ch = $CreateSql[$i]

        if ($ch -eq "'") {
            if ($inString) {
                if (($i + 1 -lt $CreateSql.Length) -and ($CreateSql[$i + 1] -eq "'")) {
                    $i++
                    continue
                }
                $inString = $false
                continue
            }

            $inString = $true
            continue
        }

        if ($inString) {
            continue
        }

        if ($ch -eq '(') { $depth++ }
        elseif ($ch -eq ')') {
            $depth--
            if ($depth -eq 0) {
                return @{
                    Body = $CreateSql.Substring($openPos + 1, $i - $openPos - 1)
                    Tail = $CreateSql.Substring($i + 1)
                }
            }
        }
    }

    return $null
}

function Parse-TableDefinition {
    param([string]$CreateSql)

    $tableMatch = [regex]::Match($CreateSql, 'CREATE TABLE\s+`(?<table>[^`]+)`\s*\(', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if (-not $tableMatch.Success) { return $null }

    $table = $tableMatch.Groups['table'].Value
    $balanced = Get-BalancedBody -CreateSql $CreateSql
    if ($null -eq $balanced) { return $null }

    $body = $balanced.Body
    $tail = $balanced.Tail

    $engine = 'N/A'
    $charset = 'N/A'
    $collation = 'N/A'

    $engineMatch = [regex]::Match($tail, 'ENGINE\s*=\s*([A-Za-z0-9_]+)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if ($engineMatch.Success) { $engine = $engineMatch.Groups[1].Value }

    $charsetMatch = [regex]::Match($tail, 'DEFAULT\s+CHARSET\s*=\s*([A-Za-z0-9_]+)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if ($charsetMatch.Success) { $charset = $charsetMatch.Groups[1].Value }

    $collationMatch = [regex]::Match($tail, 'COLLATE\s*=\s*([A-Za-z0-9_]+)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if ($collationMatch.Success) { $collation = $collationMatch.Groups[1].Value }

    $items = Convert-ToLines -Text $body

    $columns = New-Object System.Collections.Generic.List[object]
    $indexes = New-Object System.Collections.Generic.List[object]
    $foreignKeys = New-Object System.Collections.Generic.List[object]

    foreach ($rawLine in $items) {
        $line = $rawLine.Trim()
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        if ($line.EndsWith(',')) { $line = $line.Substring(0, $line.Length - 1) }

        if ($line -match '^`') {
            $colMatch = [regex]::Match($line, '^`(?<name>[^`]+)`\s+(?<rest>.+)$')
            if (-not $colMatch.Success) { continue }

            $colName = $colMatch.Groups['name'].Value
            $rest = $colMatch.Groups['rest'].Value

            $type = 'N/A'
            $typeMatch = [regex]::Match($rest, '^(?<type>[A-Za-z]+(?:\([^\)]*\))?(?:\s+unsigned)?)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            if ($typeMatch.Success) {
                $type = $typeMatch.Groups['type'].Value
            }

            $nullable = if ($rest -match '\bNOT\s+NULL\b') { 'Nao' } else { 'Sim' }

            $defaultVal = ''
            $defaultMatch = [regex]::Match($rest, "\bDEFAULT\s+((?:'[^']*')|(?:NULL)|(?:CURRENT_TIMESTAMP(?:\(\))?)|(?:[A-Za-z0-9_\.-]+))", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            if ($defaultMatch.Success) {
                $defaultVal = $defaultMatch.Groups[1].Value
            }

            $comment = ''
            $commentMatch = [regex]::Match($rest, "\bCOMMENT\s+'([^']*)'", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            if ($commentMatch.Success) {
                $comment = $commentMatch.Groups[1].Value
            }

            $isAutoIncrement = $rest -match '\bAUTO_INCREMENT\b'

            $columns.Add([PSCustomObject]@{
                Name = $colName
                Type = $type
                Nullable = $nullable
                Default = $defaultVal
                Comment = $comment
                AutoIncrement = $isAutoIncrement
            }) | Out-Null
            continue
        }

        $pkMatch = [regex]::Match($line, '^PRIMARY\s+KEY\s*\((?<cols>[^\)]+)\)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($pkMatch.Success) {
            $cols = ($pkMatch.Groups['cols'].Value -split ',') | ForEach-Object { $_.Trim().Trim('`') }
            $indexes.Add([PSCustomObject]@{
                Name = 'PRIMARY'
                Type = 'BTREE'
                Columns = $cols
                Purpose = 'Chave primaria da tabela.'
            }) | Out-Null
            continue
        }

        $ukMatch = [regex]::Match($line, '^UNIQUE\s+KEY\s+`(?<name>[^`]+)`\s*\((?<cols>[^\)]+)\)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($ukMatch.Success) {
            $cols = ($ukMatch.Groups['cols'].Value -split ',') | ForEach-Object { $_.Trim().Trim('`') }
            $indexes.Add([PSCustomObject]@{
                Name = $ukMatch.Groups['name'].Value
                Type = 'UNIQUE'
                Columns = $cols
                Purpose = 'Garante unicidade dos dados indexados.'
            }) | Out-Null
            continue
        }

        $kMatch = [regex]::Match($line, '^KEY\s+`(?<name>[^`]+)`\s*\((?<cols>[^\)]+)\)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($kMatch.Success) {
            $cols = ($kMatch.Groups['cols'].Value -split ',') | ForEach-Object { $_.Trim().Trim('`') }
            $indexes.Add([PSCustomObject]@{
                Name = $kMatch.Groups['name'].Value
                Type = 'KEY'
                Columns = $cols
                Purpose = 'Acelera filtros e operacoes de juncao.'
            }) | Out-Null
            continue
        }

        $fkMatch = [regex]::Match(
            $line,
            '^CONSTRAINT\s+`(?<name>[^`]+)`\s+FOREIGN\s+KEY\s*\(`(?<local>[^`]+)`\)\s+REFERENCES\s+`(?<refTable>[^`]+)`\s*\(`(?<refCol>[^`]+)`\)(?<actions>.*)$',
            [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        )

        if ($fkMatch.Success) {
            $actions = $fkMatch.Groups['actions'].Value

            $onDelete = 'RESTRICT'
            $onUpdate = 'RESTRICT'

            $delMatch = [regex]::Match($actions, 'ON\s+DELETE\s+(CASCADE|SET\s+NULL|RESTRICT|NO\s+ACTION)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            if ($delMatch.Success) { $onDelete = $delMatch.Groups[1].Value.ToUpperInvariant() }

            $updMatch = [regex]::Match($actions, 'ON\s+UPDATE\s+(CASCADE|SET\s+NULL|RESTRICT|NO\s+ACTION)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            if ($updMatch.Success) { $onUpdate = $updMatch.Groups[1].Value.ToUpperInvariant() }

            $foreignKeys.Add([PSCustomObject]@{
                Name = $fkMatch.Groups['name'].Value
                LocalColumn = $fkMatch.Groups['local'].Value
                RefTable = $fkMatch.Groups['refTable'].Value
                RefColumn = $fkMatch.Groups['refCol'].Value
                Behavior = "$onDelete / $onUpdate"
            }) | Out-Null
            continue
        }
    }

    $pkColumns = New-Object System.Collections.Generic.HashSet[string]
    $uniqueColumns = New-Object System.Collections.Generic.HashSet[string]
    $fkColumns = New-Object System.Collections.Generic.HashSet[string]

    foreach ($idx in $indexes) {
        if ($idx.Name -eq 'PRIMARY') {
            foreach ($c in $idx.Columns) { $pkColumns.Add($c) | Out-Null }
        }
        if ($idx.Type -eq 'UNIQUE') {
            foreach ($c in $idx.Columns) { $uniqueColumns.Add($c) | Out-Null }
        }
    }

    foreach ($fk in $foreignKeys) {
        $fkColumns.Add($fk.LocalColumn) | Out-Null
    }

    return [PSCustomObject]@{
        Table = $table
        Engine = $engine
        Charset = $charset
        Collation = $collation
        Columns = $columns
        Indexes = $indexes
        ForeignKeys = $foreignKeys
        PkColumns = $pkColumns
        UniqueColumns = $uniqueColumns
        FkColumns = $fkColumns
    }
}

function Escape-Pipe {
    param([string]$Value)

    if ($null -eq $Value -or $Value -eq '') { return '' }
    return ($Value -replace '\|', '\|')
}

function Build-Markdown {
    param([object]$T)

    $hasDeletedAt = $false
    foreach ($c in $T.Columns) {
        if ($c.Name -eq 'deleted_at') {
            $hasDeletedAt = $true
            break
        }
    }

    $deleteStrategy = if ($hasDeletedAt) {
        '*Soft Delete* habilitado (coluna deleted_at).'
    } else {
        'Exclusao fisica (sem coluna de soft delete detectada no DDL).'
    }

    $sb = New-Object System.Text.StringBuilder

    [void]$sb.AppendLine('# DOCUMENTACAO DE DICIONARIO DE DADOS')
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine("## Schema: patronage | Tabela: $($T.Table)")
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('### 1. Visao Geral (Overview)')
    [void]$sb.AppendLine("* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela $($T.Table).")
    [void]$sb.AppendLine('* **Tipo de Tabela:** Transacional / Entidade de dominio.')
    [void]$sb.AppendLine("* **Mecanismo de Armazenamento (Engine):** $($T.Engine)")
    [void]$sb.AppendLine("* **Charset/Collation:** $($T.Charset) / $($T.Collation)")
    [void]$sb.AppendLine("* **Estrategia de Delecao:** $deleteStrategy")
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('---')
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('### 2. Dicionario de Colunas (Data Dictionary)')
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |')
    [void]$sb.AppendLine('| :--- | :--- | :---: | :--- | :--- | :--- |')

    foreach ($col in $T.Columns) {
        $attrs = New-Object System.Collections.Generic.List[string]
        if ($T.PkColumns.Contains($col.Name)) { $attrs.Add('PK') | Out-Null }
        if ($T.UniqueColumns.Contains($col.Name)) { $attrs.Add('UK') | Out-Null }
        if ($T.FkColumns.Contains($col.Name)) { $attrs.Add('FK') | Out-Null }
        if ($col.AutoIncrement) { $attrs.Add('AUTO_INCREMENT') | Out-Null }

        $attrTxt = if ($attrs.Count -gt 0) { $attrs -join ', ' } else { '' }
        $defaultTxt = if ([string]::IsNullOrWhiteSpace($col.Default)) { '' } else { $col.Default }
        $descTxt = if ([string]::IsNullOrWhiteSpace($col.Comment)) {
            'Nao informado no DDL.'
        } else {
            $col.Comment
        }

        [void]$sb.AppendLine("| **$(Escape-Pipe $col.Name)** | $(Escape-Pipe $col.Type) | $($col.Nullable) | $(Escape-Pipe $defaultTxt) | $(Escape-Pipe $attrTxt) | $(Escape-Pipe $descTxt) |")
    }

    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('---')
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('### 3. Chaves e Indices (Keys and Indexes)')
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |')
    [void]$sb.AppendLine('| :--- | :--- | :--- | :--- |')

    if ($T.Indexes.Count -eq 0) {
        [void]$sb.AppendLine('| - | - | - | Nenhum indice explicito encontrado no DDL. |')
    } else {
        foreach ($idx in $T.Indexes) {
            $idxCols = ($idx.Columns -join ', ')
            [void]$sb.AppendLine("| $(Escape-Pipe $idx.Name) | $(Escape-Pipe $idx.Type) | $(Escape-Pipe $idxCols) | $(Escape-Pipe $idx.Purpose) |")
        }
    }

    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('---')
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('### 4. Relacionamentos e Integridade (Foreign Keys)')
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |')
    [void]$sb.AppendLine('| :--- | :--- | :--- | :--- | :--- |')

    if ($T.ForeignKeys.Count -eq 0) {
        [void]$sb.AppendLine('| - | - | - | - | Nenhuma chave estrangeira declarada. |')
    } else {
        foreach ($fk in $T.ForeignKeys) {
            [void]$sb.AppendLine("| $(Escape-Pipe $fk.Name) | $(Escape-Pipe $fk.LocalColumn) | $(Escape-Pipe $fk.RefTable) | $(Escape-Pipe $fk.RefColumn) | $(Escape-Pipe $fk.Behavior) |")
        }
    }

    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('---')
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('### 5. Observacoes Especiais e Padroes de Negocio')
    [void]$sb.AppendLine('* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.')

    return $sb.ToString()
}

if (-not (Test-Path -Path $DdlsPath)) {
    throw "DDL folder not found: $DdlsPath"
}

if (-not (Test-Path -Path $DocsPath)) {
    New-Item -ItemType Directory -Path $DocsPath | Out-Null
}

if (-not (Test-Path -Path $TemplatePath)) {
    throw "Template not found: $TemplatePath"
}

$files = Get-ChildItem -Path $DdlsPath -Filter '*.sql' -File | Sort-Object Name
$generated = 0
$skipped = 0

foreach ($file in $files) {
    $raw = Get-Content -Path $file.FullName -Raw -Encoding Unicode
    $createSql = Get-CreateTableSql -Raw $raw

    if ([string]::IsNullOrWhiteSpace($createSql)) {
        $skipped++
        continue
    }

    $parsed = Parse-TableDefinition -CreateSql $createSql
    if ($null -eq $parsed) {
        $skipped++
        continue
    }

    if (($parsed.Table -eq 'processos') -and (-not $OverwriteProcessos)) {
        $skipped++
        continue
    }

    $md = Build-Markdown -T $parsed
    $outFile = Join-Path $DocsPath ($parsed.Table + '.md')

    Set-Content -Path $outFile -Value $md -Encoding UTF8
    $generated++
}

Write-Host "Files generated: $generated"
Write-Host "Files skipped: $skipped"