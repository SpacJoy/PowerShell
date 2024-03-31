
function Start-ProcessWithCheck {
    param (
        [Parameter(Mandatory = $true)]
        [string]$processName,

        [Parameter(Mandatory = $true)]
        [string]$processPath
    )

    do {
        for ($i = 5; $i -gt 0; $i--) {
            Write-Host "$i 秒后开始运行$processName"
            Start-Sleep -Seconds 1
        }

        Start-Process $processPath -WindowStyle Normal

        Start-Sleep -Seconds 2  # Wait for a while to let the process start

        if (Get-Process $processName -ErrorAction SilentlyContinue) {
            Write-Host "$processName 成功运行 (*≧▽≦)ツ┏━┓" -ForegroundColor Green
            start-sleep -Seconds 2
            break
        }
        else {
            Write-Host "$processName 未运行(‘◇’)?."
            $userInput = Read-Host "是否要重试？ (Y/N)"
            if ([string]::IsNullOrEmpty($userInput)) {
                $userInput = 'y'
            }
        }
    } while ($userInput -eq 'Y' -or $userInput -eq 'y')

    if ($userInput -ne 'Y' -and $userInput -ne 'y') {
        Write-Host "正在退出脚本..."
    }
}

Start-ProcessWithCheck -processName "HiPcMijia.UI" -processPath "C:\Users\chen6\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\HiPcMijia.UI.lnk"
