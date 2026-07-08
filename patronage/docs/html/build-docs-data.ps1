Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$markdownDir = Join-Path $root 'markdown\mysql'
$outputPath = Join-Path $PSScriptRoot 'docs-data.js'

function Repair-Mojibake {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Text
    )

    if ($Text -notmatch '[ÃÂÊÔÕÇç]') {
        return $Text
    }

    $windows1252 = [System.Text.Encoding]::GetEncoding(1252)
    return [System.Text.Encoding]::UTF8.GetString($windows1252.GetBytes($Text))
}

function Get-CategoryInfo {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $rules = @(
        @{ Pattern = '^(areas|area_user|sub_areas|cidades|estados|paises|regioes|polos|setores|modalidades|situacoes|etapas|comites|natureza_despesas|descricao_anexos|descricao_faixas|descricoes_item|descricoes_pergunta|descricoes_subpergunta|criterio_lattes|fonte_acoes|fonte_pagadoras|bancos|acoes|subacoes|sub_programas|instituicoes|instituicao_vinculos|funcao_equipe|programas_instituicao|programas_instituicao_user)$'; Key = 'dimensoes'; Label = 'Dimensões'; Description = 'Cadastros mestres, taxonomias e entidades de referência.' }
        @{ Pattern = '^(processos|processo_.+|inscricoes|pareceres|diarias|passagens|item_orcamento|pedido_substituicao_bolsista|publicacao_quotas)$'; Key = 'fatos'; Label = 'Fatos e Fluxos'; Description = 'Tabelas centrais do ciclo operacional, submissão, execução e tramitação.' }
        @{ Pattern = '^(editais|edital_.+|chamada_.+)$'; Key = 'editais'; Label = 'Editais e Chamadas'; Description = 'Estruturas de parametrização, publicação e regras dos instrumentos de fomento.' }
        @{ Pattern = '^(convenios|convenio_.+)$'; Key = 'convenios'; Label = 'Convênios'; Description = 'Artefatos financeiros e operacionais associados a convênios e aditivos.' }
        @{ Pattern = '^(formulario_.+|avaliacao_.+|relatorio_.+|resultado.*)$'; Key = 'avaliacao'; Label = 'Formulários e Avaliações'; Description = 'Questionários, respostas, avaliações e resultados consolidados.' }
        @{ Pattern = '^(termos|termo_.+|politica_.+|termos_uso_.+|documentacoes|documentos_gerados)$'; Key = 'governanca'; Label = 'Termos e Governança'; Description = 'Documentos normativos, aceite, cláusulas e trilhas formais do sistema.' }
        @{ Pattern = '^(users|user_.+|roles|permissions|role_has_permissions|model_has_permissions|model_has_roles|login_tokens|password_resets|gestores|gestor_.+|representante_.+)$'; Key = 'seguranca'; Label = 'Segurança e Acesso'; Description = 'Controle de identidade, papéis, permissões e atores institucionais.' }
        @{ Pattern = '^(activity_log|logs|failed_jobs|jobs|migrations|newsletter|pulse_.+|settings|telas|dados_sistema|sifaps|sifaps_dados|modulos|operacoes|notificacao_execucao|historico_.+|erro_steps_.+)$'; Key = 'plataforma'; Label = 'Plataforma e Auditoria'; Description = 'Operação técnica, observabilidade, integração e suporte ao produto.' }
    )

    foreach ($rule in $rules) {
        if ($Name -match $rule.Pattern) {
            $rule.Label = Repair-Mojibake -Text $rule.Label
            $rule.Description = Repair-Mojibake -Text $rule.Description
            return $rule
        }
    }

    $fallback = @{ Key = 'auxiliares'; Label = 'Auxiliares'; Description = 'Artefatos de apoio que não se encaixam nos grupos centrais.' }
    $fallback.Label = Repair-Mojibake -Text $fallback.Label
    $fallback.Description = Repair-Mojibake -Text $fallback.Description
    return $fallback
}

