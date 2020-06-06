!#/usr/bin/env bash

set -e

POSITIONAL=()

while [[ $# -gt 0 ]]; do
  key="$1"

  case "$key" in
    -h|--help)
      cat <<EOF

Command usage:

./install.sh -h|--help

Options:

  ⌾ -d, --debug    Print help command.
  ⌾ -h, --help    Print help command.

Help:

  This installer will bootsrap a Mac installing commun software and libraries.

    ``./install.sh``

EOF

      exit 0;
      ;;

    -d|--debug)
      set -xeu

      shift
      ;;

    *)
      POSITIONAL+=("$1")
      shift
      ;;

  esac
done

set -- "${POSITIONAL[@]}"

xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew install ansible

ansible-playbook bootstrap.yml
