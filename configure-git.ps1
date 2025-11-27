param(
    [Parameter(Mandatory = $true)]
    [string] $MSYS2Location
)

echo "::group::Configure git line endings, user and email"
git config --global core.autocrlf input
git config --global user.name "$env:GITHUB_ACTOR"
git config --global user.email "$env:GITHUB_ACTOR_ID+$env:GITHUB_ACTOR@users.noreply.github.com"
git config -l
echo "::endgroup::"

echo "::group::Favour using system git"
$linkDir = Join-Path $MSYS2Location "usr" "local" "bin"
if (-Not (Test-Path $linkDir)) {
    New-Item -ItemType Directory -Path $linkDir -Force | Out-Null
}

$target = (Get-Command git).Path
$link   = Join-Path $linkDir "git.exe"

New-Item -ItemType SymbolicLink -Path $link -Target $target
echo "::endgroup::"
