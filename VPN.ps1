# 在你的脚本中

# 定义参数
$processName = "Clash Verge"
$processPath = "C:\Users\Public\Desktop\Clash Verge.lnk"

Start-Sleep -Seconds 3
# 调用 start.ps1 文件
& "d:\Code\PowerShell\start.ps1" -processName $processName -processPath $processPath