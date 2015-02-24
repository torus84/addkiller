#!/bin/bash
realpath ()
{
    f=$@;
    if [ -d "$f" ]; then
        base="";
        dir="$f";
    else
        base="/$(basename "$f")";
        dir=$(dirname "$f");
    fi;
    dir=$(cd "$dir" && /bin/pwd);
    echo "$dir$base"
}
BASE_DIR="$(dirname "${BASH_SOURCE[0]}")"
BASE_DIR="$(realpath "$BASE_DIR")"
export BASE_DIR