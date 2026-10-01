@echo off
rem Stop the Jarvis voice and the face. The opencode brain stays available
rem for the other agents, so nothing else is disturbed.
cd /d "%USERPROFILE%\my-agent\fullstack-agent"
py -3 supervisor.py --stop
echo.
echo Jarvis voice and face stopped.
timeout /t 6 >nul
