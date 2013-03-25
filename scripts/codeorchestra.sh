#!/bin/sh

UNAME=`uname`
SCRIPT_PATH="$0"
if [ "${UNAME}" = "Linux" ]; then
  # readlink resolves symbolic links, but on linux only
  SCRIPT_PATH=`readlink -f "$0"`
fi
PROJECT_HOME=`dirname "${SCRIPT_PATH}"`
PROJECT_HOME_FROM_STARTUP_DIR=..

if [ -z "${JDK_HOME}" ]; then
  JAVA=java
else
  JAVA="${JDK_HOME}/bin/java"
  echo "$0 info: Using jdk located in ${JDK_HOME}."
fi

MAIN_CLASS=jetbrains.mps.Launcher

if [ -z "${MPS_VM_OPTIONS}" ]; then
  MPS_VM_OPTIONS="${PROJECT_HOME}/bin/codeorchestra.vmoptions"
else
  echo "$0 info: Using vmoptions defined in ${MPS_VM_OPTIONS}."
fi
JVM_ARGS=`tr '\n' ' ' <${MPS_VM_OPTIONS} | tr '\r' ' '`
# ADDITIONAL_JVM_ARGS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005 -d32"
ADDITIONAL_JVM_ARGS="-d32"

# Beta should be launched with YourKit agent by default
ADDITIONAL_JVM_ARGS="${ADDITIONAL_JVM_ARGS} -agentpath:libyjpagent.so -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -DdataIndexerMode=load"

CLASSPATH=""
#CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/branding.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/mpsboot.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/boot.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/bootstrap.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/util.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/jdom.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/log4j.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/extensions.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/trove4j.jar

CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/actionScript.jar

CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/falcon.jar

CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/ext/codeOrchestra.actionScript.core.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/ext/codeOrchestra.actionScript.enums.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/ext/codeOrchestra.actionScript.generics.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/ext/codeOrchestra.actionScript.refactoring.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/plugins/codeOrchestra.actionScript.plugins.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/plugins/codeOrchestra.actionScript.plugins.runtime.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/baseLanguage.ext.movements.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/baseLanguage.ext.nullable.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/baseLanguage.ext.modelCache.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/codeOrchestra.actionScript.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/Scala.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/Metaas.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/Dump.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/playerglobal_swc.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/flex_swc.mpsarch.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/ActionScript/XStream.mpsarch.jar

CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/swt.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/rip.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/commons-io-2.0.1.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/canvas.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/MozillaInterfaces-1.8.1.3.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/DJNativeSwing.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/DJNativeSwing-SWT.jar

CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/CommonsVFS/commons-vfs2-2.0.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/CommonsVFS/jsch-0.1.48.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/ApacheSSHD/bcprov-jdk15-140.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/ApacheSSHD/mina-core-2.0.2.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/ApacheSSHD/slf4j-api-1.4.3.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/ApacheSSHD/slf4j-simple-1.4.3.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/ApacheSSHD/sshd-core-0.6.0.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/ApacheSSHD/sshd-pam-0.6.0.jar

CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/jetty/jetty-6.1.26.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/jetty/jetty-util-6.1.26.jar
CLASSPATH=${CLASSPATH}:${PROJECT_HOME_FROM_STARTUP_DIR}/lib/jetty/servlet-api-2.5.jar

cd ${PROJECT_HOME}
cd bin
if [ "${UNAME}" = "Darwin" ]; then
  if [ -z ${DYLD_LIBRARY_PATH} ]; then
    DYLD_LIBRARY_PATH=${PWD}
  else
    DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${PWD}
  fi
  export DYLD_LIBRARY_PATH
elif [ "${UNAME}" = "Linux" ]; then
  if [ -z ${LD_LIBRARY_PATH} ]; then
    LD_LIBRARY_PATH=${PWD}
  else
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PWD}
  fi
  export LD_LIBRARY_PATH
else
  echo "$0 warning: Unknown operating system ${UNAME}. Do not know how to add PWD to libraries path."
fi
${JAVA} ${JVM_ARGS} ${ADDITIONAL_JVM_ARGS} -classpath ${CLASSPATH} ${MAIN_CLASS} $*
