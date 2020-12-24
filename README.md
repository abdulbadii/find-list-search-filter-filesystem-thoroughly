Run InstallUpdate2.bashrc.sh script to quickly copy **list.sh** above to ~/.bashrc    
Should do too is clicking it, and copy Bash functions inside then paste, prepend to ~/.bashrc   
**list-su.sh** differs only in having superuser request; `sudo` command prefix. However it cannot be applied with -in, -de option   

Find and list specific file, directory, link or any filesystem type recursively while keep utilizing **find** utility useful options. The options to print out found file's:  
<pre>- Size								-z   
- Last modification time					-t   
- Information on file found (whether 64/32 bit binary etc)	-in   
- Dependencies of file found in one level depth			-de</pre>
To narrow down search   
<pre>
- To find only directory, file, executable or link type, suffix path with /, //, /// or ////    
- To have better control by regular expression				-E or -re   
- To search in case sensitive			-cs. (Defaults to insensitive, -ci)   
- to filter by creation, acces or, modification pass time, use -c, -a, -m an easier use than find (the found number is rounded up to the given)   
	-a-7m last access is less than or equal to 7 minutes ago   
	-c7d last creation equals to 7 days ago  
	-m7d- last modification is more than or equals to 7 days ago   
	-c7-10 last creation is between 7 to 10 minutes inclusively. No unit means in minute   
- to filter by size in byte, kibi-, mebi- and gibi- byte unit which has simpler command than find's   
	-s7m (or M): size equals to 7 mebibiytes being rounded up  
	-s-7g (or G): size is less than or equal to 7 gibibytes   
	-s7b- : size is more than or equals to 7 blocks (7 times 512-bytes)   
	-s7-10 : size is between 7 to 10 kibibyte inclusively. No unit means in kibibyte 
	-s70c-50 : size is between 70 byte to 50 kibibyte inclusively 
- To filter certain depths :		-1..99[-1..99][r|/], e.g.   
	l -5 /usr	: search only up to 5th depths counted from /usr dir.
	l -5-7	: search only within the 5th to 7th depths of current dir.
	l -7.		: search in the exact 7th depths from current dir.
	l -5- /usr : search in the 5th depth or deeper up to the last, counted from /usr dir.
	Suffix it with r e.g. l -1r  is depth in reverse direction (or / for r)
	l -1r /usr :
	l -1/ /usr : search in the last/deepest depth of /usr dir.
	l -3r /usr : search in 3 plies before the last up to the last depth of /usr dir.
	l -4.r /usr : search exactly in 4 plies before the last depth of /usr dir.
- To filter out by path name i.e. to exclude certain path(s) from the main search results -x=   
</pre>
Most of `find` test or action options may also be passed and made use of   

Simply type l   
$ l   
list every file, directory, and other kind of filesystem under current directory entirely   
$ l /   
list just directory type under current directory recursively   
$ l //   
list every regular file only under current directory... so on, which suggests:  
put suffix / to search for directory only,  
put suffix // to search for file only,   
put suffix /// to search for executable file only  
or put suffix //// to search for link only   

$ l \\\\/   
list any filesystem type under "/" (root) directory entirely, the prepended \\\\ is to differentiate it with second usage above: list every directory type under current directory   

As absolute path, it always searchs in directories depths as explicitly specified, either with or without wildcard such as:   

l /qt/build/core/meta   
means searching for any object type namedly **meta** under **core** under **build** within **qt** directory in root dir.   

/qt/\*/\*/core/\*.c//   
search for any file having extension name ".c" under **core** directory under any directory being under any directory under **qt** directory on root of filesystem.   

To search somewhere deeper than such up to maximum, add "\*\*", double wildcard asterisks, in the context of intended depth, e.g.   
$ l /qt/\*/\*/core/\*\*/meta   

Will find   
/qt/src/dev/core/meta   
/qt/src/dev/core/c/meta   
/qt/src/doc/core/build/meta   
/qt/lib/sys/core/c/obj/meta   
/qt/lib/sys/core/src/c/obj/meta  

I.e. it will search in two plies depth between **qt** and **core** directory, and indefinite number of ply depth between **core** and **meta** directory   

