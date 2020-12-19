fxr(){ ##### BEGINNING OF l, find wrap script #####
local F L a b e d M p re s z R D
[[ $1 =~ ^/ ]]&&{	echo Should be no absolute path exclusion, instead use relative path to \"$S\">&2;return 1;}
[[ $1 =~ ^\.?/[^/] ]]||re=1;e=${1#./}
: ${se='\\\\'}
while [[ $e =~ ([^\\])($se) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done 
IFS=$'\n';set -- ${e//\\/\\\\}
[[ $1 =~ ^((/?([^/]+/)*)([^/]+))?(/*)$ ]]
d=${BASH_REMATCH[2]}
L=\"${BASH_REMATCH[4]}\"
z=${BASH_REMATCH[5]}
[[ $L =~ \"\.\.\" ]] &&{ d=$d../;L=*$z;}
F=1
shift;for a;{	[[ $a =~ (/|^)\.\.(/|$) ]] &&{	L=$L\ "$@";F=;break;};}
[ $# -ge 1 ]&&((F)) &&{	[[ $e =~ ^[^$'\n']*($'\n'.*)?$ ]];M=${BASH_REMATCH[1]};}
unset IFS;eval set -- $L
for a;{
a=$d${a%%+(/)}
if [[ $a =~ ^(\.\.(/\.\.)*)(/.+)?$ ]] ;then
	s=$S/${BASH_REMATCH[1]}
	p=${BASH_REMATCH[3]}
	while [[ $s =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do s=${s/"${BASH_REMATCH[0]}"/\/};done
	[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid path: $a. It goes up beyond root>&2;continue;}
	s=${s%/}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do	[ "$s" ] ||{ echo Invalid path: $a. It goes up beyond root>&2;continue;}
			p=${p#/..}; s=${s%/*};done
	fi
else
	s=$S;p=${a:+/$a}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do	[ "$s" ]||{ echo Invalid path: $a. It goes up beyond root>&2;continue;}
			p=${p#/..}; s=${s%/*};done
	fi
fi
p=${p%/};D=$s;echo Exclusion path is relative to directory \"$D\">&2
b=${p%/*}
IFS=$'\n';eval set -- \"${p##*/}\"$z$M
for f;{
[[ $f =~ ^(.*[^/])?(/*)$ ]]
z=${BASH_REMATCH[2]}
f=$b/${BASH_REMATCH[1]}
((!REX))&&{
	while [[ $f =~ ([^$'\f']\[)! ]] ;do f=${f/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
	while [[ $f =~ ([^\\].|.[^\\])([.{}()]) ]] ;do f=${f/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}"};done
}
if [[ $f =~ ([^$'\f']|^)[]*?[] ]] ;then
		if((re)) ;then	p=**$f
		else
			[[ $f =~ [^$'\f'][]*?[].*$ ]];	p=${BASH_REMATCH[0]}
			D=${f%$/*$p};p=${f#$D}
			D=$s$D
		fi
		while [[ $p =~ ([^$'\f']|^)\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
		p=${p//\*\*/.$'\r'}
		while [[ $p =~ ([^$'\f']|^)\* ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"[^/]$'\r'} ;done;p=${p//$'\r'/*}
		R=\".{${#D}}$p\"
else		R=\".{${#D}}${re+.*}$f\"
fi
case $z in
/)	z=-type\ d\ ;;
//)	z=-type\ f\ ;;
///)	z="\! -type d -executable ";;
////)	z=-type\ l\ ;;
esac
while [[ $R =~ $'\f'([]*?[]) ]] ;do R=${R/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"} ;done
Rt="$z-${J}regex \"$R\" $Rt"
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
		x="${x//////[mh]/min} ";x="${x/[dM]/time} "
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
fd(){	local a e A E
	E=${D#*-}
	if [[ $D =~ - ]];then	A=${D%-*}
	elif [[ $D = *. ]];then	E=${D%.};A=$E;fi
	if((Rd));then
		a=\ $(eval echo {1..$((DM-A+1))})
		a=${a// ?[! ]/ .};a=${a// ?/\/*}/*
		e=\ $(eval echo {1..$((DM-E+1))})
		e=${e// ?[! ]/ .};e=${e// ?/\/*}
		Rt="${E+-path \"${1-$S}$e\"}${A:+ \! -path \"${1-$S}$a\"}"
	else
		a=\ $(eval echo {1..$A})
		a=${a// ?[! ]/ .};a=${a// ?/\/*}
		e=\ $(eval echo {1..$E})
		e=${e// ?[! ]/ .};e=${e// ?/\/*}/*
		Rt="${A+-path \"${1-$S}$a\"}${E:+ \! -path \"${1-$S}$e\"}"
	fi
}
fx(){	local D F L G H x r Rt REX IFS S=$1;shift
for a;{
eval set -- $a
unset F L G H r;for e;{
case $e in
	-[cam][0-9]*|-[cam]-[0-9]*)	((L))&&continue;L=1
		ftm $e;r=$Rt\ $r;;
	-s[0-9]|-s[0-9][-cwbkMG]*|-s[-0-9][0-9]*)	((G))&&continue;G=1
		fsz $e;r=$Rt\ $r;;
	-[1-9]|-[1-9][0-9]|-[1-9][-0-9.]*|-[1-9][r/]|-[1-9][-0-9.]*[r/])
		((H))&&continue;H=1
		D=${e:1};[[ $e =~ [r/]$ ]]&&{	${D%?};Rd=1;}
		fd;	r=$Rt\ $r
		dtx="exclusion option \"$e\"";;
	-E|-re)	REX=1;;
	*)	[[ $e = -* ]]&&echo \'$e\': unrecognized exclusion option, it\'d be an excluded path>&2
		((F))&&continue;F=1
		fxr "$e"; (($?))&&return 1
		r=$r\ $Rt
esac
}
F=${F+'\(' -type d -prune -o -printf \'\' '\)'};: ${F:=-printf \'\'}
x=($x "$r" "$F")
}
X=('\(' $x -o $Z '\)')
}
fid(){
	[[ `file "$1"` =~ ^[^:]+:\ *([^,]+$|[^,]+\ [^,]+) ]];echo -e " ${BASH_REMATCH[1]}\n DEPs"
	ldd "$1" 2>/dev/null |sed -E 's/^\s*([^>]+>\s*)?(.+)\s+\(0.+/  \2/'
}
l(){
unset IFS F L A E a RX de dp po opt se sz tm D Dt Rd DM dt dtx if l lh lx c cp Fc Fp Rt X XF;I=i
shopt -s extglob;set -f;trap 'set +f;unset IFS' 1 2
for e;{
((F)) &&{	opt=$opt$e\ ;F=;continue;}
case $e in
-cs) I=;;
-[cam][0-9]*|-[cam]-[0-9]*)	ftm $e;opt=$opt$Rt\ ;;
-[1-9]|-[1-9][-0-9.]*|-[1-9][r/]|-[1-9][-0-9.]*[r/])
	Dt=$e;D=${e:1};[[ ${e: -1} = [r/] ]]&&{	D=${D%?};Rd=1;};;
-s[0-9]|-s[0-9][-cwbkmMgG]*|-s[-0-9][0-9]*)	fsz $e;opt=$opt$Rt\ ;;
-x=*|-xs=*|-xcs=*|c=*|cp=*)	;;
-l) lx=-maxdepth\ 1;l=1;;
-l[0-9]|-l[1-9][0-9])	((${e:2})) &&lx="-maxdepth\ ${e:2}";l=1;;
-z)	sz=%s\ ;;
-E|-re) RX=1;;
-|--)	break;;
-rm)	opt=$opt-delete\ ;;
-sep=?|-sep=??) se=${e:5};;
-sep=*) echo "Separator must be 1 or 2 characters, it'd still default to \\">&2;;
-de) de=1;;
-in) if=1;;
-ci) I=i;;
-dp)	dp=%d\ ;;
-t)	tm="%Tr %Tx ";;
-h|--help) man find;return;;
-[HDLPO]) po=$e\ ;;
-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-exec|-execdir|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	opt=$opt$e\ ;F=1;;
\!|-[ac-il-x]?*)
	if [[ $e =~ ^!|-(delete|depth|daystart|follow|fprint|fls|group|gid|o|xstype)$ ]] ;then opt=$opt$e' '
	else	read -n1 -p "Option '$e' seems unrecognized, ignoring it and continue? " k>&2;echo;[ "$k" = y ]||return;fi;;
