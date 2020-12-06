fxr(){ ##### BEGINNING OF l, find wrap script #####
local F L a b e B M p re s z
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
	[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid path: $a. It goes up beyond root>&2;continue;}
	p=$a
elif [[ $a =~ ^(\.\.(/\.\.)*)(/.+)?$ ]] ;then
	s=~+/${BASH_REMATCH[1]}
	p=${BASH_REMATCH[3]}	# p is first explicit path
	while [[ $s =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do s=${s/"${BASH_REMATCH[0]}"/\/};done
	[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid path: $a. It goes up beyond root>&2;continue;}
	s=${s%/}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do p=${p#/..}; s=${s%/*}: ${s:=/} ;done
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
		[[ -z "$s" ]] &&{ echo Invalid path: $a. It goes up beyond root>&2;continue;}
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
	while [[ $p =~ ([^]*$'\f'])\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
	while [[ $p =~ ([^\\]|^)([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
	p=${p//\*\*/.*}
fi
while [[ $p =~ $'\f'([*?]) ]];do p=${p/"${BASH_REMATCH[0]}"/\\"${BASH_REMATCH[1]}"} ;done
case $z in
/)	z=-type\ d;;
//)	z=-type\ f;;
///)	z=-executable;;
////)	z=-type\ l;;
esac
Sd=\"$s$p\"
Rt="-${J}regex \"$s${re+.*}$p(/.+)?\" $z"
}
}
}
ftm(){	local d f a e z x
	d=${1:2};f=-${1:1:1}
	a=${d%-*};e=${a##*[0-9]}
	: ${e:=m};a=${a%[mhdM]}
	[ $e = h ] && let a*=60
	[ $e = M ] && let a*=30
	e=${e/[mh]/min};e="${e/[dM]/time} "
	if [[ $d = *-* ]] ;then
		z=${d#*-};x=${z##*[0-9]}
		: ${x:=m};z=${z%[mhdM]}
		[ $x = h ] &&let z*=60;[ $x = M ] &&let z*=30
		x="${x/[mh]/min} ";x="${x/[dM]/time} "
		if((!a)) ;then	Rt="\( $f$x-$z -o $f$x$z \) "
		elif((!z)) ;then	Rt="\( $f$e+$a -o $f$e$a \) "
		else	Rt="\( $f$e+$a $f$x-$z -o $f$e$a -o $f$x$z \) ";fi
	else	Rt=$f$e$a\ ;fi
}
fsz(){	local d f a e z x
	d=${1:2};f='-size '
	a=${d%-*};e=${a##*[0-9]}
	: ${e:=k};e=${e//m/M};e=${e//g/G}
	a=${a%[cwbkmMgG]}
	if [[ $d = *-* ]] ;then
		z=${d#*-};x=${z##*[0-9]}
		: ${x:=k};x=${x//m/M};x=${x//g/G}
		z=${z%[cwbkmMgG]}
		if((!a)) ;then	Rt="\( $f-$z$x -o $f$z$x \)"
		elif((!z)) ;then	Rt="\( $f+$a$e -o $f$a$e \)"
		else	Rt="\( $f+$a$e $f-$z$x -o $f$a$e -o $f$z$x \)";fi
	else	Rt=$f$a$e\ ;fi
}
fd(){	local d l m a z=1
	d=${1:1};a=${d%[-.]*}
	l=\ $(eval echo {1..$a})
	[[ $d =~ [-.] ]] &&{
		z=${d#*-}
		m="-path \"${2-$S}${l// ?/\/*}\""
		l=\ $(eval echo {1..${z%.}})
	}
	Rt="$m${z:+ \! -path \"${2-$S}${l// ?/\/*}/*\"}"
}
fx(){	local REX F xn Rt IFS S=$1;shift
for a;{
eval set -- $a
unset F xn;for e;{
case $e in
	-[cam][0-9]*|-[cam]-[0-9]*)	ftm $e;;
	-s[0-9]|-s[0-9][-cwbkMG]*|-s[-0-9][0-9]*)	fsz $e;;
	-[1-9]|-[1-9][0-9]|-[1-9][-.]*|[1-9][0-9][-.]*)
		(($#==1)) && fd $e;
		dtx="option \"$e\" of exclusion";F=1;;
	-E|-re)	REX=1;;
	*)	[[ $e = -* ]] &&echo \'$e\': unrecognized exclusion option, it\'s regarded as an excluded path>&2
		fxr "$e"
		((F)) &&fd $e $Sd
esac
xn=$xn$Rt\ ;}
X=(${X[@]} \\! "\( $xn\)")
}
}
fid(){
	[[ `file "$1"` =~ ^[^:]+:\ *([^,]+$|[^,]+\ [^,]+) ]];echo -e " ${BASH_REMATCH[1]}\n DEPs"
	ldd "$1" 2>/dev/null |sed -E 's/^\s*([^>]+>\s*)?(.+)\s+\(0.+/  \2/'
}
l(){
unset IFS F L a z RX de po opt se sz tm DT dt dtx if l lh lx c cp Fc Fp Rt X;I=i
shopt -s extglob;set -f;trap 'set +f;unset IFS' 1 2
for e;{
((F)) &&{	opt=$opt$e\ ;F=;continue;}
case $e in
-c|-cs) I=;;
-[cam][0-9]*|-[cam]-[0-9]*)	ftm $e;opt=$opt$Rt\ ;;
-[1-9]*)	Dt=$e
	d=${e:1};z=${d#*-}
	if [[ $d =~ ^[0-9]+-[0-9]*$ ]];then	a=${d%-*}
	elif [[ $d = *. ]];then	z=${d%.};a=$z
	fi
	dt="${a+-mindepth $a}${z:+${a+ }-maxdepth $z}";;
-s[0-9]|-s[0-9][-cwbkMG]*|-s[-0-9][0-9]*)	fsz $e;opt=$opt$Rt\ ;;
-x=?*|-xs=?*|-xcs=?*)	;;
-i|-ci) I=i;;
-l) lx=-maxdepth\ 1;l=1;;
-l[0-9]|-l[1-9][0-9])	((${e:2})) &&lx="-maxdepth\ ${e:2}";l=1;;
-E|-re) RX=1;;
-z)	sz=%s\ ;;
-t)	tm="%Tr %Tx ";;
-|--)	break;;
\!)	opt=$opt$e\ ;;
-sep=?|-sep=??) se=${e:5};;
-sep=*) echo Separator must be 1 or 2 characters, ignoring>&2;;
-de) de=1;;
-in) if=1;;
-h|--help) man find;return;;
-[HDLPO]) po=$e;;
-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-exec|-execdir|-executable|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	opt=$opt$e\ ;F=1;;
-[ac-il-x]?*)
	if [[ $e =~ ^-(delete|depth|daystart|follow|fprint|fls|group|gid|o|xstype)$ ]] ;then opt=$opt$e' '
	else	read -n1 -p "Option '$e' seems unrecognized, ignoring it and continue? " k>&2;echo;[ "$k" = y ]||return;fi;;
