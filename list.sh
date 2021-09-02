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
			r=("${r[@]}" "${Rt[@]}");}
esac
r=(\! \( "${r[@]}" \))
}
X=(${X[@]} "${r[@]}");}
}
fid(){
	[[ `file "$1"` =~ ^[^:]+:\ *[^,]*(symbol|text|script$|pack( index)?$|^TDB) ]]&&return
	IFS=$'\n';for i in `ldd "$1"`;{
		[[ "$i" =~ ^[[:space:]]*([^>]+>\ *)?(.+)\ +\(0.+ ]] && echo -e "\t${BASH_REMATCH[2]}";}
}
l(){
unset IFS F L G E EX EP P M x_a V X IS J S Q RX D Dl Du DF DR DM co pt po opt se sz s dtx de if lx LD Z RM OL EM C C1 CT CM MV c ch mh
CR=-r;CO=--preserve=all;CP=--parents;RL=1;I=i
shopt -s nocaseglob;set -f;trap 'set +f;unset IFS' 1 2
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]];h=${BASH_REMATCH[1]}
while [[ $h =~ ([^\\]|\\\\)[\;\&|\>\<] ]];do	h=${h/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'};done
IFS=$'\n';set -- $h
for a;{
	[[ $a =~ ^.+\ *\$\(\ *$FUNCNAME[[:space:]]+(.*)\)|.+[[:space:]]*\`[[:space:]]*$FUNCNAME[[:space:]]+(.*)\`|$FUNCNAME[[:space:]]+(.+) ]]&&{	
		a="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
		while [[ $a =~ ([^\\])\\([]*?[]) ]];do	a=${a/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\f'"${BASH_REMATCH[2]}"};done
		eval set -- $a;break;
	}
	set --
}
for e;{
((P)) &&{	if [ $pt ];then pt=$pt$e\ ;else	opt=(${opt[@]} $e);fi;D=;continue;}
((EX))&&{ echo -exec use is discouraged, mind on better xargs pipe, executing it anyway..
	E=$@;	((Ex))&&E=(-exec ${E#*-exec});	((Ed))&&E=(-execdir ${E#*-execdir});L=1;}
((!L)) &&{
	case $e in
		-[mca][0-9]*|-[mca]-[0-9]*)	ftm $e;opt=(${opt[@]} ${Rt[@]});;
		-[1-9]|-[1-9][-0-9.]*|-[1-9][r/])D=${e:1}
			[[ ${e: -1} = [r/] ]]&&{	D=${D%?};DR=1;};;
		-s[0-9]|-s[0-9][-cwbkmMgG]*|-s[-0-9][0-9]*)	fsz $e;opt=(${opt[@]} ${Rt[@]});;
		-s=*|-sep=*) se=${e#*=}
			[ $se ]||echo "Separator must be 1 or 2 characters. Ignoring, it defaults to \\">&2;;
		-aa)RL=;;-ls)E=(-ls "${E[@]}");;
		-l|-l[0-9]|-l[1-9][0-9])	LD=1;n=${e:2}
			((n)) ||: ${n:=1};
			((n)) && lx=-maxdepth\ $n;;
		-de)de=1;;-i)if=1;;-cs)I=;;-co)co=1;;-ci)I=i;;
		-s) Z=$Z\ %s;;
		-m) Z=\ %Tx$Z;;-mh) Z=\ %Tr\ %Tx$Z;;
		-a) Z=\ %Ax$Z;;-ah) Z=\ %Ar\ %Ax$Z;;
		-c) Z=\ %Cx$Z;;-ch) Z=\ %Cr\ %Cx$Z;;
		-E|-re)RX=1;;-no)OL=1;;-0)EM=1;;
		-[HDLPO])po=$e;;-printf)pt=("${pt[@]}" "$e");D=1;;
		-h|--help)man find;return;;
		-[HDLPO])po=$e;;
		-printf)pt=("${pt[@]}" "$e");D=1;;
		-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-ok|-inum|-mindepth|-maxdepth)	opt=(${opt[@]} $e);P=1;;
		-exec)Ex=1;((EX=Ex+Ed));;-execdir)Ed=1;((EX=Ex+Ed));;
		\!|-d|-depth|-daystart|-follow|-fprint|-fls|-group|-gid|-o|-xstype) opt=(${opt[@]} $e);;
		-rm|-delete|-exec|-execdir|-i|-de|-no|-0)
			((CM))&&{	echo Cannot be both copy or move and $e option;return;}
			[[ $e =~ ^-rm|^-del ]]&&RM=1;;
		-x=?*|-xi=?*)((G))&&{ echo Must be just one -x=;return;}
			((CM))&&{	echo copy option must be the last argument>&2;return;}
			[ ${e:2:1} = i ]&&J=i
			x_a=\"${e#-x*=}\";[[ $x_a =~ ^-[1-9].*\.?[r/]$ ]]&&Rd=1;G=1;;
		-m=?*|-mio=?*)
			((RM+C))&&{ echo Cannot be both copy or remove, and $e option;return;}
			((F))||{	echo move option must be after main search path, it must be the last>&2;return;}
			[[ $e = -mio* ]]&&M1=1;	c=\"${e#*=}\";((L=CM=MV=1));;
		-mhd=*|-mpd=*|-mpdir=*)MH=1;[[ $e =~ ^.+=(.*[^/]?)/* ]];mh=${BASH_REMATCH[1]};;
		-c=?*|-cio=?*|-ctree=?*|-ciod=?*|-cnr=?*)((RM+MV))&&{ echo Cannot be both remove or move, and $e option;return;}
			((F))||{	echo copy option must be after main search path, it must be the last>&2;return;}
			case $e in			-cio=?*)C1=1;;	-ctree=?*)CT=1;;-cnr=?*)CR=
			esac
			c=\"${e#*=}\";((L=CM=C=1));;
		-chd=?*|-cpd=?*|-cpdir=?*)[[ $e =~ =(.*[^/]?)/*$ ]];ch=${BASH_REMATCH[1]};;
		-copt=?*)CO=${e#*=}\ $CO;;
		-*)echo -e "Unknown \e[1;33m$e\e[m option. Copy option is one letter, gathered in a string if multiple. If it\'d be a path name, put it after - or -- then space\n";read -n1 -p 'Ignore and continue (Enter: yes, else is no)? ' k;[ "$k" = $'\x0a' ]||return;;
		*)if((G))&&((F));then	x_a=$x_a\ \"$e\"
		elif((CM));then	L=1
		else	M=$M\ \"$e\";F=1;fi
	esac
	continue
	}
	a=\"$e\"
	if((G));then	if((F));then	x_a=$x_a\ $a;else	M=$a;fi
	elif((C)) ;then
		((!F))&&{	echo copy option must be after search path name>&2;return;}
		if [[ $e  =~ ^-c[hp]di?r?=(.*[^/]/*|/)$ ]];then	ch=${BASH_REMATCH[1]}
		else			c=$c\ $a;fi
	elif((MV)) ;then	((!F))&&{	echo move option must be after search path name>&2;return;}
		[[ $e =~ ^m[hd]i?r?=(.*[^/]?)/*$ ]]&&mh=${BASH_REMATCH[1]}
	elif((F));then		M=$M\ $a
	else		M=$a;F=1;fi
}
E1="echo Path \'\$a\' is invalid, it goes up beyond root. Ignoring>&2";E2="{ $E1;continue 2;}"
((CM))||((RF=RM+OL+EM))&&{	((EX))&&{	echo -exec option cannot be with -rm, -no, -0, -c= or -m= option;return;};po=;}

PT=(\( -path '* *' -printf "'%p'$Z\n" -o -printf "%p$Z\n" \))
PD=(-type d \( -path '* *' -printf "'%p/'$Z\n" -o -printf "%p/$Z\n" \))
PE=(\( "${PD[@]}" -o "${PT[@]}" \))
PL=(-type l \( -path '* *' -printf "\033[1;36m'%p' -> \033[1;35m'%l'\033[m\n" -o -printf "\033[1;36m%p -> \033[1;35m%l\033[m\n" \))
((LD))&&PD=(-type d -prune -exec find {} $lx "${PS[@]}" \;)

[ "${M//\*}" ]||M=
M=${M//\\/\\\\};eval set -- ${M:-\"\"}
for e;{
unset F T B BL a b p r re s z;W=.
if [ "${e::2}" = \\/ ];then	z=${e:2};[ "$z" = *[!/]* ]&&return;s=/			# start with \\, means root dir search
else
re=1;T=1 # doT relative path on output and recursive initialized True
e=${e//${se='\\'}/$'\n'};IFS=$'\n';set -- $e			# break down to paths of same base, separated by \\ or $se
for a;{									# a fake loop to diffrentiate one with and w/o main path arg, once then breaks
[[ $a =~ ^(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[2]}
a=${BASH_REMATCH[1]}
if [ "${a::1}" = / ];then	re=;T= # absolute is no doT relative path. It is, or . only, or...
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
		((re))||{	T=
			[ $s = / ]&&eval $E2;	s=$s${BASH_REMATCH[1]}
			while [[ $s =~ /[^/]+/\.\.(/|$) ]];do	s=${s/"${BASH_REMATCH[0]}"/\/}; [[ $s =~ ^/\.\.(/|$) ]]&&{ eval $E1;return;};done
		};break;}
	done
	s=${s%/}
fi	
p=${p%/};BL=${p%/*}					# if common base dir. is literal, it'd be BL, they're as array r
r=("${p##*/}$z" ${@:2})
(($#>1))&&p=$p$'\n'${e#*$'\n'}			# else the regex-converted array are put in p, delimited by \n...
p=${p//\/..\//$'\t/'}
p=${p//\{/\\\\\{};p=${p//\}/\\\\\}};p=${p//\(/\\\\\(};p=${p//\)/\\\\\)}
while [[ $p =~ ([^$'\f']|^)\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"};done
while [[ $p =~ ([^$'\f']\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"};done
p=${p//./\\.};p=${p//\//$'\v'}
p=${p//$'\v**\v'/$'\v(.\r/)?'}
p=${p//\*\*/$'.\r'}
while [[ $p =~ ([^$'\f']|^)\* ]];do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"[^/]$'\r'};done
p=${p//$'\r'/*}
b=${p%%$'\n'*}
p=${b##*$'\v'}$z${p#"$b"}
B=${b%$'\v'*}					# ... and common head/base dir. is B
break;}
fi
i=;set -- ${p:-\"\"};for e;{
unset IFS F G LK IS LN Q R S L N WD 
if((!RX))&& [[ $B$e =~ ([^$'\f']|^)[*?[] ]];then
	[[ $B$'\v'$e =~ ^($'\t'*)$'\v'(.*[^/])?(/*)$ ]]
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
	P=${p//$'\v'/\/}
else
	B=$BL;[[ $B/${r[i++]} =~ ^((/\.\.)*)/(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[4]}
	p=${BASH_REMATCH[3]:+/${BASH_REMATCH[3]}}
	[ ${BASH_REMATCH[1]} ]&&{
		S=$s${BASH_REMATCH[1]};[[ $S =~ ^/\.\.(/|$) ]]&&{ eval $E1;continue;}
		while [[ $S =~ /[^/]+/\.\.(/|$) ]];do S=${S/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $S =~ ^/\.\.(/|$) ]]&&eval $E2;done;}
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do
		p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2;done
	: ${S=${s-~+}}
	if((RX));then	P=$p
	elif((re));then	F=1;Q=$S$p
	else
		IS=$I;	S=$s$p;P=/$W*;W=
		[ "$ch" ]	||{			ch=$S;((T))&&ch=.$p	;}
		[ -e "$S" ]&&[ -d "$S" ]||{ P=.*;x_a=
			[ $D$dtx ]&&echo Search path turns out non directory. Ignoring depth option>&2;D=;dtx=;}
	fi
fi
while [[ $S =~ $'\f'([]*?[]) ]];do S=${S/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"};done
while [[ $P =~ $'\f'([]*?[]) ]];do P=${P/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
LC_ALL=C
if [ "$S" = / ];then R=$P
else	[ $IS ]&&{	set +f;S=("${S:: -1}"[${S: -1}]);set -f;[ -e "$S" ]||{ ((RF+CM))||return;	S=-false;};}
	if((F));then N=${PWD##*/};WD=\ current
	else N=${S##*/};fi
	P="${re:+.*}($P)"
	if((T))&&((RL));then	S=.
		Q=.$p;	R=${W:-$Q}$P
		while [[ $R =~ $'\f'([]*?[]) ]];do R=${R/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
	else
		((F))||R=".{${#S}}$P";fi
fi
Q=${Q-$S}
((DR))&&{	[[ `find $Q -printf '%d\n'|sort -nur` =~ [1-9]+ ]];DM=${BASH_REMATCH[0]};}
((V))||{	eval ${x_a:+fx $Q $x_a};(($?))&&return;V=1;}
unset DF e o ND AA H DC
[ "$D" ]&&{
	((F))&&{	e=${p//[!\/]};e=${#e};}
	if [[ $D = *-* ]];then
		Du=${D#*-};	opt=(-mindepth $((e+Dl)) ${DU:+-maxdepth $((e+Du))} ${opt[@]} )
		Dl=${D%-*}${DU:- up to max depth}
	else
		DF=${D//[0-9]};DF=${DF//./${D%.} only};	Du=${D%.}
		opt=(${DF:+-mindepth $((e+Du)) }-maxdepth $((e+Du)) ${opt[@]});fi
}
[ "$D$dtx" ]&&echo "${D+Option \"-$D\" is the depth${Dl+ $Dl}${Du:+ ${DF:-up to $Du}}${DR+ reversed from max $DM} of $Q}${D+${dtx+. And }}${dtx+$dtx of $Q}">&2

case $z in
/)	PS=("${PD[@]}");;//)	PS=(-type f "${PT[@]}");;
///)	PS=(! -type d -executable "${PD[@]}");;
////) PS=(-type l "${PT[@]}");LN=1;;*) PS=("${PE[@]}")
esac
PS=("${PS[@]}" "${pt[@]}")
if((F));then	A=($po "${S[@]}" ${opt[@]} \( -${I}path "$Q/*" "${X[@]}")
	[ "$p" ]&&{
		PC=(\( -path '* *' -printf "\033[1;36m'%p'$Z\033[m\n" -o -printf "\033[1;36m'%p$Z\033[m\n" \))
		PK=(-type d \( -path '* *' -printf "\033[1;36m'%p/'$Z\033[m\n" -o -printf "\033[1;36m%p/$Z\033[m\n" \))
		AA=(-o \( -${I}path "$Q" ! -type d -o -${I}path "$S/*$p" \) "${PE[@]}" \( "${PC[@]}" -o "${PK[@]}" \));}
else
		A=($po "${S[@]}" ${opt[@]} -regextype posix-extended \( -${I}regex "$R" "${X[@]}")
fi
find "${A[@]}" ${CT+-type d} "${PS[@]}" "${AA[@]}" \) "${E[@]}"&&((LN))&&{ echo Link resolution:;sudo find "${A[@]}" "${AA[@]}" \) "${PL[@]}";}>&2

[ "$po" = -L ] ||{
	find . -type l -xtype d |tee /tmp/.0 |read -n1 &&{
		mapfile -t a</tmp/.0
		echo 'Search into which the below link(s) point(s) ?'>&2;find "${a[@]}" "${PL[@]}"
		read -N1 -p '(Enter: Yes)' i>&2
		[ "$i" = $'\x0a' ] &&{
			find -L "${a[@]}" ${opt[@]} -regextype posix-extended \( -${I}regex "$R" "${X[@]}" \( "${PD[@]}" -o "${PT[@]}" \) \)
	};}
}

((de+if+RF+CM))&&{
	: #((OL+EM))&&
}	
};}

if((de));then	export -f fid;find "${A[@]}" "${PS[@]}" "${AA[@]}" \) ! -type d -executable -exec bash -c 'fid "$0" "$@"' '{}' \;
elif((if));then	find "${A[@]}" "${PS[@]}" "${AA[@]}" \) ! -type d -exec bash -c '[[ `file "{}"` =~ ^[^:]+:\ *([^,]+$|[^,]+\ ([^,]+)) ]];echo "   ${BASH_REMATCH[1]}"' \;
elif((co));then	> >(x=;F=;IFS=/;while read -r l;do
		l=${l#?};l=${l%\'};((F=x=!F));m=${l: -1};: ${m:=/}
		for i in $l;{	((x=!x))&&c=||c=1\;36;echo -ne "\e[${c}m${i:+/$i}">&2;}
		echo -e "\e[41;1;33m${m%[!/]}\e[m">&2;done)	find "${A[@]}" "${PS[@]}" "${AA[@]}" \) "${E[@]}"
else

((RF+CM))&&{
	PP=(-printf "'%p'\n")
	case $z in	/)PS=(-type d "${PP[@]}");;//)PS=(-type f "${PP[@]}");;///)PS=(! -type d -executable "${PP[@]}");;
	////)PS=(-type l "${PP[@]}");;*)PS=("${PP[@]}");esac
	if [ ! $W ];then PO=' the directory${CT+ structure of} content found above? (Enter: yes) "'
	else D='and whole content of any';PO=' the objects above $D directory above? (Enter: yes) "';fi
	((RF))&&{ E=
		((EM)) &&	E=(-empty "${PE[@]}")
		((OL)) &&{	E=(${E:+"${EM[@]}" -o }"${PL[@]}");L=-L;}
		if((F)) ;then	AA=(-o -${I}path "$Q" -o -${I}path "$S/*$p" -o -${I}path "$S/*$p/*")
		else	A=("${S[@]}" -regextype posix-extended \( -${I}regex "$R${W:+$R(/.*)}?" "${X[@]}");fi
		a=remov;}
	((C))&&a=copi;((MV))&&a=mov
	find $L "${A[@]}" "${AA[@]}" \) "${E[@]}"| read -n1||{ echo Nothing has been found and ${a}ed>&2;return;}
	if((RF));then
		((OL+EM))&&find $L "${A[@]}" "${AA[@]}" \) "${E[@]}"&&((OL))&&{ echo Orphan link resolution:;sudo find "${A[@]}" "${AA[@]}" \) "${PL[@]}";}>&2
		eval read -N1 -p \"Delete$PO o>&2;[ "$o" = $'\x0a' ]||return
		find $L "${A[@]}" "${PP[@]}" "${AA[@]}" \) "${E[@]}" -delete &&echo All deleted>&2
	elif((C));then
		[ $CR ]||D='but only path name of'
		eval set -- $c;for c;{
		h=;	[ ${c::1} = / ]||h=~+
		if((C1));then CP=;CR=;ND='! -type d'
		elif [ ! "$ch" ];then
			if((T));then R=.$p ;else R=.$P;fi;	DC=1
		elif [ "$ch" != / ];then
			[ ${ch::1} = / ];G=$?
			if((T));then	((G=!G))
					p=${p#/};ch=${ch#./}
					H=${p#$ch};			Q=.$H;R=$Q
			else			H=${S#$ch};			R=.$H$P;fi
			((${#h}==${#S}))||((G))&&{ echo "'$ch' is not part of the resolved search path, or has implicit .. name, or does not exist">&2;return;};	S=.;DC=1
		fi
		echo -e "Source copy is everything searched and found under$WD directory \e[41;1;37m$N\e[m${H:+ with a leading/parent path:\n\e[1;36m$H\e[m}"
		if [ -e "$c" ];then
			echo -e "WARNING: target copy \e[41;1;33m$c\e[m exists!"
			eval echo \"Replace it with$PO
			read -N1 -p "Or if no, copy, merge them into it, or abort? (n: no, else: abort) " o>&2
			if [ "$o" = $'\x0a' ];then	rm -rf "$c"||return
			else	echo;			if [ "$o" = n ];then			c=$c/$N;	else return;fi
			fi
		else
			eval read -N1 -p \"Copy as $'\e[41;1;33m$c\e[m'$PO o>&2;	[ "$o" = $'\x0a' ]||{ echo;return;};fi
		mkdir -p "$c" 2>/dev/null||{
			[ -e "$c" ]&&	echo "An object under copy target has the same name as '$N' copy source. Aborting";return;}
		c=$h/$c
		if((F));then	A=(\( -${I}path "$Q/*" "${X[@]}");AA=(${p:+-o \( -${I}path "$Q" ! -type d -o -${I}path "$S/*$p" \) "${PP[@]}"})
		else			A=(-regextype posix-extended \( -${I}regex "$R" "${X[@]}")
		fi
		eval ${DC+pushd $ch>/dev/null}
		(if((CT));then
			find "${S[@]}" ${opt[@]} -type d "${A[@]}" "${AA[@]}" \) -exec bash -c "for d ;{ mkdir -p $c/\$d;chmod --reference=\$d $c/\$d; chown --reference=\$d $c/\$d; touch --reference=\$d $c/\$d;} " '{}' +
		elif [ ! $CR ];then
			find $po "${S[@]}" ${opt[@]} "${A[@]}" "${PS[@]}" "${AA[@]}" \) |sudo xargs bash -c "for d ;{ if [ -d \"\$d\" ];then mkdir -p $c/\$d; chmod --reference=\$d $c/\$d; chown --reference=\$d $c/\$d; touch --reference=\$d $c/\$d; else cp $CO $CP \"\$d\" $c;fi;}"
		else
			find $po "${S[@]}" ${opt[@]} $ND "${A[@]}" "${PS[@]}" "${AA[@]}" \) |sudo xargs -i cp $CO $CP $CR '{}' "$c"
		fi
		 (($?))||echo Successfully copied)2> >(while read s;do echo -e "\e[1;31m$s\e[m">&2;done)
		 [ "$ch" != / ]&&popd>/dev/null
		}
	elif((MV));then	:;fi
	}
fi
set +f;} ##### ENDING OF l, find wrap script #####
