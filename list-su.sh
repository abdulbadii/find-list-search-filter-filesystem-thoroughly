fxr(){ ##### BEGINNING OF l, find wrap script ##### 
local a b B M p re s z
[[ $1 =~ ^\.?/[^/] ]]||re=1
e=${1#./}
: ${se='\\\\'}
while [[ $e =~ ([^\\])($se) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done 
IFS=$'\n';set -- ${e//\\/\\\\}
[[ $1 =~ ^((/?([^/]+/)*)([^/]+))?(/*)$ ]]
B=${BASH_REMATCH[2]}
L=\"${BASH_REMATCH[4]}\"
z=${BASH_REMATCH[5]}
while [[ $L =~ \"\.\.\" ]] ;do B=$B../;L=*$z;done
F=1
shift;for a;{	[[ $a =~ (/|^)\.\.(/|$) ]] &&{	L=$L\ "$@";F=;break;};}
[ $# -ge 1 ]&&((F)) &&{	[[ $e =~ ^[^$'\n']*($'\n'.*)?$ ]];M=${BASH_REMATCH[1]};}
unset IFS s;eval set -- $L
for a;{
a=$B${a%%+(/)}
if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
	[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	p=$a
elif [[ $a =~ ^(\.\.(/\.\.)*)(/.+)?$ ]] ;then
	s=~+/${BASH_REMATCH[1]}
	p=${BASH_REMATCH[3]}	# p is first explicit path
	while [[ $s =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do s=${s/"${BASH_REMATCH[0]}"/\/};done
	[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid path: $a. It goes up beyond root >&2;continue;}
	s=${s%/}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do p=${p#/..}; s=${s%/*}: ${s:=/} ;done
		[[ -z "$s" ]] &&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	fi
else
	s=~+
	p=${a:+/$a}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do p=${p#/..}; s=${s%/*};: ${s:=/} ;done
		[[ -z "$s" ]] &&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	fi
fi
p=${p%/};b=${p%/*}
IFS=$'\n';eval set -- ${p##*/}$z$M
for f;{
f=$b${f:+/$f}
[[ $f =~ ^(.*[^/])?(/*)$ ]]
z=${BASH_REMATCH[2]}
p=$b${BASH_REMATCH[1]}
if((E)) ;then
	while [[ $s =~ ([^\\]|^)([.*?{}().]) ]] ;do s=${s/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
else
	while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
	while [[ $p =~ ([^\\])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
	while [[ $p =~ ([^\]\\*]|^)\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
	while [[ $p =~ ([^\\]|^)([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
	p=${p//\*\*/.*}
fi
case $z in
/)	z=" -type d";;
//)	z=" -type f";;
///)	z=\ -executable;;
////)	z=" -type l";;
esac
if((re)) ;then	Rt=-${J}regex\ \"$s.*$p\"$z
else	Rt=-${J}regex\ \"$s$p\"$z;fi
}
}
}
ftm(){	local d f a e z x;Rt=
	d=${1:2};f=-${1:1:1}
	a=${d%-*};e=${a##*[0-9]}
	: ${e:=m};a=${a%[mhdM]}
	[ $e = h ] && let a*=60
	[ $e = M ] && let a*=30
	e=${e/[mh]/min};e="${e/[dM]/time} "
	if [[ $d = *-* ]] ;then
		z=${d#*-};x=${z##*[0-9]}
		: ${x:=m};z=${z%[mhdM]}
		[ $x = h ] && let z*=60
		[ $x = M ] && let z*=30
		x=${x/[mh]/min};x="${x/[dM]/time} "
		if((!a)) ;then	Rt="$Rt\( $f$x-$z -o $f$x$z \) "
		elif((!z)) ;then	Rt="$Rt\( $f$e+$a -o $f$e$a \) "
		else	Rt="$Rt\( $f$e+$a $f$x-$z -o $f$e$a -o $f$x$z \) ";fi
	else	Rt=$Rt$f$e$a\ ;fi
}
fsz(){	local d f a e z x;Rt=
	d=${1:2};f='-size '
	a=${d%-*};e=${a##*[0-9]}
	: ${e:=k};a=${a%[cwbkMG]}
	if [[ $d = *-* ]] ;then
		z=${d#*-};x=${z##*[0-9]}
		: ${x:=k};z=${z%[cwbkMG]}
		if((!a)) ;then	Rt="$Rt\( $f-$z$x -o $f$z$x \) "
		elif((!z)) ;then	Rt="$Rt\( $f+$a$e -o $f$a$e \) "
		else	Rt="$Rt\( $f+$a$e $f-$z$x -o $f$a$e -o $f$z$x \) ";fi
	else	Rt=$Rt$f$a$e\ ;fi
}
fxd(){	local d l u
	d=${1:1}
	case $1 in
	-[1-9]|-[1-9][0-9])
		i=\ $(eval echo {1..$d})
		Rt="-path $s${i// ?/\/*}/*";;
	-[1-9]-*|-[1-9][0-9]-*)
		a=${d%-*};z=${d#*-}
		l=\ $(eval echo {1..$a})
		l="\! -path $s${l// ?/\/*}"
		u=\ $(eval echo {1..$z})
		Rt="$l -o -path $s${u// ?/\/*}/*"
	esac
}
fx(){
local a e 
for a;{
unset IFS xn;eval set -- $a
for e;{
case $e in
	-[cam][0-9]*|-[cam]-[0-9]*)	ftm $e;;
	-s[0-9]|-s[0-9][-cwbkMG]*|-s[-0-9][0-9]*)	fsz $e;;
	-[1-9]|-[1-9]*[-.]*)	fxd $e;;
	-*)	echo \'$e\' is invalid exclusion option. Ignoring;continue;;
	*)	fxr "$e"
esac
xn=$xn$Rt\ ;}
X=("${X[@]} \! \( $xn\)")
}
}
fid(){
	[[ `file "$1"` =~ ^[^:]+:\ *([^,]+$|[^,]+\ [^,]+) ]]
	echo -e " ${BASH_REMATCH[1]}\n DEPs"
	ldd "$1" 2>/dev/null |sed -E 's/^\s*([^>]+>\s*)?(.+)\s+\(0.+/  \2/'
}
l(){
unset IFS F L po opt se E sz t dt if l lh lx cp x Fc Fp Xd X;I=i;J=i ;de=0
shopt -s extglob;set -f;trap 'set +f;unset IFS' 1 2
for e;{
((F)) &&{	opt=$opt$e\ ;F=;continue;}
case $e in
-[cam][0-9]*|-[cam]-[0-9]*)	ftm $e;opt=$opt$Rt\ ;;
-[1-9]|-[1-9][0-9]) dt=-maxdepth\ ${e:1};;
-[1-9]*[-.]*)	d=${e:1};z=${d#*-};	dt="-mindepth ${d%-*}${z:+ -maxdepth ${z%.}}";;
-s[0-9]|-s[0-9][-cwbkMG]*|-s[-0-9][0-9]*)	fsz $e;opt=$opt$Rt\ ;;
-x=?*|-xs=?*|-xcs=?*)	J=
	[ ${e:1:2} = x= ] &&J=i
	((L)) && break;L=1;;
-de) de=1;;
-in) if=1;;
-cs) I=;;
-ci) I=i;;
-l) lx=-maxdepth\ 1;l=1;;
-l[0-9]|-l[1-9][0-9])	((${e:2})) &&lx="-maxdepth\ ${e:2}";l=1;;
-E|-re) E=1;;
-z)	sz=%s\ ;;
-t)	tm="%Tr %Tx ";;
-|--)	break;;
-sep=?|-sep=??) se=${e:5};;
-sep=*) echo Separator must be 1 or 2 characters, ignoring;;
-h|--help) man find;return;;
-[HDLPO]) po=$e;;
\!)	opt=$opt$e\ ;;
-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-exec|-execdir|-executable|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	opt=$opt$e\ ;F=1;;
-[ac-il-x]?*)
	if [[ $e =~ ^-(delete|depth|daystart|follow|fprint|fls|group|gid|o|xstype)$ ]] ;then opt=$opt$e\ 
	else	read -pn1 "Option '$e' seems unrecognized, ignoring it and continue? " k; [ "$k" = y ]||return;fi;;
