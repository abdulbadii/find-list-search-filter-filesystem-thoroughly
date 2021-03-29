Run the InstallUpdate2.bashrc.sh to quickly copy **list.sh** above to ~/.bashrc    
Should do too, clicking it, copy Bash functions inside and then paste it into ~/.bashrc   
**list-su.sh** differs only in having superuser request: `sudo` command prefix, but it cannot be applied with -de and -i option   

Find and list specific file, directory, link or any filesystem type recursively while keep utilizing most`find` test and action options that may be passed and made use of
## Requirement  
  - Bash (tested/developed using version 5)
  - Find (Linux utility, tested/developed using GNU findutils 4.6)
  - The default settings of history.  
     It is enabled and not prevented by HISTIGNORE variable value having this tool/function name. So not screwing up this default settings is required. If any single letter needs to be prevented from command history saving, exclude this tool name, e.g.  
     `HISTIGNORE=[!l]`
     when **l** for this function name
  - Optional, as required by optional feature:
    - `file` needed for -i (information) option 
    - `ldd` needed for -de (dependencies) option 
## Limitation  
  - Can't be used multiply in one-liner shell script only the first invocation can work  
  - Can't be used as alias  
  - Default setting globstar is off must not be changed by `shopt -s globstar` as it'd cause inefficiency in `**` wildcard path search of which otherwise search pattern invocation is completely fine

Simply type:   
$ l   
list every file, directory, and other kinds of filesystem under current directory entirely   
$ l /   
list every directory only under current directory recursively   
$ l //   
list every regular file only under current directory, etc, which suggests:  
put suffix / to search for directory only,  
put suffix // to search for file only,   
put suffix /// to search for executable file only  
put suffix //// to search for link only   

$ l \\\\/   
list any filesystem type under **/** (root) directory entirely, the prefixed **\\\\** is to differentiate it from second usage above: list every directory type under current directory   

 To narrow down search:   
<pre>
- To find only directory, file, executable, or link type, suffix path with /, //, /// or ////    
- To get better control in search by using regular expression  
- To search in case sensitive. (Defaults to insensitive)   
- to filter by last creation, acces or modification time, use -c, -a, -m an easier use than find (the found number is rounded up to the given)   
	-a-7m last access is less than or equal to 7 minutes ago   
	-c7d last creation equals to 7 days ago  
	-m7d- last modification is more than or equals to 7 days ago   
	-c7-10 last creation is between 7 to 10 minutes inclusively. No unit means in minute   
	-c5-  find object created more than or equal to 5 minutes ago  
	-a5h-7h  find object accesed between 5 and 7 hours ago inclusively  
	-m-5d  find object modified 5 days ago or earlier  
	-m5d   find object modified exactly 5 days ago
- to filter by size in byte, kibi-, mebi- and gibi- byte unit which has simpler command than find's   
	-s7m (or M): size equals to 7 mebibiytes being rounded up  
	-s-7g (or G): size is less than or equal to 7 gibibytes   
	-s7b- : size is more than or equals to 7 blocks (7 times 512-bytes)   
	-s7-10 : size is between 7 to 10 kibibyte inclusively. No unit means in kibibyte 
	-s70c-50 : size is between 70 byte to 50 kibibyte inclusively 
- To filter certain depths :		-1..99[-1..99][r|/], e.g.   
	$ l -5 /usr	: search up only to 5th depths based on /usr dir.
	$ l -5-7	: search only within the 5th to 7th depths of current dir.
	$ l -7.		: search in the exact 7th depths from current dir.
	$ l -5- /usr : search in the 5th depth or deeper up to the last, counted from /usr dir.
	Suffix it with r e.g. l -1r,  would search depth in reverse direction (or / instead of r)
	$ l -1r /usr : or
	$ l -1/ /usr : search in the last directory in depth of /usr dir.
	$ l -3r /usr : search in the last 3 plies up from the max depth of /usr dir.
	$ l -4.r /usr : search exactly in 4 plies before the last depth of /usr dir.
- To filter out by path name i.e. to exclude certain path(s) from the main search result using -x=   
</pre>

The absolute path-input search, will target in the directory depth as explicitly specified, either with or without wildcard such as:   

l /qt/build/core/meta   
means searching for any object type namedly **meta** under **core** under **build** within **qt** directory in root dir., or e.g:   

/qt/\*/\*/core/\*.c//   
search for a regular file type only having extension name ".c" under **core** directory under any directory being under any directory under **qt** directory in root of filesystem.   

To search somewhere deeper up to maximum, add **\*\*** i.e. double wildcard asterisks, in the context of depth intended, e.g:   
$ l /qt/\*/\*/core/\*\*/meta   

Will find   
/qt/src/dev/core/meta   
/qt/src/dev/core/c/meta   
/qt/src/doc/core/c/build/meta   
/qt/lib/sys/core/c/obj/meta   
/qt/lib/sys/core/src/c/obj/meta  

Will search exactly two plies depth between **qt** and **core** directory, and indefinite number of ply between **core** and **meta** directory   

