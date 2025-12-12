#!/usr/bin/env bash

set -euo pipefail

re='[^[:alnum:][:blank:]_'\''":/+=-]'
args=()
for ((i=1; i<=$#; i++)); do
    while IFS=$'\n' read -r -a arg; do
        if [[ "${arg[*]-}" =~ $re ]]; then
            echo "[$(basename "${0}")] Unsafe argument: ${arg[*]}" >&2
            exit 1
        else
            eval "args+=(${arg[*]-})"
        fi
    done < <(printf "%s\n" "${!i}"              \
                 | grep -v -e '^[[:space:]]*$')
done

if [[ -n "${HOMEBREW_PREFIX+x}" ]]; then
    cflag="-isystem=${HOMEBREW_PREFIX}/include"
    ldflag="-L${HOMEBREW_PREFIX}/lib"
    for ((i = 0; i < ${#args[@]}; i++)); do
        elt="${args[${i}]}"
        if [[ "${elt}" =~ ^CFLAGS= ]]; then
            if [[ ! "${elt}" =~ ${cflag}$
                    && ! "${elt}" =~ ${cflag}[[:space:]] ]]; then
                args[i]="CFLAGS=${cflag} ${elt/#CFLAGS=}"
            fi
            cflag=""
        elif [[ "${elt}" =~ ^LDFLAGS= ]]; then
            if [[ ! "${elt}" =~ ${ldflag}$
                    && ! "${elt}" =~ ${ldflag}[[:space:]] ]]; then
                args[i]="LDFLAGS=${ldflag} ${elt/#LDFLAGS=}"
            fi
            ldflag=""
        fi
    done
    if [[ -n "${cflag}" ]]; then
        args+=("CFLAGS=${cflag}${CFLAGS+ ${CFLAGS}}")
    fi
    if [[ -n "${ldflag}" ]]; then
        args+=("LDFLAGS=${ldflag}${LDFLAGS+ ${LDFLAGS}}")
    fi
fi

echo "::group::Run autogen.sh"
./autogen.sh
echo "::endgroup::"

echo "::group::Run configure"
configure=(./configure "${args[@]}")
echo "[$(basename "${0}")] Running:" "${configure[@]}"
"${configure[@]}"
echo "::endgroup::"

echo "::group::Run make"
make "-j$(nproc)"
echo "::endgroup::"
