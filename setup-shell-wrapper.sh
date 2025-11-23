echo "::group::Setup shell wrapper"

dest=${HOME}/.local/bin/setup-emacs-dev-bash
bash=$(which bash)

mkdir -p "$(dirname "${dest}")"
echo "#!${bash}" > "${dest}"
echo "exec ${bash} --noprofile --norc -e -o pipefail \"\$@\"" >> "${dest}"
chmod +x "${dest}"

ls -l "${dest}"

echo "::endgroup::"
