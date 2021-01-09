fxr(){ ##### BEGINNING OF l, find wrap script #####
local B a b e i p re r z R Z m=path
[[ $1 =~ ^\./ ]]||re=1;e=${1#./}
[[ $e =~ ^\.?\.?/ ]]&&{ echo Exclusion must not be upward/.. nor absolute path, it is relative to \'$S\'>&2;return 1;}
e=${e//$se/$'\n'}
IFS=$'\n';set -- $e
[[ $1 =~ ^(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[2]};p=/${BASH_REMATCH[1]}
B=${p%/*}
r=("${p##*/}$z" ${@:2})
(($#>1))&&p=$p$'\n'${e#*$'\n'}
p=${p//\/..\//$'\t/'}
p=${p//\{/\\\\\{};p=${p//\}/\\\\\}};p=${p//\(/\\\\\(};p=${p//\)/\\\\\)}
while [[ $p =~ ([^$'\f']|^)\? ]];do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"};done
while [[ $p =~ ([^$'\f']\[)! ]];do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"};done
p=${p//./\\\\.};p=${p//\//$'\v'}
p=${p//$'\v**\v'/$'\v(.\r/)?'}
p=${p//\*\*/.$'\r'}
while [[ $p =~ ([^$'\f']|^)\* ]];do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"[^/]$'\r'};done;p=${p//$'\r'/*}
b=${p%%$'\n'*}
p=${b##*$'\v'}$z${p#"$b"}
b=${b%$'\v'*}
set -- ${p:-\"\"};i=;for a;{
if((!RE))&& [[ $b$a =~ ([^$'\f']|^)[*[] ]];then
	[[ $b$'\v'$a =~ ^($'\t'*)$'\v'(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[3]}
	p=${BASH_REMATCH[2]};p=${p:+$'\v'$p}
	[[ ${BASH_REMATCH[1]} ]]&&{
		Z=${Z-$S}${BASH_REMATCH[1]};[[ $Z =~ ^$'\t'($'\v'|$) ]]&&{ eval $E;continue;}
		while [[ $Z =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do Z=${Z/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $Z =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	}
	while [[ $p =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	R=-${J}regex\ \"$Z${re+.*}${p//$'\v'/\/}\"
else
	[[ $B/${r[i++]} =~ ^((/\.\.)*)/(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[4]}
	p=${BASH_REMATCH[3]};p=${p:+/$p}
	[ ${BASH_REMATCH[1]} ]&&{
		Z=${Z-$S}${BASH_REMATCH[1]};[[ $Z =~ ^/\.\.(/|$) ]]&&{ eval $E:continue;}
		while [[ $Z =~ /[^/]+/\.\.(/|$) ]];do Z=${Z/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $Z =~ ^/\.\.(/|$) ]]&&eval $E2;done;}
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2;done
	((RE))&&m=regex
	R=-${J}$m\ \"$Z${re+${RE+.}*}$p\"
fi
case $z in /) z=-type\ d;;//) z=-type\ f;;///) z="\! -type d -executable";;////) z=-type\ l;esac
while [[ $R =~ $'\f'([]*?[]) ]];do R=${R/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
Rt="$z $R"
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
		x="${x/[mh]/min} ";x="${x/[dM]/time}"
		if((!a)) ;then	Rt="\( $f$x-$z -o $f$x$z \)"
		elif((!z)) ;then	Rt="\( $f$e+$a -o $f$e$a \)"
		else	Rt="\( $f$e+$a $f$x-$z -o $f$e$a -o $f$x$z \)";fi
	else	Rt=$f$e$a;fi
}
fsz(){	local d f a e z x
	d=${1:2};f='-size '
	a=${d%-*};e=${a##*[0-9]}
	: ${e:=k};e=${e//m/M};e=${e//g/G}
	a=${a%[cwbkmMgG]}
	if [[ $d = *-* ]] ;then
		z=${d#*-};x=${z#*[0-9]}
		: ${x:=k};x=${x/m/M};x=${x/g/G}
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
fx(){	local D F L G H x r Rt RE IFS S=$1;shift
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
		dtx="exclusion option \"$e\" is${Rd+ reversedly depth '$D' to max $DM,}";;
	-E|-re)	RE=1;;
	*)	[[ $e = -* ]]&&echo \'$e\': unrecognized exclusion option, it\'d be as an excluded path>&2
		((F))&&continue;F=1
		fxr "$e"	;(($?))&&return 1
		r=$r\ $Rt
esac
}
X=(${X[@]} "$r" '\(' ${F+-type d -prune -o }-true '\)' -o)
}
}
fid(){
	[[ `file "$1"` =~ ^[^:]+:\ *([^,]+$|[^,]+\ [^,]+) ]];echo -e " ${BASH_REMATCH[1]}\n DEPs"
	ldd "$1" 2>/dev/null |sed -E 's/^\s*([^>]+>\s*)?(.+)\s+\(0.+/  \2/'
}
l(){
unset IFS F RX xc co po opt se sz tm AX D Dt Rd DM dtx de if ld c cp;I=i
shopt -s nocaseglob;set -f;trap 'set +f;unset IFS' 1 2
for e;{
((F)) &&{	F=;((xc))||opt=$opt$e\ ;continue;}
case $e in
-cs) I=;;
-[cam][0-9]*|-[cam]-[0-9]*)	ftm $e;opt=$opt$Rt\ ;;
-[1-9]|-[1-9][-0-9.]*|-[1-9][r/]|-[1-9][-0-9.]*[r/])
	Dt=$e;D=${e:1};[[ ${e: -1} = [r/] ]]&&{	D=${D%?};Rd=1;};;
-s[0-9]|-s[0-9][-cwbkmMgG]*|-s[-0-9][0-9]*)	fsz $e;opt=$opt$Rt\ ;;
-s=?|-s=??) se=${e:5};;
-l|-l[0-9]|-l[1-9][0-9])	ld=1;n=${e:2}
	lx=-maxdepth\ ${n:=1};	((n))||lx=;;
-x=*|-xs=*|-xcs=*|-c=*|-cv=*|-cz=*|-czv=*);;
-exec|-execdir)xc=1;F=1;;
-z)	sz=\ %s;;
-E|-re) RX=1;;
-|--)	break;;
-rm)	AX=-delete;;
-s=*) echo "Separator must be 1 or 2 characters. Ignoring as it\'d default to \\">&2;;
-de)de=1;;
-in)if=1;;
-c)co=1;;
-ci)I=i;;
-t)	tm=" %Tr %Tx";;
-h|--help) man find;return;;
-[HDLPO]) po=$e\ ;;
-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	opt=$opt$e\ ;F=1;;
\!|-[ac-il-x]?*)
	if [[ $e =~ ^!|-(delete|depth|daystart|follow|fprint|fls|group|gid|o|xstype)$ ]];then opt=$opt$e' '
	else	read -n1 -p "Option '$e' seems unrecognized, ignore and continue? " k>&2;echo;[ "$k" = y ]||return;fi;;
-*)	echo \'$e\': unknown option, ignoring. To let it be a path name, put it after - or -- then space>&2
esac
}
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]];h=${BASH_REMATCH[1]}
while [[ $h =~ ([^\\]|\\\\)[\;\&|\>\<] ]];do	h=${h/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'};done
IFS=$'\n';set -- $h
unset IFS F L G K Fc Fp x_a x vb C M Rt X XF IS S
for c;{
	[[ $c =~ ^.+\ *\$\(\ *$FUNCNAME\ +(.*)\)|.+\ *\`\ *$FUNCNAME\ +(.*)\`|\ *$FUNCNAME\ +(.*) ]]&&{	
		c="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
		while [[ $c =~ ([^\\])\\([]*?[]) ]];do	c=${c/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\f'"${BASH_REMATCH[2]}"};done
		eval set -- $c;break;
	}
	set --
}
J=;for a;{	((S))&&{	S=;continue;}
	((!L)) &&{	case $a in
		-x=?*|-xs=?*|-xcs=?*)
			((Fc))&&{	echo -c or -cp option must be as the last>&2;return;}
			[ ${a:2:1} = = ]&&J=i
			x=${a#-x*=};[[ $x =~ ^-[1-9].*\.?[r/]$ ]]&&Rd=1
			x_a=$x_a\"$x\"' ';
			G=1;continue;;
		-c=?*|-cv=?*|-cz=*|-czv=?*)
			[ $K$AX ]&&{ S=${K+-exec/execdir};echo Cannot be both ${S:-$AX} and $a option;return;}
			C=${a#-c*=}
			[[ $a = -c*v= ]]&&vb=-v
			[ ${a:2:1} = z ]&&Fz=1;Fc=1
			((!F))&&{	echo -c or -cp option must be after main path name>&2;return;}
			break;; #continue;;
		-exec|-execdir)
			[ $Fc$AX ]&&{	S=${Fc+copy};echo Cannot be both ${S:-$AX} and $a option;return;}
			AX=\ $a;K=1;continue;;
		-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-exec|-execdir|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	S=1;;
		-|--)	L=1;continue;;
		-\!|-*)continue
	esac
	}
	a=\"$a\"			# l m -x=i o - -c=m n
	if((G));then
		if((F));then	x_a=$x_a$a\ ;else			M=$M$a\ ;fi
	#elif((Fc)) ;then
		#((!F))&&{	echo -c or -cp option must be after main path name>&2;return;}C=$C\"$a\"' '
	elif((K));then
		XC=$XC\ \"$a\"
	elif ((L));then
		if((F));then		M=$M$a
		else		M=$a;	x_a=$x_a$M
		fi;G=0
	else	M=$M$a\ ;F=1;fi
}
E="echo Path \'\$a\' is invalid, it\'d be up beyond root. Ignoring>&2";E2="{ $E;continue 2;}"	#E1="{ $E;break;}"
[ "${M//\*}" ]||M=;M=${M//\\/\\\\}
eval set -- ${M:-\"\"}
for e;{
unset F a b B p z r re s
if [ "${e:0:2}" = \\/ ];then	z=${e:2};s=/			# start with prefix \\, suggests root dir search
else
e=${e//${se='\\'}/$'\n'}
re=1;IFS=$'\n';set -- $e			# break down to paths of same base, separated by \\ or $se
for a;{									# fake 'For Loop' to apart of no path argument, once then breaks
[[ $a =~ ^(\./|.*[^/])?(/*)$ ]]
z=${BASH_REMATCH[2]}
a=${BASH_REMATCH[1]}
if [ "${a:0:1}" = / ];then re=;p=$a;[[ $p =~ ^/\.\.(/|$) ]]&&eval $E 2
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/\/};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2;done
else
	[[ $a =~ ^\.(/|$) ]]&&{ re=;a=${a#${BASH_REMATCH[0]}};}	# if . or prefixed by ./ needn't to insert .* search
	[[ /$a =~ ^((/\.\.)*)(/.+)?$ ]]
	p=${BASH_REMATCH[3]};s=~+
	[ ${BASH_REMATCH[1]} ]&&{	[ $s = / ]&&eval $E 2
		s=$s${BASH_REMATCH[1]}
		while [[ $s =~ /[^/]+/\.\.(/|$) ]];do	s=${s/"${BASH_REMATCH[0]}"/\/};[[ $s =~ ^/\.\.(/|$) ]]&&eval $E2;done
	}
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/\/}
		[[ $p =~ ^/\.\.(/|$) ]]&&{
			[[ $p =~ ^((/\.\.)*)(/.+)?$ ]]
			p=${BASH_REMATCH[3]}
			((re))||{	[ $s = / ]&&eval $E 2;	s=$s${BASH_REMATCH[1]}
				while [[ $s =~ /[^/]+/\.\.(/|$) ]];do	s=${s/"${BASH_REMATCH[0]}"/\/}
					[[ $s =~ ^/\.\.(/|$) ]]&&{ eval $E;return;}
				done;}
			break;}
	done		
	s=${s%/}
fi
p=${p%/}
B=${p%/*}					# common base dir. of names as literal is in B, they're in array
r=("${p##*/}$z" ${@:2})
(($#>1))&&p=$p$'\n'${e#*$'\n'}			# else the regex-converted array are put in p, delimited by \n...
p=${p//\/..\//$'\t/'}
p=${p//\{/\\\\\{};p=${p//\}/\\\\\}};p=${p//\(/\\\\\(};p=${p//\)/\\\\\)}
while [[ $p =~ ([^$'\f']|^)\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"};done
while [[ $p =~ ([^$'\f']\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"};done
p=${p//./\\\\.};p=${p//\//$'\v'}
p=${p//$'\v**\v'/$'\v(.\r/)?'}
p=${p//\*\*/.$'\r'}
while [[ $p =~ ([^$'\f']|^)\* ]];do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"[^/]$'\r'};done;p=${p//$'\r'/*}
b=${p%%$'\n'*}							# ... and common head/base dir. is b
p=${b##*$'\v'}$z${p#"$b"}
b=${b%$'\v'*}
break;}
fi
unset i L T Q U V dt;set -- ${p:-\"\"};for a;{
unset F N IS R S G
if((!RX))&& [[ $b$a =~ ([^$'\f']|^)[*[] ]];then L=$ld
	[[ $b$'\v'$a =~ ^($'\t'*)$'\v'(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[3]}
	p=${BASH_REMATCH[2]};p=${p:+$'\v'$p}
	[[ ${BASH_REMATCH[1]} ]]&&{
		S=$s${BASH_REMATCH[1]};[[ $S =~ ^$'\t'($'\v'|$) ]]&&{ eval $E;continue;}
		while [[ $S =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do S=${S/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $S =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	}
	while [[ $p =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	if((re));then	p=.*$p;S=$s
	else
		[[ $p =~ [^$'\f']([]*?[].*)$ ]];	S=${p%$'\v'*"${BASH_REMATCH[1]}"};	p=${p#$S}
		S=$s${S//$'\v'/\/}
		IS=$I
	fi
	R=\".{${#S}}${p//$'\v'/\/}\"
else
	[[ $B/${r[i++]} =~ ^((/\.\.)*)/(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[4]}
	p=${BASH_REMATCH[3]};p=${p:+/$p}
	[ ${BASH_REMATCH[1]} ]&&{
		S=$s${BASH_REMATCH[1]};[[ $S =~ ^/\.\.(/|$) ]]&&{ eval $E;continue;}
		while [[ $S =~ /[^/]+/\.\.(/|$) ]];do S=${S/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $S =~ ^/\.\.(/|$) ]]&&eval $E2;done;}
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2;done
	: ${S=${s-~+}}
	if((RX));then	L=$ld;R=\".{${#S}}${re+.*}$p\"
	elif((re));then	F=1;N=\"$S$p\";	G=$S$p
		while [[ $G =~ ([^\\]|^)\* ]];do G=${G/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}\*"};done;
	else	IS=$I;S=$s$p;R=.*
		[ -d "$S" ]||{	N=\'\';x_a=;}
	fi
fi
while [[ $S =~ $'\f'([]*?[]) ]];do S=${S/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"};done
while [[ $R =~ $'\f'([]*?[]) ]];do R=${R/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
P="\( -path '* *' -printf \"$dp'%p'$sz$tm\n\" -o -printf '$dp%p$sz$tm\n' \)"
PD="-type d \( -path '* *' -printf \"$dp$tm'%p/'\n\" -o -printf '$dp$tm%p/\n' \)"
((ld))&&PD="\( -type d -prune -exec find \{\} $lx \( $PD -o $P \) \; -o $P \)"
case $z in
/)	Z="$PD";;//)	Z="-type f $P";;///)	Z="\! -type d -executable $P";;
////)	Z="-type l \( -path '* *' -printf \"'%p' '%l'\n\" -o -printf \"%p %l\n\" \)";;
*)	Z="\( $PD -o $P \)"
esac
: ${N=\"$S\"}
[ $IS ]&&[ -d "${S%/}" ]&&{ c=${S: -1};set +f;printf -v S "%q" ${S/$c/[$c]};set -f;}

((Rd))&&{	[[ `eval "find $S -printf '%d\n'|sort -nur"` =~ [1-9]+ ]];DM=${BASH_REMATCH[0]};}
((XF))||{	eval ${x_a+fx $N $x_a};(($?))&&return;XF=1;}
eval ${D+fd $N}
[ "$D$dtx" ]&&echo "${D+Option \"$Dt\" is depth '$D'${Rd+ reversed from max $DM} of $N}${D+${dtx+ and }}${dtx+$dtx of $N}">&2
LC_ALL=C
if((Fc));then T="${T% $S} $S";Q="${Q% \! -ipath $S} \! -ipath $S";	U=$U${R:+\|$R};V=$V${G:+ -o -${I}path \"$G/*\"}
else
	if((F));then
		CL="find $po$S -regextype posix-extended $Rt $opt\( -${I}path \"$G/*\" \( ${X[@]} $Z \)${p:+" -o -${I}path \"$G\" -type f $P -o -${I}regex \".{${#s}}/.+$p\" \\( $PD -o $P \\)"} \)$AX"
	else
		CL="find $po$S \! -ipath $N -regextype posix-extended $opt$Rt -${I}regex $R \( ${X[@]} $Z \)$AX"
	fi
	if((de))&&[[ $z != / ]];then
		export -f fid;eval "$CL ! -type d -executable -exec /bin/bash -c 'fid \"\$0\" \"\$@\"' '{}' \;"
	elif((if))&&[[ $z != / ]];then
		eval "$CL ! -type d -exec /bin/bash -c '[[ \`file \"{}\"\` =~ ^[^:]+:\ *([^,]+$|[^,]+\ ([^,]+)) ]];echo \  \${BASH_REMATCH[1]}' \;"
	elif((co));then	command> >(x=;F=;IFS=/;while read -r l;do
		l=${l#?};l=${l%\'};((F=x=!F));m=${l: -1};: ${m:=/}
		for i in $l;{	((x=!x))&&c=||c=1\;36;echo -ne "\e[${c}m${i:+/$i}">&2;}
		echo -e "\e[41;1;33m${m%[!/]}\e[m">&2;done)	eval $CL
	else	command 2> >(while read s;do echo -e "\e[1;31m$s\e[m">&2;done) eval $CL;fi
fi
}
if((Fc));then
	if [ -d "$C" ];then read -n1 -p "Really to delete dir. \"$C\" and replace it with the found result? " o
		echo;[ "$o" = y ]||return;rm -r "$C"
	elif	[ -f "$C" ];then echo Trying to replace file $C>&2;rm $vb "$C"||{ echo Failed, try again as root>&2;};fi
	T=${T# };Q=${Q# };U=${U#\|};V=${V# -o }
	U=${U:+-${I}regex \"$U\"};V=${V:+$V}
	[[ `eval "find $po$T $opt$Rt \( -regextype posix-extended $U $V \) \( ${X[@]} -type d -printf '%d\n' \)|sort -nur"` =~ [1-9]+ ]]
	D=${BASH_REMATCH[0]}.;fd $T
	eval find "$po$T $Q $opt$Rt \( -regextype posix-extended $U $V \) ${X[@]} -type d -printf '%P\n' -exec mkdir -p$vb $C'{}' \;"

	#[[ $D =~ - ]]&&	D=${D%-*}
	#eval "find $po$T $opt$Rt \( -regextype posix-extended ${U:+-${I}regex \"$U\"} ${V:+$V} \) ${X[@]-$Z} -printf \"%P\n\" \( -type d -exec mkdir -p$vb "$C/\{\}" -o  -exec /bin/bash -c 'fcf \"\$0\" \"\$@\"' '{}' \;"
	
	#2>/dev/null
	#((Fz))&&	a='bsdtar -cf$vb $C \{\} \; ;cd $C;bsdtar -xf$vb $C' 
fi
}
set +f;unset IFS;} ##### ENDING OF l, find wrap script #####
