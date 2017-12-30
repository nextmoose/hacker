#!/bin/sh

pass git ls-tree -r --name-only HEAD | while read FILE
do
    echo "$(pass git log -1 --format="%ad" -- ${FILE}) ${FILE}"
done