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
        netsh wlan set hostednetwork mode=allow ssid="$ssid" key="$password"
        netsh wlan connect name="$ssid"
        write-host "正在连接到 WiFi 网络：$ssid `n请稍后"
        start-sleep -Seconds 10
        $wifi = netsh wlan show interfaces | Where-Object { $_ -match '^\s*SSID' }
        if ($wifi) {
            $ssid2 = ($wifi -split ':')[1].Trim()
            if ($ssid2) {
                Write-Host "WiFi 已连接$wifi2" -ForegroundColor Green
                start-sleep -Seconds 5
                exit
            }
            else {
                Write-Host "WiFi 连接失败$wifi2`n请自行检查是否连接成功" -ForegroundColor Red
                start-sleep -Seconds 5
                exit
            }
        }
}