fd(){
	f=`file $3`
	e=`echo $f|sed -E 's/[^:]+:\s+\S+\s+(\S+(\s+\S+){2}).+/\1/;s/Intel$/32bit/'`
	if [[ $e =~ ^execu ]];then echo $e
	else echo $f|sed -E 's/[^:]+:\s*(.+)/\1/';fi
	(($2))&&ldd $3 2>/dev/null |sed -Ee 's/[^>]+>(.+)\s+\(0.+/\1/ ;1s/.*/DEP:&/ ;1! s/.*/    &/'
}
l(){
[[ ${@:1} =~ ^\.$ ]] &&{ find ~+ -type f; return; }
[[ ${@:1} =~ ^/$ ]] &&{ find ~+ \! -ipath ~+ -type d -printf $r/\\n ; return; }
unset a E opt u y d I i ex
r=%p
for e
{
((i++))
case $e in
-h|--help) find --help; return;;
-d) d=1;;
-i) I=1;;
-[0-9]*) y=-maxdepth\ ${e:1};;
-E|--re) E=1;;
-s) r=%s\ $r;;
-t) r="$r %Tr %Tx";;
-st) r='%s %p %Tr %Tx';;
-[ac-il-y]) echo \'$e\' : inadequate specific sub-option, ignoring it.;;
-[ac-il-y]?|-[HDLPO]) opt=$opt$e\ ;;
-?) echo \'$e\' : unrecognized option, ignoring it. If it\'s meant a filename, put it after - or --;;
-|--) break;;
*) ex=1; break;;
esac
}
xt=${@:1:((i-ex))}
set -f

if [[ $@ =~ \* ]] ;then
	A=$@
