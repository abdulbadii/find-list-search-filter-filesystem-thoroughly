#!/usr/bin/bash

d=$(cd `dirname "${BASH_SOURCE[0]}"`&&pwd)
cp -u ~/.bashrc $d/../bashrc

n=${1:+-$1}
sed -Ene "/^\s*fx\(\)\{/,/\}\s+#\s*END\s+l/{s/^li\(\)/l\(\)/;tn; s/\}\s+#\s*END\s+l.*/\}/;Tn;wlist-su$n.sh" -e "q; :n wlist-su$n.sh" -e '}' ~/.bashrc
sed -En "s/\bsudo\s+//; wlist$n.sh" list-su$n.sh
