if [[ $# -gt 1 ]]; then
    echo "Usage: $(basename "${0}") [TYPE]"
    exit 1
fi

type=${1:+(${1})}

echo "::group::Configure git line endings, user and email ${type}"
git config --global core.autocrlf input
git config --global user.name "$GITHUB_ACTOR"
git config --global user.email "$GITHUB_ACTOR_ID+$GITHUB_ACTOR@users.noreply.github.com"
git config --show-origin --list
echo "::endgroup::"