function Get-MetadataMatch {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content,
        [Parameter(Mandatory = $true)]
        [string]$Pattern
    )

    $match = [regex]::Match($Content, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if ($match.Success) {
        return $match.Groups[1].Value.Trim()
    }

    return ''
}

function Get-TableRowCount {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content,
        [Parameter(Mandatory = $true)]
        [string]$SectionTitle
    )

    $sectionPattern = '(?s)' + [regex]::Escape($SectionTitle) + '.*?(?=\r?\n---\r?\n|\z)'
    $sectionMatch = [regex]::Match($Content, $sectionPattern)
    if (-not $sectionMatch.Success) {
        return 0
    }

    $count = 0
    foreach ($line in ($sectionMatch.Value -split "`r?`n")) {
        if ($line -match '^\|\s*\*\*' -or $line -match '^\|\s*`' -or $line -match '^\|\s*[A-Za-z0-9_-]+\s*\|') {
            if ($line -notmatch 'Campo\s*\|' -and $line -notmatch '^\|\s*:-' -and $line -notmatch '^\|\s*-\s*\|') {
                $count++
            }
        }
    }

    return $count
}

$documents = Get-ChildItem -Path $markdownDir -Filter '*.md' | Sort-Object Name | ForEach-Object {
    $name = $_.BaseName
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
    $category = Get-CategoryInfo -Name $name
    $schema = Get-MetadataMatch -Content $content -Pattern 'Schema:\s*`?([^|`\r\n]+)`?'
    $tableName = Get-MetadataMatch -Content $content -Pattern 'Tabela:\s*`?([^`\r\n]+)`?'
    if (-not $tableName) {
        $tableName = $name
    }

    [PSCustomObject]@{
        id = $name
        name = $tableName
        fileName = $_.Name
        schema = if ($schema) { $schema } else { 'patronage' }
        categoryKey = $category.Key
        categoryLabel = $category.Label
        categoryDescription = $category.Description
        overview = Get-MetadataMatch -Content $content -Pattern 'Descri[cç][aã]o Funcional:\*\*\s*(.+)'
        tableType = Get-MetadataMatch -Content $content -Pattern 'Tipo de Tabela:\*\*\s*(.+)'
        deleteStrategy = Get-MetadataMatch -Content $content -Pattern 'Estrat[eé]gia de Del[eê][cç][aã]o:\*\*\s*(.+)'
        columnCount = 0
        fkCount = 0
        markdown = $content
    }
}

$documents = $documents | ForEach-Object {
    $doc = $_
    $doc.columnCount = Get-TableRowCount -Content $doc.markdown -SectionTitle '### 2. Dicionário de Colunas (Data Dictionary)'
    if (-not $doc.columnCount) {
        $doc.columnCount = Get-TableRowCount -Content $doc.markdown -SectionTitle '### 2. Dicionario de Colunas (Data Dictionary)'
    }

    $doc.fkCount = Get-TableRowCount -Content $doc.markdown -SectionTitle '### 4. Relacionamentos e Integridade (Foreign Keys)'
    $doc
}

$categories = $documents |
    Group-Object categoryKey |
    Sort-Object Name |
    ForEach-Object {
        $first = $_.Group[0]
        [PSCustomObject]@{
            key = $first.categoryKey
            label = $first.categoryLabel
            description = $first.categoryDescription
            count = $_.Count
        }
    }

$payload = [PSCustomObject]@{
    projectName = 'patronage'
    databaseEngine = 'MySQL'
    generatedAt = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    totalDocuments = $documents.Count
    categories = $categories
    documents = $documents
}

$json = $payload | ConvertTo-Json -Depth 6 -Compress
$output = @(
    'window.__DOCS_PORTAL__ = ' + $json + ';',
    ''
) -join [Environment]::NewLine

[System.IO.File]::WriteAllText($outputPath, $output, [System.Text.UTF8Encoding]::new($true))
Write-Host "Arquivo gerado em: $outputPath"