If navigating in way of relative path i.e. not started with slash character (/), then the given relative path will always be searched anywhere in any depth of under current directory, does not have to be directly on current directory.   
To limit the search on current directory only, precede (prefix) it with ./   

Suppose previous explicit part of path exists only where it's specified i.e. **meta** exists only under **core** directory being under any directory being under any dir. under qt directory.   

Prefixing a relative path with ./ characters will search for at current dir., i.e. as if the CLI path is concatenated directly to current dir.   

$ cd /qt   
$ l core/meta   

Would find, e.g:   
/qt/src/dev/core/meta   

$ l ./core/meta   
will not find it since there is no /qt/core/meta    

More e.g. if current working dir. is **/usr**,   
	l lib   

Defaults to search recursively under **/usr**, so it'd mean (in way of shell global star) searching for:   
	/usr/lib   
	/usr/*/lib   
	/usr/*/*/lib   
	/usr/*/*/*/lib   
	or as shell globstar: 	/usr/**/lib   
So prefixing the relative path with ./ to become l ./lib, will ensure only search /usr/lib (the first)  

In this way of having relative path explicitly stated, i.e. there's no any wildcard in the string, if being searched and a **directory is found** in current working dir (precisely there), then that directory content entirely will be listed automatically, while otherwise place in deeper depth, it'll be just listed normally regardless of the type.      
If this purpose is needed in another way of path specification mentioned above, ie. in wildcard pattern or some depth searches, put -l option or -l followed by number of depth contained in a directory found.   
E.g to have it shown more certain depth add the number, -l3 option will show to 3 directory plies of every  directory found and to show entirely put number 0, e.g. l -l0 lib* 

Control the limited search depth by option -1..99[-1..99],  e.g:
   
search for only on current directory and one below it put -2   
$ l -2   

to search for only from 3rd ply from current up to 5th    
$ l -3-5 src/dev   

to search only from 5th ply of current directory until the last, under src/dev dir. relative to PWD, of size between 40 and 50 kibibyte inclusively:   

$ l -5- -s40-50 src/dev   

can be navigated by way of one-line multiple paths such as absolute followed by relative path      

$ l /qt/\*/\*/core/\*\*/meta  usr/src/\*.c   tmp/\*.o var/\*.etc

can even invoked as multiple object/item names of the same first directory path, each must be separated by separator \\\\\\\\ in a row.   
e.g. this will search for /qt/src/dev/\*.h, /qt/src/dev/\*.c, and /qt/src/dev/\*.cp    
$ cd /qt
$ l src/dev/*.h\\\\\*.c\\\\\*.cpp   

To change separator other than \\\\ use **-sep=** option, it'd be any 1 or 2 characters (not guaranteed being robust if it's regarded as special one by Bash)   
Below is to search for o, c and so type files everywhere under usr directory path   
$ l  sep=:: /usr/\*\*.o::*\*.c::*\*.so   

Can search in POSIX-extended regular expression by -E or -re option   
$ l -E '/a/*/m\w{1,2}\\.[c-h]'   

One of the most useful feature of this tool are its recognized standard format of both input and output which could be used/piped as input of another utility, and the -x (or-xs for case-sensitive) exclusion option for excluding some certain files or paths from the main result paths  
E.g. search under **lib** being under **dev** being under **qt** dir. instead of in **src** or **core**, any **c** file:   

$ l /qt/src/../dev/core/../lib/*.c\\*.cpp\\*.o   
/qt/dev/lib/main.c   
/qt/dev/lib/edit.c   
/qt/dev/lib/clear.c   
/qt/dev/lib/main.cpp   
/qt/dev/lib/edit.cpp   

And the result is recognizable as absolute path, surronded by '' if it contains space, which is ready to be piped correctly by **\| xargs** ...    

$ l -c-5   
   find object created less than or equal to 5 minutes ago. No unit defaults to be in minute  
$ l -c5-   
   find object created more than or equal to 5 minutes ago  
$ l -a5h-7h   
   find object accesed between 5 and 7 hours ago inclusively  
$ l -m-5d   
   find object modified 5 days ago or earlier   
$ l -m5d   
   find object modified exactly 5 days ago   

## EXCLUSION

Another most useful and powerful feature is the exclusion from the main result found. It's done by specifiying path and/or pattern in `-x=` option ...

.......is being edited and worked



