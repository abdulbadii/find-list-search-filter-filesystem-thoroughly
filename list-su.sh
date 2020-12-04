fxr(){ ##### BEGINNING OF l, find wrap script ##### 
local a b B M p re s z SD
[[ $1 =~ ^\.?/[^/] ]]||re=1;e=${1#./}
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
IFS=$'\n';eval set -- \"${p##*/}\"$z$M
for f;{
f=$b${f:+/$f}
[[ $f =~ ^(.*[^/])?(/*)$ ]]
z=${BASH_REMATCH[2]}
p=$b${BASH_REMATCH[1]}
if((RX+REX)) ;then
	while [[ $s =~ ([^\\]|^)([.*?{}().]) ]] ;do s=${s/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
else
	while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
	while [[ $p =~ ([^]$'\f'])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
	while [[ $p =~ ([^]$'\f'])\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
	while [[ $p =~ ([^\\]|^)([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
	p=${p//\*\*/.*}
fi
case $z in
/)	z=" -type d";;
//)	z=" -type f";;
///)	z=\ -executable;;
////)	z=" -type l";;
esac
Rt="-${J}regex \"$s${re+.*}$p\"$z -type d -prune";SD=$s
}
}
}
ftm(){	local d f a e z x;REX=;Rt=
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
		if((!a)) ;then	Rt="\( $f-$z$x -o $f$z$x \)"
		elif((!z)) ;then	Rt="\( $f+$a$e -o $f$a$e \)"
		else	Rt="\( $f+$a$e $f-$z$x -o $f$a$e -o $f$z$x \)";fi
	else	Rt=$Rt$f$a$e\ ;fi
}
fxd(){	local d l u a z;Rt=
	d=${1:1}
	a=${d%[-.]*}
	l=\ $(eval echo {1..$a})
	[[ $d =~ [-.] ]] &&{
		z=${d#*-}
		Rt="-path \"$S${l// ?/\/*}\""
		l=\ $(eval echo {1..${z%.}})
	}
	Rt="$Rt${z:+ \! -path \"$S${l// ?/\/*}/*\"}"
}
fx(){	local F a e REX
for a;{
unset IFS xn;eval set -- $a
F=;for e;{
case $e in
	-[cam][0-9]*|-[cam]-[0-9]*)	ftm $e;;
	-s[0-9]|-s[0-9][-cwbkMG]*|-s[-0-9][0-9]*)	fsz $e;;
	-[1-9]|-[1-9][0-9]|-[1-9][-.]*|[1-9][0-9][-.]*) F=1;;
	-E|-re)	REX=1;;
	*)	[[ $e = -* ]] &&echo \'$e\': unrecognized exclusion option, it\'ll be regarded as excluded path>&2
		fxr "$e";	while [[ $Rt =~ $'\f'([*?]) ]];do Rt=${Rt/"${BASH_REMATCH[0]}"/\\"${BASH_REMATCH[1]}"} ;done
		((F))&&{	S=$SD;fxd $e;dtx="depth '$e' on exclusion"
		};;
esac
xn=$xn$Rt\ ;}
X=(${X[@]} \\! "\( $xn\)")
}
}
fid(){
	[[ `file "$1"` =~ ^[^:]+:\ *([^,]+$|[^,]+\ [^,]+) ]]
	echo -e " ${BASH_REMATCH[1]}\n DEPs"
	ldd "$1" 2>/dev/null |sed -E 's/^\s*([^>]+>\s*)?(.+)\s+\(0.+/  \2/'
}
l(){
unset IFS a z F L de po opt se RX sz tm dt dtx if l lh lx c cp Fc Fp X;I=i;J=i
shopt -s extglob;set -f;trap 'set +f;unset IFS' 1 2
for e;{
((F)) &&{	opt=$opt$e\ ;F=;continue;}
case $e in
-[cam][0-9]*|-[cam]-[0-9]*)	ftm $e;opt=$opt$Rt\ ;;
-[1-9]*)
	d=${e:1};z=${d#*-}
	if [[ $d =~ ^[0-9]+-[0-9]*$ ]];then	a=${d%-*}
	elif [[ $d = *. ]];then	z=${d%.};a=$z
	fi
	dt="${a+-mindepth $a}${z:+${a+ }-maxdepth $z}";;
-s[0-9]|-s[0-9][-cwbkMG]*|-s[-0-9][0-9]*)	fsz $e;opt=$opt$Rt\ ;;
-x=?*|-xs=?*|-xcs=?*)	J=
	[ ${e:1:2} = x= ] &&J=i
	((L))&&break
	L=1;;
