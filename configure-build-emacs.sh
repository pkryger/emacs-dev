set -euo pipefail

IFS=$'\n' read -r -d '\0' -a args <<< "$1\0"

echo "::group::Run autogen.sh"
./autogen.sh
echo "::endgroup::"

echo "::group::Run configure"
./configure "${args[@]}"
echo "::endgroup::"

echo "::group::Run make"
make "-j$(nproc)"
echo "::endgroup::"
