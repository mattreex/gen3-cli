#
# Source this file in .bashrc to expose the gen3 helper function.
# Following the example of python virtual environment scripts.
#
GEN3_CLI_HOME="${GEN3_CLI_HOME:-$(cd "${G3K_SETUP_DIR}/.." && pwd)}"

if [[ ! -f "$GEN3_CLI_HOME/gen3/lib/utils.sh" ]]; then
  echo "ERROR: is GEN3_CLI_HOME correct? $GEN3_CLI_HOME"
  unset GEN3_CLI_HOME
  return 1
fi

export GEN3_CLI_HOME

source "$GEN3_CLI_HOME/gen3/lib/utils.sh"
# gen3_load "gen3/lib/g3k"


#
# Flag values - cleared on each call to 'gen3'
#
GEN3_DRY_RUN_FLAG=${GEN3_DRY_RUN:-"false"}
GEN3_VERBOSE_FLAG=${GEN3_VERBOSE:-"false"}




gen3_run() {
  local commandStr
  local scriptName
  local scriptFolder
  local resultCode
  local subCommand

  let resultCode=0 || true
  scriptFolder="$GEN3_CLI_HOME/gen3/bin"
  commandStr=$1
  scriptName=""
  shift
  subCommand="$1"

  if [[ -z "$commandStr" || "$commandStr" =~ -*help$ || "$subCommand" =~ -*help$ ]]; then
    local helpCommand
    helpCommand="$subCommand"
    if [[ "$subCommand" =~ -*help$ ]]; then
      helpCommand="$commandStr"
    fi
    bash "$scriptFolder/usage.sh" "$helpCommand"
    return 0
  fi

  case $commandStr in
  "help")
    scriptName=usage.sh
    ;;
  "cd")
    if [[ $1 = "home" ]]; then
      cd $GEN3_CLI_HOME
      let resultCode=$? || true
    elif [[ $1 = "config" ]]; then
      cd "$GEN3_ETC_FOLDER"
      let resultCode=$? || true
    else
      cd $GEN3_WORKDIR
      let resultCode=$? || true
    fi
    scriptName=""
    ;;
  "ls")
    (
      set -e
      if [[ -n "$1" && ! "$1" =~ ^-*help ]]; then
        gen3_workon $1 gen3ls
      fi
      source "$GEN3_CLI_HOME/gen3/bin/ls.sh"
    )
    resultCode=$?
    ;;
  *)
    if [[ -f "$scriptFolder/${commandStr}.sh" ]]; then
      scriptName="${commandStr}.sh"
    else
      gen3_log_err "Cannot find command ${commandStr}"
    fi
    ;;
  esac

  if [[ ! -z "$scriptName" ]]; then
    local scriptPath="$scriptFolder/$scriptName"
    if [[ ! -f "$scriptPath" ]]; then
      gen3_log_err "internal bug - $scriptPath does not exist"
      return 1
    fi
    GEN3_DRY_RUN=$GEN3_DRY_RUN_FLAG GEN3_VERBOSE=$GEN3_VERBOSE_FLAG bash "$GEN3_CLI_HOME/gen3/bin/$scriptName" "$@"
    return $?
  fi
  return $resultCode
}


gen3() {
  if [[ ! -d "$GEN3_CLI_HOME/gen3/bin" ]]; then
    echo "ERROR $GEN3_CLI_HOME/gen3/bin does not exist"
    return 1
  fi
  GEN3_DRY_RUN_FLAG=${GEN3_DRY_RUN:-"false"}
  GEN3_VERBOSE_FLAG=${GEN3_VERBOSE:-"false"}

  unset GEN3_SOURCE_ONLY;  # cleanup if set - used by `gen3_load`

  # Remove leading flags (start with '-')
  while [[ $1 =~ ^-+.+ ]]; do
    case $1 in
    "--dryrun")
      GEN3_DRY_RUN_FLAG=true
      ;;
    "--verbose")
      GEN3_VERBOSE_FLAG=true
      ;;
    *)
      echo "Unsupported flag: $1"
      gen3_run "help"
      return 1
      ;;
    esac
    shift
  done
  # Pass remaing args to gen3_run
  gen3_run "$@"
}
