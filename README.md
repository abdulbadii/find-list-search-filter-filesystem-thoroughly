Click, copy "list.sh"  above, then paste, prepend the Bash functions inside to ~/.bashrc file   
Should copy too is running the InstallUpdate2.bashrc.sh script     

"list-su.sh" differs only in having superuser request (sudo-prefixed command), however it cannot be applied with in, de option   

Find and list specific file, directory, link or any filesystem type recursively while keep utilizing "find" utility useful options   
Would print its
<pre>- Size								-z   
- Last modification time						-t   
- Information on file found (whether 64/32 bit binary etc)	-in   
- Dependencies of file found in one level depth			-de</pre>
To narrow down search   
<pre>
- To find only directory, file, executable or link type, suffix it with /, //, /// or ////    
- To have better control by regular expression				-E or -re   
- To search in case sensitive		-cs or -s .Defaults to insensitive ( -ci option)   
- To filter out i.e. exclude certain path from the main find search result  
- to filter by creation, acces or, modification pass time, use -c, -a, -m as easier use than find's, e.g.   
		-c7m last creation equals to 7 minute being rounded up     
    -a-7m last access is less than or equal to 7 minute   
    -m7d- last modification is more than or equals to 7 days   
    -c7-10 last creation is between 7 to 10 minutes inclusively. No unit means in minute   
- to filter by size in byte, kibi-, mebi- and gibi- byte unit which has simpler command than find's, e.g.   
		-s7m (or M) size equals to 7 mebibiytes being rounded up  
    -s-7g (or G) size is less than or equal to 7 gibibytes   
    -s7b- size is more than or equals to 7 blocks (7 times 512-bytes)   
    -s7-10 size is between 7 to 10 kibibyte inclusively. No unit means in kibibyte 
    -s70c-50 size is between 70 byte to 50 kibibyte inclusively 
- To filter certain depths :		-1..99[-1..99], e.g.   
	l /usr -5  : search only up to 5th depths counted from /usr dir.
	l -5-7  : search only within the 5th to 7th depths counted from current dir.
	l -7.  : search in the exact 7th depths counted from current dir.
	l -5-  : search in the 5th depths and deeper to the last, counted from current dir.
</pre>
Most of `find` test or action options may also be passed and made use of   

Simply type l   
$ l   
list every file, directory, and other kind of filesystem under current directory entirely   
$ l /   
list every directory under current directory entirely   
$ l //   
list every file only under current directory, so on.   

So it suggests:
just put suffix / to search for directory only,   
or put suffix // to search for file only,   
or put suffix /// to search for executable binary only 
or put suffix //// to search for link only   

$ l \\\\/   
list every filesystem type under "/" (root) directory entirely, the preceding \\\\ is to differentiate it with second use above: list every directory under current directory   

As absolute path, it always searchs in directories depths as explicitly specified, either with or without wildcard such as:   

/qt/build/core/meta   
means searching for any object type namedly "meta" under "core under "build" in "qt" directory   

/qt/\*/\*/core/meta   
search for any file type "meta" under "core" dir. being under any directory being under any directory under "qt" directory on top/root of filesystem.   

To search somewhere deeper than such up to maximum, add "\*\*", double wildcard asterisks, in the context of intended depth, e.g.   
$ l /qt/\*/\*/core/\*\*/meta   

Will find   
/qt/src/dev/core/meta   
/qt/src/dev/core/c/meta   
/qt/src/doc/core/build/meta   
/qt/lib/so/core/c/obj/meta   
/qt/lib/so/core/src/c/obj/meta  

will search in two plies depth between "qt" and "core" directory, and indefinite number of ply depth between "core" and "meta" directory   

If navigating in way of relative path i.e. not started with slash character (/), then the given relative path will always be searched anywhere in any depth of under current directory, does not have to be directly on current directory.   
To limit the search on current directory only, precede (prefix) it with ./   

