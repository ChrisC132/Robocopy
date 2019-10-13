@echo off

:Main
echo Verbundene Speichermedien:

for /f "skip=1 tokens=1,2 delims=: " %%a in ('wmic logicaldisk get deviceid^,volumename') do (
	if %%a neq C (
		if %%a neq "" (
			echo.%%a %%b
		)
	)
)

echo Buchstaben des Sicherungsmediums eingeben:
set /p medium=""

for /f "skip=1 tokens=1,2 delims=: " %%a in ('wmic logicaldisk get deviceid^,volumename') do (
	if %%a neq C (
		if %%a neq "" (
			if /I %%a equ %medium% (
				call :Copy %%a, %%b
			)
		)
	)
) 
echo Falschen Laufwerkbuchstabe eingegeben
PAUSE
EXIT


:Copy
	set folders=Pictures Documents Downloads Music Videos Desktop AppData
	
	set from=%USERPROFILE%\
	set to=%~1:\Backup\
	
	echo Sichert folgende Verzeichnisse:
	(for %%a in (%folders%) do (
		echo.%from%%%a --^> %to%%%a
	))
	
	echo.
	echo.Wirklich sichern^? [Y/N]
	set /p medium=""
	
	if /I %medium% neq y (
		EXIT
	)
	
	(for %%a in (%folders%) do (
		robocopy %from%%%a %to%%%a /MIR /FFT /Z /W:5 /R:5
	))
	
	
	echo.Fertig
PAUSE
EXIT


rem robocopy von zu /MIR /FFT /Z /W:5 /R:5