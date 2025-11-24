# Setup MSYS2 texinfo to be runnable from a pwsh shell.

param(
    [Parameter(Mandatory = $true)]
    [string] $MSYS2Location
)

echo "::group::Setup texinifo"

# Ensure MSYS2 /usr/local/bin, /usr/bin, and /bin are in the PATH.  Adding the
# /usr/local/bin in the front to make sure git.exe is picked up from there.
Join-Path ${MSYS2Location} "bin" `
  | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append
Join-Path ${MSYS2Location} "usr" "bin" `
  | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append
Join-Path ${MSYS2Location} "usr" "local" "bin" `
  | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append

# Make makeinfo runnable under Windows
$makeinfo = Join-Path ${MSYS2Location} "usr" "bin" "makeinfo.bat"
if (-Not (Test-Path $makeinfo)) {
    Set-Content -Path $makeinfo -Value @(
        '@echo off'
        'perl "%~dpn0" %*'
    )
}

echo "::endgroup::"
