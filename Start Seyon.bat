@echo off
rem Start the whole Seyon stack and keep it healthy.
rem Double-click this. Close it only when you want Seyon off.
cd /d "%USERPROFILE%\my-agent\fullstack-agent"
py -3 supervisor.py
pause
