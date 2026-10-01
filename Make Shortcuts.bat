@echo off
rem Create the three Desktop shortcuts the README promises, named after
rem this agent. Re-run it any time; it overwrites whatever is there.
rem
rem These are ordinary shortcuts, no install step and nothing elevated, so
rem they can be deleted from the Desktop like any other file.
setlocal

cd /d "%~dp0"

rem The display name comes from backtalk.json, which is the same file the
rem voice itself reads, so the shortcuts cannot drift from the agent's name.
set "AGENTNAME=Assistant"
rem Plain %%n, not !AGENTNAME!: reading the variable back inside its own
rem for-block needs delayed expansion, which this script deliberately does
rem not enable.
for /f "tokens=2 delims=:," %%n in ('findstr /r /c:"\"name\"" backtalk\backtalk.json') do (
  set "AGENTNAME=%%n"
)
rem Trim spaces and quotes left behind by the token split.
for /f "tokens=* delims= " %%n in ("%AGENTNAME%") do set "AGENTNAME=%%n"
set "AGENTNAME=%AGENTNAME:"=%"

if "%AGENTNAME%"=="" set "AGENTNAME=Seyon"

set "DESK=%USERPROFILE%\Desktop"
set "START=%~dp0fullstack-agent\start.bat"
set "ICON=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

echo   name: %AGENTNAME%
echo   making shortcuts on %DESK%
echo.

rem -- Talk: the voice and the face. start.bat "voice" starts exactly those
rem    two and skips the hands board.
powershell -NoProfile -Command ^
  "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%DESK%\Talk to %AGENTNAME%.lnk');" ^
  "$s.TargetPath='%ComSpec%';" ^
  "$s.Arguments='/c ""%START%"" voice';" ^
  "$s.WorkingDirectory='%~dp0';" ^
  "$s.Description='Start the voice and the face';" ^
  "$s.Save()"
echo   Talk to %AGENTNAME%.lnk

rem -- Barehands: the voice and the hands board instead of the face.
powershell -NoProfile -Command ^
  "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%DESK%\%AGENTNAME% barehands.lnk');" ^
  "$s.TargetPath='%ComSpec%';" ^
  "$s.Arguments='/c ""%START%"" hands';" ^
  "$s.WorkingDirectory='%~dp0';" ^
  "$s.Description='Start the voice and the hands board';" ^
  "$s.Save()"
echo   %AGENTNAME% barehands.lnk

rem -- Chat: a typed session, terminal only. No voice, no face.
powershell -NoProfile -Command ^
  "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%DESK%\Chat with %AGENTNAME%.lnk');" ^
  "$s.TargetPath='cmd.exe';" ^
  "$s.Arguments='/k opencode';" ^
  "$s.WorkingDirectory='%~dp0';" ^
  "$s.Description='A typed session with %AGENTNAME%';" ^
  "$s.Save()"
echo   Chat with %AGENTNAME%.lnk

echo.
echo Done. The shortcuts are on your Desktop.
endlocal