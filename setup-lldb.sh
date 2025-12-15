#!/usr/bin/env bash

echo "::group::Setup LLDB"

echo "settings set target.load-cwd-lldbinit true" > "${HOME}/.lldbinit"

ls -l "${HOME}/.lldbinit"
cat "${HOME}/.lldbinit"

echo "::endgroup::"
