set -euo pipefail

echo "::group::Run make"
make "-j$(nproc)"
echo "::endgroup::"
