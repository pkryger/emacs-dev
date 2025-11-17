if [[ $# -ne 4 ]]; then
    echo "Usage $0 RUNNER_OS GITHUB_SERVER_URL REPOSITORY BASE_REF"
    exit 1
fi

set -euo pipefail

runner_os=$1
repository=$2/$3
base_ref=$4

sha=$(git ls-remote "${repository}" "${base_ref}" \
          | cut -f 1)

if [[ -z "${sha}" ]]; then
    echo "Cannot get commit ID for reference ${base_ref} from ${repository}" >&2
    exit 2
fi

echo "emacs-${runner_os}-${base_ref}-${sha}" | tee /dev/stderr
