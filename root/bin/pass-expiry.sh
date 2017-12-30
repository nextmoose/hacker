#!/bin/sh

pass git ls-tree -r --name-only HEAD | grep ".gpg\\\$" | while read FILE
do
    pass git log -1 --format="%at ${FILE}" -- ${FILE}
done | sort -k 1