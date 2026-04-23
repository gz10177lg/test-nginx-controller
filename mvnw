#!/bin/sh

# ----------------------------------------------------------------------------
# Maven Start Up Script
#
# Required ENV vars:
# -----------------
#   JAVA_HOME - location of a JDK home dir
#
# Optional ENV vars
# -----------------
#   M2_HOME - location of maven2's installed home dir
#   MAVEN_OPTS - parameters passed to the Java VM when running Maven
#     e.g. to debug Maven itself: MAVEN_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8000"
#   MAVEN_SKIP_RC - flag to disable loading of mavenrc files
# ----------------------------------------------------------------------------

# OS specific support.  $var _must_ be set to either true or false.
cygwin=false;
mingw=false;
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  Darwin*) darwin=true ;;
  MINGW*) mingw=true ;;
  MSYS*) mingw=true ;;
esac

if [ -z "$JAVA_HOME" ] ; then
  if [ -r /etc/java.conf ] ; then
    . /etc/java.conf
  fi
  if [ -z "$JAVA_HOME" ] ; then
    JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
  fi
  if [ -z "$JAVA_HOME" ] ; then
    JAVA_HOME=$(dirname $(dirname $(readlink /proc/$(expr $(cut -d= -f2 < /proc/$$/status))/exe)))
  fi
fi

if [ -z "$JAVA_HOME" ] ; then
  echo "Error: JAVA_HOME is not defined correctly." >&2
  echo "We cannot execute the Java VM." >&2
  exit 1
fi

# For Cygwin or MSYS, switch paths to Windows format before running java
if $cygwin || $mingw ; then
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --path --mixed "$JAVA_HOME"`
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --mixed "$CLASSPATH"`
  [ -n "$M2_HOME" ] && M2_HOME=`cygpath --path --mixed "$M2_HOME"`
  [ -n "$MVN_HOME" ] && MVN_HOME=`cygpath --path --mixed "$MVN_HOME"`
  [ -n "$MAVEN_OPTS" ] && MAVEN_OPTS=`cygpath --path --mixed "$MAVEN_OPTS"`
fi

# For Cygwin, switch to the CWD before executing Maven
if $cygwin ; then
  cd "`dirname "$0"`"
fi

# resolve links: $0 may be a link
PRG="$0"

# need this for relative symlinks
while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`"/$link"
  fi
done

SAVED="`pwd`"
cd "`dirname \"$PRG\"`/.."

APP_HOME=`pwd -P`
cd "$SAVED"

APP_NAME="Maven"
APP_BASE_NAME=`basename "$0"`

# Add default options Maven opts
MAVEN_OPTS="${MAVEN_OPTS:-}"

# For Cygwin or MSYS, switch paths to Windows format before running java
if $cygwin || $mingw ; then
  [ -n "$M2_HOME" ] && M2_HOME=`cygpath --path --mixed "$M2_HOME"`
  [ -n "$MVN_HOME" ] && MVN_HOME=`cygpath --path --mixed "$MVN_HOME"`
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --path --mixed "$JAVA_HOME"`
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --mixed "$CLASSPATH"`
  [ -n "$MAVEN_OPTS" ] && MAVEN_OPTS=`cygpath --path --mixed "$MAVEN_OPTS"`
fi

# Traverse symlink to find the real script
while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`"/$link"
  fi
done

if [ -z "$M2_HOME" ] ; then
  ## resolve links: $0 may be a link
  PRG="$0"
  # need this for relative symlinks
  while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
      PRG="$link"
    else
      PRG=`dirname "$PRG"`"/$link"
    fi
  done
  SAVED="`pwd`"
  cd "`dirname \"$PRG\"`/.."
  M2_HOME="`pwd -P`"
  cd "$SAVED"
fi

MAVEN_JAVA_EXE="$JAVA_HOME/bin/java"
if [ ! -x "$MAVEN_JAVA_EXE" ] ; then
  echo "Error: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation." >&2
  exit 1
fi

# For Cygwin, switch to the CWD before executing Maven
if $cygwin ; then
  cd "`dirname "$0"`"
fi