else
A=`history 1`' '
A=${A# *[0-9] $xt }
A=${A#*$xt }
A=${A%% [12]>*}
A=${A%%[>&|<]*}
fi

[[ $A =~ ^[\ \t]*$ ]] &&{ eval "find ~+ \! -ipath ~+ $opt -type d -printf \"$r/\n\" -o -type d -printf \"$r\n\""; set +f;return; }

eval set -- "${A//\\/\\\\}"
IFS=$'\n'
for a
{
unset O P N
D="-type d -printf \"$r/\n\""
F="-type f -printf \"$r\n\""
z=${a: -1}
a=${a%[/.]}
[[ $a =~ ^(.*/)?([^/]+)$ ]]
p=${BASH_REMATCH[1]}
n=${BASH_REMATCH[2]}

if [ $z = . ] ;then	D=
elif [ $z = / ] ;then	F=
else	O=-o
fi

if [ $p ] ;then # If it has dir. path it is possibly either absolute or relative
if [ ${p:0:1} = / ];then # Absolute Dir. Path
	if [ $E ] ;then
		A="sudo find / $y -regextype posix-extended -iregex *$p$n* $opt \( $D $O $F"
		return
	elif [[ ! $p =~ [*?] ]] ;then # No single wildcard in dir. path 
		s=$p
		if [[ ! $n =~ \*\* ]] ;then # and not double one in filename
			N=-iname\ $n
			if [[ ! $n =~ \* ]] ;then # if there is none
				eval "sudo find $s -maxdepth 1 $N $opt \( -type d -exec find \{\} $y -iname * $opt $D $O $F \; $O $F \)"
				continue
			fi
			y=-maxdepth\ 1
		fi
	else			# If there's at least a wildcard in dir. path or double ones in filename
		s=${p%%[*?]*} # s is starting search dir.
		s=${s%/*}
		if [[ $n =~ \*\* ]] || [[ ! $n =~ \* ]] ;then # if there is double wildcards in filename or none at all 
			P=-ipath\ $a
		elif [[ $n =~ \* ]] ;then
			n=${n//./\.}
			n=${n//\?/[^/.]}
			n=${n//\*/'[^/]*'}
			p=${p//./\.}
			p=${p//\?/[^/.]}
			p=${p//\*/.*}
			P="-regextype posix-extended -iregex ^$p$n\$"
		fi
	fi
else # Relative Dir. Path
	s=~+
	while [ ${p:0:3} = ../ ] ;do
		s=${s%/*}
		p=${p#../}
		p=${p#./}
	done
	if [ $E ] ;then
		A="sudo find $s $y -regextype posix-extended -iregex *$s/$p$n* $opt \( $D $O $F"
		return
	elif [[ ! $p =~ [*?] ]] && [[ ! $n =~ \*\* ]] ;then # No single wildcard in dir. path nor double one in filename
		p=${p%/}
		s=$s/$p
		y=-maxdepth\ 1
		N=-iname\ $n
	else			# If there's at least a wildcard in dir. path or double ones in filename
		if [[ $n =~ \*\* ]] || [[ ! $n =~ \* ]] ;then # if there is double wildcards in filename or none at all 
			P=-ipath\ $s/$p$n
		elif [[ $n =~ \* ]] ;then
			n=${n//./\.}
			n=${n//\?/[^/.]}
			n=${n//\*/'[^/]*'}
			p=${p//./\.}
			p=${p//\?/[^/.]}
			p=${p//\*/.*}
			P="-regextype posix-extended -iregex ^$s/$p$n\$"
		fi
	fi	
fi

else # If has no dir. path, it must be dir./file name relative to PWD
	s=~+
	if [ $E ] ;then
		A="sudo find $s $y -regextype posix-extended -iregex $s/$p $opt \( $D $O $F"
		return
	elif [[ $n =~ \*\* ]] ;then # if there is double wildcards in filename
		P=-ipath\ $s/$n
	elif [[ ! $n =~ \* ]] ;then	# if none at all 
		eval "sudo find $s $y -ipath $s/$n $opt \( -type d -exec find \{\} $y -iname * $opt $D $O $F \; $O $F \)"
		continue
	elif [[ $n =~ \* ]] ;then
		n=${n//\*/'[^/]*'}
		P="-regextype posix-extended -iregex ^$s/$n\$"
	fi
fi

A="sudo find $s $y $P $N $opt \( $D $O $F"

if((d+I));then
	export -f fd;eval $A -exec bash -c \'fd $d $i \$0\' {} '\; \)'
else
	set -o pipefail;
	(eval "$A \)" 2>&1>&3 | sed -E $'s/:(.+):(.+)/:\e[1;36m\\1:\e[1;31m\\2\e[m/'>&2 ) 3>&1
fi
}
set +f; unset IFS
}

ren(){
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
		echo -ne '\033[0;36m'Would' '
		if [ ${F%/*} = ${t%/*} ] ;then	echo -n Rename
		elif [ ${F##*/} = ${t##*/} ];then	echo -n Move
		else	echo -n Move then rename
		fi
		echo -e '\033[0m'" $F -> $t\n"
		}
	done<$f
	else	for F in `find $s -regextype posix-extended $c "$x" |head -n499`
	{	t=`echo $F | sed -E "s!$v!$y!$I"`
		[ $F = $t ]||{
		echo -ne '\033[0;36m'Would' '
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
		echo -ne '\033[0;36m'Would' '
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
		echo -ne '\033[0;36m'Would' '
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
#   pushd "${the_new_dir}" > /dev/nulll
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
#
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/nulll 1>/dev/nulll
#
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/nulll)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/nulll 1>/dev/nulll
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
		# a=`head -c512 $f | od -xAn  | gre -Moe '4550( \w{4}\s*){12}'` 2>/dev/null&&{ test ${a: -4} = 20b &&l="$l$f "; }
		# }
	# elif test $r = -32 ;then
		# for f
		# {
		# a=`head -c512 $f | od -xAn  | gre -Moe '4550( \w{4}\s*){12}'` 2>/dev/null&&{ test ${a: -4} = 10b &&l="$l$f "; }
		# }
	# fi
	# mv -bv $l $f
# else	mv -bv "$@"
# fi
# }
