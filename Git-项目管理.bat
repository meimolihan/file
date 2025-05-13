@echo off
color 0A

:MENU
color 0A
cls
echo ==============================
echo         Git ��Ŀ����ű�
echo ==============================
echo 1. ���Git�ֿ�״̬
echo 2. �ύ�����͸���
echo 3. ��ȡԶ�̵ĸ���
echo 4. �ύ�����±�ǩ
echo ==============================
echo 0. �˳�
echo ==============================
    set "choice="
    set /p choice="������������ (0 - 3): "
    if not defined choice (
        echo ���벻��Ϊ�գ������루0 - 3��֮������֡�
        timeout /t 2 >nul
		rem ����Ҫ���صĲ˵�
        goto MENU
    )

if "%choice%"=="1" goto CHECK_STATUS
if "%choice%"=="2" goto COMMIT_PUSH
if "%choice%"=="3" goto PULL_UPDATE
if "%choice%"=="4" goto UPDATE_GIT_TAG
if "%choice%"=="0" goto EXIT_SCRIPT


echo ============= ���Git�ֿ�״̬ =================
:CHECK_STATUS
echo ���ڼ��Git�ֿ�״̬...
git status
echo �����ɣ��������ʾȷ���ļ�״̬��
pause
goto MENU

echo ============= �ύ�����͸��� =================
:COMMIT_PUSH
echo �ύ�����͸��ģ�
set /p commit_msg=�������ύ��Ϣ��ֱ�ӻس�Ĭ��Ϊ "update"���� 
if "%commit_msg%"=="" set commit_msg=update

echo ����������и��ĵ��ݴ���...
git add .
echo �����ɣ�

echo �����ύ���ģ��ύ��ϢΪ��%commit_msg%
git commit -m "%commit_msg%"
echo �ύ��ɣ�

echo �������͸��ĵ�Զ�ֿ̲�...
git push
echo ������ɣ����ĸ����ѳɹ�ͬ����Զ�ֿ̲⡣

pause
goto MENU

echo ============= ��ȡԶ�̸��� =================
:PULL_UPDATE
echo ���ڴ�Զ�ֿ̲���ȡ����...
git pull
if %errorlevel% equ 0 (
    echo ��ȡ�ɹ������زֿ��������°汾��
) else (
    echo ��ȡʧ�ܣ����������Զ�ֿ̲��ַ�Ƿ���ȷ��
)
pause
goto MENU


echo ============= �ύ�����±�ǩ =================
:UPDATE_GIT_TAG
REM ʹ�õ�ǰĿ¼��ΪGit�ֿ�·��
SET REPO_PATH=%CD%

echo ��ǰ�����Git�ֿ�·����%REPO_PATH%
echo ==============================

REM ����Ƿ�Ϊ��Ч��Git�ֿ�
IF NOT EXIST .git (
    echo ���󣺵�ǰĿ¼ %REPO_PATH% ����һ����Ч��Git�ֿ⡣
    echo ==============================
    pause
    EXIT /B 1
)

REM ������и��Ĳ��ύ
echo ����������и���...
git add .
echo ==============================
echo �����ύ���ģ��ύ��ϢΪ "update"...
git commit -m "update"
echo ==============================

REM �����ύ��Զ�ֿ̲�
echo ���ڽ��ύ���͵�Զ�ֿ̲�...
git push
echo ==============================

REM ɾ�����ر�ǩ v1.0.0
echo ����ɾ�����ر�ǩ v1.0.0...
git tag -d v1.0.0
echo ==============================

REM ɾ��Զ�̱�ǩ v1.0.0
echo ����ɾ��Զ�̱�ǩ v1.0.0...
git push origin :refs/tags/v1.0.0
echo ==============================

REM ����ǩ�Ƿ�ɾ���ɹ�
echo ����ǩ v1.0.0 �Ƿ�ɾ���ɹ�...
git tag -l | findstr /I "v1.0.0" >nul
IF %ERRORLEVEL% EQU 0 (
    echo Զ�̱�ǩ v1.0.0 ɾ��ʧ�ܣ����ֶ���顣
) ELSE (
    echo Զ�̱�ǩ v1.0.0 ɾ���ɹ���
)
echo ==============================

REM �����±�ǩ
set /p tag_name=�������±�ǩ����ֱ�ӻس�Ĭ�ϱ�ǩ��Ϊ v1.0.0��:
if "%tag_name%"=="" (
    set tag_name=v1.0.0
)
echo ���ڴ����±�ǩ %tag_name%����ǩ��ϢΪ "Ϊ�����ύ�����´�����ǩ"...
git tag -a %tag_name% -m "Recreate tags for the latest submission"
echo ==============================

REM �����±�ǩ��Զ�ֿ̲�
echo ���ڽ��µı�ǩ %tag_name% ���͵�Զ�ֿ̲�...
git push origin %tag_name%
echo ==============================

REM ����ǩ�Ƿ����ͳɹ�
echo ����ǩ %tag_name% �Ƿ����ͳɹ�...
git tag -l | findstr /I "%tag_name%" >nul
IF %ERRORLEVEL% EQU 0 (
    echo ��ǩ %tag_name% ���ͳɹ���
) ELSE (
    echo ��ǩ %tag_name% ����ʧ�ܣ����ֶ���顣
)
echo ==============================



echo ==============================
:EXIT_SCRIPT
echo ��лʹ�ã��ټ���
timeout /t 2 >nul
exit