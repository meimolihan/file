@echo off
SETLOCAL EnableDelayedExpansion

:MAIN
    title 通用Git仓库更新与标签管理工具
    set "REPO_PATH=%CD%"

    echo ============================================
    echo 通用Git仓库更新与标签管理工具
    echo ============================================
    echo 当前目录: %REPO_PATH%
    echo ============================================
    echo 请选择操作:
    echo 1. 检查更新并推送
    echo 2. 更新标签
    echo 3. 检查更新并推送 + 更新标签
    echo 4. 退出
    echo ============================================
    
    set /p choice="请输入选项(1-4): "
    
    if "%choice%"=="1" (
        call :CheckAndPushUpdates
    ) else if "%choice%"=="2" (
        call :UpdateTags
    ) else if "%choice%"=="3" (
        call :CheckAndPushUpdates
        if not errorlevel 1 (
            call :UpdateTags
        )
    ) else if "%choice%"=="4" (
        goto :EXIT_SCRIPT
    ) else (
        echo 无效的选项，请重新输入
        pause
        goto :MAIN
    )
    
    goto :EXIT_SCRIPT

:CheckAndPushUpdates
    call :ValidateGitRepo
    if errorlevel 1 goto :EXIT_SCRIPT
    
    call :CheckForChanges
    if errorlevel 1 goto :EXIT_SCRIPT
    
    exit /b 0

:UpdateTags
    call :ValidateGitRepo
    if errorlevel 1 goto :EXIT_SCRIPT
    
    set /p tagName="请输入标签名称(例如v1.0.0): "
    if "!tagName!"=="" (
        echo 标签名称不能为空
        goto :EXIT_SCRIPT
    )
    
    set /p tagMessage="请输入标签描述信息: "
    if "!tagMessage!"=="" (
        set "tagMessage=自动创建的标签 !tagName!"
    )
    
    call :DeleteTag "!tagName!"
    if errorlevel 1 goto :EXIT_SCRIPT
    
    call :CreateAndPushTag "!tagName!" "!tagMessage!"
    if errorlevel 1 goto :EXIT_SCRIPT
    
    exit /b 0

:ValidateGitRepo
    if not exist "%REPO_PATH%\.git" (
        echo ============================================
        echo 错误: 当前目录不是一个有效的Git仓库
        echo ============================================
        exit /b 1
    )
    exit /b 0

:CheckForChanges
    echo ============================================
    echo 正在检查Git仓库状态...
    echo ============================================
    
    git status >nul 2>&1
    if errorlevel 1 (
        echo 无法获取Git仓库状态，请检查Git环境
        exit /b 1
    )
    
    set "CHANGES="
    for /f "delims=" %%D in ('git status --porcelain') do (
        if "%%D" neq "" set "CHANGES=YES"
    )
    
    if defined CHANGES (
        echo 检测到文件修改，准备提交...
        
        set "COMMIT_MSG=自动提交于 %DATE% %TIME%"
        set /p COMMIT_MSG="请输入提交信息(直接回车使用默认信息): "
        if "!COMMIT_MSG!"=="" (
            set "COMMIT_MSG=自动提交于 %DATE% %TIME%"
        )
        
        call :AddChanges
        if errorlevel 1 exit /b 1
        
        call :CommitChanges "!COMMIT_MSG!"
        if errorlevel 1 exit /b 1
        
        call :PushChanges
        if errorlevel 1 exit /b 1
        
        echo 提交和推送成功完成!
    ) else (
        echo 没有检测到文件修改，尝试直接推送到远程仓库...
        call :PushChanges
        if errorlevel 1 exit /b 1
    )
    
    exit /b 0

:AddChanges
    echo ============================================
    echo 正在添加所有更改到暂存区...
    echo ============================================
    
    git add .
    if errorlevel 1 (
        echo 错误: 无法添加文件到暂存区
        exit /b 1
    )
    exit /b 0

:CommitChanges
    echo ============================================
    echo 正在提交更改到本地仓库...
    echo 提交信息: %~1
    echo ============================================
    
    git commit -m "%~1"
    if errorlevel 1 (
        echo 错误: 提交到本地仓库失败
        exit /b 1
    )
    exit /b 0

:PushChanges
    echo ============================================
    echo 正在推送更改到远程仓库...
    echo ============================================
    
    for /f "delims=" %%b in ('git symbolic-ref --short HEAD 2^>nul') do set "CURRENT_BRANCH=%%b"
    
    if defined CURRENT_BRANCH (
        git push origin !CURRENT_BRANCH!
    ) else (
        git push
    )
    
    if errorlevel 1 (
        echo 错误: 推送到远程仓库失败，请检查网络或远程配置
        exit /b 1
    )
    exit /b 0

:DeleteTag
    echo ============================================
    echo 正在删除标签 %~1...
    echo ============================================
    
    git tag -d %~1 >nul 2>&1
    git push origin :refs/tags/%~1 >nul 2>&1
    
    git tag -l | findstr /I "%~1" >nul
    if %errorlevel% equ 0 (
        echo 警告: 标签 %~1 删除失败，可能不存在
    ) else (
        echo 标签 %~1 删除成功
    )
    exit /b 0

:CreateAndPushTag
    echo ============================================
    echo 正在创建新标签 %~1...
    echo 标签描述: %~2
    echo ============================================
    
    git tag -a %~1 -m "%~2"
    if errorlevel 1 (
        echo 错误: 创建标签失败
        exit /b 1
    )
    
    git push origin %~1
    if errorlevel 1 (
        echo 错误: 推送标签失败
        exit /b 1
    )
    
    echo 标签 %~1 创建并推送成功!
    exit /b 0

:EXIT_SCRIPT
    echo ============================================
    echo 按任意键退出...
    echo ============================================
    pause >nul
    exit /b 0