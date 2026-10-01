@echo off
rem Stop Jarvis: the voice, the face, and the supervisor that watches them.
rem The opencode brain stays available for the other agents, so nothing
rem else is disturbed.
rem
rem The supervisor has to stop too. It used to be left running, which meant
rem this script reported "stopped" and then watched the supervisor start the
rem voice and face again on its next poll, ten seconds later.
cd /d "%USERPROFILE%\my-agent\fullstack-agent"
py -3 supervisor.py --stop
echo.
echo Jarvis stopped.
timeout /t 6 >nul
