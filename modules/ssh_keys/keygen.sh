#!/bin/bash

set -e

function error_exit() {
  echo "$1" 1>&2
  exit 1
}

function check_deps() {
  test -f $(which dirname) || error_exit "dirname command not detected in path, please install it or fix path"
  test -f $(which yes) || error_exit "yes command not detected in path, please install it or fix path"
  test -f $(which awk) || error_exit "awk command not detected in path, please install it or fix path"
  test -f $(which ssh-keygen) || error_exit "ssh-keygen command not detected in path, please install it or fix path"
  test -f $(which jq) || error_exit "jq command not detected in path, please install it or fix path"
}

function parse_input() {
  # jq reads from stdin so we don't have to set up any inputs, but let's validate the outputs
  eval "$(jq -r '@sh "export NAME=\(.name) KEY_PATH=\(.path) ENVIRONMENT=\(.env)"')"
  if [[ -z "${NAME}" ]]; then export NAME=none; fi
  if [[ -z "${KEY_PATH}" ]]; then export KEY_PATH=none; fi
  if [[ -z "${ENVIRONMENT}" ]]; then export ENVIRONMENT=none; fi
}

function create_ssh_key() {
  script_dir=$(dirname $0)
  local ssh_key_path="${script_dir}/${KEY_PATH}"

  if [[ ! -f ${ssh_key_path} ]]; then
    mkdir -p ${ssh_key_path}
  fi

  export ssh_key_file="${ssh_key_path}/${NAME}-${ENVIRONMENT}"

  # echo "DEBUG: ssh_key_file = ${ssh_key_file}" 1>&2

	if [[ ! -f "${ssh_key_file}" ]]; then
    yes yes | ssh-keygen -q -t rsa -b 4096 -C "${NAME}-${ENVIRONMENT} keypair" -N '' -f ${ssh_key_file} > /dev/null 2>&1
   fi
}

function produce_output() {
  public_key_contents=$(cat ${ssh_key_file}.pub)
#  echo "DEBUG: public_key_contents ${public_key_contents}" 1>&2
  private_key_contents=$(cat ${ssh_key_file} | awk '$1=$1' ORS='  \n')
#  echo "DEBUG: private_key_contents ${private_key_contents}" 1>&2
#  echo "DEBUG: private_key_file ${ssh_key_file}" 1>&2
  jq -n \
    --arg public_key "$public_key_contents" \
    '{"public_key":$public_key}'
}

check_deps
parse_input
create_ssh_key
produce_output

# echo '{"name": "foo", "path": "bar", "environment": "baz"}'