!#/usr/bin/env bash

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

  wget https://github.com/killua99/bootstrapMac/archive/master.zip -O ${TMPFILE}
  unzip -d ${TMPDIR} ${TMPFILE}

  ${TMPDIR}/bootstrapMac-master/install.sh -l
  exit 0

fi

xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew install ansible

ansible-playbook bootstrap.yml
