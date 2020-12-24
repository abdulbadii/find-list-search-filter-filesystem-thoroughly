fxr(){ ##### BEGINNING OF l, find wrap script #####
local F B a b e d r p re s z R D
[[ $1 =~ ^\./ ]]||re=1
a=${a#./};[[ $a =~ ^\.?/ ]]&&{echo should be no absolute path on exclusion, it must be relative to \'$S\';return;}
a=${1//$se/$'\n'}
[[ $a =~ ^(.*[^/])?(/*)$ ]]
z=${BASH_REMATCH[2]}
p=${BASH_REMATCH[1]};s=$S

B=${p%/*}${p:+/}
r=("${p##*/}$z" ${@:2})
e=$e$'\n';e=${e#*$'\n'}
p=$p${e:+$'\n'$e}
p=${p//\//$'\v'}
while [[ $p =~ ([^$'\f']\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
while [[ $p =~ ([^$'\f']|^)\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
p=${p//./\\\\.};p=${p//\{/\\\\\{};p=${p//\}/\\\\\}};p=${p//\(/\\\\\(};p=${p//\)/\\\\\)}
p=${p//\*\*/.$'\r'}
while [[ $p =~ ([^$'\f']|^)\* ]];do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"[^/]$'\r'};done;p=${p//$'\r'/*}
b=${p%%$'\n'*}
p=$p$'\n';p=${p#*$'\n'}
p=${b##*$'\v'}${z//\//$'\v'}$p
b=${b%$'\v'*}

unset i F L;set -- ${p:-\"\"}
for f;{
if((!RX))&&	[[ $B$f =~ ([^$'\f']|^)[*[] ]] ;then
	a=$b$'\v'$f
	while [[ $a =~ /[^/]+/\.\.(/|$) ]];do	a=${a/"${BASH_REMATCH[0]}"/\/};[[ $a =~ ^/\.\.(/|$) ]]&&{	a=$a;eval $E;};done
	[[ $a =~ ^(.*[^$'\v'])?($'\v'*)$ ]]
	z=${BASH_REMATCH[2]//$'\v'/\/}
	p=${BASH_REMATCH[1]}
	p=${re+.*}$a;
	R=\"$S${p//$'\v'/\/}\"
else	a=$B${r[i++]}
	while [[ $a =~ /[^/]+/\.\.(/|$) ]];do	a=${a/"${BASH_REMATCH[0]}"/\/};[[ $a =~ ^/..(/|$) ]]&&eval $E;done
	[[ $a =~ ^(.*[^/])?(/*)$ ]]
	z=${BASH_REMATCH[2]};p=${BASH_REMATCH[1]}
	if((RX));then	R=\"$s${re+.*}$p\"
	elif((re));then	L=1;F=\"$s$p\";S=$s
	else	S=$s$p;R=.*;	[ -d "$S" ]||{ R=\"$S\";S=${S%/*};x_a=;}
	fi
fi

case $z in
/)	z=-type\ d;;
//)	z=-type\ f;;
///)	z="\! -type d -executable";;
////)	z=-type\ l
esac
while [[ $R =~ $'\f'([]*?[]) ]];do R=${R/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
Rt="$z -${J}regex \"$R\""
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
		D=${e:1};[[ $e =~ [r/]$ ]]&&{	D=${D%?};Rd=1;}
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
unset IFS F L A E a RX de dp po opt se sz tm D Dt Rd DM dt dtx if l lh lx c cp Fc Fp Rt X XF IS;I=i
shopt -s extglob nocaseglob
set -f;trap 'set +f;unset IFS' 1 2
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
-sep=*) echo "Separator must be 1 or 2 characters. So it still defaults to \\">&2;;
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
	else	read -n1 -p "Option '$e' seems unrecognized, ignoring and continue? " k>&2;echo;[ "$k" = y ]||return;fi;;
-*)	echo \'$e\': unknown option, ignoring. To let it be a path string, put it after - or -- then space>&2
esac
}
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]];h=${BASH_REMATCH[1]}
while [[ $h =~ ([^\\]|\\\\)[\;\&|\>\<] ]];do	h=${h/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'};done
IFS=$'\n';set -- $h
unset IFS F L G K S J Ca x_a x M
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
			x=${a#-x*=};[[ $x =~ ^-[1-9].*\.?[r/]$ ]]&&Rd=1
			x_a=$x_a\"$x\"' ';
			G=1;continue;;
		#-c=?*|-cp=?*)
			#Ca=\"${c#-c*=}\"
			#if [ ${a:2:1} = = ] ;then Fc=1;else Fp=1 ;fi;K=1;continue;;
		-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-exec|-execdir|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	S=1;;
		-|--)	L=1;continue;;
		-\!|-*)	continue;;
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
E='echo Invalid path: \"$a\". It goes up beyond root>&2;continue'
M=${M//\\/\\\\};eval set -- ${M:-\"\"}
for e;{
unset F b B s p z r re
if [ "${e:0:2}" = \\/ ];then	z=${e:2};s=/			# prepended \\ is a mark of root dir
else
: ${se='\\'};e=${e//$se/$'\n'}			# path with same head separated by \\ or $sep
IFS=$'\n';set -- $e;re=1
for a;{
	[[ $a =~ ^(\./|.*[^/])?(/*)$ ]]
	z=${BASH_REMATCH[2]}
	a=${BASH_REMATCH[1]}
	if [ "${a:0:1}" = / ] ;then re=
		p=$a;[[ $a =~ ^/\.\.(/|$) ]] &&eval $E 2
		while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/\/};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E 2;done
	else
		[ "$a" = . ]&&a=./;[[ $a =~ ^\./ ]]&&re=			# if . or prefixed by ./ do not search recursively
		a=${a#./};p=${a:+/$a};s=~+
		[[ $p =~ ^((/\.\.)*)(/.+|$) ]]
		p=${BASH_REMATCH[3]}
		s=$s${BASH_REMATCH[1]}
		[[ $s =~ ^/\.\.(/|$) ]] &&{	a=$s;eval $E 2;}
		while [[ $s =~ /[^/]+/\.\.(/|$) ]];do	s=${s/"${BASH_REMATCH[0]}"/\/};[[ $s =~ ^/\.\.(/|$) ]]&&{	a=$s;eval $E 2;};done
		while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)*)(/.+|$) ]]
		p=${BASH_REMATCH[3]}
		((re))||{
			s=$s${BASH_REMATCH[1]}
			while [[ $s =~ /[^/]+/\.\.(/|$) ]];do	s=${s/"${BASH_REMATCH[0]}"/\/}
				[[ $s =~ ^\.\.(/|$) ]] &&eval $E 2;done
		}
		s=${s%/}
	fi
	p=${p%/}
break;}
r=("${p##*/}$z" ${@:2}); B=${p%/*}${p:+/}				# common base dir. of sub paths as literal is B, they're in array
(($#>1)) &&p=$p$'\n'${e#*$'\n'}			# else the regex-converted ones put in p delimited by \n
p=${p//\//$'\v'}
while [[ $p =~ ([^$'\f']\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
while [[ $p =~ ([^$'\f']|^)\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
p=${p//./\\\\.};p=${p//\{/\\\\\{};p=${p//\}/\\\\\}};p=${p//\(/\\\\\(};p=${p//\)/\\\\\)}
p=${p//\*\*/.$'\r'}
while [[ $p =~ ([^$'\f']|^)\* ]];do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"[^/]$'\r'};done;p=${p//$'\r'/*}
b=${p%%$'\n'*}
a=${b##*$'\v'}${z//\//$'\v'}${p#$b}
b=${b%$'\v'*}							# head/base dir. is b
fi
unset i F L;set -- ${a:-\"\"}
for f;{
if((!RX))&&	[[ $b$f =~ ([^$'\f']|^)[*[] ]] ;then
	a=$b$'\v'$f
	while [[ $a =~ /[^/]+/\.\.(/|$) ]];do	a=${a/"${BASH_REMATCH[0]}"/\/}
		[[ $a =~ ^/\.\.(/|$) ]]&&{	a=$a;eval $E;};done
	[[ $a =~ ^(.*[^$'\v'])?($'\v'*)$ ]]
	z=${BASH_REMATCH[2]//$'\v'/\/}
	p=${BASH_REMATCH[1]}
	if((re)) ;then	p=.*$p;S=$s
	else	IS=$I
		[[ $p =~ [^$'\f']([]*?[].*)$ ]]
		S=${p%$'\v'*${BASH_REMATCH[1]}}
		S=$s${S//$'\v'/\/}
	fi
	R=\"$s${p//$'\v'/\/}\"
else	a=$B${r[i++]}
	while [[ $a =~ /[^/]+/\.\.(/|$) ]];do	a=${a/"${BASH_REMATCH[0]}"/\/};[[ $a =~ ^/..(/|$) ]]&&eval $E;done
	[[ $a =~ ^(.*[^/])?(/*)$ ]]
	z=${BASH_REMATCH[2]};p=${BASH_REMATCH[1]}
	if((RX));then	R=\"$s${re+.*}$p\"
	elif((re));then	L=1;F=\"$s$p\";S=${s-~+}
	else	IS=$I;S=$s$p;R=.*;	[ -d "$S" ]||x_a=
	fi
fi
while [[ $S =~ $'\f'([]*?[]) ]];do S=${S/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"};done
while [[ $R =~ $'\f'([]*?[]) ]];do R=${R/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
P="\( -path '* *' -printf \"$dp$sz$tm'%p'\n\" -o -printf \"$dp$sz$tm%p\n\" \)"
PD="-type d \( -path '* *' -printf \"$dp$tm'%p/'\n\" -o -printf \"$dp$tm%p/\n\" \)"
((l)) &&{ [ "$lx" ]|| lh=-prune; PD="-type d $lh -exec find \{\} $lx $opt\( $PD -o $P \) \;";}
case $z in
/)	Z="$PD";;//)	Z="-type f $P";;///)	Z="\! -type d -executable $P";;
////)	Z="-type l \( -path '* *' -printf \"'%p' '%l'\n\" -o -printf \"%p %l\n\" \)";;
*)	Z="\( $PD -o $P \)"
esac
if [ $IS ]&&[ $S != / ];then	c=${S: -1};set +f;printf -v S "%q " ${S/$c/[$c]};set -f
else	S=\"${S:-/}\";: ${F=$S}
fi
((Rd))&&{	[[ `eval "find $F -printf \"%d\n\"|sort -nur"` =~ [1-9]+ ]];DM=${BASH_REMATCH[0]};}
((XF))||{	eval ${x_a+fx $F $x_a};(($?))&&return;XF=1;}
eval ${D+fd $F}
if((L)) ;then
	CL="find $po$S -regextype posix-extended $opt-${I}path $F/* $Rt ${X[@]-$Z}"${p:+" -o -${I}path $F -type f $P -o -${I}regex \".{${#s}}.+$p\" $opt\( $PD -o $P \)"}
else	CL="find $po$S -regextype posix-extended $Rt $opt-${I}regex $R ${X[@]-$Z}";fi

[ "$D$dtx" ]&&echo "${D+Depth option \"$Dt\" is${Rd+ '$D' depth from max $DM} of $F}${D+${dtx+ and }}${dtx+$dtx is of $F}">&2
LC_ALL=C
if((de)) &&[[ $z != / ]] ;then	export -f fid
	eval "$CL ! -type d -executable -exec /bin/bash -c 'fid \"\$0\" \"\$@\"' '{}' \;"
elif((if)) &&[[ $z != / ]] ;then eval "$CL ! -type d -exec /bin/bash -c '
		[[ \`file \"{}\"\` =~ ^[^:]+:\ *([^,]+$|[^,]+\ ([^,]+)) ]];echo \  \${BASH_REMATCH[1]}' \;"
#elif((Fc+Fp)) ;then
	#mkdir -pv $cp
	#for i in ${c[@]};{	eval "$CL -exec cp '{}' $i \;";}
else	command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done)	eval $CL
fi
}
}
set +f;unset IFS;} ##### ENDING OF l, find wrap script #####
