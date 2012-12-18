@echo off

set PROJECT_HOME=%~dp0
set JAVA=javaw
IF EXIST "%PROJECT_HOME%jre" set JAVA="%PROJECT_HOME%jre\bin\%JAVA%"
set MAIN_CLASS=codeOrchestra.rgs.server.bootstrap.RGSBootstrap
SET MPS_VM_OPTIONS="%PROJECT_HOME%bin\codeorchestra.vmoptions"
set ACC=
FOR /F "delims=" %%i in ('TYPE %MPS_VM_OPTIONS%') DO call :parse_vmoptions "%%i"
set JVM_ARGS=%ACC%
::set ADDITIONAL_JVM_ARGS=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005
::set ADDITIONAL_JVM_ARGS=-d32

set CLASSPATH="%PROJECT_HOME%lib\mpsboot.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\boot.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\bootstrap.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\util.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\jdom.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\log4j.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\extensions.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\trove4j.jar"

set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\actionScript.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\mps.jar"

set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\falcon.jar"

set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%plugins\mpsmake.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%plugins\mpseditor.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%plugins\vcs.jar"

set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\ApacheSSHD\bcprov-jdk15-140.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\ApacheSSHD\mina-core-2.0.2.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\ApacheSSHD\slf4j-api-1.4.3.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\ApacheSSHD\slf4j-simple-1.4.3.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\ApacheSSHD\sshd-core-0.6.0.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\ApacheSSHD\sshd-pam-0.6.0.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\ApacheSSHD\tomcat-apr-5.5.23.jar"

set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\CommonsVFS\commons-vfs2-2.0.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\CommonsVFS\jsch-0.1.48.jar"

set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%ActionScript\baseLanguage.ext.movements.mpsarch.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%ActionScript\baseLanguage.ext.nullable.mpsarch.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%ActionScript\baseLanguage.ext.modelCache.mpsarch.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%ActionScript\codeOrchestra.actionScript.mpsarch.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%ActionScript\Scala.mpsarch.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%ActionScript\Metaas.mpsarch.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%ActionScript\Dump.mpsarch.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%ActionScript\XStream.mpsarch.jar"

set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\commons-io-2.0.1.jar"
set CLASSPATH=%CLASSPATH%;"%PROJECT_HOME%lib\commons-lang-2.4.jar"

pushd bin
start "" %JAVA% %JVM_ARGS% %ADDITIONAL_JVM_ARGS% -classpath %CLASSPATH% %MAIN_CLASS% %*
popd

exit

:parse_vmoptions
if not defined ACC goto emptyacc
if "%SEPARATOR%" == "" goto noseparator
set ACC=%ACC%%SEPARATOR%%1
goto :eof

:noseparator
set ACC=%ACC% %1
goto :eof

:emptyacc
set ACC=%1
goto :eof

