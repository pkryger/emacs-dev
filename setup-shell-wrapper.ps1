echo "::group::Setup shell wrapper"

$target = (Get-Command msys2).Path
$link=Join-Path (Split-Path $target) "setup-emacs-dev-bash.cmd"
New-Item -ItemType SymbolicLink -Path $link -Target $target

echo "::endgroup::"