If navigating in way of relative path, i.e. not started with **/**, a slash character, then the given relative path will always be searched anywhere in any depth of under current directory, does not have to be directly on current directory.   
To limit the search on current directory only, precede (prefix) it in the start with **./**   

Suppose previous explicit part of path exists only where it's specified i.e. **meta** exists only under **core** directory being under any directory being under any dir. under qt directory.   

Prefixing a relative path with ./ characters will search for at current dir. only as if the CLI path is concatenated directly to current dir.   

$ cd /qt   
$ l core/meta   

Would find, e.g:   
/qt/src/lib/core/meta   
/qt/dev/src/lib/core/meta   

$ l ./core/meta   
will not find it since there is no **/qt/core/meta**   

More, use shell global star analogy as it's set by `shopt -s globstar`  
 if current working dir. is **/usr** and we do:   
	$ l lib   

Defaults to search recursively under **/usr**, so it'd mean searching for:   
	/usr/lib   
	/usr/\*/lib   
	/usr/\*/\*/lib   
	/usr/\*/\*/\*/lib  
	...so on till the max depth, or in way of shell global star:  
	/usr/\*\*/lib   
So prefixing the relative path with **./** to be **l ./lib**, will ensure only search /usr/lib the first above  

In this way of having relative path explicitly put i.e. there's no wildcard in the string, if searching and matches **a directory** in current working dir, precisely there, then the directory content all will entirely be listed automatically, when it'll be otherwise listed itself in else deeper place regardless of its type.      
If such need arise otherwise way of path specification above; i.e. searching by wildcard pattern or some depth searches, put -l option or -l followed by number of depth of directory found.   
E.g to have it shown more certain depth add the number, -l3 option will show to 3 directory plies for every  directory found and to show entirely put number 0, e.g. l -l0 lib* 

Control the limited search depth by option -1..99[-1..99],  e.g:
   
To search only on current directory and another one below it, put -2   
$ l -2   

To search for only from 3rd ply from current up to 5th    
$ l -3-5 src/dev   

to search only from 5th ply of current directory until the last, under src/dev dir. relative to PWD, of size between 40 and 50 kibibyte inclusively:   

$ l -5- -s40-50 src/dev   

can be navigated by way of one-line multiple paths such as absolute followed by relative path      

$ l /qt/\*/\*/core/\*\*/meta  usr/src/\*.c   tmp/\*.o var/\*.etc

can even invoked as multiple object/item names of the same first directory path, each must be separated by separator \\\\\\\\ in a row.   
e.g. this will search for /qt/src/dev/\*.h, /qt/src/dev/\*.c, /qt/src/dev/\*.cp  and /qt/src/dev/\*.cs    
$ cd /qt
$ l src/dev/*.h\\\\\*.c\\\\\*.cpp\\\\.cs   

To change separator to other than **\\\\**, use **-s=** option, it'd be any one or two characters (no guaranteed it has robust consisent result if the character(s) are regarded as special one by Bash)   
E.g. below is to search for o, c and so type files everywhere under usr directory path   
$ l -s=: /usr/\*/\*.o:\*.c:\*.so   

Can search in POSIX-extended regular expression by `-E` or `-re` option e.g.   
$ l -E '/a/*/m\w{1,2}\\.[c-h]'

Printout option:  
<pre>- Size					-s   or with extra info: -ls  (similar to command ls -l)
- Last modification, change/creation, and access date time   -m, -c, -a  
- Last modification, change/creation, and access hour time   -mh, -ch, -ah  
- Information on the file found (whether 64/32 bit binary etc)	-i  
- Dependencies of file found in one level depth			-de</pre>

One of the most useful feature of this tool are its widely recognized, standard format of both the input and output which could later be used or piped as input of another utility, and the -x (or-xs for case-sensitive) exclusion option for excluding some certain files or paths from the main result paths  
E.g. search under **lib** being under **dev** being under **qt** dir. instead of in **src** or **core**, any **c** file:   

$ l /qt/src/../dev/core/../lib/*.c\\\\*.cpp\\\\*.o   
/qt/dev/lib/main.c   
/qt/dev/lib/edit.c   
/qt/dev/lib/clear.c   
/qt/dev/lib/main.cpp   
/qt/dev/lib/edit.o  

And the result is recognizable as absolute path, surronded by single quote ('') if it contains space, which is ready to be piped correctly by **\| xargs** ...  

## AUTOMATED REMOVAL

Removal is readily guarded nicely. One needn't to test it first by a usual search without removal options below, instead go straight using it as it'll prompt user to confirm to execute the deletion as final decision, if there is a find result   
<pre>-0    :  to remove every zero size file and empty directory sits under any directory found in the main search result
-no  :  to remove all orphan links  sits under any directory found in the main search result
-rm  or -delete : to remove all objects of the main find result</pre>

## EXCLUSION

Another most useful and powerful feature is the exclusion from the main result found. It's done by specifiying path and/or pattern in `-x=` option 

...wrting is being edited, for now just go on using `-x=` {search pattern}



