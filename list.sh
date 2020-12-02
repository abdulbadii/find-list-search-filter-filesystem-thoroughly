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
IFS=$'\n';eval set -- \"${p##*/}\"$z$M
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
		if((!a)) ;then	Rt="\( $f-$z$x -o $f$z$x \)"
		elif((!z)) ;then	Rt="\( $f+$a$e -o $f$a$e \)"
		else	Rt="\( $f+$a$e $f-$z$x -o $f$a$e -o $f$z$x \)";fi
	else	Rt=$Rt$f$a$e\ ;fi
}
fxd(){	local d l u
	d=${1:1}
	case $1 in
	-[1-9]|-[1-9][0-9])
		l=\ $(eval echo {1..$d})
		Rt="-path $S${l// ?/\/*}/*";;
	-[1-9]*[-.]*)
		a=${d%-*};z=${d#*-}
		l=\ $(eval echo {1..$a})
		u=\ $(eval echo {1..${z%.}})
		Rt="-path $S${l// ?/\/*} ${z:+\! -path $S${u// ?/\/*}/*}"
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
-[1-9]*[-.]*)	d=${e:1}
	z=${d#*-};	dt="-mindepth ${d%[-.]*}${z:+ -maxdepth ${z%.}}";;
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
	-|--)	L=1;shift;;
	-*|\\!)	shift;;
	-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-exec|-execdir|-executable|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	shift 2;;
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
while [[ $M =~ [^\\](\\([*?])) ]] ;do M=${M/"${BASH_REMATCH[1]}"/$'\f'"${BASH_REMATCH[2]}"} ;done
eval set -- ${M:-\"\"}
for e;{
unset b B L M s re
[[ ${e:0:2} = \\ ]] &&{	z=${e##+(\\)};z=${z#/}; e=/;}
[[ $e =~ ^\.?/[^/] ]]||re=1	# if no prefix ./ nor /, it's recursive at any depth of PWD
e=${e#./}
: ${se='\\\\'} # Get multi items separated by \\ or $sep in same dir, if any and...
while [[ $e =~ ([^\\])$se ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done 
IFS=$'\n';set -- ${e//\\/\\\\}
#get common base dir. path (B)
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
	p=${BASH_REMATCH[3]}	# is first explicit path
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
p=${p%/}
d=${p%/*};IFS=$'\n';eval set -- \"${p##*/}\"$z$M; r=("$@")
p=$p$M
p=${p//\//$'\v'}
while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
while [[ $p =~ ([^\\])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
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
		[ -d $S ] ||{ R=\"$S\";S=${s%/*};x_a=;}
	fi
fi
}
[ "$x_a" ]&&{	while [[ $x_a =~ [^\\](\\([*?])) ]] ;do x_a=${x_a/"${BASH_REMATCH[1]}"/$'\f'"${BASH_REMATCH[2]}"} ;done;fx "$x_a"
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
((l)) &&{ [ "$lx" ]|| lh=-prune; PD="-type d $lh -exec find \{\} $lx $opt \( $PD -o $P \) \;"
}
[ "$R" ]||{
	R="\".{${#S}}$f\" \( -type d -exec find '{}' $dt \! -path '{}' $opt $Z \; -o $P \)"${f:+" -o -${I}regex \".{${#S}}.+$f\" $opt \( $PD -o $P \)"}; unset dt opt Z;}
while [[ $R =~ $'\f'([*?]) ]] ;do R=${R/"${BASH_REMATCH[0]}"/\\"${BASH_REMATCH[1]}"} ;done

export LC_ALL=C
if((de)) &&[[ $z != / ]] ;then
	#export -f fid
	eval "find $po \"$S\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$S\" $X $P ! -type d -executable -exec /bin/bash -c 'fid \"\$0\" \"\$@\"' '{}' \;"
elif((if)) &&[[ $z != / ]] ;then
	eval "find $po \"$S\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$S\" $X $P ! -type d -exec /bin/bash -c '
		[[ \`file \"{}\"\` =~ ^[^:]+:[[:space:]]*([^,]+$|[^,]+[[:space:]]([^,]+)) ]];echo \  \${BASH_REMATCH[1]}' \;"

elif((Fc+Fp)) ;then
	#mkdir -pv $cp
	for i in ${c[@]};{
		eval "find $po \"$s\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$s\" $X -exec cp '{}' $i \;"
	}
	
else
	command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done)	eval "find $po \"$S\" $dt $Xd -regextype posix-extended $opt -${I}regex $R $X \! -path \"$S\" $Z"
fi
}
}
}
set +f;unset IFS;} ##### ENDING OF l, find wrap script #####


up(){
p=$FAT32
n=SoftScreen
p=$p/$n
x=zip;
z=$n.$x;pf=$p/$z
on=manifest.json
if [ -f "$pf" ] ;then
	k=`7z x $pf $on -so |sed -En '/^.*"version"/ {s/.*:\s*"([0-9.]+[0-9])",\s*/\1/p;q}'`
else
	k=`sed -En '/^.*"version"/ {s/.*:\s*"([0-9.]+[0-9])",\s*/\1/p;q}' $p/$on`
fi
echo -ne "\nVersion now: $k"
read  -n 1 -p 'Increment on second level? ' o
[[ $k =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]]
j=${BASH_REMATCH[1]}
k=${BASH_REMATCH[2]}
l=${BASH_REMATCH[3]}
if [ "$o" = y ] ;then
	((++k))
	[[ $k =~ 10+ ]] &&{ ((++j)); k=0; }
elif [[ $((++l)) =~ 10+ ]] ;then
	((++l))
	[[ $k =~ 10+ ]] &&{ ((++j)); k=0; }
	k=${k//.}
	k=$((10#$k+1)) #Remove leading '0' and increment
	printf -v k "%04d\n" $k # pad 0 back
	[[ $k =~ ${k//?/(.)} ]]
	printf -v k ".%s" ${BASH_REMATCH[@]:2}
	k=${BASH_REMATCH[1]}$k.0
else 
	k=$k.$l
fi

echo -e "\twill be updated to: $k"
sed -Ei "/^.*\"version\"/s/(.*:\s*\")([0-9].)+[0-9]/\1${k%.}/" $p/$on
cd $p
rm $z 2>/dev/nul
7z a $z . -mx=9
cd -
}

rn(){
[[ "$1" =~ -h|--help ]]&&{ echo -e "\nFor more help go to https://github.com/abdulbadii/GNU-ext-regex-rename/blob/master/README.md"
	mv --help|sed -Ee 's/\bmv\b/ren/;8a\ \ -c\t\t\t\tCase sensitive search' -e '14a\ \ -N\t\t\t\tNot to really execute only tell what it will do. It is useful as a test' ;}
unset f N i o
c=-iregex;I=i;
if [[ "${@: -1}" =~ ' ;;' ]];then
for a
{
case ${a:0:6} in
-f????) f=${a:2};f=${f#=};;
-N) N=1;;
-c) c=-regex;I=;;
-[HLPRSTabdfilnpstuvxz]) o=$o$a\ ;;
-*) echo Unrecognized option \'$a\';return;;
*)
if [ -n "$f" ] && [ ! -f "$f" ];then
	f=$(echo $f| sed -E 's~\\\\~\\~g ;s~\\~/~g ;s~\b([a-z]):(/|\W)~/\1/~i')
	[ -f $f ]||{ echo file does not exist;return;}
fi
[[ $a =~ ^(.+)\;\;[\ ]*(.+)$ ]]
x=${BASH_REMATCH[1]};y=${BASH_REMATCH[2]}

# PCRE --> GNU-ext regex
x=$(echo $x |sed -E 's/(\[.*?)\\\w([^]]*\])/\1a-z0-9\2/g; s/(\[.*?)\\\d([^]]*\])/\10-9\2/g ;s/\\\d/[0-9]/g; s/([^\])\.\*/\1[^\/]*/g; s/\.?\*\*/.*/g ;s/\s+$//')
v=${x#.\*}
if [[ "$x" =~ ^\(*(/|[a-z]:) ]] ;then
	s=$(echo $x |sed -E 's/([^[|*+\\{.]+).*/\1/;s~(.+)/.*~\1~;s/[()]//g')	#the first longest literal
else s=~+;x=$PWD/$x
fi
IFS=$'\n';LC_ALL=C
if((N));then
	if [ "$f" ];then	while read -r F
	do	[ -e $F ] ||{ F=$(echo $F|sed -E 's/[^!#-~]*([!#-~]+)[^!#-~]*/\1/;s~(\\+|//+)~/~g;s~\b([a-z]):(/|\W)~/\1/~i')
			[ -e $F ] ||continue;}
		t=`echo $F | sed -E "s!$v!$y!$I"`
		[ $F = $t ]||{
		echo -ne '\033[0;36m'Would\ 
		if [ ${F%/*} = ${t%/*} ];then	echo -n Rename
		elif [ ${F##*/} = ${t##*/} ];then	echo -n Move
		else	echo -n Move then rename
		fi
		echo -e ' \033[0m'"$F -> $t\n"
		}
	done<$f
	else	for F in `find $s -regextype posix-extended $c "$x" |head -n499`
	{	t=`echo $F | sed -E "s!$v!$y!$I"`
		[ $F = $t ]||{
		echo -ne '\033[0;36m'Would\ 
		if [ ${F%/*} = ${t%/*} ];then	echo -n Rename
		elif [ ${F##*/} = ${t##*/} ];then	echo -n Move
		else	echo -n Move then rename
		fi
		echo -e ' \033[0m'"$F -> $t"
		}
	}
	fi
else
	B='-bS .old'
	if [ "$f" ];then	while read -r F
	do	[ -e $F ] ||{ F=$(echo $F|sed -E 's/[^!#-~]*([!#-~]+)[^!#-~]*/\1/;s~(\\+|//+)~/~g;s~\b([a-z]):(/|\W)~/\1/~i')
			[ -e $F ] ||continue;}
		t=`echo $F | sed -E "s!$v!$y!$I"`
		[ $F = $t ]||{
		mkdir -p "${t%/*}"
		command mv  $o "$F" "$t" &&{
		echo -ne '\033[0;36m'
		if [ ${F%/*} = ${t%/*} ];then	echo -e Renaming'\033[0m' $F -\> $t
		elif [ ${F##*/} = ${t##*/} ];then	echo -e Moving'\033[0m' $F -\> $t
		else	echo -e Moving and renaming'\033[0m' $F -\> $t
		fi; }
		}
	done<$f
	else F==
		while([ "$F" ])
		do F=
		for F in `find $s -regextype posix-extended $c "$x" |head -n499`
		{
		t=`echo $F | sed -E "s|$v|$y|$I"`
		[ $F = $t ]||{
		mkdir -p "${t%/*}"
		command mv $o "$F" "$t" &&{
		echo -ne '\033[0;36m'
		if [ ${F%/*} = ${t%/*} ];then	echo -e Renaming'\033[0m' $F -\> $t
		elif [ ${F##*/} = ${t##*/} ];then	echo -e Moving'\033[0m' $F -\> $t
		else	echo -e Moving and renaming'\033[0m' $F -\> $t
		fi; }
		}; }
		done
	fi
fi
unset IFS;;esac
}
else	t=${@: -1};mkdir -p "${t%/*}";mv -v $o ${@: -2} $t
fi
}

cpr(){
[[ "$1" =~ -h|--help ]]&&{ echo -e "\nFor more help go to https://github.com/abdulbadii/GNU-ext-regex-rename/blob/master/README.md"
	cp --help|sed -Ee 's/\bmv\b/ren/;8a\ \ -c\t\t\t\tCase sensitive search' -e '14a\ \ -N\t\t\t\tNot to really execute only tell what it will do. It is useful as a test' ;}
unset f N i o
c=-iregex;I=i;
if [[ "${@: -1}" =~ ' ;;' ]];then
for a
{
case ${a:0:6} in
-f????) f=${a:2};f=${f#=};;
-N) N=1;;
-c) c=-regex;I=;;
-[HLPRSTabdfilnpstuvxz]) o=$o$a\ ;;
-*) echo Unrecognized option \'$a\';return;;
*)
if [ -n "$f" ] && [ ! -f "$f" ];then
	f=$(echo $f| sed -E 's~\\\\~\\~g ;s~\\~/~g ;s~\b([a-z]):(/|\W)~/\1/~i')
	[ -f $f ]||{ echo file does not exist;return;}
fi
[[ $a =~ ^(.+)\;\;[\ ]*(.+)$ ]]
x=${BASH_REMATCH[1]};y=${BASH_REMATCH[2]}

# PCRE --> GNU-ext regex
x=$(echo $x |sed -E 's/(\[.*?)\\\w([^]]*\])/\1a-z0-9\2/g; s/(\[.*?)\\\d([^]]*\])/\10-9\2/g ;s/\\\d/[0-9]/g; s/([^\])\.\*/\1[^\/]*/g; s/\.?\*\*/.*/g ;s/\s+$//')
v=${x#.\*}
if [[ "$x" =~ ^\(*(/|[a-z]:) ]] ;then
	s=$(echo $x |sed -E 's/([^[|*+\\{.]+).*/\1/;s~(.+)/.*~\1~;s/[()]//g')	#the first longest literal
else s=~+;x=$PWD/$x
fi
IFS=$'\n';LC_ALL=C
if((N));then
	if [ "$f" ];then	while read -r F
	do	[ -e $F ] ||{ F=$(echo $F|sed -E 's/[^!#-~]*([!#-~]+)[^!#-~]*/\1/;s~(\\+|//+)~/~g;s~\b([a-z]):(/|\W)~/\1/~i')
			[ -e $F ] ||continue;}
		t=`echo $F | sed -E "s!$v!$y!$I"`
		[ $F = $t ]||{
		echo -ne '\033[0;36m'Would\ 
		if [ ${F%/*} = ${t%/*} ];then	echo -n Rename
		elif [ ${F##*/} = ${t##*/} ];then	echo -n Move
		else	echo -n Move then rename
		fi
		echo -e ' \033[0m'"$F -> $t\n"
		}
	done<$f
	else	for F in `find $s -regextype posix-extended $c "$x" |head -n499`
	{	t=`echo $F | sed -E "s!$v!$y!$I"`
		[ $F = $t ]||{
		echo -ne '\033[0;36m'Would\ 
		if [ ${F%/*} = ${t%/*} ];then	echo -n Rename
		elif [ ${F##*/} = ${t##*/} ];then	echo -n Move
		else	echo -n Move then rename
		fi
		echo -e ' \033[0m'"$F -> $t"
		}
	}
	fi
else
	B='-bS .old'
	if [ "$f" ];then	while read -r F
	do	[ -e $F ] ||{ F=$(echo $F|sed -E 's/[^!#-~]*([!#-~]+)[^!#-~]*/\1/;s~(\\+|//+)~/~g;s~\b([a-z]):(/|\W)~/\1/~i')
			[ -e $F ] ||continue;}
		t=`echo $F | sed -E "s!$v!$y!$I"`
		[ $F = $t ]||{
		mkdir -p "${t%/*}"
		command cp  $o "$F" "$t" &&{
		echo -ne '\033[0;36m'
		if [ ${F%/*} = ${t%/*} ];then	echo -e Renaming'\033[0m' $F -\> $t
		elif [ ${F##*/} = ${t##*/} ];then	echo -e Moving'\033[0m' $F -\> $t
		else	echo -e Moving and renaming'\033[0m' $F -\> $t
		fi; }
		}
	done<$f
	else F==
		while([ "$F" ])
		do F=
		for F in `find $s -regextype posix-extended $c "$x" |head -n499`
		{
		t=`echo $F | sed -E "s|$v|$y|$I"`
		[ $F = $t ]||{
		mkdir -p "${t%/*}"
		command cp $o "$F" "$t" &&{
		echo -ne '\033[0;36m'
		if [ ${F%/*} = ${t%/*} ];then	echo -e Renaming'\033[0m' $F -\> $t
		elif [ ${F##*/} = ${t##*/} ];then	echo -e Moving'\033[0m' $F -\> $t
		else	echo -e Moving and renaming'\033[0m' $F -\> $t
		fi; }
		}; }
		done
	fi
fi
unset IFS;;esac
}
else	t=${@: -1};mkdir -p "${t%/*}";cp -v $o ${@: -2} $t
fi
}



copy(){
(($#<2))&&return
N=;i=;o=;c=-iregex;I=i;
for a
{
case ${a:0:6} in
-f????) f=${a:2};f=${f#=};;
-N) N=1;;
-c) c=-regex;I=;;
-[HLPRSTabdfilnpstuvxz]) o="$o $a";;
--h|-h) echo -e For more help go to'\nhttps://github.com/abdulbadii/GNU-ext-regex-copy/blob/master/README.md\n'
	cp --help|sed -Ee 's/\bmv\b/ren/;8a\ \ -c\t\t\t\tCase sensitive search' -e '14a\ \ -N\t\t\t\tNot to really execute only tell what it will do. It is useful as a test';return;;
-*) echo Unrecognized option \'$a\';return;;
*)
if [ ! -f $f ];then
	f=$(echo $f| sed -E 's~\\\\~\\~g ;s~\\~/~g ;s~\b([a-z]):(/|\W)~/\1/~i')
	[ -f $f ]||{ echo file $f does not exist;return;}
fi
if [[ "${@: -1}" =~ ' ;;' ]];then
y=${a#* ;;}
x=${a%[^ ]*;;*};x=$x${a:${#x}:1}
# PCRE --> GNU-ext regex
x=$(echo $x |sed -E 's/(\[.*?)\\\w([^]]*\])/\1a-z0-9\2/g; s/(\[.*?)\\\d([^]]*\])/\10-9\2/g ;s/\\\d/[0-9]/g; s/([^\])\.\*/\1[^\/]*/g; s/\.?\*\*/.*/g')
v=${x#.\*}
if [[ "$x" =~ ^\(*(/|[a-z]:) ]] ;then
	s=$(echo $x |sed -E 's/([^[|*+\\{.]+).*/\1/;s~(.+)/.*~\1~;s/[()]//g')	#the first longest literal
else s=~+;x=$PWD/$x
fi
IFS=$'\n';LC_ALL=C
if((N==1));then
	if [ "$f" ];then	while read -r F
	do	[ -e $F ] ||{ F=$(echo $F|sed -E 's/[^!#-~]*([!#-~]+)[^!#-~]*/\1/;s~(\\+|//+)~/~g;s~\b([a-z]):(/|\W)~/\1/~i')
			[ -e $F ] ||continue;}
		t=`echo $F | sed -E "s|$v|$y|$I"`
		[ $F = $t ]||{
		echo -ne '\033[0;36m'Would\ 
		if [ ${F%/*} = ${t%/*} ];then	echo copy as different name on the same folder
		elif [ ${F##*/} = ${t##*/} ];then	echo copy to different folder
		else	echo copy to different name and folder
		fi
		echo -e '\033[0m'"$F -> $t\n"
		}
	done<$f
	else	for F in `find $s -regextype posix-extended $c "$x" |head -n499`
	{	t=`echo $F | sed -E "s|$v|$y|$I"`
		[ $F = $t ]||{
		echo -ne '\033[0;36m'Would\ 
		if [ ${F%/*} = ${t%/*} ];then	echo copy as a new name at the same folder
		elif [ ${F##*/} = ${t##*/} ];then	echo copy into different folder
		else	echo copy to different name and folder
		fi
		echo -e '\033[0m'"$F -> $t\n"
		}
	}
	fi
else
	if [ "$f" ];then	while read -r F
	do	[ -e $F ] ||{ F=$(echo $F|sed -E 's/[^!#-~]*([!#-~]+)[^!#-~]*/\1/;s~(\\+|//+)~/~g;s~\b([a-z]):(/|\W)~/\1/~i')
			[ -e $F ] ||continue;}
		t=`echo $F | sed -E "s|$v|$y|$I"`
		[ $F = $t ]||{
		if [ ${F%/*} = ${t%/*} ];then	echo -e '\033[0;36m'Copying to different name on the same folder'\033[0m' 
		elif [ ${F##*/} = ${t##*/} ];then	echo -e '\033[0;36m'Copying to different folder'\033[0m' 
		else	echo -e '\033[0;36m'Copying to different name and folder'\033[0m' 
		fi
		mkdir -p "${t%/*}";cp -vbS .old $o "$F" "$t";}
	done<$f
	else F==
		while([ "$F" ])
		do F=
		for F in `find $s -regextype posix-extended $c "$x" |head -n499`
		{
		t=`echo $F | sed -E "s|$v|$y|$I"`
		[ $F = $t ]||{
		if [ ${F%/*} = ${t%/*} ];then	echo -e '\033[0;36m'Copying as new name of the same folder'\033[0m'
		elif [ ${F##*/} = ${t##*/} ];then	echo -e '\033[0;36m'Copying into different folder'\033[0m'
		else	echo -e '\033[0;36m'Copying to different folder and name'\033[0m'
		fi
		mkdir -p "${t%/*}";cp -vbS .old $o "$F" "$t";}
		}
		done
		fi
fi
unset IFS
else
	t=xv${@: -1};mkdir -p "${t%/*}";cp -bvS .old $o ${@: -2} $t
fi;;
esac
}
}

filsz(){
e=;d=;w=v;x='tmp,bak';p=~+
for o
{
case ${o:0:3} in
-x*)	
	x=${o#-x};x=${x#=};;
-d*)
	o=${o#-d[= ]/}
	a=${o%,*};b=${o#*,}
	o=${a:+"-mindepth $a "}${b:+"-maxdepth $b "};;
-nv)	w=;;
/[a-z]*)
	if [ -d "$o" ] ;then
		p=$o
	elif [ -e $o ] ;then
		p=${o%/*}
		e=${o##*/}
	else	echo Directory/file \'$o\' does not exist;return 1
	fi;;
-?*) echo Invalid option;return 1;;
*)
	if [ -f ~+/$o ] ;then	e=$o
	elif [ -d ~+/$o ] ;then p=~+/$o
	else echo Directory/file  \'$PWD/$o\' does not exist;return 1
	fi;;
esac
}
xt="(${x//,/|})"
if [ $e ] ;then
	f="($(echo "$e.$xt|${e%%.*}[-_][0-9]${e#*.}"| sed -E 's/[{}\.$]/\\\&/g; s/\*/.*/g; s/\?/./'))"
else
	f="[^/]+(\.$xt|[-_][0-9]\.[^./]+)"
fi
IFS=$'\n'
s==;while [ "$s" ]
do
y=0;a=;b=;d=;s=
for s in `find $p $d -type f -regextype posix-extended -iregex ^.*/$f\$ -printf '%p %s\n' |head -n199`
{
	fx=${s% *};h=${fx%/*};z=${s##* }
	if [[ ${fx: -4} =~ $xt ]] ;then e=${fx:0:-4}
	else
		e=`echo $fx|sed -E 's/[-_][0-9](\.[^./]+)$/\1/'`
	fi
	if [ "$h" = "$d" ] &&[ $e = $a ];then
		if [ $z -lt $y ]	;then
			rm -f$w $fx
			continue
		elif [ $z -gt $y ]|| [ `find $h -noleaf -maxdepth 1 -type f -iname "${e##*/}" -newer "$b"` ];then
			rm -f$w $b
		fi
	elif [ "$d" ] ;then
		if [ -f $a ]&&[ `find $d -noleaf -maxdepth 1 -type f -iname "${a##*/}" -printf %s` -gt $y ];then rm -f$w $b
		else mv -f$w $b $a
		fi
	fi
	d=$h
	a=$e
	b=$fx
	y=$z
}
done
unset IFS
}

# access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"
# Aliases - Some people use a different file for aliases
# if test -f "${HOME}/.bash_aliases" ; then
#   source "${HOME}/.bash_aliases"
# fi

# Umask
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077
# Functions
#
# Some people use a different file for functions
# if test -f "${HOME}/.bash_functions" ; then
#   source "${HOME}/.bash_functions"
# fi
#functions:
# a) function settitle
# settitle ()
# {
#   echo -ne "\e]2;$@\a\e]1;$@\a";
# }
#
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
#
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
#
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
#
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
#
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
#
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
#
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
#
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
#   return 0
# }
#
# alias cd=cd_func
# mvc() {
# if [[ $@ =~ ^- ]] ;then
	# r=;l=
	# for f
	# {
		# [[ $f =~ ^- ]] || break
		# [[ $f =~ -(64|32) ]] &&{ r=$f ;shift; }
	# }
	# if test $r = -64 ;then 
		# for f
		# {
		# a=`head -c512 $f | od -xAn  | gre -Moe '4550( \w{4}\s*){12}'` 2>/dev/nul&&{ test ${a: -4} = 20b &&l="$l$f "; }
		# }
	# elif test $r = -32 ;then
		# for f
		# {
		# a=`head -c512 $f | od -xAn  | gre -Moe '4550( \w{4}\s*){12}'` 2>/dev/nul&&{ test ${a: -4} = 10b &&l="$l$f "; }
		# }
	# fi
	# mv -bv $l $f
# else	mv -bv "$@"
# fi
# }

