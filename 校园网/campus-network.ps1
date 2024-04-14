function menu {
    $multiLineString = @"
请先查看教程！(ノ^_^)ノ
先打开校园网的登陆链接检查是否能连接校园网[○･｀Д´･○]`
能正常打开校园网登陆链接就可以进行第二步操作啦(●'◡'●)ﾉ♥`n
tips:点击鼠标右键可以直接粘贴(无需Ctrl+V)"( ´ ▽ ` )ﾉ"`n
"@
    Write-Host $multiLineString -ForegroundColor Green

    Write-Host "请选择操作""~(=^‥^)ノ"":" 
    # 让用户选择功能序号
    Write-Host "1. 打开校园网网址" -ForegroundColor Blue
    Write-Host "2. 生成开机自动登陆脚本" -ForegroundColor Yellow
    Write-Host "3. 一键打开开自启文件夹" -ForegroundColor Green
    Write-Host "4. 退出脚本" -ForegroundColor Red
    $userChoice = Read-Host "请输入数字选择操作"
    # 根据用户选择的功能序号执行相应的功能
    switch ($userChoice) {
        1 { OpenUrl }
        2 { CreateScript }
        3 { OpenStartup }
        4 { exit }
        default {
            Write-Host "输入有误，请重新输入`n" -ForegroundColor Red 
            menu
        }
    }
}
function OpenStartup {
    $startupPath = [Environment]::GetFolderPath('Startup')
    Start-Process $startupPath
    menu
}

function OpenUrl {
    Write-Host "打开浏览器访问校园网登陆网址(可自行修改网址)?您是否要继续此操作ψ(｀∇´)ψ?" -ForegroundColor Blue
    Write-Host "注意:此操作会打开默认浏览器。您是否要继续此操作？(๑•̀ㅂ•́)و✧" -ForegroundColor Red

    $continue = Read-Host "请输入 'y' 继续，或 'n' 停止" 
    Write-Host "`n"
    if ($continue -eq 'y') {
        $url = Read-Host "请输入校园网的链接（有默认值）`n"
        # 输入为空时使用默认值
        if ($url -eq '') {
            $url = "http://172.17.100.200/a70.htm"
            Start-Process $url
        }
    }
    elseif ($continue -eq 'n') {
        Write-Host "操作已取消`n"
    }
    else {
        Write-Host "无效的输入，请输入 'y' 或 'n'`n" -ForegroundColor Red
        OpenUrl
    }
    menu
}
function CreateScript {
    Write-Host "生成开机自动登陆脚本？`n"-ForegroundColor Red
    Write-Host "注意:再次生成会覆盖旧的文件！！！！您是否要继续此操作(*´ω｀)o?" -ForegroundColor Red
    $continue = Read-Host "请输入 'y' 继续，或 'n' 停止"
    if ($continue -eq 'y') {
        InputUrl
    }
    elseif ($continue -eq 'n') {
        Write-Host "操作已取消`n"
        menu
    }
    else {
        Write-Host "无效的输入，请输入 'y' 或 'n'`n"
        CreateScript
    }
}

