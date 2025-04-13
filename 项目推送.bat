@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM 设置颜色为绿色背景，默认亮白色文字
COLOR 0A
CLS
PROMPT $P$G

REM 检查当前目录是否为有效的 Git 仓库
IF NOT EXIST .git (
    CALL :ShowError "错误：当前目录不是一个有效的 Git 仓库。"
    EXIT /B 1
)

REM 检查是否有修改需要提交
CALL :ShowMessage "正在检查是否有文件需要提交..."

git status >nul 2>&1
IF ERRORLEVEL 1 (
    CALL :ShowError "错误：无法获取 Git 仓库状态，请检查环境。"
    EXIT /B 1
)

SET "CHANGES="
FOR /F "delims=" %%D IN ('git status --porcelain') DO (
    IF "%%D" NEQ "" (
        SET "CHANGES=YES"
    )
)

IF DEFINED CHANGES (
    CALL :ShowMessage "检测到文件修改，开始提交..."
    CALL :AddChanges
    CALL :CommitChanges
    CALL :PushChanges
    CALL :ShowMessage "提交和推送成功！"
) ELSE (
    CALL :ShowMessage "没有文件需要提交。"
)

REM 提示完成
CALL :ShowMessage "脚本执行完成。"
pause
ENDLOCAL
EXIT /B 0

:ShowMessage
ECHO ============================================
ECHO %~1
ECHO ============================================
ECHO.
EXIT /B 0

:ShowError
ECHO ============================================
ECHO %~1
ECHO ============================================
pause
EXIT /B 1

:AddChanges
CALL :ShowMessage "正在添加所有更改..."
git add .
IF ERRORLEVEL 1 (
    CALL :ShowError "错误：无法添加文件，请检查 Git 仓库。"
)
EXIT /B 0

:CommitChanges
CALL :ShowMessage "正在提交更改..."
git commit -m "update"
IF ERRORLEVEL 1 (
    CALL :ShowError "错误：提交失败，请检查 Git 仓库。"
)
EXIT /B 0

:PushChanges
CALL :ShowMessage "正在推送更改到远程仓库..."
git push
IF ERRORLEVEL 1 (
    CALL :ShowError "错误：推送失败，请检查网络连接或远程配置。"
)
EXIT /B 0