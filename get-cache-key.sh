echo "::group::Get cache key" >&2

if [[ $# -ne 5 ]]; then
    echo "Usage $0 RUNNER_OS GITHUB_SERVER_URL REPOSITORY BASE_REF CONFIGURE_ARGUMENTS" >&2
    echo "::engroup::" >&2
    exit 1
fi

set -euo pipefail

runner_os=$1
repository=$2/$3
base_ref=$4
configure_arguments=$5

repo_sha=$(git ls-remote "${repository}" "${base_ref}" \
          | cut -f 1)

echo "Emacs repository SHA: ${repo_sha}" >&2

if [[ -z "${repo_sha}" ]]; then
    echo "Cannot get commit ID for reference ${base_ref} from ${repository}" >&2
    exit 2
fi

sha=$(printf "%s\n%s" "${repo_sha}" "${configure_arguments}" \
          | sort \
          | grep -v -e '^\s*$' \
          | sha256sum \
          | cut -d ' ' -f 1)

key="setup-emacs-dev-${runner_os}-${base_ref}-${sha}"
echo "Key: ${key}" >&2
echo "::engroup::" >&2

echo "${key}"
