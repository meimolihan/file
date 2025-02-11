@echo off
cd /d "%USERPROFILE%\Desktop\GitHub\file"

git add .
git commit -m "update"
git push

pause