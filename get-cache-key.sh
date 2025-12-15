#!/usr/bin/env bash

echo "::group::Get cache key" >&2

if [[ $# -lt 4 ]]; then
    echo "Usage: $(basename "${0}") RUNNER_OS GITHUB_SERVER_URL REPOSITORY BASE_REF [ARGS...]" >&2
    echo "::engroup::" >&2
    exit 1
fi

set -euo pipefail

this="[$(basename "${0}")]"
runner_os=${1}
repository=${2}/${3}
base_ref=${4}

repo_sha=$(git ls-remote "${repository}" "${base_ref}"  \
               | cut -f 1)

echo "${this} Emacs repository SHA: ${repo_sha}" >&2

if [[ -z "${repo_sha}" ]]; then
    echo "${this} Cannot get commit ID for reference ${base_ref} from ${repository}" >&2
    exit 2
fi

re='[^[:alnum:][:blank:]_'\''":/+=-]'
args=()
for ((i = 5; i <= $#; i++)); do
    while IFS=$'\n' read -r -a arg; do
        if [[ "${arg[*]-}" =~ $re ]]; then
            echo "${this} Unsafe argument: ${arg[*]}" >&2
            exit 1
        else
            eval "args+=(${arg[*]-})"
        fi
    done < <(printf "%s\n" "${!i}"              \
                 | grep -v -e '^[[:space:]]*$')
done

sorted_args=()
while read -r arg; do
    sorted_args+=("${arg}")
done < <(printf "%s\n" "${args[@]}"             \
             | sort                             \
             | uniq)

echo "${this} Arguments:" "${sorted_args[@]}" >&2

sha=$(printf "%s\n%s" "${repo_sha}" "${sorted_args[@]}" \
          | sha256sum                                   \
          | cut -d ' ' -f 1)

key="setup-emacs-dev-${runner_os}-${base_ref}-${sha}"
echo "${this} Key: ${key}" >&2
echo "::engroup::" >&2

echo "${key}"
