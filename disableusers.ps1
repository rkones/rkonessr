# Run daily to disable AD user accounts that have been inactive for 90 days.
# Requires the ActiveDirectory module and appropriate permissions.

$daysInactive = 90
$logFolder = "C:\Reports"
$logPath = Join-Path $logFolder "DisableInactiveUsers.log"

if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
}

try {
    $timeSpan = New-TimeSpan -Days $daysInactive
    $inactiveUsers = Search-ADAccount -UsersOnly -AccountInactive -TimeSpan $timeSpan

    if ($inactiveUsers) {
        $inactiveUsers | Disable-ADAccount -Confirm:$false
        $count = ($inactiveUsers | Measure-Object).Count
        "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) Disabled $count inactive user account(s)." | Out-File -FilePath $logPath -Append -Encoding utf8
    }
    else {
        "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) No inactive users found." | Out-File -FilePath $logPath -Append -Encoding utf8
    }
}
catch {
    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) ERROR: $($_.Exception.Message)" | Out-File -FilePath $logPath -Append -Encoding utf8
    throw
}
