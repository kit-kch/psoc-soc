#!/bin/bash

# Only export path if questa is not already available
if ! [ -x "$(command -v questa)" ]; then
    source /etc/profile.d/modules.sh
    module load questa/2023.4
fi

# Allow sourcing this script without params. Otherwise exec command
if [ $# -ne 0 ]; then
    exec "$@"
fi
