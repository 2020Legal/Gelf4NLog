@echo Off
ECHO Starting build

set config=%1
if "%config%" == "" (
   set config=Release
)

set version=
if not "%PackageVersion%" == "" (
   set version=-Version %PackageVersion%
)
if not "%GitVersion_NuGetVersion%" == "" (
	if "%version%" == "" (
		set version=-Version %GitVersion_NuGetVersion%
	)
)

set PATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin;%PATH%

if "%nuget%" == "" (  
  set nuget=nuget.exe
)

REM Restoring Packages
ECHO Restoring Packages
call "%nuget%" restore "NLog.Targets.Gelf.sln"
if not "%errorlevel%"=="0" goto failure

ECHO Running MSBUILD and pack
REM Build
msbuild NLog.Targets.Gelf.sln /p:Configuration="%config%" /p:PackageOutputPath="../Build" /m /v:M /fl /flp:LogFile=msbuild.log;Verbosity=Normal /nr:false

:success
ECHO successfully built project
REM exit 0
goto end

:failure
ECHO failed to build.
REM exit -1
goto end

:end