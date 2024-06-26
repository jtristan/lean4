#!/usr/bin/env bash
set -euxo pipefail

LAKE=${LAKE:-../../.lake/build/bin/lake}

./clean.sh

# Test the `postUpdate?` configuration option and the docstring example.
# If the Lake API experiences changes, this test and the docstring should be
# updated in tandem.

echo "root" > toolchain
echo "dep" > dep/toolchain
$LAKE update | grep --color -F "post-update hello w/ arguments: [get]"
test "`cat toolchain`" = dep

