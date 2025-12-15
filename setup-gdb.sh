#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $(basename "${0}") PATH" >&2
    exit 1
fi

path=${1}

echo "::group::Setup GDB"


if [[ "${path}" =~ ^[[:alpha:]]:\\ ]]; then
    echo "add-auto-load-safe-path ${path}\src\.gdbinit" > "${HOME}/.gdbinit"
else
    echo "add-auto-load-safe-path ${path}/src/.gdbinit" > "${HOME}/.gdbinit"
fi

ls -l "${HOME}/.gdbinit"
cat "${HOME}/.gdbinit"

echo "::endgroup::"