-*)	echo \'$e\' : unknown option, ignoring. To mean it as a path string, put it after - or -- then space;;
*)	((L)) && break;L=1
esac
}
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]]
IFS=';&|><';set -- ${BASH_REMATCH[1]}
unset IFS M
for c;{
	[[ $c =~ ^.+\ *\$\(\ *$FUNCNAME\ +(.*)\)|.+\ *\`\ *$FUNCNAME\ +(.*)\`|\ *$FUNCNAME\ +(.*) ]]&&{	
		c="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}";eval set -- ${c//\\/\\\\};break;}
	set --
}
[ "$1" ]&&{
unset L i j n x_a
for a;{
	case $a in
	-x=?*|-xs=?*|-xcs=?*) m=1
		x=${a#-x*=}
		shift;for c;{
			[[ $c =~ ^--?$ ]]&&{
				let m=i+2
				n=${@:1:i}
				break;}
			let ++i
		}
		for c in ${@:m}	;{	[[ $c =~ ^-cp?=. ]] &&break;let ++j;}
		x_a=$x\ $n
		M=${@:m:j}
		C=${@:m+j:1}
		C=${C#-c*=}\ ${@:m+j+1}
		break;;
	-c=?*|-cp=?*)	shift
		if [ ${a:2:1} = = ] ;then Fc=1;else Fp=1 ;fi
		if [ $1 ] ;then	echo -c or -cp option must be the last one
		else	echo no main path pattern to search for;fi;return;;
	-|--)	L=1;shift;;	-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-exec|-execdir|-executable|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	shift 2;;
	-*|\\!)	shift;;
	*)	((L)) &&break
		i=1;for c ;{
			let ++i
			[[ $c =~ ^-xc?s?=. ]] &&{
				x=${c#-x*=}
				for c in ${@:i}	;{
					[[ $c =~ ^-cp?=. ]] &&{
						C=${c#-c*=}\ ${@:i+j+1}
						break;}
					let ++j
				}
				x_a=$x\ ${@:i:j}
				M=${@:1:i-2};	break 2
			}	
		}
		M=$@;break
	esac
}
}
: ${M:=\"\"}
eval set -- ${M//\\/\\\\}
for e;{
unset b B L M s re
[[ ${e:0:2} = \\ ]] &&{	z=${e##+(\\)};z=${z#/}; e=/;}
[[ $e =~ ^\.?/[^/] ]]||re=1	# if no prefix ./ nor /, it's recursive at any depth of PWD
e=${e#./}
: ${se='\\\\'} # Get multi items separated by \\ or else, in same dir, if any and...
while [[ $e =~ ([^\\])$se ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done 
IFS=$'\n';set -- ${e//\\/\\\\}
#get common base dir. path (B) if any and...
[[ $1 =~ ^((/?([^/]+/)*)([^/]+))?(/*)$ ]]
B=${BASH_REMATCH[2]}
z=${BASH_REMATCH[5]}
L=\"${BASH_REMATCH[4]}\"
while [[ $L =~ ^"\.\."$ ]] ;do B=$B../;L=*$z;done
F=1	# ...none has exact .. pattern, if any .. in multi items, L is these, to do outer loop
shift;for a;{	[[ $a =~ (/|^)\.\.(/|$) ]] &&{	L=$L\ "$@";F=;break;};}
[ $# -ge 1 ]&&((F)) &&{	[[ $e =~ ^[^$'\n']*($'\n'.*)?$ ]];M=${BASH_REMATCH[1]};}

unset IFS s R
eval set -- ${L:-\"\"}
for a;{
a=$B${a%%+(/)}
if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
	[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	p=$a
elif [[ $a =~ ^(\.\.(/\.\.)*)(/.+)?$ ]] ;then
	s=~+/${BASH_REMATCH[1]}
	p=${BASH_REMATCH[3]}	# p is first explicit path
	while [[ $s =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do s=${s/"${BASH_REMATCH[0]}"/\/};done
	[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid path: $a. It goes up beyond root >&2;continue;}
	s=${s%/}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}} # clear remaining leading /..
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do p=${p#/..}; s=${s%/*}: ${s:=/}  ;done
		[[ -z "$s" ]] &&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	fi
else
	s=~+
	p=${a:+/$a}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do p=${p#/..}; s=${s%/*};: ${s:=/} ;done
		[[ -z "$s" ]]&&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	fi
fi
[ "$x_a" ]&&fx "$x_a"
p=${p%/}
d=${p%/*};IFS=$'\n';eval set -- ${p##*/}$z$M; r=("$@")
p=$p$M
p=${p//\//$'\v'}
while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
while [[ $p =~ ([^\\])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
while [[ $p =~ ([^\]\\*]|^)\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
while [[ $p =~ ([^\\]|^)([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
p=${p//\*\*/.*}
M=${M:+$'\n'${p#*$'\n'}}
b=${p%%$'\n'*}
p=${b##*$'\v'}${z//\//$'\v'}$M
b=${b%$'\v'*}
S=$s
i=;IFS=$'\n';set -- ${p:-\"\"}
for f;{
[ "$f" ] &&{
if((!E)) &&[[ $f =~ ([^\\]|^)[[*?] ]] ;then
	[[ $f =~ ^(.*[^$'\v'])?($'\v'*)$ ]]
	z=${BASH_REMATCH[2]//$'\v'/\/}
	f=$b$'\v'${BASH_REMATCH[1]}
	if((re)) ;then	p=.*$f
	else
		[[ $f =~ ^([^[*]*)($'\v'.+)$ ]]
		S=$s${BASH_REMATCH[1]//$'\v'/\/}
		: ${S:=/}
		p=${BASH_REMATCH[2]}
	fi
	R=\".{${#S}}${p//$'\v'/\/}\"
else
	[[ ${r[((i++))]} =~ ^(.*[^/])?(/*)$ ]]
	f=${BASH_REMATCH[1]}
	z=${BASH_REMATCH[2]}
	f=$d${f:+/$f}
	if((E)) ;then
		if((re)) ;then R=\".{${#S}}.*$f\"
		else	R=\"$S$f\" ;fi
	elif((!re)) ;then
		S=$s$f;R=.*
		[ -d $s ] ||{ R=\"$S\";S=${s%/*};}
	fi
fi
}
P="\( -path '* *' -printf \"$sz$tm'%p'\n\" -o -printf \"$sz$tm%p\n\" \)"
PD="-type d \( -path '* *' -printf \"$sz$tm'%p/'\n\" -o -printf \"$sz$tm%p/\n\" \)"
case $z in
/)	Z="$PD";;
//)	Z="-type f $P";;
///)	Z="-executable $P";;
////)	Z="-type l $P";;
*)	Z="\( $PD -o $P \)";;
esac
((l)) &&{
 [ "$lx" ]|| lh=-prune; PD="-type d $lh -exec find \{\} $lx $opt \( $PD -o $P \) \;"
}
[ "$R" ] ||{
	R="\".{${#s}}$f\" \( -type d -exec find '{}' $dt \! -path '{}' $opt $Z \; -o $P \)"${f:+" -o $dt -${I}regex \".{${#s}}.+$f\" -$opt \( $PD -o $P \)"}; dt=;opt=;Z=
}
export LC_ALL=C
if((de)) &&[[ $z != / ]] ;then
	#export -f fid
	eval "find $po \"$S\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$S\" $X $P ! -type d -executable -exec /bin/bash -c 'fid \"\$0\" \"\$@\"' '{}' \;"
elif((if)) &&[[ $z != / ]] ;then
	eval "find $po \"$S\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$S\" $X $P ! -type d -exec /bin/bash -c '
		[[ \`file \"{}\"\` =~ ^[^:]+:[[:space:]]*([^,]+$|[^,]+[[:space:]]([^,]+)) ]];echo \  \${BASH_REMATCH[1]}' \;"

elif((Fc+Fp)) ;then
	#sudo mkdir -pv $cp
	for i in ${c[@]};{
		eval "sudo find $po \"$s\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$s\" $X -exec cp '{}' $i \;"
	}
	
else
	#command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done)
		eval "sudo find $po \"$S\" $dt $Xd -regextype posix-extended $opt -${I}regex $R $X \! -path \"$S\" $Z"
fi
}
}
}
set +f;unset IFS
} ##### ENDING OF l, find wrap script #####