-*)	echo \'$e\': unknown option, ignoring. To mean it as a path string, put it after - or -- then space>&2;;
esac
}
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]]
IFS=';&|><';set -- ${BASH_REMATCH[1]}
unset IFS F L J G C x_a M
for c;{
	[[ $c =~ ^.+\ *\$\(\ *$FUNCNAME\ +(.*)\)|.+\ *\`\ *$FUNCNAME\ +(.*)\`|\ *$FUNCNAME\ +(.*) ]]&&{	
		c="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}";eval set -- ${c//\\/\\\\};break;}
	set --;}
for a;{
	case $a in
	-x=?*|-xs=?*|-xcs=?*)
		[ ${e:1:2} = x= ] &&J=i
		x_a=${a#-x*=}\ ;shift;F=1;G=0;;
	-c=?*|-cp=?*)
		if [ ${a:2:1} = = ] ;then Fc=1;else Fp=1 ;fi
		C=${c#-c*=}
		shift;F=0;G=1;;
	-|--)	shift;	L=1;F=0;G=0;;
	-*|\\!|!)	((L))&&{
		 if((F));then x_a=$x_a$a' '
		 elif((G));then C=$C$c' '
		 else M=$M$a\ ;fi
		}
	shift;;
	-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-exec|-execdir|-executable|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	shift 2;;
	*)	if((F)) ;then	x_a=$x_a$a' '
		elif((G)) ;then	C=$C$c' '
		else	M=$M$a\ ;fi
		shift;;
	esac
}
while [[ $x_a =~ ([^\\])\\([*?]) ]] ;do x_a=${x_a/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\f'"${BASH_REMATCH[2]}"} ;done
while [[ $M =~ ([^\\])\\([*?]) ]] ;do M=${M/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\f'"${BASH_REMATCH[2]}"} ;done
eval set -- ${M:-\"\"}
for e;{
unset b B s re L M
if [ "${e:0:1}" = \\ ];then	z=${e##+(\\)};z=${z#/};[[ $z =~ /* ]]&&L=/$'\r'$z #insert \x0D to mark a root dir
else
	[[ $e =~ ^\.?/[^/] ]]||re=1	# if no prefix ./ nor /, search recursively any depth from PWD
	e=${e#./}
	: ${se='\\'} # Get multi items separated by \\ or $sep of same dir path, if any and...
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
fi
unset IFS R s F Rt
eval set -- ${L-\"\"}
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
s=${s%/};p=${p%/}
d=${p%/*};IFS=$'\n';eval set -- \"${p##*/}\"$z$M; r=("$@")
p=$p$M
p=${p//\//$'\v'}
while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
while [[ $p =~ ([^]$'\f'])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
while [[ $p =~ ([^]*$'\f'])\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
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
		p=${BASH_REMATCH[2]}
	fi
	R=\".{${#S}}${p//$'\v'/\/}\"
else
	[[ ${r[((i++))]} =~ ^(.*[^/])?(/*)$ ]]
	z=${BASH_REMATCH[2]}
	p=$d/${BASH_REMATCH[1]}
	p=${p%[/$'\r']}
	if((RX)) ;then
		if((re)) ;then R=\".{${#S}}.*$p\"
		else	R=\"$S$p\" ;fi
	elif((re)) ;then	F=\"$s$p\"
	else	S=$s$p;R=.*
		[ -d "$S" ]||{ R=\"$S\";S=${s%/*};x_a=;}
	fi
fi
while [[ $R =~ $'\f'([*?]) ]] ;do R=${R/"${BASH_REMATCH[0]}"/\\"${BASH_REMATCH[1]}"} ;done
P="\( -path '* *' -printf \"$sz$tm'%p'\n\" -o -printf \"$sz$tm%p\n\" \)"
PD="-type d \( -path '* *' -printf \"$sz$tm'%p/'\n\" -o -printf \"$sz$tm%p/\n\" \)"
case $z in
/)	Z="$PD";;
//)	Z="-type f $P";;
///)	Z=-executable\ $P;;
////)	Z="-type l \( -path '* *' -printf \"'%p' '%l'\n\" -o -printf \"%p %l\n\" \)";;
*)	Z="\( $PD -o $P \)"
esac
((l)) &&{ [ "$lx" ]|| lh=-prune; PD="-type d $lh -exec find \{\} $lx $opt \( $PD -o $P \) \;";}

S=\"${S:-/}\"
eval ${x_a+fx ${F-$S} "$x_a"}
if [ $F ] ;then
	Rt=;eval ${Dt+fd $Dt $F}
	CL="find $po \"$S\" -regextype posix-extended -${I}path $F/* $opt $Rt ${X[@]} $Z"${p:+" -o -${I}path $F -type f $P -o -${I}regex \".{${#s}}.+$p\" $opt \( $PD -o $P \)"};Z=;P=
else
	CL="find $po \"$S\" -regextype posix-extended $dt $opt -${I}regex $R \! -path \"$S\" ${X[@]}"	
fi
[ "$Dt$dtx" ] &&echo "${Dt+Depth specified by \"$Dt\"}${Dt+${dtx+, and }}${dtx+$dtx} is from ${F-$S}">&2

export LC_ALL=C
if((de)) &&[[ $z != / ]] ;then	#export -f fid
	eval "$CL $P ! -type d -executable -exec /bin/bash -c 'fid \"\$0\" \"\$@\"' '{}' \;"
elif((if)) &&[[ $z != / ]] ;then
	eval "$CL $P ! -type d -exec /bin/bash -c '
		[[ \`file \"{}\"\` =~ ^[^:]+:\ *([^,]+$|[^,]+\ ([^,]+)) ]];echo \  \${BASH_REMATCH[1]}' \;"
elif((Fc+Fp)) ;then
	#sudo mkdir -pv $cp
	for i in ${c[@]};{	eval "sudo $CL -exec cp '{}' $i \;";}
else
	command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done)	eval "sudo $CL $Z"
fi
}
}
}
set +f;unset IFS;} ##### ENDING OF l, find wrap script #####
