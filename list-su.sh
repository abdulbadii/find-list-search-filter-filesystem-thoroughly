fxr(){ ##### BEGINNING OF l, find wrap script #####
local IFS B a b e i p re r z Z Re R m=regex IFS=$'\n'
[[ $1 =~ ^\./ ]]||re=1;e=${1#./}
[[ $e =~ ^\.?\.?/ ]]&&{ echo Exclusion cannot be absolute, or upward .., path. It is relative to \'$S\'>&2;return 1;}
e=${e//$se/$'\n'};set -- $e
[[ $1 =~ ^(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[2]};p=/${BASH_REMATCH[1]}
B=${p%/*}
r=("${p##*/}$z" ${@:2})
(($#>1))&&p=$p$'\n'${e#*$'\n'}
p=${p//\/..\//$'\t/'}
p=${p//\{/\\\\\{};p=${p//\}/\\\\\}};p=${p//\(/\\\\\(};p=${p//\)/\\\\\)}
while [[ $p =~ ([^$'\f']|^)\? ]];do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"};done
while [[ $p =~ ([^$'\f']\[)! ]];do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"};done
p=${p//./\\.};p=${p//\//$'\v'}
p=${p//$'\v**\v'/$'\v(.\r/)?'}
p=${p//\*\*/.$'\r'}
while [[ $p =~ ([^$'\f']|^)\* ]];do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"[^/]$'\r'};done;p=${p//$'\r'/*}
b=${p%%$'\n'*}
p=${b##*$'\v'}$z${p#"$b"}
b=${b%$'\v'*}
E1="echo Path \'\$a\' is invalid, it\'d be up beyond root. Ignoring>&2";E2="{ $E1;continue 2;}"
i=;set -- ${p:-\"\"};for a;{ 
if((!RE))&& [[ $b$a =~ ([^$'\f']|^)[*?[] ]];then
	[[ $b$'\v'$a =~ ^($'\t'*)$'\v'(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[3]}
	p=${BASH_REMATCH[2]};p=${p:+$'\v'$p}
	[ "${BASH_REMATCH[1]}" ]&&{
		Z=${Z-$S}${BASH_REMATCH[1]};[[ $Z =~ ^$'\t'($'\v'|$) ]]&&{ eval $E;continue;}
		while [[ $Z =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do Z=${Z/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $Z =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	}
	while [[ $p =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	R="$Z${re+.*}${p//$'\v'/\/}"
else
	[[ $B/${r[i++]} =~ ^((/\.\.)*)/(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[4]}
	p=${BASH_REMATCH[3]};p=${p:+/$p}
	[ "${BASH_REMATCH[1]}" ]&&{
		Z=${Z-$S}${BASH_REMATCH[1]};[[ $Z =~ ^/\.\.(/|$) ]]&&{ eval $E:continue;}
		while [[ $Z =~ /[^/]+/\.\.(/|$) ]];do Z=${Z/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $Z =~ ^/\.\.(/|$) ]]&&eval $E2;done;}
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2;done
	((RE)) ||m=path
	R="$Z${re+${RE+.}*}$p"
fi
case $z in /) z=-type\ d;;//) z=-type\ f;;///) z="\! -type d -executable";;////) z=-type\ l;esac
while [[ $R =~ $'\f'([]*?[]) ]];do R=${R/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
unset IFS
Re=(${Re+"${Re[@]}" -o} $z -${J}$m "$R")
}
Rt=(\( "${Re[@]}" \))
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
		[ $x = h ]&&let z*=60; [ $x = M ]&&let z*=30
		x="${x/[mh]/min}";x="${x/[dM]/time}"
		if((!a)) ;then	Rt=(\( $f$x -$z -o $f$x $z \))
		elif((!z)) ;then	Rt=(\( $f$e +$a -o $f$e $a \))
		else	Rt=(\( $f$e +$a $f$x -$z -o $f$e $a -o $f$x $z \));fi
	else	Rt=($f$e $a);fi
}
fsz(){	local d f a e z x
	d=${1:2};f='-size'
	a=${d%-*};e=${a##*[0-9]}
	: ${e:=k};e=${e//m/M};e=${e//g/G}
	a=${a%[cwbkmMgG]}
	if [[ $d = *-* ]] ;then
		z=${d#*-};x=${z##*[0-9]}
		: ${x:=k};x=${x/m/M};x=${x/g/G}
		z=${z%[cwbkmMgG]}
		if((!a)) ;then	Rt=(\( $f -$z$x -o $f $z$x \))
		elif((!z)) ;then	Rt=(\( $f +$a$e -o $f $a$e \))
		else	Rt=(\( $f +$a$e $f -$z$x -o $f $a$e -o $f $z$x \));fi
	else	Rt=($f $a$e);fi
}
fdt(){	local a e A E
	E=${1#*-}
	if [[ $1 =~ - ]];then	A=${1%-*}
	elif [[ $1 = *. ]];then	E=${1%.};A=$E;fi
	if((Rd));then
		a=\ $(eval echo {1..$((DM-A+1))})
		a=${a// ?[! ]/ .};a=${a// ?/\/*}/*
		e=\ $(eval echo {1..$((DM-E+1))})
		e=${e// ?[! ]/ .};e=${e// ?/\/*}
		Rt=(${E+-${I}path ${2-$S}$e}${A:+ ! -${I}path ${2-$S}$a})
	else
		a=\ $(eval echo {1..$A})
		a=${a// ?[! ]/ .};a=${a// ?/\/*}
		e=\ $(eval echo {1..$E})
		e=${e// ?[! ]/ .};e=${e// ?/\/*}/*
		Rt=(${A+-${I}path "${2-$S}$a"}${E:+ ! -${I}path "${2-$S}$e"})
	fi
}
fx(){	local D F L G H x r Rt RE S=$1;shift
for a;{
eval set -- \"$a\"
unset F L G H r;for e;{
case $e in
	-[cam][0-9]*|-[cam]-[0-9]*)	((L))&&continue;L=1
		ftm $e;r=$Rt\ $r;;
	-s[0-9]|-s[0-9][-cwbkMG]*|-s[-0-9][0-9]*)	((G))&&continue;G=1
		fsz $e;	r=("${Rt[@]}" "${r[@]}");;
	-[1-9]|-[1-9][0-9]|-[1-9][-0-9.]*|-[1-9][r/]|-[1-9][-0-9.]*[r/])
		((H))&&continue;H=1
		D=${e:1};[[ $e =~ [r/]$ ]]&&{	D=${D%?};Rd=1;}
		fdt $D;	r=("${Rt[@]}" "${r[@]}")
		dtx="exclusion option \"$e\" is${DR+ reversed depth '$D' from max $DM,}";;
	-E|-re)	RE=1;;
	*)	[[ $e = -* ]]&&echo \'$e\': unrecognized exclusion option, it\'d be as an excluded path>&2
		((F))&&continue;F=1
		fxr "$e"	;(($?))&&return 1
		r=("${r[@]}" "${Rt[@]}")
esac
}
X=(${X[@]} "${r[@]}" \( ${F+-type d -prune -o }-true \) -o)
}
}
fid(){
	[[ `file "$1"` =~ ^[^:]+:\ *[^,]*(symbolic|text|script$|pack( index)?$|^TDB) ]]&&return
	IFS=$'\n';for i in `ldd "$1"`;{
		[[ "$i" =~ ^[[:space:]]*([^>]+>\ *)?(.+)\ +\(0.+ ]] && echo -e "\t${BASH_REMATCH[2]}"
	}
}
l(){	unset IFS D E F L G FC FM x_a M V X IS S J EM OL RM RX EP pt co po opt se sz tm Dn DF Du DR DM dtx de if lx LD CN;RL=1;I=i
set -f;trap 'set +f;unset IFS' 1 2
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]];h=${BASH_REMATCH[1]}
while [[ $h =~ ([^\\]|\\\\)[\;\&|\>\<] ]];do	h=${h/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'};done
IFS=$'\n';set -- $h
for c;{
	[[ $c =~ ^.+\ *\$\(\ *$FUNCNAME[[:space:]]+(.*)\)|.+[[:space:]]*\`[[:space:]]*$FUNCNAME[[:space:]]+(.*)\`|$FUNCNAME[[:space:]]+(.+) ]]&&{	
		c="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
		while [[ $c =~ ([^\\])\\([]*?[]) ]];do	c=${c/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\f'"${BASH_REMATCH[2]}"};done
		eval set -- $c;break;
	}
	set --
}
for e;{
((D)) &&{	if [ $p ];then pt=$pt$e\ ;else	opt=$opt$e\ ;fi;D=;continue;}
((EP))&&{ $E=$E$e\ ;EP=;continue;}
((!L)) &&{
	case $e in
		-[mca][0-9]*|-[mca]-[0-9]*)	ftm $e;opt=(${opt[@]} ${Rt[@]});;
		-[1-9]|-[1-9][-0-9.]*|-[1-9][r/]|-[1-9][-0-9.]*[r/])	Dn=${e:1}
			[[ ${e: -1} = [r/] ]]&&{	Dn=${Dn%?};DR=1;}
			DF=${Dn%-*};Du=${Dn#*-}
			if((!Du)) ;then Du='the max depth'
			elif((Du==DF)) ;then Du=;fi;;
		-s[0-9]|-s[0-9][-cwbkmMgG]*|-s[-0-9][0-9]*)	fsz $e;opt=(${opt[@]} ${Rt[@]});;
		-s=?|-s=??) se=${e:5};;
		-aa)RL=;;
		-rm|-delete)RM=1
			((EP)) && { echo cannot both rm and exec option;return;};;
		-exec|-execdir)
			((RM+OL+EM)) && { echo cannot both -exec and -rm, -no or -0 option;return;}
			E=$E$e\ ;EP=1;;
		-ls) E=-ls\ $E;;
		-s) sz=\ %s;;
		-l|-l[0-9]|-l[1-9][0-9])	LD=1;n=${e:2}
			((n)) ||: ${n:=1};
			((n)) && lx=-maxdepth\ $n;;
		-E|-re) RX=1;;
		-no)OL=1
			((EP)) && { echo cannot both -no and exec option;return;};;
		-0)EM=1
			((EP)) && { echo cannot both -0 and exec option;return;};;
		-s=*) echo "Separator must be 1 or 2 characters. Ignoring, it defaults to \\">&2;;
		-de)de=1;;-i)if=1;;
		-cs)I=;;
		-co) co=1;;-ci)I=i;;
		-m) tm=\ %Tx;;
		-mh) tm=' %Tr %Tx';;
		-a) tm=\ %Ax;;
		-ah) tm=' %Ar %Ax';;
		-c) tm=\ %Cx;;
		-ch) tm=' %Cr %Cx';;
		-h|--help)man find&return;;
		-[HDLPO])po=$e;;
		-printf)pt=("${pt[@]}" "$e");D=1;;
		-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	opt=(${opt[@]} $e);D=1;;
		\!|-d|-depth|-daystart|-follow|-fprint|-fls|-group|-gid|-o|-xstype) opt=(${opt[@]} $e);;
		-x=?*|-xs=?*)	((Fc))&&{	echo -c or -cp option must be the last>&2;return;}
			[ ${e:2:1} = = ]&&J=i
			x=${e#-x*=};[[ $x =~ ^-[1-9].*\.?[r/]$ ]]&&Rd=1
			x_a=$x_a\"$x\"' ';
			G=1;;
		-c=?*|-cnd=?*|-ch=*|-cto=?*) #|-m=?*|-mto=?*)
			((EP+RM+if+de+OL+EM))&& { echo Cannot be both copy and removal, dependency, info, or $E option;return;}
			((!F))&&{	echo -c or -cp option must be after main path name and the last argument>&2;return;}
			if [[ $e =~ ^-ch=(.*) ]];then ch=${BASH_REMATCH[1]};CH=1
			elif [[ $e =~ ^-cnd ]];then CN=1
			elif [[ $e =~ ^-cto=(.*) ]];then co=${BASH_REMATCH[1]} ]];CO=1
			fi;FC=1
			break;;
		-rm|-delete|-exec|-execdir|-i|-de|-no|-0)(($Fc))&&{	echo Cannot be both copy and $e option;return;};;
		-|--)	L=1;;
		-*)	echo -e "\e[1;33m$e\e[m unknown option, if it\'d be a path name, put it after - or -- then space. ";read -n1 -p 'Ignore and continue (y for yes, else for no)? ' k;[ "$k" = y ]||return;;

		*) M=$M\ \"$e\";F=1
	esac
	continue
	}
	a=\"$e\"
	if((G));then	if((F));then	x_a=$x_a$a\ ;else	M=$M$a\ ;fi
	elif((Fc)) ;then
		((!F))&&{	echo -c or -cp option must be after searched path name>&2;return;};CP=$CP$a' '
	elif ((L));then
		if((F));then		M=$M\ $a
		else		M=$a;	x_a=$x_a\ $M
		fi;G=0
	else	M=$M$a\ ;F=1;fi
}

M=${M//\\/\\\\};eval set -- ${M:-\"\"}
for e;{
unset F T W a b B p z r re s
if [ "${e:0:2}" = \\/ ];then	z=${e:2};[ "$z" = *[!/]* ]&&return;s=/			# start with \\, means root dir search
else
T=1;re=1
e=${e//${se='\\'}/$'\n'}
IFS=$'\n';set -- $e			# break down to paths of same base, separated by \\ or $se
for a;{									# a fake loop to diffrentiate the with and without path argument, once then breaks
[[ $a =~ ^(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[2]}
a=${BASH_REMATCH[1]}
if [ "${a:0:1}" = / ];then	re= #			if absolute or...
	p=$a;[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/\/};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2;done
	T=
else
	[[ $a =~ ^\./|^\.$ ]]&&{	re= # .. only . or prefixed by ./ then needn't to insert recursive .*
		a=${a#.};	[ "$a" ]|| W=[^/];	a=${a#/};}
	[[ /$a =~ ^((/\.\.)*)(/.+)?$ ]]
	p=${BASH_REMATCH[3]};s=~+
	[ ${BASH_REMATCH[1]} ]&&	{	T=
		[ $s = / ]&&eval $E2
		s=$s${BASH_REMATCH[1]}
		while [[ $s =~ /[^/]+/\.\.(/|$) ]];do	s=${s/"${BASH_REMATCH[0]}"/\/};[[ $s =~ ^/\.\.(/|$) ]]&&eval $E2;done
	}
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/\/}
		[[ $p =~ ^((/\.\.)+)(/.+)?$ ]] &&{	p=${BASH_REMATCH[3]}
		((re))||	{	T=
			[ $s = / ]&&eval $E2
			s=$s${BASH_REMATCH[1]}
			while [[ $s =~ /[^/]+/\.\.(/|$) ]];do
				s=${s/"${BASH_REMATCH[0]}"/\/}; [[ $s =~ ^/\.\.(/|$) ]]&&{ eval $E1;return;};done
		};break;}
	done
	s=${s%/}
fi	
p=${p%/};B=${p%/*}					# if common base dir. of names is literal, it'd be in B, they're as array
r=("${p##*/}$z" ${@:2})
(($#>1))&&p=$p$'\n'${e#*$'\n'}			# else the regex-converted array are put in p, delimited by \n...
p=${p//\/..\//$'\t/'}
p=${p//\{/\\\\\{};p=${p//\}/\\\\\}};p=${p//\(/\\\\\(};p=${p//\)/\\\\\)}
while [[ $p =~ ([^$'\f']|^)\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"};done
while [[ $p =~ ([^$'\f']\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"};done
p=${p//./\\.};p=${p//\//$'\v'}
p=${p//$'\v**\v'/$'\v(.\r/)?'}
p=${p//\*\*/$'.\r'}
while [[ $p =~ ([^$'\f']|^)\* ]];do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"[^/]$'\r'};done;p=${p//$'\r'/*}
b=${p%%$'\n'*}							# ... and common head/base dir. is b
p=${b##*$'\v'}$z${p#"$b"}
b=${b%$'\v'*}
break;}
fi
i=;set -- ${p:-\"\"};for a;{
unset IFS F LK IS G Q R S xs C L Z
if((!RX))&& [[ $b$a =~ ([^$'\f']|^)[*?[] ]];then LK=$LD
	[[ $b$'\v'$a =~ ^($'\t'*)$'\v'(.*[^/])?(/*)$ ]]
	z=${BASH_REMATCH[3]}
	p=${BASH_REMATCH[2]};p=${p:+$'\v'$p}
	[ ${BASH_REMATCH[1]} ]&&{
		S=$s${BASH_REMATCH[1]};[[ $S =~ ^$'\t'($'\v'|$) ]]&&{ eval $E1;continue;}
		while [[ $S =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do S=${S/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $S =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	}
	while [[ $p =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	if((re));then	p=.*$p;S=$s
	else	IS=$I
		[[ $p =~ [^$'\f']([][*?].*)$ ]]
		S=${p%$'\v'*"${BASH_REMATCH[1]}"};p=${p#$S}
		S=$s${S//$'\v'/\/};: ${S:=/}
	fi
	p=${p//$'\v'/\/};R=$p
else
	[[ $B/${r[i++]} =~ ^((/\.\.)*)/(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[4]}
	p=${BASH_REMATCH[3]};p=${p:+/$p}
	[ ${BASH_REMATCH[1]} ]&&{
		S=$s${BASH_REMATCH[1]};[[ $S =~ ^/\.\.(/|$) ]]&&{ eval $E1;continue;}
		while [[ $S =~ /[^/]+/\.\.(/|$) ]];do S=${S/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $S =~ ^/\.\.(/|$) ]]&&eval $E2;done;}
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2;done
	: ${S=${s-~+}}
	if((RX));then	LF=$LD;R=${re+.*}$p
	elif((re));then	F=1;Q=$S$p;	R=$Q/*
	else	S=$s$p
		[ -e "$S" ]||return;		IS=$I;R=/${W-.}*;p=$R;	[ -f "$S" ]&&{ R=.*;x_a=;Q=;}
	fi
fi
while [[ $S =~ $'\f'([]*?[]) ]];do S=${S/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"};done
while [[ $R =~ $'\f'([]*?[]) ]];do R=${R/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
LC_ALL=C
PT=(\( -path '* *' -printf "'%p'$sz$tm\n" -o -printf "%p$sz$tm\n" \))
PD=(-type d \( -path '* *' -printf "'%p/'$tm\n" -o -printf "%p$tm/\n" \))
PE=(\( "${PD[@]}" -o "${PT[@]}" \))
case $z in
/)	P=("${PD[@]}");;//)	P=(-type f "${PT[@]}");;
///)	P=(! -type d -executable "${PD[@]}");;
////) P=(-type l "${PT[@]}");;*) P=("${PE[@]}")
esac
P=("${P[@]}" "${pt[@]}")
((LD)) &&{
	P=(-type d -prune -exec find {} $lx "${P[@]}" \; -o "${PL[@]}" -o "${PT[@]}");PE=(${P[@]})
	[ $z ]&&{ z=/;echo type selective suffix if used with -l option will always be / \(find directory only\);};}
[ "$S" = / ] ||{
	((F)) ||	R=.{${#S}}$R
	[ $IS ] &&{ shopt -s nocaseglob;set +f;	printf -vS %s "${S:0: -1}"[${S: -1}];set -f;}
}
Q=${Q-$S}
((DR))&&{	[[ `find $Q -printf '%d\n'|sort -nur` =~ [1-9]+ ]];DM=${BASH_REMATCH[0]};}
((T))&&((RL))&&{
	S=.;R=.$p${F+/*}
	while [[ $R =~ $'\f'([]*?[]) ]];do R=${R/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
	Q=.${F+$p}
}
((V))||{	eval ${x_a:+fx $Q $x_a};(($?))&&return;V=1;}
((DF))&& [ "$Q" ]&&{
	fdt $Dn "$Q";opt=(${opt[@]} "${Rt[@]}")
}
[ "$Dn$dtx" ]&&echo "${Dn+Option \"-$Dn\" is depth $DF${Du:+ to $Du}${DR+ reversed from max $DM} of $Q}${Dn+${dtx+ and }}${dtx+$dtx of $Q}">&2
B=(\( "${X[@]}" "${P[@]}" \))
if((F));then	A=($po "$S" ${opt[@]} \( -${I}path);C=(${p:+-o \! -type d -${I}path "$Q" "${PT[@]}" -o -${I}path "$S/*$p" "${PE[@]}"})
else
	((RM))||xs=(\! -ipath "$Q");	A=($po "$S" "${xs[@]}" ${opt[@]} -regextype posix-extended \( -${I}regex)
fi
if((de));then	export -f fid;find "${A[@]}" "$R" "${B[@]}" "${C[@]}" \) ! -type d -executable -exec bash -c 'fid "$0" "$@"' '{}' \;
elif((if));then	find "${A[@]}" "$R" "${B[@]}" "${C[@]}" \) ! -type d -exec bash -c '[[ `file "{}"` =~ ^[^:]+:\ *([^,]+$|[^,]+\ ([^,]+)) ]];echo "   ${BASH_REMATCH[1]}"' \;
elif((co));then	> >(x=;F=;IFS=/;while read -r l;do
		l=${l#?};l=${l%\'};((F=x=!F));m=${l: -1};: ${m:=/}
		for i in $l;{	((x=!x))&&c=||c=1\;36;echo -ne "\e[${c}m${i:+/$i}">&2;}
		echo -e "\e[41;1;33m${m%[!/]}\e[m">&2;done)	sudo find $L "${A[@]}" "$R" "${B[@]}" "${C[@]}" \) $E
else
	((RM+OL+EM))&&{
		((RM))&&2> >(while read s;do echo -e "\e[1;31m$s\e[m">&2;done) sudo find "${A[@]}" "$R" "${B[@]}" "${C[@]}" \) $E
		((EM))&& E=(-empty ${PE[@]})
		((OL))&&{ L=-L;E=(${E:+"${E[@]}" -o }-type l "${PL[@]}");}
		unset B
		if((F)) ;then	C=(-o -${I}path "$Q" -o -${I}path "$S/*$p" -o -${I}path "$S/*$p/*")
		else			R="$R(/.*)?";fi
	}
	((RM))||2> >(while read s;do echo -e "\e[1;31m$s\e[m">&2;done) sudo find "${A[@]}" "$R" "${B[@]}" "${C[@]}" \) $E
	sudo find "${A[@]}" "$R" \( "${X[@]}" -true \) -o \! -type d -${I}path "$Q" -o -${I}path "$S/*$p" \) -type l \( -path '* *' -printf "'%p' -> '%l'\n" -o -printf "%p -> %l\n" \)>&2
	if((RM+OL+EM));then
		sudo find $L "${A[@]}" "$R" "${B[@]}" "${C[@]}" \) $E| read -rn1 ||{ echo Nothing was found and deleted>&2;return;}
		read -sN1 -p 'Remove the objects listed and all other objects under directories listed above (Enter: yes)? ' o>&2
		[ "$o" = $'\x0a' ]&&{
			((RM))	||{
				((EM))&&	Z=-empty;	((OL))&&	Z="${Z+$Z -o }-type l";	Z=(\( $Z \));}
			sudo find $L $A "$R" "${B[@]}" ${C[@]} \) $Z -delete &&echo All deleted>&2
		}
	#elif((Fc));then
		#sudo find $L "${A[@]}" "$R" "${B[@]}" "${C[@]}" \)|read -rn1 ||{ echo Nothing was found and copied>&2;return;}
		#D='and all other objects';((CN))&&D='but not the object'
		#read -sN1 -p 'Copy the objects listed $D under directories listed above (Enter: yes)? ' o>&2
		#[ "$o" = $'\x0a' ]&&{
		#mkdir -p $ct 2>/dev/null2
		#if(($CH)) ;then
			#[ "$CH" ]&&
				#A+=([1]=$CH) 
			#sudo find $A "$R" "${B[@]}" ${C[@]} \) |xargs -i cp --parents -r '{}' $ct

		#else
			#sudo find $A "$R" "${B[@]}" ${C[@]} \) |xargs -i cp --parents -r '{}' $ct
			#[ "$ch" ]&& popd &&echo All copied>&2
		#fi;}
	fi
	echo
fi
};};set +f;} ##### ENDING OF l, find wrap script #####