-de) de=1;;
-in) if=1;;
-cs) I=;;
-ci) I=i;;
-l) lx=-maxdepth\ 1;l=1;;
-l[0-9]|-l[1-9][0-9])	((${e:2})) &&lx="-maxdepth\ ${e:2}";l=1;;
-E|-re) RX=1;;
-z)	sz=%s\ ;;
-t)	tm="%Tr %Tx ";;
-|--)	break;;
-sep=?|-sep=??) se=${e:5};;
-sep=*) echo Separator must be 1 or 2 characters, ignoring>&2;;
-h|--help) man find;return;;
-[HDLPO]) po=$e;;
\!)	opt=$opt$e\ ;;
-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-exec|-execdir|-executable|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	opt=$opt$e\ ;F=1;;
-[ac-il-x]?*)
	if [[ $e =~ ^-(delete|depth|daystart|follow|fprint|fls|group|gid|o|xstype)$ ]] ;then opt=$opt$e\ 
	else	read -n1 -p "Option '$e' seems unrecognized, ignoring it and continue? " k>&2;echo;[ "$k" = y ]||return;fi;;
-*)	echo \'$e\' : unknown option, ignoring. To mean it as a path string, put it after - or -- then space>&2;;
*)	((L)) && break
esac
}
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]]
IFS=';&|><';set -- ${BASH_REMATCH[1]}
unset IFS M;for c;{
	[[ $c =~ ^.+\ *\$\(\ *$FUNCNAME\ +(.*)\)|.+\ *\`\ *$FUNCNAME\ +(.*)\`|\ *$FUNCNAME\ +(.*) ]]&&{	
		c="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}";eval set -- ${c//\\/\\\\};break;}
	set --
}
unset F L G C M x_a
[ "$1" ]&&{
for a;{
	case $a in
	-x=?*|-xs=?*|-xcs=?*)
		x_a=${a#-x*=}\ ;shift;F=1;G=0;;
	-c=?*|-cp=?*)
		if [ ${a:2:1} = = ] ;then Fc=1;else Fp=1 ;fi
		C=${c#-c*=}
		shift;G=1;F=0;;
	-|--)	shift;	L=1;F=0;G=0;;
	-*|\\!|!)	((L))&&{
		 if((F));then x_a=$x_a$a' '
		 elif((G));then C=$C$c' '
		 else M=$M$a\ ;fi
		}
		shift;;
	-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-exec|-execdir|-executable|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	shift 2;;
	*)
		if((F)) ;then	x_a=$x_a$a' '
		elif((G)) ;then	C=$C$c' '
		else	M=$M$a\ ;fi
		shift;;
	esac
}
}
while [[ $x_a =~ ([^\\])\\([*?]) ]] ;do x_a=${x_a/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\f'"${BASH_REMATCH[2]}"} ;done
while [[ $M =~ ([^\\])\\([*?]) ]] ;do M=${M/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\f'"${BASH_REMATCH[2]}"} ;done
eval set -- ${M:-\"\"}
for e;{
unset b B s re M G
[[ ${e:0:2} = \\ ]] &&{	z=${e##+(\\)};z=${z#/}; e=/;}
[[ $e =~ ^\.?/[^/] ]]||re=1	# if no prefix ./ nor /, it's recursive at any depth of PWD
e=${e#./}
: ${se='\\\\'} # Get multi items separated by \\ or $sep of same dir path, if any and...
while [[ $e =~ ([^\\])$se ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done 
IFS=$'\n';set -- ${e//\\/\\\\}
#get common base dir. path (B)
[[ $1 =~ ^((/?([^/]+/)*)([^/]+))?(/*)$ ]]
B=${BASH_REMATCH[2]}
z=${BASH_REMATCH[5]}
L=\"${BASH_REMATCH[4]}\"
while [[ $L =~ ^"\.\."$ ]] ;do B=$B../;L=*$z;done
F=1			# ...none has exact .. pattern to be as M, otherwise as L to be the outer loop
shift;for a;{	[[ $a =~ (/|^)\.\.(/|$) ]] &&{	L=$L\ "$@";F=;break;};}
[ $# -ge 1 ]&&((F)) &&{	[[ $e =~ ^[^$'\n']*($'\n'.*)?$ ]];M=${BASH_REMATCH[1]};}
unset IFS s R
eval set -- ${L:-\"\"}
for a;{
a=$B${a%%+(/)}
if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
	[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid path: $a. It goes up beyond root>&2;continue;}
	p=$a
elif [[ $a =~ ^(\.\.(/\.\.)*)(/.+)?$ ]] ;then
	s=~+/${BASH_REMATCH[1]}
	p=${BASH_REMATCH[3]}	# is first explicit path
	while [[ $s =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do s=${s/"${BASH_REMATCH[0]}"/\/};done
	[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid path: $a. It goes up beyond root>&2;continue;}
	s=${s%/}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}} # clear remaining leading /..
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do p=${p#/..}; s=${s%/*}: ${s:=/}  ;done
		[[ -z "$s" ]] &&{ echo Invalid path: $a. It goes up beyond root>&2;continue;}
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
		[[ -z "$s" ]]&&{ echo Invalid path: $a. It goes up beyond root>&2;continue;}
	fi
fi
p=${p%/}
d=${p%/*};IFS=$'\n';eval set -- \"${p##*/}\"$z$M; r=("$@")
p=$p$M
p=${p//\//$'\v'}
while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
while [[ $p =~ ([^]$'\f'])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
while [[ $p =~ ([^]$'\f'])\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
while [[ $p =~ ([^\\]|^)([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
p=${p//\*\*/.*}
M=${M:+$'\n'${p#*$'\n'}}
b=${p%%$'\n'*}
p=${b##*$'\v'}${z//\//$'\v'}$M
b=${b%$'\v'*}
S=$s
i=;IFS=$'\n';set -- ${p:-\"\"}
for f;{
if((!RX)) &&[[ $f =~ ([^\\]|^)[[*?] ]] ;then
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
	while [[ $p =~ $'\f'([*?]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/\\"${BASH_REMATCH[1]}"} ;done
else
	[[ ${r[((i++))]} =~ ^(.*[^/])?(/*)$ ]]
	p=${BASH_REMATCH[1]}
	z=${BASH_REMATCH[2]}
	p=$d${p:+/$p}
	while [[ $p =~ $'\f'([*?]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/\\"${BASH_REMATCH[1]}"} ;done
	if((RX)) ;then
		if((re)) ;then R=\".{${#S}}.*$p\"
		else	R=\"$S$p\" ;fi
	elif((re)) ;then
		G=1
	else
		S=$s$p;R=.*
		[ -d "$S" ] ||{ R=\"$S\";S=${s%/*};x_a=;}
	fi
fi
P="\( -path '* *' -printf \"$sz$tm'%p'\n\" -o -printf \"$sz$tm%p\n\" \)"
PD="-type d \( -path '* *' -printf \"$sz$tm'%p/'\n\" -o -printf \"$sz$tm%p/\n\" \)"
case $z in
/)	Z="$PD";;
//)	Z="-type f $P";;
///)	Z="-executable $P";;
////)	Z="-type l \( -path '* *' -printf \"'%p' '%l'\n\" -o -printf \"%p %l\n\" \)";;
*)	Z="\( $PD -o $P \)";;
esac
if((G)) ;then
	S=$s$p
	[ "$x_a" ]&&fx "$x_a"
	R="\"$S\" \( -type d -exec find '{}' $dt $opt \! -path '{}' ${X[@]} $Z \; -o $P \)"${p:+" -o -${I}regex \".{${#S}}.+$p\" $opt \( $PD -o $P \)"}
	[ "$dt$dtx" ] &&echo "${dt+Depth specified by '$dt'}${dt+${dtx+, and }}${dtx+$dtx} is from '$S'">&2
	unset dt opt X Z
else
	[ "$x_a" ]&&fx "$x_a"
	[ "$dt$dtx" ] &&echo "${dt+Depth specified by '$dt'}${dt+${dtx+, and }}${dtx+$dtx} is from '$S'">&2
fi
((l)) &&{ [ "$lx" ]|| lh=-prune; PD="-type d $lh -exec find \{\} $lx $opt \( $PD -o $P \) \;"
}
export LC_ALL=C
if((de)) &&[[ $z != / ]] ;then
	#export -f fid
	eval "find $po \"$S\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$S\" ${X[@]} $P ! -type d -executable -exec /bin/bash -c 'fid \"\$0\" \"\$@\"' '{}' \;"
elif((if)) &&[[ $z != / ]] ;then
	eval "find $po \"$S\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$S\" ${X[@]} $P ! -type d -exec /bin/bash -c '
		[[ \`file \"{}\"\` =~ ^[^:]+:\ *([^,]+$|[^,]+\ ([^,]+)) ]];echo \  \${BASH_REMATCH[1]}' \;"
elif((Fc+Fp)) ;then
	#sudo mkdir -pv $cp
	for i in ${c[@]};{
		eval "sudo find $po \"$s\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$S\" ${X[@]} -exec cp '{}' $i \;"
	}
	
else
	#command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done)
		eval "sudo find $po \"$S\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$S\" ${X[@]} $Z"
fi
}
}
}
set +f;unset IFS;} ##### ENDING OF l, find wrap script #####