#校验链接是否能登陆校园网
function InputUrl {
    $date = Get-Date

    $unixEpoch = [DateTime]::new(1970, 1, 1, 0, 0, 0, [DateTimeKind]::Utc)
    $timestamp = [Math]::Truncate(($date.ToUniversalTime() - $unixEpoch).TotalMilliseconds)

    Write-Host "时间戳：$timestamp"
    $account = Read-Host "请输入账号"
    $password = Read-Host "请输入密码"
    $url = "http://172.17.100.200:801/eportal/?c=GetMsg&a=loadToken&callback=jQuery_$timestamp&account=$account&password=$password&mac=000000000000&_=$timestamp"
    $response = VisitUrl -url "$url"
    Write-Host "$response"
    if ($response.Content | Select-String -Pattern '"result":"ok"') {
        Write-Host "找到 'result:ok'测试登陆成功`n" -ForegroundColor Green
        Create -account $account -password $password
    }
    else {
        Write-Host "未找到 'result:ok'`n"
        Write-Host "登陆失败！！！`n" -ForegroundColor Red
        write-host "登陆使用的链接：$url`n" -ForegroundColor Blue
        write-host "返回值：$response`n" -ForegroundColor Blue
        Write-Host "请检查账号密码是否正确`n"
        Read-Host '按 Enter 键继续...'
        menu
    }
}
# 访问url链接
function VisitUrl {
    param (
        [string]$url
    )
    Write-Host "测试中！`n请稍后..." -ForegroundColor Blue
    $response = Invoke-WebRequest -Uri $url
    return $response
}
function Create {
    param (
        [string]$account,
        [string]$password
    )
    
    $startupPath = [Environment]::GetFolderPath('Startup')
    $filePath = Join-Path -Path $startupPath -ChildPath "登陆校园网.ps1"
    New-Item -Path $filePath -ItemType "file" -Force
    $script = @"
Write-Host "正在登陆中...." -ForegroundColor Yellow
write-host "请稍后...." -ForegroundColor Blue
`$date = Get-Date

`$unixEpoch = [DateTime]::new(1970, 1, 1, 0, 0, 0, [DateTimeKind]::Utc)
`$timestamp = [Math]::Truncate((`$date.ToUniversalTime() - `$unixEpoch).TotalMilliseconds)

Write-Host "时间戳：`$timestamp"
`$response = Invoke-WebRequest -Uri "http://172.17.100.200:801/eportal/?c=GetMsg&a=loadToken&callback=jQuery_`$timestamp&account=$account&password=$password&mac=000000000000&_=`$timestamp"

Write-Host "`$response"
if (`$response.Content | Select-String -Pattern '"result":"ok"') {
    Write-Host "找到 'result:ok'登陆成功" -ForegroundColor Green
    Write-Host "3秒后将自动退出..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    exit
}
else {
    Write-Host "未找到 'result:ok'登陆失败！！！" -ForegroundColor Red
    Write-Host "正在尝试连接wifi"
    `$ssid = Read-Host -Prompt "请输入 wifi 名称"
    `$password = Read-Host -Prompt "请输入密码"
    `$wifiInfo = netsh wlan show interfaces | Where-Object { `$_ -match '^\s*SSID' }
    if (`$wifiInfo) {
        `$ssid = (`$wifiInfo -split ':')[1].Trim()
        if (ssid) {
            Write-Host "已连接到 Wi-Fi 网络: `$ssid" -ForegroundColor Green
            start-sleep -Seconds 5
            exit
        }
    }
    else {
        Write-Host "WiFi 未连接"
        write-host "正在连接到 WiFi 网络：`$ssid"
        netsh wlan set hostednetwork mode=allow ssid="`$ssid" key="`$password"
        netsh wlan connect name="`$ssid"
        write-host "正在连接到 WiFi 网络：`$ssid 请稍后"
        start-sleep -Seconds 10
        `$wifi = netsh wlan show interfaces | Where-Object { `$_ -match '^\s*SSID' }
        if (`$wifi) {
            `$ssid2 = (`$wifi -split ':')[1].Trim()
            if (`$ssid2) {
                Write-Host "WiFi 已连接`$wifi2" -ForegroundColor Green
                start-sleep -Seconds 5
                exit
            }
            else {
                Write-Host "WiFi 连接失败`$wifi2请自行检查是否连接成功"-ForegroundColor Red
                start-sleep -Seconds 5
                exit
            }
        }
    }
}
    
"@
    Set-Content -Path $filePath -Value $script

    if (Test-Path -Path $filePath) {
        Write-Host "文件已成功生成。`n" -ForegroundColor Green
        Write-Host "文件路径：$filePath`n"
    }
    else {
        Write-Host "文件生成失败。" -ForegroundColor Red
    }
    Read-Host '按 Enter 键继续...'
    menu
}
menu