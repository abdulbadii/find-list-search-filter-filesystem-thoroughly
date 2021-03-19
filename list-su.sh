fxr(){ ##### BEGINNING OF l, find wrap script #####
local B a b e i p re r z A Z m=path
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
p=${p//./\\.};p=${p//\//$'\v'}
p=${p//$'\v**\v'/$'\v(.\r/)?'}
p=${p//\*\*/.$'\r'}
while [[ $p =~ ([^$'\f']|^)\* ]];do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"[^/]$'\r'};done;p=${p//$'\r'/*}
b=${p%%$'\n'*}
p=${b##*$'\v'}$z${p#"$b"}
b=${b%$'\v'*}
set -- ${p:-\"\"};i=;for a;{ 
if((!RE))&& [[ $b$a =~ ([^$'\f']|^)[*?[] ]];then
	[[ $b$'\v'$a =~ ^($'\t'*)$'\v'(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[3]}
	p=${BASH_REMATCH[2]};p=${p:+$'\v'$p}
	[[ ${BASH_REMATCH[1]} ]]&&{
		Z=${Z-$S}${BASH_REMATCH[1]};[[ $Z =~ ^$'\t'($'\v'|$) ]]&&{ eval $E;continue;}
		while [[ $Z =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do Z=${Z/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $Z =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	}
	while [[ $p =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	A=-${J}regex\ \"$Z${re+.*}${p//$'\v'/\/}\"
else
	[[ $B/${r[i++]} =~ ^((/\.\.)*)/(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[4]}
	p=${BASH_REMATCH[3]};p=${p:+/$p}
	[ ${BASH_REMATCH[1]} ]&&{
		Z=${Z-$S}${BASH_REMATCH[1]};[[ $Z =~ ^/\.\.(/|$) ]]&&{ eval $E:continue;}
		while [[ $Z =~ /[^/]+/\.\.(/|$) ]];do Z=${Z/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $Z =~ ^/\.\.(/|$) ]]&&eval $E2;done;}
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2;done
	((RE))&&m=regex
	A=-${J}$m\ \"$Z${re+${RE+.}*}$p\"
fi
case $z in /) z=-type\ d;;//) z=-type\ f;;///) z="\! -type d -executable";;////) z=-type\ l;esac
while [[ $A =~ $'\f'([]*?[]) ]];do A=${A/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
Rt="$z $A"
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
fx(){
local D F L G H x r Rt RE IFS S=$1;shift
for a;{
eval set -- \"$a\"
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
X=(${X[@]} "$r" \( ${F+-type d -prune -o }-true \) -o)
}
}
fid(){
	[[ `file "$1"` =~ ^[^:]+:\ *([^,]+$|[^,]+\ [^,]+) ]];echo -e " ${BASH_REMATCH[1]}\n DEPs"
	ldd "$1" 2>/dev/null |sed -E 's/^\s*([^>]+>\s*)?(.+)\s+\(0.+/  \2/'
}

l(){
unset IFS F N0 OL RM RX EP EO co po opt se sz tm D Dt Rd DM dtx de if ld CM;I=i
set -f;trap 'set +f;unset IFS' 1 2
for e;{
((F)) &&{	opt=$opt$e' '
		((EP))&&{ EO=$opt;break;}
		continue;}
case $e in
-[mca][0-9]*|-[mca]-[0-9]*)	ftm $e;opt=$opt$Rt\ ;;
-[1-9]|-[1-9][-0-9.]*|-[1-9][r/]|-[1-9][-0-9.]*[r/])
	Dt=$e;D=${e:1};[[ ${e: -1} = [r/] ]]&&{	D=${D%?};Rd=1;};;
-s[0-9]|-s[0-9][-cwbkmMgG]*|-s[-0-9][0-9]*)	fsz $e;opt=$opt$Rt\ ;;
-s=?|-s=??) se=${e:5};;
-l|-l[0-9]|-l[1-9][0-9])	ld=1;n=${e:2}
	lx=-maxdepth\ ${n:=1};	((n))||lx=;;
-x=?*|-xs=?*|-xcs=?*|-c=?*|-cv=?*|-cu=?*|-cuv=?*|-cz=?*|-czv=?*|-m=?*|-mv=?*);;
-ls) EO=-ls\ $EO;;
-rm|-delete)RM=1
	((EP)) && { echo cannot both rm and exec option;return;};;
-exec|-execdir)
	((RM+OL+N0)) && { echo cannot both exec and rm, no, 0 option;return;}
	EO=$EO\ $e;EP=1;F=1;;
-s) sz=\ %s;;
-E|-re) RX=1;;
-no)OL=1
	((EP)) && { echo cannot both no and exec option;return;};;
-0)N0=1
	((EP)) && { echo cannot both 0 and exec option;return;};;
-|--)	break;;
-s=*) echo "Separator must be 1 or 2 characters. Ignoring, it defaults to \\">&2;;
-de)de=1;;-i)if=1;;
-cs)I=;;
-c) co=1;;-ci)I=i;;
-m) tm=\ %Tx;;
-mh) tm=' %Tr %Tx';;
-a) tm=\ %Ax;;
-ah) tm=' %Ar %Ax';;
-c) tm=\ %Cx;;
-ch) tm=' %Cr %Cx';;
-h|--help) man find;return;;
-[HDLPO])po=$e\ ;;
-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	opt=$opt$e\ ;F=1;;
\!|-ls|-d|-delete|-depth|-daystart|-follow|-fprint|-fls|-group|-gid|-o|-xstype) opt=$opt$e\ ;;
-*)	echo -e "\e[1;33m$e\e[m unknown option, if it\'d be a path name, put it after - or -- then space. "
read -n1 -p 'Ignore and continue (y for yes, else for no)? ' k;[ "$k" = y ]||return
esac
}
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]];h=${BASH_REMATCH[1]}
while [[ $h =~ ([^\\]|\\\\)[\;\&|\>\<] ]];do	h=${h/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'};done
IFS=$'\n';set -- $h
unset IFS F L G K Fc Fu Fm x_a x vb C M X XF IS S J
for c;{
	[[ $c =~ ^.+\ *\$\(\ *$FUNCNAME\ +(.*)\)|.+\ *\`\ *$FUNCNAME\ +(.*)\`|\ *$FUNCNAME\ +(.*) ]]&&{	
		c="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
		while [[ $c =~ ([^\\])\\([]*?[]) ]];do	c=${c/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\f'"${BASH_REMATCH[2]}"};done
		eval set -- $c;break;
	}
	set --
}
for a;{	((S))&&{	S=;continue;}
	((!L)) &&{	case $a in
		-x=?*|-xs=?*|-xcs=?*)
			((Fc))&&{	echo -c or -cp option must be the last>&2;return;}
			[ ${a:2:1} = = ]&&J=i
			x=${a#-x*=};[[ $x =~ ^-[1-9].*\.?[r/]$ ]]&&Rd=1
			x_a=$x_a\"$x\"' ';
			G=1;continue;;
		-c=*|-cv=*|-cu=*|-cuv=*|-cz=*|-czv=*|-m=*|-mv=*|-mu=*|-muv=*)
			((EP+RM+if+de+OL+N0))&& { echo Cannot be both copy and removal, dependency, info, or $EO option;return;}
			((!F))&&{	echo -c or -cp option must be after main path name>&2;return;}
			C=${a#-*=}
			[[ $a = -*v= ]]&&vb=v
			eval F${a:1:1}=1;	(($Fm))&&CM=mv
			[[ ${a:2:1} = [uz] ]]&&eval F${a:2:1}=1
			Fc=1;break;;
		-rm|-delete|-exec|-execdir|-i|-de|-no|-0)	[ $Fc ]&&{	echo Cannot be both copy and $a option;return;}
			continue;;
		-[cam]min|-[cam]time|-size|-samefile|-use[dr]|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-group|-uid|-perm|-links|-fstype|-exec|-execdir|-ipath|-name|-[il]name|-ilname|-iregex|-path|-context|-D|-O|-ok|-inum|-mindepth|-maxdepth)	S=1;;
		-|--)	L=1;continue;;
		-\!|-*)continue
	esac
	}
	a=\"$a\"		
	if((G));then
		if((F));then	x_a=$x_a$a\ ;else			M=$M$a\ ;fi
	elif((Fc)) ;then
		((!F))&&{	echo -c or -cp option must be after searched path name>&2;return;};CP=$CP\"$a\"' '
	elif((K));then
		XC=$XC\ \"$a\"
	elif ((L));then
		if((F));then		M=$M$a
		else		M=$a;	x_a=$x_a$M
		fi;G=0
	else	M=$M$a\ ;F=1;fi
}
E="echo Path \'\$a\' is invalid, it\'d be up beyond root. Ignoring>&2";E2="{ $E;continue 2;}"
[ "${M//\*}" ]||M=;M=${M//\\/\\\\}
eval set -- ${M:-\"\"}
for e;{
unset F a b B p z r re s
if [ "${e:0:2}" = \\/ ];then	z=${e:2};s=/			# start with \\, means root dir search
else
e=${e//${se='\\'}/$'\n'}
re=1;IFS=$'\n'
set -- $e			# break down to paths of same base, separated by \\ or $se
for a;{									# fake for-loop to apart of no path argument, once then breaks
[[ $a =~ ^(.*[^/])?(/*)$ ]]
z=${BASH_REMATCH[2]}
a=${BASH_REMATCH[1]}
if [ "${a:0:1}" = / ];then	re= # if absolute or...
	p=$a;[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/\/};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2;done
else
	[[ $a =~ ^\./|^\.$ ]]	&&{ re=	# ..prefixed by ./ , needn't to insert recursive .*
		W=.
		a=${a#.};[ "$a" ] || W=[^/]
		a=${a#/}
	}
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
unset i L T Q U V dt;set -- ${p:-\"\"};for a;{
unset F IS R S G M N
if((!RX))&& [[ $b$a =~ ([^$'\f']|^)[*?[] ]];then L=$ld
	[[ $b$'\v'$a =~ ^($'\t'*)$'\v'(.*[^/])?(/*)$ ]]
	z=${BASH_REMATCH[3]}
	p=${BASH_REMATCH[2]};p=${p:+$'\v'$p}
	[ ${BASH_REMATCH[1]} ]&&{
		S=$s${BASH_REMATCH[1]};[[ $S =~ ^$'\t'($'\v'|$) ]]&&{ eval $E;continue;}
		while [[ $S =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do S=${S/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $S =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	}
	while [[ $p =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	if((re));then	p=.*$p;S=$s
	else	IS=$I
		[[ $p =~ [^$'\f']([][*?].*)$ ]]
		S=${p%$'\v'*"${BASH_REMATCH[1]}"};p=${p#$S}
		S=$s${S//$'\v'/\/};: ${S:=/}
	fi
	R=${p//$'\v'/\/}
else
	[[ $B/${r[i++]} =~ ^((/\.\.)*)/(.*[^/])?(/*)$ ]];z=${BASH_REMATCH[4]}
	p=${BASH_REMATCH[3]};p=${p:+/$p}
	[ ${BASH_REMATCH[1]} ]&&{
		S=$s${BASH_REMATCH[1]};[[ $S =~ ^/\.\.(/|$) ]]&&{ eval $E;continue;}
		while [[ $S =~ /[^/]+/\.\.(/|$) ]];do S=${S/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $S =~ ^/\.\.(/|$) ]]&&eval $E2;done;}
	while [[ $p =~ /[^/]+/\.\.(/|$) ]];do	p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^/\.\.(/|$) ]]&&eval $E2;done
	: ${S=${s-~+}}
	if((RX));then
		L=$ld;R=${re+.*}$p
	elif((re));then		F=1;M=$S$p
	else	IS=$I
		S=$s$p;R=/$W*;	[ -d "$S" ]||{	M=\'\';x_a=;}
	fi
fi
while [[ $S =~ $'\f'([]*?[]) ]];do S=${S/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"};done
while [[ $R =~ $'\f'([]*?[]) ]];do R=${R/"${BASH_REMATCH[0]}"/\\\\"${BASH_REMATCH[1]}"};done
#[ ${C#.} ]||((Fc)) &&{
	#if [ "$R" = .* ] ;then C=${p##*/}	else [ -e "$R" ] && C=${R##*/};fi
#}
PT="( -regex .*\s.* -printf '%p'$sz$tm\n -o -printf %p$sz$tm\n )"
PD="-type d ( -regex .*\s.* -printf '%p/'$tm\n -o -printf %p$tm/\n )"
PL="-type l ( -regex .*\s.* -printf '%p'->'%l'\n -o -printf %p->%l\n )"
((ld))&& PD="( -type d -prune -exec find {} $lx ( $PD -o $PT ) ; -o $PT )"
case $z in
/)	P="$PD";;//)	P="-type f $PT";;
///)	P="\! -type d -executable $PT";;
////) P=$PL;;	*) P="( $PD -o $PT )"
esac
M=\"${M=$S}\";[ $S = / ] ||{ R=.{${#S}}$R; ((OL+N0))|| N="! -ipath $M";}

[ $IS ]&&[ -d "${S%/}" ]&&{ shopt -s nocaseglob;c=${S: -1};set +f;printf -vS "%q" ${S/$c/[$c]};set -f;}

((Rd))&&{	[[ `eval "find $S -printf '%d\n'|sort -nur"` =~ [1-9]+ ]];DM=${BASH_REMATCH[0]};}
((XF))||{	eval ${x_a+fx $M $x_a};(($?))&&return;XF=1;}
eval ${D+fd $M}
[ "$D$dtx" ]&&echo "${D+Option \"$Dt\" is depth '$D'${Rd+ reversed from max $DM} of $M}${D+${dtx+ and }}${dtx+$dtx of $M}">&2
#if((Fc));then T="${T% $S} $S";Q="${Q% \! -ipath $S} \! -ipath $S";	U=$U${R:+\|$R};V=$V${G:+ -o -${I}path \"$G/*\"}
#else
	LC_ALL=C;unset IFS E L Z
	if((F)) ;then
		C=("$po$S -regextype posix-extended $opt(" "-${I}path $S$p/*" "( ${X[@]} $P )"
		 ${p:+"-o -${I}path $S$p" "-type f $PT" "-o -${I}path $S/*$p" "( $PD -o $PT )"} \))
	else
		C=("$po$S -regextype posix-extended $N $opt(" "-${I}regex $R" "( ${X[@]} $P )" \))
	fi
	if((de))&&[[ $z != / ]];then	export -f fid;find ${C[@]} ! -type d -executable -exec bash -c 'fid \"\$0\" \"\$@\"' '{}' \;
	elif((if))&&[[ $z != / ]];then
		find ${C[@]} ! -type d -exec bash -c '[[ \`file \"{}\"\` =~ ^[^:]+:\ *([^,]+$|[^,]+\ ([^,]+)) ]];echo \  \${BASH_REMATCH[1]}' \;
	elif((co));then	> >(x=;F=
		IFS=/;while read -r l;do
			l=${l#?};l=${l%\'};((F=x=!F));m=${l: -1};: ${m:=/}
			for i in $l;{	((x=!x))&&c=||c=1\;36;echo -ne "\e[${c}m${i:+/$i}">&2;}
			echo -e "\e[41;1;33m${m%[!/]}\e[m">&2;done)	sudo find ${C[@]} $EO
	else
		((OL+N0))&&{
			EO=;((OL))&&{ L=-L;	EO="-type l $PL";}
			((N0))&&	EO="${EO:+$EO -o }-empty ( -type f $PT -o $PD )"
			if((F)) ;then
				unset C[2] C[4];	[ "$p" ]&&	C[6]=${C[5]}/*
			else		C[2]="-o ${C[1]}/*"
			fi
		}
		2> >(while read s;do echo -e "\e[1;31m$s\e[m">&2;done) sudo find $L ${C[@]} $EO
		((OL+N0+RM))&&{
			find $L ${C[@]} $EO |read -rn1 || { echo Nothing was found and deleted>&2;return;}
			read -sN1 -p 'Remove all the objects listed above (Enter: yes) ? ' o;echo
			[ "$o" = $'\x0a' ]&&{
				((OL))&&	Z=-type\ l
				((N0))&&	Z="${Z+$Z -o }-empty"
				sudo find $L ${C[@]} $Z -delete &&echo All above has been deleted
			}
		}
	fi
#fi
}
#if((Fc));then
	#C=${C%/}
	#if [ -d "$C" ];then read -n1 -p "Delete content of directory \"$C\" and replace with the found result? " o
		#echo;[ "$o" = y ]||return;rm -r "$C"
	#elif	[ -f "$C" ];then echo Trying to replace file $C>&2;rm $vb "$C"||{ echo Failed, try again as root>&2;};fi
	#T=${T# };Q=${Q# };U=${U#\|};V=${V# -o };U=${U:+-${I}regex \"$U\"};V=${V:+$V}
	#if((Fu));then
		#mkdir -p$vb $C
		#eval find "$po$T $Q $opt$Rt \( -regextype posix-extended $U $V \) ${X[@]} -type f" |xargs -i $CM -u$vb '{}' "$C"
	#else
		#eval find "$po$T $Q $opt$Rt \( -regextype posix-extended $U $V \) ${X[@]} -type d -printf \"$C/%P\n\"" |xargs mkdir -p$vb -- 2>/dev/null &&{
		#cd $C;eval find "$po$T $Q $opt$Rt \( -regextype posix-extended $U $V \) ${X[@]} -type f -printf '%P\n'" |xargs -i $CM -u$vb "$T/{}" '{}'
		#cd ->/dev/null;}
	#fi
#fi
}
set +f;} ##### ENDING OF l, find wrap script #####
