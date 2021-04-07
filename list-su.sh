fxr(){ ##### BEGINNING OF l, find wrap script #####
local a b e i p re r z Z R s m=regex IFS=$'\n'
[[ $1 =~ ^\./ ]]||re=1;e=${1#./}
[[ $e =~ ^\.?\.?/ ]]&&{ echo Exclusion cannot be absolute, or upward \(..\) path. It\d be relative to \'$S\'>&2;return 1;}
e=${e//$se/$'\n'};set -- $e
[[ $1 =~ ^(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[2]};p=/${BASH_REMATCH[1]}
a=${p%/*}
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
i=;set -- ${p:-\"\"};for e;{ 
if((!RE))&& [[ $b$e =~ ([^$'\f']|^)[*?[] ]];then
	[[ $b$'\v'$e =~ ^($'\t'*)$'\v'(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[3]}
	p=${BASH_REMATCH[2]};p=${p:+$'\v'$p}
	[ "${BASH_REMATCH[1]}" ]&&{
		Z=${Z-$S}${BASH_REMATCH[1]};[[ $Z =~ ^$'\t'($'\v'|$) ]]&&{ eval $E;continue;}
		while [[ $Z =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do Z=${Z/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $Z =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	}
	while [[ $p =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	R="$Z${re+.*}${p//$'\v'/\/}"
else
	[[ $a/${r[i++]} =~ ^((/\.\.)*)/(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[4]}
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
s=($s $z -${J}$m "$R" -o)
}
unset s[-1];Rt=(\( "${s[@]}" \))
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
unset F L G H r;for e;{ case $e in
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
		((F))||{ F=1
			fxr "$e"	;(($?))&&return 1
			r=(\! \( "${r[@]}" "${Rt[@]}" \));}
esac
};X=(${X[@]} "${r[@]}");}
}
fid(){
	[[ `file "$1"` =~ ^[^:]+:\ *[^,]*(symbolic|text|script$|pack( index)?$|^TDB) ]]&&return
	IFS=$'\n';for i in `ldd "$1"`;{
		[[ "$i" =~ ^[[:space:]]*([^>]+>\ *)?(.+)\ +\(0.+ ]] && echo -e "\t${BASH_REMATCH[2]}"
	}
}
l(){
	unset IFS D E EX EP F L G FC FM x_a M V X IS S J RM OL EM RX pt po opt se sz tm Dn DF Du DR DM dtx de if lx LD CH CO C1
	CR=r;CP=--parents;RL=1;I=i
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
((D)) &&{	if [ $pt ];then pt=$pt$e\ ;else	opt=(${opt[@]} $e);fi;D=;continue;}
((EX))&&{
	echo -exec use is not good relative to the far better xargs piping, trying to do..
	((Ex))&&E=$@;E=(-exec ${E#*-exec})
	((Ed))&&E=$@;E=(-execdir ${E#*-execdir});break;}
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
		-rm|-delete)RM=1;((EX)) && { echo cannot both rm and exec option;return;};;
		-exec)Ex=1;((EX=Ex+Ed));;
		-execdir)Ed=1;((EX=Ex+Ed));;
		-ls)E=(-ls "${E[@]}");;
		-s) sz=\ %s;;
		-l|-l[0-9]|-l[1-9][0-9])	LD=1;n=${e:2}
			((n)) ||: ${n:=1};
			((n)) && lx=-maxdepth\ $n;;
		-E|-re) RX=1;;
		-no|-0)
			if [ $e = -no ];then OL=1; else EM=1;fi;;
		-s=*) echo "Separator must be 1 or 2 characters. Ignoring, it defaults to \\">&2;;
		-de)de=1;;-i)if=1;;
		-cs)I=;;-co) co=1;;-ci)I=i;;
		-m) tm=\ %Tx;;
		-mh) tm=' %Tr %Tx';;
		-a) tm=\ %Ax;;
		-ah) tm=' %Ar %Ax';;
		-c) tm=\ %Cx;;
		-ch) tm=' %Cr %Cx';;
		-h|--help)man find;return;;
		-[HDLPO])po=$e;;
		-printf)pt=("${pt[@]}" "$e");D=1;;
		-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-ok|-inum|-mindepth|-maxdepth)	opt=(${opt[@]} $e);D=1;;
		\!|-d|-depth|-daystart|-follow|-fprint|-fls|-group|-gid|-o|-xstype) opt=(${opt[@]} $e);;
		-x=?*|-xi=?*)	((FC))&&{	echo copy option must be the last>&2;return;}
			[ ${e:2:1} = i ]&&J=i
			x=${e#-x*=};[[ $x =~ ^-[1-9].*\.?[r/]$ ]]&&Rd=1
			x_a=$x_a\ \"$x\"
			G=1;;
		-co=?*|-copt=?*)CO=${e#*=};;
		-caio)C1=1;;-cnr|-cnorec)CR=;;-chd=*|-cpd=*|-cpdir=*)CH=1;[[ $e =~ ^.+=(.*) ]];ch=${BASH_REMATCH[1]};;
		-c=?*)
			((!F))&&{	echo copy option must be after main search path, it must be the last argument>&2;return;}
			((RF+if+de))||((EX))&& { echo Cannot be both copy and removal, dependency, info, or exec option;return;}
			[[ $e =~ ^-c=(.*) ]];c=${BASH_REMATCH[1]}
			FC=1;L=1;;
		-rm|-delete|-exec|-execdir|-i|-de|-no|-0)(($FC))&&{	echo Cannot be both copy and $e option;return;};;
		-|--)	L=1;;
		-*)	echo -e "Unknown \e[1;33m$e\e[m option, as copy option it must be short, in one string if multiple. If it\'s a path name, put it after - or -- then space\n";read -n1 -p 'Ignore and continue (y for yes, else for no)? ' k;[ "$k" = y ]||return;;
	*)if((G));then			x_a=$x_a\ \"$e\";FC=
		elif((!F));then	M=\"$e\";F=1
		elif((FC));then	c=$c\ \"$e\";G=
		else			M=$M\ \"$e\";F=1;fi
	esac
	continue
	}
	a=\"$e\"
	if((G));then
		((FC))&&{	echo copy option must be the last argument>&2;return;}
		if((F));then	x_a=$x_a\ $a;else	M=$M$a\ ;fi
	elif((FC)) ;then	((!F))&&{	echo copy options must be after searched path name>&2;return;}
		case $e in
		-co=?*|-copt=?*)CO=${e#*=};;
		-caio)C1=1;;-cnr|-cnorec)CR=;;-chd=*|-cpd=*|-cpdir=*)CH=1;[[ $e =~ ^.+=(.*) ]];ch=${BASH_REMATCH[1]};;
		-caio)C1=1;;-cnr|-cnorec)CR=;;
		*)[ -e $a ] || echo $e not exist;return
			c=$c\ $a
		esac
	elif ((L));then
		if((F));then		M=$M\ $a
		else		M=$a;	x_a=$x_a\ $M
		fi;G=0
	else	M=$M\ $a;F=1;fi
}
E1="echo Path \'\$a\' is invalid, it goes up beyond root. Ignoring>&2";E2="{ $E1;continue 2;}"
((RF=RM+OL+EM))&&{	((EX))&&{ echo -exec cannot be with -rm, -no, -0 option;return;};po=;}
[ "${M//\*}" ]||M=
M=${M//\\/\\\\};eval set -- ${M:-\"\"}
for e;{
unset F T a b p r re s z;W=.
if [ "${e:0:2}" = \\/ ];then	z=${e:2};[ "$z" = *[!/]* ]&&return;s=/			# start with \\, means root dir search
else
re=1;T=1 # doT relative path on output and recursive initialized TRUE
e=${e//${se='\\'}/$'\n'}
IFS=$'\n';set -- $e			# break down to paths of same base, separated by \\ or $se
for a;{									# a fake loop to diffrentiate the with and without path argument, once then breaks
[[ $a =~ ^(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[2]}
a=${BASH_REMATCH[1]}
if [ "${a:0:1}" = / ];then	re=;T= # absolute is no doT relative It is, or . only, or...
	p=$a;[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/\/};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2;done
	T=
else
	[[ $a =~ ^\./|^\.$ ]]&&{	re= # .. any prefixed by ./, they needn't to be inserted with recursive .*
		a=${a#.};	[ "$a" ]|| W=[^/]
		a=${a#/};}
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
p=${p%/};a=${p%/*}					# if common base dir. of names is literal, it'd be a, they're as array r
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
i=;set -- ${p:-\"\"};for e;{
unset IFS F G LK IS PL Q P S B L Z
if((!RX))&& [[ $b$e =~ ([^$'\f']|^)[*?[] ]];then LK=$LD
	[[ $b$'\v'$e =~ ^($'\t'*)$'\v'(.*[^/])?(/*)$ ]]
	z=${BASH_REMATCH[3]}
	p=${BASH_REMATCH[2]};p=${p:+$'\v'$p}
	[ ${BASH_REMATCH[1]} ]&&{
		S=$s${BASH_REMATCH[1]};[[ $S =~ ^$'\t'($'\v'|$) ]]&&{ eval $E1;continue;}
		while [[ $S =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do S=${S/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $S =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	}
	while [[ $p =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	if((re));then	S=$s
	else	IS=$I
		[[ $p =~ [^$'\f']([][*?].*)$ ]]
		S=${p%$'\v'*"${BASH_REMATCH[1]}"};p=${p#$S}
		S=$s${S//$'\v'/\/};: ${S:=/}
	fi
	p=${p//$'\v'/\/};P=$p
else
	[[ $a/${r[i++]} =~ ^((/\.\.)*)/(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[4]}
	p=${BASH_REMATCH[3]};p=${p:+/$p}
	[ ${BASH_REMATCH[1]} ]&&{
		S=$s${BASH_REMATCH[1]};[[ $S =~ ^/\.\.(/|$) ]]&&{ eval $E1;continue;}
		while [[ $S =~ /[^/]+/\.\.(/|$) ]];do S=${S/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $S =~ ^/\.\.(/|$) ]]&&eval $E2;done;}
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2;done
	: ${S=${s-~+}}
	if((RX));then	LF=$LD;P=$p
	elif((re));then	F=1;Q=$S$p
	else
		S=$s$p;P=/$W*;W=;IS=$I;	[ -f "$S" ]&&{ P=.*;x_a=;Q=;}
	fi
fi
while [[ $S =~ $'\f'([]*?[]) ]];do S=${S/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"};done;[ -e "$S" ]||return
while [[ $P =~ $'\f'([]*?[]) ]];do P=${P/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
PT=(\( -path '* *' -printf "'%p'$sz$tm\n" -o -printf "%p$sz$tm\n" \))
PD=(-type d \( -path '* *' -printf "'%p/'$tm\n" -o -printf "%p$tm/\n" \))
PE=(\( "${PD[@]}" -o "${PT[@]}" \))
case $z in
/)	PS=("${PD[@]}");;//)	PS=(-type f "${PT[@]}");;
///)	PS=(! -type d -executable "${PD[@]}");;
////) PS=(-type l "${PT[@]}");PL=1;;*) PS=("${PE[@]}")
esac
PS=("${PS[@]}" "${pt[@]}")
LC_ALL=C
((LD)) &&{
	PS=(-type d -prune -exec find {} $lx "${PS[@]}" \; -o "${PT[@]}");PE=(${PS[@]})
	[ $z ]&&{ z=/;echo type selective suffix if used with -l option will always be / \(find directory only\);};}
[ "$S" = / ] ||{
	((F))||	R=".{${#S}}${re:+.*}($P)"
	[ $IS ] &&{ shopt -s nocaseglob;set +f;printf -vS %s "${S:0: -1}"[${S: -1}];set -f;}
	((T))&&((RL))&&{	S=.
		Q=.$p;R=.$p
		while [[ $R =~ $'\f'([]*?[]) ]];do R=${R/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
	}
}
Q=${Q-$S}
((DR))&&{	[[ `find $Q -printf '%d\n'|sort -nur` =~ [1-9]+ ]];DM=${BASH_REMATCH[0]};}
((V))||{	eval ${x_a:+fx $Q $x_a};(($?))&&return;V=1;}
((DF))&& [ "$Q" ]&&{
	fdt $Dn "$Q";opt=(${opt[@]} "${Rt[@]}")
}
[ "$Dn$dtx" ]&&echo "${Dn+Option \"-$Dn\" is depth $DF${Du:+ to $Du}${DR+ reversed from max $DM} of $Q}${Dn+${dtx+ and }}${dtx+$dtx of $Q}">&2
if((F));then
	A=($po "$S" ${opt[@]} \( -${I}path "$Q/*" "${X[@]}")
	B=(${p:+-o \! -type d -${I}path "$Q" "${PT[@]}" -o -${I}path "$S/*$p" "${PE[@]}"})
else
	A=($po "$S" ${opt[@]} -regextype posix-extended \( -${I}regex "$R" "${X[@]}")
fi
if((de));then	export -f fid;find "${A[@]}" "${PS[@]}" "${B[@]}" \) ! -type d -executable -exec bash -c 'fid "$0" "$@"' '{}' \;
elif((if));then	find "${A[@]}" "${PS[@]}" "${B[@]}" \) ! -type d -exec bash -c '[[ `file "{}"` =~ ^[^:]+:\ *([^,]+$|[^,]+\ ([^,]+)) ]];echo "   ${BASH_REMATCH[1]}"' \;
elif((co));then	> >(x=;F=;IFS=/;while read -r l;do
		l=${l#?};l=${l%\'};((F=x=!F));m=${l: -1};: ${m:=/}
		for i in $l;{	((x=!x))&&c=||c=1\;36;echo -ne "\e[${c}m${i:+/$i}">&2;}
		echo -e "\e[41;1;33m${m%[!/]}\e[m">&2;done)	sudo find $L "${A[@]}" "${PS[@]}" "${B[@]}" \) "${E[@]}"
else
	((RF))&&{
		((RM))&&2> >(while read s;do echo -e "\e[1;31m$s\e[m">&2;done) sudo find "${A[@]}" "${PS[@]}" "${B[@]}" \) "${E[@]}"
		((EM))&&	E=(-empty "${PE[@]}")
		((OL))&&{	E=(${E:+"${EM[@]}" -o }-type l \( -path '* *' -printf "'%p' -> '%l'\n" -o -printf "%p -> %l\n" \));L=-L;}
		if((F)) ;then	B=(-o -${I}path "$Q" -o -${I}path "$S/*$p" -o -${I}path "$S/*$p/*")
		else	A=("$S" -regextype posix-extended \( -${I}regex "$R${W:+$R(/.*)}?" "${X[@]}");fi
		unset PS
	}
	((RM))||2> >(while read s;do echo -e "\e[1;31m$s\e[m">&2;done) sudo find $L "${A[@]}" "${PS[@]}" "${B[@]}" \) "${E[@]}"
	((PL))&&{ echo;echo "Link resolution (in non-standard form to stderr, to keep it from piping):";sudo find $L "${A[@]}" "${B[@]}" \) -type l \( -path '* *' -printf "'%p' -> '%l'\n" -o -printf "%p -> %l\n" \)>&2;}
	if((RF));then
		sudo find $L "${A[@]}" "${PS[@]}" "${B[@]}" \) "${E[@]}"| read -rn1 ||{ echo Nothing was found and deleted>&2;return;}
		read -sN1 -p 'Remove the objects listed and all other objects under directories listed above (Enter: yes)? ' o>&2
		[ "$o" = $'\x0a' ]&&{
			((RM))||{	((EM))&&Z=-empty;	((OL))&&	Z="${Z+$Z -o }-type l";	Z=(\( $Z \));}
			sudo find $L "${A[@]}"  "${B[@]}" \) $Z -delete &&echo All deleted>&2;}
	elif((FC));then
		sudo find "${A[@]}" "${PS[@]}" "${B[@]}" \)|read -rn1 ||{ echo Nothing was found and copied>&2;return;}
		[ $CR ]&&D='and all other objects';[ $CR ]||D='but not any object'
		read -sN1 -p "Copy the objects listed $D under directories listed above into $c? (Enter: yes) " o>&2
		[ "$o" = $'\x0a' ]&&{	mkdir -p $c 2>/dev/null
		if((C1));then CP=;CR=
		elif((CH));then
			if [ "$ch" ];then
				if((T));then
					[ ${ch:0:1} = / ]&&{ echo "Starting parent directory '$ch' cannot be absolute due to relative path searching";return;}
					((F))&&P=$p
					P=${P#/};ch=${ch#./};h=${P#$ch}
					R=./$h
				else
					[ ${ch:0:1} = / ]||{ echo "Starting parent directory '$ch' cannot be relative due to absolute path searching";return;}
					h=${S#$ch};fi
				[ -e $ch ]&&((${#h}!=${#S}))||{ echo "Path '$ch' is not a valid or part of search directory path";return;}
				pushd $ch>/dev/null
				R=./${h#/}$P
			else
				pushd $S>/dev/null
			fi
			S=.
		fi
		if((F));then
			A=(\( -${I}path "$R/*" "${X[@]}")
			B=(${p:+-o \! -type d -${I}path "$R" "${PT[@]}" -o -${I}path "$S/*$p" "${PE[@]}"})
		else
			A=(-regextype posix-extended \( -${I}regex "$R" "${X[@]}")
		fi
		2> >(while read s;do [[ $s =~ cp:\ -r\ not\ spe ]]||echo -e "\e[1;31m$s\e[m">&2;done) sudo find $po "$S" ${opt[@]} "${A[@]}" "${PS[@]}" "${B[@]}" \) | xargs -i cp $CO $CP -$CR '{}' $c		
		((CH))&&popd
		}
	fi
fi
};};set +f;} ##### ENDING OF l, find wrap script #####
