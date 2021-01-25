fid(){
	[[ `file "$1"` =~ ^[^:]+:\ *([^,]+$|[^,]+\ [^,]+) ]];echo -e " ${BASH_REMATCH[1]}\n DEPs"
	ldd "$1" 2>/dev/null |sed -E 's/^\s*([^>]+>\s*)?(.+)\s+\(0.+/  \2/'
}
l(){
unset IFS F RX xc co po opt se sz tm AX D Dt Rd DM dtx de if ld;I=i;CM=cp
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
-x=?*|-xs=?*|-xcs=?*|-c=?*|-cv=?*|-cu=?*|-cuv=?*|-cz=?*|-czv=?*|-m=?*|-mv=?*);;
-exec|-execdir)xc=1;F=1;;
-s)	sz=\ %s;;
-E|-re) RX=1;;
-|--)	break;;
-rm)	AX=\ -delete;;
-de)de=1;;
-in)if=1;;
-c)co=1;;
-s=*) echo "Separator must be 1 or 2 characters. Ignoring and let it default to \\">&2;;
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
unset IFS F L G K Fc Fu Fm x_a x vb C M Rt X XF IS S
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
			((Fc))&&{	echo -c or -cp option must be the last>&2;return;}
			[ ${a:2:1} = = ]&&J=i
			x=${a#-x*=};[[ $x =~ ^-[1-9].*\.?[r/]$ ]]&&Rd=1
			x_a=$x_a\"$x\"' ';
			G=1;continue;;
		-c=*|-cv=*|-cu=*|-cuv=*|-cz=*|-czv=*|-m=*|-mv=*|-mu=*|-muv=*)
			((!F))&&{	echo -c or -cp option must be after main path name>&2;return;}
			[ $K$AX ]&&{ S=${K+-exec/execdir};echo Cannot be both ${S:-$AX} and $a option;return;}
			C=${a#-*=}
			[[ $a = -*v= ]]&&vb=v
			eval F${a:1:1}=1;	(($Fm))&&CM=mv
			[[ ${a:2:1} = [uz] ]]&&eval F${a:2:1}=1
			Fc=1;break;;
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
	elif((Fc)) ;then
		((!F))&&{	echo -c or -cp option must be after main path name>&2;return;};C=$C\"$a\"' '
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
if [ "${e:0:2}" = \\/ ];then	z=${e:2};s=/			# start with prefix \\, means root dir search
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
	[[ $a =~ ^\.(/|$) ]]	&&{		# if . or prefixed by ./ needn't to insert recursive .*
		a=${a#.};re=; if [ "$a" ];then	a=${a#/};	else	Rt=-maxdepth\ 1;fi;}
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
	[[ $b$'\v'$a =~ ^($'\t'*)$'\v'(.*[^/])?(/*)$ ]]
	z=${BASH_REMATCH[3]}
	p=${BASH_REMATCH[2]};p=${p:+$'\v'$p}
	[ ${BASH_REMATCH[1]} ]&&{
		S=$s${BASH_REMATCH[1]};[[ $S =~ ^$'\t'($'\v'|$) ]]&&{ eval $E;continue;}
		while [[ $S =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do S=${S/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $S =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	}
	while [[ $p =~ $'\v'[^/]+$'\t'($'\v'|$) ]];do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}};[[ $p =~ ^$'\t'($'\v'|$) ]]&&eval $E2;done
	if((re));then	p=.*$p;S=$s
	else
		[[ $p =~ [^$'\f']([]*?[].*)$ ]]
		S=${p%$'\v'*"${BASH_REMATCH[1]}"};	p=${p#$S}
		S=$s${S//$'\v'/\/};	IS=$I
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
[ ${C#.} ]||((Fc)) &&{
	if [ "$R" = .* ] ;then C=${p##*/}
	else [ -e "$R" ] && C=${R##*/}
	fi
}
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
else		: ${S:=/}
	if((F));then
		CL="find $po$S $Rt -regextype posix-extended $opt\( -${I}path \"$G/*\" \( ${X[@]} $Z \)${p:+" -o -${I}path \"$G\" -type f $P -o -${I}regex \".{${#s}}/.+$p\" \\( $PD -o $P \\)"} \)$AX"
	else
		CL="find $po$S $Rt \! -ipath $N -regextype posix-extended $opt-${I}regex $R \( ${X[@]} $Z \)$AX";fi
	if((de))&&[[ $z != / ]];then
		export -f fid;eval "$CL ! -type d -executable -exec /bin/bash -c 'fid \"\$0\" \"\$@\"' '{}' \;"
	elif((if))&&[[ $z != / ]];then
		eval "$CL ! -type d -exec /bin/bash -c '[[ \`file \"{}\"\` =~ ^[^:]+:\ *([^,]+$|[^,]+\ ([^,]+)) ]];echo \  \${BASH_REMATCH[1]}' \;"
	elif((co));then	command> >(x=;F=;IFS=/;while read -r l;do
		l=${l#?};l=${l%\'};((F=x=!F));m=${l: -1};: ${m:=/}
		for i in $l;{	((x=!x))&&c=||c=1\;36;echo -ne "\e[${c}m${i:+/$i}">&2;}
		echo -e "\e[41;1;33m${m%[!/]}\e[m">&2;done)	eval sudo $CL
	else	2> >(while read s;do echo -e "\e[1;31m$s\e[m">&2;done) eval sudo $CL;fi
fi
}
if((Fc));then
	C=${C%/}
	if [ -d "$C" ];then read -n1 -p "Delete directory \"$C\" to be replaced with the found result? " o
		echo;[ "$o" = y ]||return;rm -r "$C"
	elif	[ -f "$C" ];then echo Trying to replace file $C>&2;rm $vb "$C"||{ echo Failed, try again as root>&2;};fi
	T=${T# };Q=${Q# };U=${U#\|};V=${V# -o };U=${U:+-${I}regex \"$U\"};V=${V:+$V}
	if((Fu));then
		mkdir -p$vb $C
		eval find "$po$T $Q $opt$Rt \( -regextype posix-extended $U $V \) ${X[@]} -type f" |xargs -i $CM -u$vb '{}' "$C"
	else
		eval find "$po$T $Q $opt$Rt \( -regextype posix-extended $U $V \) ${X[@]} -type d -printf \"$C/%P\n\"" |xargs mkdir -p$vb -- 2>/dev/null &&{
		cd $C;eval find "$po$T $Q $opt$Rt \( -regextype posix-extended $U $V \) ${X[@]} -type f -printf '%P\n'" |xargs -i $CM -u$vb "$T/{}" '{}'
		cd ->/dev/null;}
	fi
	#2>/dev/null#((Fz))&&	a='bsdtar -cf$vb $C \{\} \; ;cd $C;bsdtar -xf$vb $C' 
fi
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
source "$HOME/.cargo/env"
