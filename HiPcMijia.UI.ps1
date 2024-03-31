# 在你的脚本中

# 定义参数
$processName = "HiPcMijia.UI"
$processPath = "C:\Users\chen6\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\HiPcMijia.UI.lnk"

# 调用 start.ps1 文件
& "d:\Code\PowerShell\start.ps1" -processName $processName -processPath $processPath