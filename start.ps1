
# function Start-ProcessWithCheck {
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
    if (Get-Process -Name $processName -ErrorAction SilentlyContinue) {
        Write-Host "$processName 已经在运行了"
        break
    }
    else {
        # 启动程序
        Start-Process $processPath
        Start-Sleep -Seconds 2  # 等待x秒后检查程序启动结果

        if (Get-Process $processName -ErrorAction SilentlyContinue) {
            Write-Host "$processName 成功运行 (*≧▽≦)ツ┏━┓" -ForegroundColor Green
            start-sleep -Seconds 2  # 等待x秒后跳出循环
        }
        else {
            Write-Host "$processName 未运行(‘◇’)?."
            $userInput = Read-Host "是否要重试？默认Y (Y/N)"
            if ([string]::IsNullOrEmpty($userInput)) {
                $userInput = 'y'
            }
        }
    }
} while ($userInput -eq 'Y' -or $userInput -eq 'y')

if ($userInput -ne 'Y' -and $userInput -ne 'y') {
    Write-Host "正在退出脚本..."
}
# }

# Start-ProcessWithCheck -processName "HiPcMijia.UI" -processPath "C:\Users\chen6\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\HiPcMijia.UI.lnk"

