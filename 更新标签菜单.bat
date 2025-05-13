@echo off
SETLOCAL EnableDelayedExpansion

:MAIN
    title ͨ��Git�ֿ�������ǩ������
    set "REPO_PATH=%CD%"

    echo ============================================
    echo ͨ��Git�ֿ�������ǩ������
    echo ============================================
    echo ��ǰĿ¼: %REPO_PATH%
    echo ============================================
    echo ��ѡ�����:
    echo 1. �����²�����
    echo 2. ���±�ǩ
    echo 3. �����²����� + ���±�ǩ
    echo 4. �˳�
    echo ============================================
    
    set /p choice="������ѡ��(1-4): "
    
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
        echo ��Ч��ѡ�����������
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
    
    set /p tagName="�������ǩ����(����v1.0.0): "
    if "!tagName!"=="" (
        echo ��ǩ���Ʋ���Ϊ��
        goto :EXIT_SCRIPT
    )
    
    set /p tagMessage="�������ǩ������Ϣ: "
    if "!tagMessage!"=="" (
        set "tagMessage=�Զ������ı�ǩ !tagName!"
    )
    
    call :DeleteTag "!tagName!"
    if errorlevel 1 goto :EXIT_SCRIPT
    
    call :CreateAndPushTag "!tagName!" "!tagMessage!"
    if errorlevel 1 goto :EXIT_SCRIPT
    
    exit /b 0

:ValidateGitRepo
    if not exist "%REPO_PATH%\.git" (
        echo ============================================
        echo ����: ��ǰĿ¼����һ����Ч��Git�ֿ�
        echo ============================================
        exit /b 1
    )
    exit /b 0

:CheckForChanges
    echo ============================================
    echo ���ڼ��Git�ֿ�״̬...
    echo ============================================
    
    git status >nul 2>&1
    if errorlevel 1 (
        echo �޷���ȡGit�ֿ�״̬������Git����
        exit /b 1
    )
    
    set "CHANGES="
    for /f "delims=" %%D in ('git status --porcelain') do (
        if "%%D" neq "" set "CHANGES=YES"
    )
    
    if defined CHANGES (
        echo ��⵽�ļ��޸ģ�׼���ύ...
        
        set "COMMIT_MSG=�Զ��ύ�� %DATE% %TIME%"
        set /p COMMIT_MSG="�������ύ��Ϣ(ֱ�ӻس�ʹ��Ĭ����Ϣ): "
        if "!COMMIT_MSG!"=="" (
            set "COMMIT_MSG=�Զ��ύ�� %DATE% %TIME%"
        )
        
        call :AddChanges
        if errorlevel 1 exit /b 1
        
        call :CommitChanges "!COMMIT_MSG!"
        if errorlevel 1 exit /b 1
        
        call :PushChanges
        if errorlevel 1 exit /b 1
        
        echo �ύ�����ͳɹ����!
    ) else (
        echo û�м�⵽�ļ��޸ģ�����ֱ�����͵�Զ�ֿ̲�...
        call :PushChanges
        if errorlevel 1 exit /b 1
    )
    
    exit /b 0

:AddChanges
    echo ============================================
    echo ����������и��ĵ��ݴ���...
    echo ============================================
    
    git add .
    if errorlevel 1 (
        echo ����: �޷�����ļ����ݴ���
        exit /b 1
    )
    exit /b 0

:CommitChanges
    echo ============================================
    echo �����ύ���ĵ����زֿ�...
    echo �ύ��Ϣ: %~1
    echo ============================================
    
    git commit -m "%~1"
    if errorlevel 1 (
        echo ����: �ύ�����زֿ�ʧ��
        exit /b 1
    )
    exit /b 0

:PushChanges
    echo ============================================
    echo �������͸��ĵ�Զ�ֿ̲�...
    echo ============================================
    
    for /f "delims=" %%b in ('git symbolic-ref --short HEAD 2^>nul') do set "CURRENT_BRANCH=%%b"
    
    if defined CURRENT_BRANCH (
        git push origin !CURRENT_BRANCH!
    ) else (
        git push
    )
    
    if errorlevel 1 (
        echo ����: ���͵�Զ�ֿ̲�ʧ�ܣ����������Զ������
        exit /b 1
    )
    exit /b 0

:DeleteTag
    echo ============================================
    echo ����ɾ����ǩ %~1...
    echo ============================================
    
    git tag -d %~1 >nul 2>&1
    git push origin :refs/tags/%~1 >nul 2>&1
    
    git tag -l | findstr /I "%~1" >nul
    if %errorlevel% equ 0 (
        echo ����: ��ǩ %~1 ɾ��ʧ�ܣ����ܲ�����
    ) else (
        echo ��ǩ %~1 ɾ���ɹ�
    )
    exit /b 0

:CreateAndPushTag
    echo ============================================
    echo ���ڴ����±�ǩ %~1...
    echo ��ǩ����: %~2
    echo ============================================
    
    git tag -a %~1 -m "%~2"
    if errorlevel 1 (
        echo ����: ������ǩʧ��
        exit /b 1
    )
    
    git push origin %~1
    if errorlevel 1 (
        echo ����: ���ͱ�ǩʧ��
        exit /b 1
    )
    
    echo ��ǩ %~1 ���������ͳɹ�!
    exit /b 0

:EXIT_SCRIPT
    echo ============================================
    echo ��������˳�...
    echo ============================================
    pause >nul
    exit /b 0