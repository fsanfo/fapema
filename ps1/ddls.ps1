$User = "patro"
$Password = "123"
$ServerHost = "172.16.1.8"
$Port = "33065"
$DB = "patronage"
$DirSaida = "C:\Users\fabiano.fonseca\git\patronage\ddls"
$mysqlPath = "C:\ProgramData\chocolatey\bin\mysql.exe"

New-Item -ItemType Directory -Force -Path $DirSaida

Write-Host "Listando tabelas e exportando DDLs..."

# Obter lista de tabelas
$tables = & $mysqlPath -u $User -h $ServerHost -P $Port --password=$Password -N -e "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = '$DB' ORDER BY TABLE_NAME"

foreach ($tabela in $tables) {
    $tabelaNome = $tabela.Trim()
    if ($tabelaNome -ne "") {
        Write-Host "Exportando $tabelaNome..."
        $query = "SHOW CREATE TABLE " + [char]96 + "$tabelaNome" + [char]96 + [char]92 + "G"
        & $mysqlPath -u $User -h $ServerHost -P $Port --password=$Password $DB -e $query > "$DirSaida\$tabelaNome.sql" 2>&1
    }
}