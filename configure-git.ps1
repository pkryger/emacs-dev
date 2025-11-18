echo "::group::Run git config"
git config --global core.autocrlf false
git config --global core.eol lf
git config -l
echo "::endgroup::"
