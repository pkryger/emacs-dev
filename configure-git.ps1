param(
    [Parameter(Mandatory = $true)]
    [string] $MSYS2Location
)

echo "::group::Configure git line endings"
git config --global core.autocrlf inherit
git config -l
echo "::endgroup::"

echo "::group::Favour using system git"
$linkDir = Join-Path $MSYS2Location "usr" "local" "bin"
if (-Not (Test-Path $linkDir)) {
    New-Item -ItemType Directory -Path $linkDir -Force | Out-Null
}

$target = "C:\Program Files\Git\bin\git.exe"
$link   = Join-Path $linkDir "git.exe"

New-Item -ItemType SymbolicLink -Path $link -Target $target
echo "::endgroup::"
