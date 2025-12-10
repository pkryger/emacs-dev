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
