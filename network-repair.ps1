Write-Host "Checking network connection..." -ForegroundColor Cyan

# Test Internet connectivity 
$test = Test-Connection -ComputerName 8.8.8.8 -Count 2 -Quiet

if ($test) {
Write-Host "Internet Connection is Working." -ForegroundColor Green
}
else {
Write-Host "Connection issue detected. Running fixes..." -ForegroundColor Red

#Step 1: Restart network adapter
Write-Host "Restarting network adapter..." -ForegroundColor Yellow

$adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }}

if ($adapter) {
Disable-NetAdapter -Name $adapter .Name -Confirm:$false
Start-Sleep -Seconds 3
Enable-NetAdapter -Name $adapter.Name -Confirm:$false
}

#Step 2: Renew IP Address
Write-Host "Renewing IP address..." -ForegroundColor Yellow
ipconfig /release | Out-Null
ipconfig /renew | Out-Null

# Step 3: Flush DNS
Write-Host "Flushing DNS cache..." -ForegroundColor Yellow
ipconfig /flushdns | Out-Null

# Step 4: Reset network stack
Write-Host "Resetting network stack..." -ForegroundColor Yellow
netsh int ip reset | Out-Null
netsh winsock reset | Out-Null

# Step 5: Re-test connection
Start-Sleep -Second 5
$retest = Test-Connection -ComputerName 8.8.8.8 -Count 2 Quiet

if ($reset) {
Wtite-Host "Connection restored." ForegroundColor Green
}
else {
Write-Host "Still no connectivity. Try the following:" -ForegroundColor Red
Write-Host "- Restart your router"
Write-Host "- Check cables or Wi-Fi"
Write-Host "- Contact your ISP"
}