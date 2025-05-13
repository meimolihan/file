@echo off
color 0A

:MENU
color 0A
cls
echo ==============================
echo         Git 项目管理脚本
echo ==============================
echo 1. 检查Git仓库状态
echo 2. 提交并推送更改
echo 3. 拉取远程的更新
echo 4. 提交并更新标签
echo ==============================
echo 0. 退出
echo ==============================
    set "choice="
    set /p choice="请输入操作编号 (0 - 3): "
    if not defined choice (
        echo 输入不能为空，请输入（0 - 3）之间的数字。
        timeout /t 2 >nul
		rem 定义要返回的菜单
        goto MENU
    )

if "%choice%"=="1" goto CHECK_STATUS
if "%choice%"=="2" goto COMMIT_PUSH
if "%choice%"=="3" goto PULL_UPDATE
if "%choice%"=="4" goto UPDATE_GIT_TAG
if "%choice%"=="0" goto EXIT_SCRIPT


echo ============= 检查Git仓库状态 =================
:CHECK_STATUS
echo 正在检查Git仓库状态...
git status
echo 检查完成！请根据提示确认文件状态。
pause
goto MENU

echo ============= 提交并推送更改 =================
:COMMIT_PUSH
echo 提交并推送更改：
set /p commit_msg=请输入提交信息（直接回车默认为 "update"）： 
if "%commit_msg%"=="" set commit_msg=update

echo 正在添加所有更改到暂存区...
git add .
echo 添加完成！

echo 正在提交更改，提交信息为：%commit_msg%
git commit -m "%commit_msg%"
echo 提交完成！

echo 正在推送更改到远程仓库...
git push
echo 推送完成！您的更改已成功同步到远程仓库。

pause
goto MENU

echo ============= 拉取远程更新 =================
:PULL_UPDATE
echo 正在从远程仓库拉取更新...
git pull
if %errorlevel% equ 0 (
    echo 拉取成功！本地仓库已是最新版本。
) else (
    echo 拉取失败！请检查网络或远程仓库地址是否正确。
)
pause
goto MENU


echo ============= 提交并更新标签 =================
:UPDATE_GIT_TAG
REM 使用当前目录作为Git仓库路径
SET REPO_PATH=%CD%

echo 当前处理的Git仓库路径：%REPO_PATH%
echo ==============================

REM 检查是否为有效的Git仓库
IF NOT EXIST .git (
    echo 错误：当前目录 %REPO_PATH% 不是一个有效的Git仓库。
    echo ==============================
    pause
    EXIT /B 1
)

REM 添加所有更改并提交
echo 正在添加所有更改...
git add .
echo ==============================
echo 正在提交更改，提交信息为 "update"...
git commit -m "update"
echo ==============================

REM 推送提交到远程仓库
echo 正在将提交推送到远程仓库...
git push
echo ==============================

REM 删除本地标签 v1.0.0
echo 正在删除本地标签 v1.0.0...
git tag -d v1.0.0
echo ==============================

REM 删除远程标签 v1.0.0
echo 正在删除远程标签 v1.0.0...
git push origin :refs/tags/v1.0.0
echo ==============================

REM 检查标签是否删除成功
echo 检查标签 v1.0.0 是否删除成功...
git tag -l | findstr /I "v1.0.0" >nul
IF %ERRORLEVEL% EQU 0 (
    echo 远程标签 v1.0.0 删除失败，请手动检查。
) ELSE (
    echo 远程标签 v1.0.0 删除成功。
)
echo ==============================

REM 创建新标签
set /p tag_name=请输入新标签名（直接回车默认标签名为 v1.0.0）:
if "%tag_name%"=="" (
    set tag_name=v1.0.0
)
echo 正在创建新标签 %tag_name%，标签信息为 "为最新提交的重新创建标签"...
git tag -a %tag_name% -m "Recreate tags for the latest submission"
echo ==============================

REM 推送新标签到远程仓库
echo 正在将新的标签 %tag_name% 推送到远程仓库...
git push origin %tag_name%
echo ==============================

REM 检查标签是否推送成功
echo 检查标签 %tag_name% 是否推送成功...
git tag -l | findstr /I "%tag_name%" >nul
IF %ERRORLEVEL% EQU 0 (
    echo 标签 %tag_name% 推送成功。
) ELSE (
    echo 标签 %tag_name% 推送失败，请手动检查。
)
echo ==============================



echo ==============================
:EXIT_SCRIPT
echo 感谢使用，再见！
timeout /t 2 >nul
exit