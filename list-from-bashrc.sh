#!/usr/bin/bash

d=$(cd `dirname ${0}`&&pwd)
cp -u ~/.bashrc $d/../bashrc

n=${1:+-$1}
sed -Ene "/^fxr\(\)\{\s+#{5,}\s*BEGINNING OF l,/,/^\}\s+#{5,}\s*ENDING OF l,/{s/^li\(\)/l\(\)/;tn;/^\}\s+#{5,}\s*ENDING OF/{wlist-su$n.sh" -e "q}; :n wlist-su$n.sh" -e '}' ~/.bashrc
sed -En "s/\bsudo\s+//; wlist$n.sh" list-su$n.sh
