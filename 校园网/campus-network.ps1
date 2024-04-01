function menu {
    $multiLineString = @"
提示：`n
需要先获取到校园网的登陆链接[○･｀Д´･○]`n`
打开开发者工具按F12
选择网络(英文为network)
然后登陆校园网,找到下面第一个get请求的网址
就是复制请求url里的内容,全部复制下来
在第二步中粘贴到脚本中`n
tips:点击鼠标右键可以直接粘贴(无需Ctrl+V)"( ´ ▽ ` )ﾉ`n"
"@
    Write-Host $multiLineString

    Write-Host "请选择操作""~(=^‥^)ノ"":"
    # 让用户选择功能序号
    Write-Host "1. 打开校园网网址"
    Write-Host "2. 生成开机自动登陆脚本"
    Write-Host "3. 一键打开开自启文件夹"
    Write-Host "4. 退出脚本"
    $userChoice = Read-Host "请输入数字选择操作"
    # 根据用户选择的功能序号执行相应的功能
    switch ($userChoice) {
        1 { OpenUrl }
        2 { CreateScript }
        3 { OpenStartup }
        4 { exit }
        default { Write-Host "输入有误，请重新输入" -ForegroundColor Red }
    }
}
function OpenUrl {
    Write-Host "打开浏览器访问校园网登陆网址(可自行修改网址)?您是否要继续此操作ψ(｀∇´)ψ?"

    $continue = Read-Host "请输入 'y' 继续，或 'n' 停止"
    if ($continue -eq 'y') {
        $url = Read-Host "请输入校园网的登陆链接"
        Write-Host ""
        # 其他代码...
    }
    elseif ($continue -eq 'n') {
        Write-Host "操作已取消"
    }
    else {
        Write-Host "无效的输入，请输入 'y' 或 'n'"
        OpenUrl
    }
}
menu
