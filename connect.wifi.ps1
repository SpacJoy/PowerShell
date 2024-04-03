# 定义你的 WiFi 网络的 SSID 和密码
param (
    [Parameter(Mandatory = $true)]
    [string]$ssid,
    [Parameter(Mandatory = $true)]
    [SecureString]$password
)
# $ssid = "Internet"
# $password = "chen6019"
# 检查wifi是否已经连接
$wifi = netsh wlan show interfaces | Select-String -Pattern "SSID"
# $wifi = (netsh wlan show interfaces) -join "`n"
if ($wifi -match $ssid) {
    Write-Host "WiFi 已连接" -ForegroundColor Green
    start-sleep -Seconds 3
    exit
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
    # 等待连接成功
    Write-Host "连接成功！"-ForegroundColor Green
    start-sleep -Seconds 3
    exit
}