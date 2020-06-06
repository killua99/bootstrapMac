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

  TMPFILE=`mktemp`

  rm -rf ${TMPDIR}bootstrapMac-master

  wget https://github.com/killua99/bootstrapMac/archive/master.zip -O ${TMPFILE}
  unzip -qq -d ${TMPDIR} ${TMPFILE}

  cd ${TMPDIR}bootstrapMac-master/

  ${TMPDIR}bootstrapMac-master/install.sh -l
  exit 0

fi

STATUS_XCODE=`xcode-select -p 1>/dev/null; printf $?`

if [[ STATUS_XCODE == 2 ]]; then
  xcode-select --install
fi

[ -f "/usr/local/lib" ] && sudo chmod -R 775 /usr/local/lib
[ -f "/usr/local/share" ] && sudo chmod -R 775 /usr/local/share
[ -f "/usr/local/Homebrew" ] && sudo chmod -R 775 /usr/local/Homebrew
[ -f "/usr/local/var/homebrew" ] && sudo chmod -R 775 /usr/local/var/homebrew
[ -f "/usr/local/Cellar" ] && sudo chmod -R 775 /usr/local/Cellar

[ -x "$(which brew)" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

[ -x "$(which ansible-playbook)" ] && brew install ansible

ansible-playbook bootstrap.yml
