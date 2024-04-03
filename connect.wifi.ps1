# 定义你的 WiFi 网络的 SSID 和密码
param (
    [Parameter(Mandatory = $true)]
    [string]$ssid,
    [Parameter(Mandatory = $true)]
    [SecureString]$password
)
# 检查wifi是否已经连接
$wifiInfo = netsh wlan show interfaces | Where-Object { $_ -match '^\s*SSID' }

if ($wifiInfo) {
    $ssid = ($wifiInfo -split ':')[1].Trim()
    if ($ssid) {
        Write-Host "已连接到 Wi-Fi 网络: $ssid" -ForegroundColor Green
        start-sleep -Seconds 5
        exit
    }
}
else {
    Write-Host "WiFi 未连接"
    write-host "正在连接到 WiFi 网络：$ssid"
    # 创建一个新的 WiFi 配置文件
    netsh wlan set hostednetwork mode=allow ssid="$ssid" key="$password"
    # 启动 WiFi 网络
    #netsh wlan start hostednetwork
    # 使用 netsh 命令连接到 WiFi 网络
    netsh wlan connect name="$ssid"
    start-sleep -Seconds 5
    if ($wifi -match $ssid) {
        Write-Host "WiFi 已连接$wifi" -ForegroundColor Green
        start-sleep -Seconds 5
        exit
    }
    else {
        Write-Host "WiFi 连接失败$wifi" -ForegroundColor Red
        start-sleep -Seconds 5
        exit
    }
}