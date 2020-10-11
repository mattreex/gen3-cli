#!/bin/bash
#
# This script will copy the environment configuration of the specified environment or apply
# version updates to all the services and may specify particular values for a given subset of services.
# It is designed to be used in Dev or QA virtual machines.
#
# gen3 config-env copy {repo} {environment}
# repo = The Github repository where the environment is located
# environment = The Gen3 environment to be copied

# gen3 config-env apply {version} {override}
# version = The version of services desired
# override = (optional) Json-formatted string for assigning versions to specific services

# Example usage:
# gen3 config-env copy cdis-manifest gen3.theanvil.io
# gen3 config-env apply 2020.09
# gen3 config-env apply 2020.09 {"ambassador":"quay.io/datawire/ambassador:2020.11"}

source ${GEN3_CLI_HOME}/gen3/lib/utils.sh


run_pypfb() {
  if [[ -e ${GEN3_CLI_HOME}/pypfb ]]; then
    git -C ${GEN3_CLI_HOME}/pypfb checkout master
    git -C ${GEN3_CLI_HOME}/pypfb pull
  else
    git clone git@github.com:uc-cdis/pypfb.git ${GEN3_CLI_HOME}/pypfb
  fi

  cd ${GEN3_CLI_HOME}/pypfb
  python3 -m pip install poetry
  poetry install
  poetry run pfb ${cmd}
  check_error=$?
  if [[ $check_error != 0 ]]; then
    gen3_log_err "Something went wrong in pypfb script, exited with code $check_error"
    return 1
  fi

  cd ${GEN3_CLI_HOME}
  set --
}

# Let testsuite source file
if [[ -z "$GEN3_SOURCE_ONLY" ]]; then
  run_pypfb "$@"
fi
