$LogName = 'Application'
$Source = 'WingetUpgradeScript'

if (-not [System.Diagnostics.EventLog]::SourceExists($Source)) {
    New-EventLog -LogName $LogName -Source $Source
}

try {
    $result = winget upgrade --all --accept-source-agreements --accept-package-agreements 2>&1
    Write-Output $result

    $entryType = if ($LASTEXITCODE -eq 0) { 'Information' } else { 'Error' }
    $message = if ($result -is [System.Array]) { $result -join "`n" } else { $result }

    Write-EventLog -LogName $LogName -Source $Source -EntryType $entryType -EventId 1000 -Message $message
} catch {
    Write-Error $_
    Write-EventLog -LogName $LogName -Source $Source -EntryType Error -EventId 1001 -Message $_.Exception.Message
}