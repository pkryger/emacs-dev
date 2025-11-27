echo "::group::Configure git line endings, user and email"
git config --global core.autocrlf input
git config --global user.name "$GITHUB_ACTOR"
git config --global user.email "$GITHUB_ACTOR_ID+$GITHUB_ACTOR@users.noreply.github.com"
git config -l
echo "::endgroup::"
