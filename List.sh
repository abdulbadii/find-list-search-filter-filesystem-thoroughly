fd(){
	f=`file $3`
	e=`echo $f|sed -E 's/[^:]+:\s+\S+\s+(\S+(\s+\S+){2}).+/\1/;s/Intel$/32bit/'`
	if [[ $e =~ ^execu ]];then echo $e
	else echo $f|sed -E 's/[^:]+:\s*(.+)/\1/';fi
	(($2))&&ldd $3 2>/dev/null |sed -Ee 's/[^>]+>(.+)\s+\(0.+/\1/ ;1s/.*/DEP:&/ ;1! s/.*/    &/'
}

li(){
[[ ${@:1} =~ ^\.$ ]] &&{ find ~+ -type f; return; }
[[ ${@:1} =~ ^/$ ]] &&{ find ~+ \! -ipath ~+ -type d -printf $r/\\n ; return; }
unset a E opt O p P N u w y d i et
r=%p
for e
{
((i++))
case $e in
-h|--help) find --help; return;;
-d) d=1;;
-i) I=1;;
-[0-9]*) y=-maxdepth\ ${e:1};;
-E|-re) E=1;;
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

A=`history 1`
set -f
A=${A# *[0-9]*  *$xt }
A=${A%% [12]>*}
A=${A%%[>&|<]*}

D="-type d -printf \"$r/\n\""
F="-type f -printf \"$r\n\""
[[ $A =~ ^[\ \t]*$ ]] &&{ eval "find ~+ \! -ipath ~+ $opt $D -o $F"; set +f;return; }

eval set -- "${A//\\/\\\\}"
IFS=$'\n'
for a
{
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
				return
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
		return
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