-*)	echo \'$e\': unknown option, ignoring. To let it be a path string, put it after - or -- then space>&2
esac
}
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]]
IFS=';&|><';set -- ${BASH_REMATCH[1]}
unset IFS F L G K S J Ca x_a M
for c;{
	[[ $c =~ ^.+\ *\$\(\ *$FUNCNAME\ +(.*)\)|.+\ *\`\ *$FUNCNAME\ +(.*)\`|\ *$FUNCNAME\ +(.*) ]]&&{	
		c="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
		while [[ $c =~ ([^\\])\\([]*?[]) ]] ;do c=${c/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\f'"${BASH_REMATCH[2]}"} ;done
		eval set -- $c;break;}
	set --;}
for a;{
	((S))&&{	S=;continue;}
	((!L)) &&{
		case $a in
		-x=?*|-xs=?*|-xcs=?*)
			#((K))&&{	echo -c or -cp option must be as the last>&2;return;}
			[ ${e:2:1} = = ]&&J=i
			x_a=$x_a\"${a#-x*=}\"' ';G=1;continue;;
		#-c=?*|-cp=?*)
			#Ca=\"${c#-c*=}\"
			#if [ ${a:2:1} = = ] ;then Fc=1;else Fp=1 ;fi;K=1;continue;;
		-*|-\!)	continue;;	-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-exec|-execdir|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	S=1;;
		-|--)	L=1;continue
		esac
	}
	a=\"$a\"			# k l m -x=i o  -- -c=m n
	if((G)) ;then
		if((F)) ;then	x_a=$x_a$a' '
		else				M=$M$a' '
		fi
	#elif((K)) ;then
		#((F))&&{	echo -c or -cp option must be as the last>&2;return;}
		#Ca=$Ca\"$c\"' '
	elif ((L)) ;then
		if((F))	;then	M=$M$a
		else		M=$a;	x_a=$x_a$M
		fi;G=0
	else	M=$M$a' ';F=1;fi
}
M=${M//\\/\\\\}
eval set -- ${M:-\"\"}
for e;{
unset b B s re M
if [ "${e:0:1}" = \\ ];then	z=${e##+(\\)};z=${z#/};[[ $z =~ /* ]]&&L=/$'\r'$z # put \x0D to mark a root dir
else
[[ $e =~ ^\.?/[^/] ]]||re=1	# if no prefix ./ nor /, search recursively any depth from PWD
e=${e#./}
: ${se='\\'} # Get multi items separated by \\ or $sep of same dir path, if any and...
while [[ $e =~ ([^\\])$se ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done 
IFS=$'\n';set -- ${e//\\/\\\\}
[[ $1 =~ ^(.*[^/])?(/*)$ ]]
z=${BASH_REMATCH[2]}
a=${BASH_REMATCH[1]}

if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
	[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid path: $a. It goes up beyond root>&2;continue;}
	p=$a
else
	while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do
		a=${a/"${BASH_REMATCH[0]}"/\/};done
	[[ $a =~ ^(/\.\.)+(/.*|$) ]] &&{
	p=${BASH_REMATCH[2]}
	s=$s"${BASH_REMATCH[1]}"
	while [[ $s =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do
		[[ $s =~ ^\.\.(/|$) ]] &&{ echo Invalid path: $a. It goes up beyond root>&2;continue;}
		s=${s/"${BASH_REMATCH[0]}"/\/};done
fi
	


	s=$s{s%/}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}} # clear remaining leading /..
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do	[ "$s" ] ||{ echo Invalid path: $a. It goes up beyond root>&2;continue;}
			p=${p#/..}; s=${s%/*};done
	fi
else
	s=~+;p=${a:+/$a}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do	[ "$s" ]||{ echo Invalid path: $a. It goes up beyond root>&2;continue;}
			p=${p#/..}; s=${s%/*};done
	fi
fi
fi
	B=${BASH_REMATCH[2]}					#get common dir. (B) of multi items
	L=\"${BASH_REMATCH[4]}\"

	F=1			# ...none has exact .. pattern to be M, otherwise become the outer loop: L
	shift;for a;{	[[ $a =~ (/|^)\.\.(/|$) ]] &&{	L=$L\ "$@";F=;break;};}
	[ $# -ge 1 ]&&((F)) &&{	[[ $e =~ ^[^$'\n']*($'\n'.*)?$ ]];M=${BASH_REMATCH[1]};}

unset IFS R s;eval set -- $L
for a;{
a=$B${a%%+(/)}

p=${p%/}
d=${p%/*};IFS=$'\n';eval set -- \"${p##*/}\"$z$M; r=("$@")
p=$p$M
p=${p//\//$'\v'}
while [[ $p =~ ([^$'\f']\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
while [[ $p =~ ([^$'\f']|^)\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
while [[ $p =~ ([^\\].|.[^\\])([.{}()]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}"};done
p=${p//\*\*/.$'\r'}
while [[ $p =~ ([^$'\f']|^)\* ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"[^/]$'\r'} ;done;p=${p//$'\r'/*}
M=${M:+$'\n'${p#*$'\n'}}
b=${p%%$'\n'*}
p=${b##*$'\v'}${z//\//$'\v'}$M
b=${b%$'\v'*}
S=$s
i=;F=;set -- ${p:-\"\"}
for f;{
if((!RX)) &&[[ ${r[i]} =~ ([^$'\f']|^)[]*?[] ]] ;then
	[[ $f =~ ^(.*[^$'\v'])?($'\v'*)$ ]]
	z=${BASH_REMATCH[2]//$'\v'/\/}
	f=$b$'\v'${BASH_REMATCH[1]}
	if((re)) ;then	p=.*$f
	else
		[[ $f =~ [^$'\f'][]*?[].*$ ]];	p=${BASH_REMATCH[0]}
		S=${f%$'\v'*$p};p=${f#$S}
		S=$s${S//$'\v'/\/}
	fi
	R=\".{${#S}}${p//$'\v'/\/}\"
else
	[[ ${r[i]} =~ ^(.*[^/])?(/*)$ ]]
	z=${BASH_REMATCH[2]}
	p=$d/${BASH_REMATCH[1]};p=${p%[/$'\r']}
	if((RX)) ;then	R=\".{${#S}}${re+.*}$p\"
	elif((re)) ;then	F=\"$s$p\"
	else	S=$s$p;R=.*;	[ -d "$S" ]||{ R=\"$S\";S=${s%/*};x_a=;}
	fi
fi
((i++))
while [[ $S =~ $'\f'([]*?[]) ]];do S=${S/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"};done
while [[ $R =~ $'\f'([]*?[]) ]];do R=${R/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
P="\( -path '* *' -printf \"$dp$sz$tm'%p'\n\" -o -printf \"$dp$sz$tm%p\n\" \)"
PD="-type d \( -path '* *' -printf \"$dp$tm'%p/'\n\" -o -printf \"$dp$tm%p/\n\" \)"
((l)) &&{ [ "$lx" ]|| lh=-prune; PD="-type d $lh -exec find \{\} $lx $opt\( $PD -o $P \) \;";}
case $z in
/)	Z="$PD";;
//)	Z="-type f $P";;
///)	Z="\! -type d -executable $P";;
////)	Z="-type l \( -path '* *' -printf \"'%p' '%l'\n\" -o -printf \"%p %l\n\" \)";;
*)	Z="\( $PD -o $P \)"
esac
S=\"${S:-/}\";FS=${F:-$S}
((Rd))&&{	[[ `eval "find $FS -printf \"%d\n\"|sort -nur"` =~ [1-9]+ ]];DM=${BASH_REMATCH[0]};}

((XF))||{	eval ${x_a+fx $FS $x_a};(($?))&&return;XF=1;}
eval ${D+fd $F}
if [ $F ] ;then
	CL="find $po$S -regextype posix-extended $opt-${I}path $F/* $Rt ${X[@]-$Z}"${p:+" -o -${I}path $F -type f $P -o -${I}regex \".{${#s}}.+$p\" $opt\( $PD -o $P \)"}
else	CL="find $po$S -regextype posix-extended $Rt $opt-${I}regex $R \! -path $S ${X[@]-$Z}"
fi
[ "$D$dtx" ]&&echo "${D+Depth option \"$Dt\" is${Rd+ '$D' depth from max $DM} of $FS}${D+${dtx+ and }}${dtx+$dtx is of $FS}">&2
LC_ALL=C
if((de)) &&[[ $z != / ]] ;then	export -f fid
	eval "$CL ! -type d -executable -exec /bin/bash -c 'fid \"\$0\" \"\$@\"' '{}' \;"
elif((if)) &&[[ $z != / ]] ;then eval "$CL ! -type d -exec /bin/bash -c '
		[[ \`file \"{}\"\` =~ ^[^:]+:\ *([^,]+$|[^,]+\ ([^,]+)) ]];echo \  \${BASH_REMATCH[1]}' \;"
#elif((Fc+Fp)) ;then
	#sudo mkdir -pv $cp
	#for i in ${c[@]};{	eval "sudo $CL -exec cp '{}' $i \;";}
else	command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done)	eval sudo $CL
fi
}
}
}
set +f;unset IFS;} ##### ENDING OF l, find wrap script #####
