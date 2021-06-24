@echo off
for /r "%CD%" %%a in (Script*.iss) do set script=%%~dpnxa
start "" "IS_Files\Compil32Ex.exe" /CC "%script%"