Suppose previous explicit part of path exists only where it's specified i.e. "meta" exists only under "core" directory being under any directory being under any dir. under qt directory.   

Prefixing a relative path with ./ characters will search for at current dir., i.e. as if the CLI path is concatenated directly to current dir. Defaults to have recursive in between. E.g. if current working dir. is /usr,   

	l lib   

	should mean, in way of shell global star, searching for:
	/usr/lib   
	/usr/*/lib   
	/usr/*/*/lib   
	/usr/*/*/*/lib   
	or as shell globstar: 	/usr/**/lib   
So prefixing the relative path with ./ to become l ./lib, will ensure only search /usr/lib (the first one)  

$ cd /qt   
$ l core/meta   

will find one e.g:   
/qt/src/dev/core/meta   

while   
$ l ./core/meta   
will not find it since there is no /qt/core/meta    

In this way of having relative path explicitly stated, i.e. there's no any wildcard in the string, if being searched a directory is found in current working dir (exactly there), then the entire directory content will automatically be shown, otherwise on else place in deeper depth, it will just list them out normally.      
If this purpose is needed in another way of path mentioned above, put -l option in order to show first depth content of any directory found in wildcard pattern or some depth searches   
To have it shown more certain depth add the number, -l3 option will show to 3 directory plies of every  directory found and to show entirely put number 0, e.g. l -l0 lib* 

Control the limited search depth by option -1..99[-1..99],  e.g:
   
search for only on current directory and one below it put -2   
$ l -2   

to search for only from 3rd ply from current up to 5th    
$ l -3-5 src/dev   

to search for only from 5th ply of current directory until the last, under src/dev dir. relative to PWD, of size between 40 and 50 kibibyte inclusively:   

$ l -5- -s40-50 src/dev   

can be navigated by way of one-line multiple paths such as absolute followed by relative path      

$ l /qt/\*/\*/core/\*\*/meta  usr/src/\*.c   tmp/\*.o var/\*.etc

can even invoked as multiple object name of the same first directory path   
this will search for /qt/src/dev/\*.h and /qt/src/dev/\*.c and /qt/src/dev/\*.cp    
$ cd /qt
$ l src/dev/*.h\\\\\*.c\\\\\*.cpp   

Below is to search for o, c and so type files everywhere under usr directory path on root, each must be separated by separator \\\\\\\\ in a row   
$ l /usr/\*\*.o\\\\\*\*.c\\\\\*\*.so   

To change separator other than \\\\ use -sep= option   
-sep={any 1 or 2 characters not being regarded special by Bash}. E.g. -sep=,, or sep=:   

Can search in POSIX-extended regular expression by -E or -re option   
$ l -E '/a/*/m\w{1,2}\\.[c-h]'   

One of the most useful and powerful feature of this tool are its recognized standard format of input and output which could be used/piped as input of another tool, and the -x (or-xs for case-sensitive) exclusion option for excluding some certain files or paths from the main result paths  
E.g. search under "lib" being under "dev" being under "qt" dir. instead of in "src" or "core", any "c" file:   

$ l /qt/src/../dev/core/../lib/*.c\\*.cpp\\*.o   
/qt/dev/lib/main.c   
/qt/dev/lib/edit.c   
/qt/dev/lib/clear.c   
/qt/dev/lib/main.cpp   
/qt/dev/lib/edit.cpp   

And the result is recognizable as absolute path, surronded by '' if it contains space, which is ready to be piped correctly by \|xargs ...    

$ l -c-5   
   find object created less than orequal to 5 minutes ago. No unit defaults to be in minute  
$ l -c5h-   
   find object created more than or equal to 5 hours ago  
$ l -a5h-7h   
   find object accesed between 5 and 7 hours ago inclusively  
$ l -m-5d   
   find object modified between today and 5 days ago inclusively  

## EXCLUSION

Another most useful and powerful feature is the exclusion from the main result found. It's done by specifiying path and/or pattern in `-x=` option 




