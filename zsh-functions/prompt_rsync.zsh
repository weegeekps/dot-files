#!/usr/bin/zsh

local src=$1
local dst=$2

# Validate the paths exist and are the same.
if ! [[ -d "$src" && -d "$dst" ]]; then
    if ! [[ -e "$src" && -e "$dst" ]]; then
        err_and_exit("Source and destination must exist and both be directories or files.")
    fi
fi

# Confirmation to prevent my dumb ass from making a mistake.
echo "This script copies $src to $dst.\n"
read -q "REPLY?Do you want to continue (y/N)? "
if ! [[ $REPLY =~ ^[Yy]$ ]]; then
    exit 0
fi

# Run rsync from $src to $dst
rsync -avP --delete $src $dst
