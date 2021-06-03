#!/usr/bin/env bash

THIS="$(dirname "$(readlink -fm "$0")")"
SERVER=FALSE
CLEANUP=false

_arguments() {
  for PARM in "$@"; do
    if [ "${PARM}" = "--server" ]; then
      SERVER=TRUE
    elif [ "${PARM}" = "--cleanup" ]; then
      CLEANUP=TRUE
    elif [ "${PARM}" = "-h" ] || [ "${PARM}" = "--help" ]; then
      _help
      exit 0
    fi
  done
}

_help() {
  echo "Usage: $(readlink -fm "$0") [-h | --help] [--cleanup]"
  echo
  echo "Options:"
  echo "  -h | --help : Prints this help message and quits"
  echo "  --server: Customizes the terminal feel for a server installation"
  echo "  --cleanup: Removes the source folder after installation"
  echo
}

_bash_overrides() {
  cp -r bashrc_overrides ~/.bashrc_overrides
  echo "#REF:bashrc_overrides:REF" >> ~/.bashrc
  echo "if [ -f ~/.bashrc_overrides/_all ]; then" >> ~/.bashrc
  echo "  . ~/.bashrc_overrides/_all" >> ~/.bashrc
  echo "fi" >> ~/.bashrc
}

_cleanup() {
  rm -rf ${THIS}
}

_main() {
  _arguments "$@"

  if [ ! -z "$(grep "#REF:bashrc_overrides:REF" ~/.bashrc)" ]; then
    echo "bash overrides already in place"
    echo "skipping..."
    echo
  else
    _bash_overrides
    echo "bash overrides added"
    echo
  fi

  if [ "${SERVER}" = true ]; then
    sed -i 's/terminal_fancyfying/terminal_fancyfying_server/' ~/.bashrc_overrides/_all
  fi

  if [ "${CLEANUP}" = true ]; then
    echo "cleaning up..."
    _cleanup
  fi
}

_main "$@"
