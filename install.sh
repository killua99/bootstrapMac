#!/usr/bin/env bash

set -e

POSITIONAL=()

while [[ $# -gt 0 ]]; do
  key="$1"

  case "$key" in

    -l|--local)

      LOCAL=1

      shift
      ;;
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

if [[ -z ${LOCAL} ]]; then

  cd $HOME

  # Removing legacy way of installing.
  rm -rf ${TMPDIR}master.zip
  rm -rf ${TMPDIR}bootstrapMac-master

  curl -L https://github.com/killua99/bootstrapMac/archive/master.zip --output master.zip
  unzip -qq -d ${HOME}/ master.zip

  mv bootstrapMac-master .bootstrapMac

  cd .bootstrapMac

  ${HOME}/.bootstrapMac/install.sh -l
  exit 0

fi

STATUS_XCODE=`xcode-select -p 1>/dev/null; printf $?`

if [[ STATUS_XCODE == 2 ]]; then
  xcode-select --install
fi

[ ! -x "$(which brew)" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
[ -x "$(which brew)" ] && sudo chown -R $(whoami) $(brew --prefix)/*`
[ -x "$(which brew)" ] && sudo chmod -R 775 $(brew --prefix)/*`

[ ! -x "$(which ansible-playbook)" ] && brew install ansible

ansible-playbook bootstrap.yml