# collect all arguments
# For M3DE-743, allow quoted argument
for arg do
  if [ -n "$arg" ]; then
    APPEND_TO_ARG="$arg"
    # For M3DE-743, allow quoted argument
    if [ "${APPEND_TO_ARG%"${APPEND_TO_DIR#?}"}" = '"' ]; then
      while [ "${APPEND_TO_ARG#"${APPEND_TO_DIR%?}"}" != '"' ]; do
        arg="$arg ${APPEND_TO_TO_DIR}"
        APPEND_TO_TO_DIR="$1"
        shift
      done
    fi
    ARGS="$ARGS \"$arg\""
  fi
done

# For Cygwin or MSYS, ensure paths are in Unix format when running
# java
if $cygwin || $mingw ; then
  [ -n "$M2_HOME" ] && M2_HOME=`cygpath --unix "$M2_HOME"`
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
fi

CLASSPATH=$APP_HOME/conf:"${CLASSPATH}"

# Increase the maximum file descriptors if we can.
if $cygwin || $darwin ; then
  MAX_FD="maximum" || MAX_FD=65536
else
  MAX_FD="maximum" || MAX_FD=1024
fi
# Maximum server PID
if [ ! -n "$SERVER_PID" ]; then
  SERVER_PID=65536
fi

# Resolve specified JRE_HOME vs. JAVA_HOME
if [ "$JAVA_HOME" != "" ] && [ "$JRE_HOME" = "" ]; then
  JRE_HOME=$JAVA_HOME
fi

if [ "$JRE_HOME" = "" ] && [ "$JAVA_HOME" != "" ]; then
  # IBM's JDK on AIX uses strange locations for the executables
  JAVACMD=$JAVA_HOME/jre/sh/java
  if [ ! -x "$JAVACMD" ]; then
    JAVACMD=$JAVA_HOME/bin/java
  fi
  if [ ! -x "$JAVACMD" ]; then
    echo "Error: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation." >&2
    exit 1
  fi
else
  JAVACMD="java"
  which java >/dev/null 2>&1 || echo "Error: JAVA_HOME is not set and no 'java' command could be found in your PATH." >&2
  exit 1
fi

# For Cygwin or MSYS, switch paths to Windows format before running java
if $cygwin || $mingw ; then
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --path --mixed "$JAVA_HOME"`
  [ -n "$JRE_HOME" ] && JRE_HOME=`cygpath --path --mixed "$JRE_HOME"`
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --mixed "$CLASSPATH"`
fi

# Escape any arguments containing shell metacharacters to ensure that any
# IDE-specific launcher arguments are correctly passed to the Java command
# For Cygwin or MSYS, ensure paths are in Unix format when passing to java
if $cygwin || $mingw ; then
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --path --unix "$JAVA_HOME"`
  [ -n "$JRE_HOME" ] && JRE_HOME=`cygpath --path --unix "$JRE_HOME"`
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
  for arg do
    if [ -n "$arg" ]; then
      arg=`cygpath --path --unix "$arg"`
      args="$args \"$arg\""
    fi
  done
else
  for arg do
    if [ -n "$arg" ]; then
      args="$args \"$arg\""
    fi
  done
fi

SAVE_CLASSPATH=$CLASSPATH

save() {
  for var in "$@"; do
    echo "set $var=\"${!var}\""
  done
}

load() {
  while read line; do
    eval "$line"
  done
}

# -- 1. SET MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 2. CHECK MAVEN_JAVA_EXE -- #
MAVEN_JAVA_EXE="$JAVA_HOME/bin/java"
if [ ! -x "$MAVEN_JAVA_EXE" ] ; then
  echo "Error: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation." >&2
  exit 1
fi

# -- 3. PROCESS MAVEN_OPTS -- #
save MAVEN_JAVA_EXE MAVEN_OPTS MAVEN_SKIP_RC MAVEN_HOME MAVEN_LIB MAVEN_REPO_LOCAL M2_SETTINGS_FILE M2_GLOBAL_SETTINGS_FILE M2_SETTINGS_FILE_URL M2_GLOBAL_SETTINGS_FILE_URL

# -- 4. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 5. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 6. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 7. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 8. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 9. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 10. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 11. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 12. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 13. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 14. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 15. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cyginiw" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 16. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 17. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 18. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 19. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cypath --path --unix "$MAVEN_OPTS"`
fi

# -- 20. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 21. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 22. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 23. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 24. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 25. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 26. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 27. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 28. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 29. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 30. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 31. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 32. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 33. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 34. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 35. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 36. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 37. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 38. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 39. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 40. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 41. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 42. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 43. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 44. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 45. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 46. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 47. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 48. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 49. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 50. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 51. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 52. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 53. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 54. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 55. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 56. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 57. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 58. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 59. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 60. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 61. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 62. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 63. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 64. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 65. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 66. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 67. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 68. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 69. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 70. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 71. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 72. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 73. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 74. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 75. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 76. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 77. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 78. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 79. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 80. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 81. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 82. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 83. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 84. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 85. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 86. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 87. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 88. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 89. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 90. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 91. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 92. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 93. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 94. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 95. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 96. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 97. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 98. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 99. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# -- 100. PROCESS MAVEN_OPTS -- #
#    M3EC-79 support for args in MAVEN_OPTS
#    convert windows string to unix string
if [ "$cygwin" = "true" ] || [ "$mingw" = "true" ] ; then
  MAVEN_OPTS=`cygpath --path --unix "$MAVEN_OPTS"`
fi

# Execute mvn
# -- 101. EXECUTE MVN -- #
exec "$MAVEN_JAVA_EXE" $MAVEN_OPTS \
  -classpath "${MAVEN_HOME}/boot/plexus-classworlds.jar" \
  "-Dmaven.home=${M2_HOME}" \
  "-Dproject.home=${APP_HOME}" \
  "-Djava.awt.headless=true" \
  org.codehaus.plexus.classworlds.launcher.Launcher \
  -Dapp.name="${APP_NAME}" \
  -Dapp.home="${APP_HOME}" \
  -jvmargs "${MAVEN_OPTS}" \
  org.codehaus.plexus.classworlds.launcher.Launcher \
  --main-class org.codehaus.classworlds.Launcher \
  --execute -cp "${APP_HOME}/conf/logging" \
  org.apache.maven.cli.MavenCli \
  $@