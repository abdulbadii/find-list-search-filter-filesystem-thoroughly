Click, copy "list.sh"  above, then paste, prepend the Bash functions inside to ~/.bashrc file   
Should copy too is running the InstallUpdate2.bashrc.sh script     

"list-su.sh" differs only in having superuser request (sudo-prefixed command), however it cannot be applied with in, de option   

Find and list specific file, directory, link or any filesystem type recursively while keep utilizing "find" utility useful options   

Would print its  <pre> 
- Size								-z   
- Last modification time					-t   
- Information on file found (whether 64/32 bit binary etc)	-in   
- Dependencies of file found in one level depth			-de   
</pre>
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
Most of #### find 'test' options may also be passed here, below is its manual excerpt    

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

$ l \\/   
list every filesystem type under "/" (root) directory entirely, the preceding \\ (may be put as \\\\ too) is to differentiate it with second use above: list every directory under current directory   

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
	/usr/\*/lib   
	/usr/\*/\*/lib   
	/usr/\*/\*/\*/lib   
	or same as shell globstar: 	/usr/\*\*/lib   
So prefixing the relative path with ./ to become l ./lib, will ensure only search /usr/lib (the first one)  

$ cd /qt   
$ l core/meta   

will find one e.g:   
/qt/src/dev/core/meta   

while   
$ l ./core/meta   
will not find it since there is no /qt/core/meta    

In this way of having relative path explicitly referred i.e. there's no any wildcard in the string, while searching and a directory is found in current working dir (exactly in this place), then the entire directory content will automatically be shown, on else deeper depth findings it will just list them as normally.      
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

Below is to search for o, c and so type files everywhere under usr directory path on root, separated by separator \\\\\\\\ in a single line   
$ li /usr/**.o\\\\**.c\\\\**.so   

To change separator other than \\\\ use -sep= option   
-sep={any 1 or 2 characters not being regarded as special ones by Bash}. E.g. -sep=,,   

Can search in  POSIX extended regular expression by enclosing it with ' ' and preceding it with -E option   
$ l -E '/a/*/m\w{1,2}\\.[c-h]'   

The most usefull and powerful feature of this tool are its recognized standard format of input and output which could be used/piped as input of another tool, and the -x (or-xs for case-sensitive) exclusion option for excluding some certain files or paths from the main result paths  
E.g. search under "lib" being under "dev" being under "qt" dir. instead of in "src" or "core", any "c" file:   

$ l /qt/src/../dev/core/../lib/*.c   
/qt/dev/lib/main.c   
/qt/dev/lib/edit.c   
/qt/dev/lib/clear.c   

And the result is recognizable as absolute path surronded by '' if it contains space, which is ready to be piped correctly by \|xargs ...    

the below will search such above with additional stricter filter that is the one without letter "e" in all "c" files found:   

$ l -c5h-   
   find object created more than or equal to 5 hours ago  
$ l -a5h-7h   
   find object accesed between 5 and 7 hours ago inclusively  
$ l -m-5   
   find object modified between today and 5 days ago inclusively  

## EXCLUSION







"find" filter options    
  Note if a number n specified   
     +n     for greater than    
     -n     for less than    
      n      for exactly    

-amin    
       File was last accessed n minutes ago   
-anewer fil   
        File was last accessed more recently than file was modified.   If  fil   
        is a symbolic link and the -H option or the -L option is in effect, th   
        access time of the file it points to is always used   
 -atime    
        File was last accessed n*24 hours ago.  When find figures out how  man   
        24-hour  periods ago the file was last accessed, any fractional part i   
        ignored, so to match -atime +1, a file has to  have  been  accessed  a   
        least two days ago   

 -cmin    
        File's status was last changed n minutes ago   

 -cnewer fil   
        File's  status  was  last changed more recently than file was modified   
        If file is a symbolic link and the -H option or the  -L  option  is  i   
        effect, the status-change time of the file it points to is always used   

 -ctime    
        File's  status  was  last changed n*24 hours ago.  See the comments fo   
        -atime to understand how rounding affects the  interpretation  of  fil   
        status change times   

 -empty File is empty and is either a regular file or a directory   

 -executable   
        Matches files which are executable and directories which are searchabl   
        (in a file name resolution sense).  This takes into account access con   
        trol  lists  and  other  permissions  artefacts  which  the  -perm tes   
        ignores.  This test makes use of the access(2) system call, and so  ca   
        be  fooled  by  NFS  servers  which do UID mapping (or root-squashing)   
        since many systems implement access(2) in the client's  kernel  and  s   
        cannot  make  use  of  the  UID mapping information held on the server   
        Because this test is based only on the result of the  access(2)  syste   
        call,  there  is  no guarantee that a file for which this test succeed   
        can actually be executed   

 -false Always false   

 -fstype typ   
        File is on a filesystem of type type.  The valid filesystem types  var   
        among  different  versions  of  Unix;  an incomplete list of filesyste   
        types that are accepted on some version of Unix  or  another  is:  ufs   
        4.2,  4.3,  nfs, tmp, mfs, S51K, S52K.  You can use -printf with the %   
        directive to see the types of your filesystems   

 -gid n File's numeric group ID is n   

 -group gnam   
        File belongs to group gname (numeric group ID allowed   
 -inum    
        File has inode number n.  It is normally easier to  use  the  -samefil   
        test instead   
 -links    
        File has n links   

 -mmin    
        File's data was last modified n minutes ago   

 -mtime    
        File's data was last modified n*24 hours ago.   See  the  comments  fo   
        -atime  to  understand  how rounding affects the interpretation of fil   
        modification times   
 -newer fil   
        File was modified more recently than file.  If file is a symbolic  lin   
        and  the -H option or the -L option is in effect, the modification tim   
        of the file it points to is always used   

 -newerXY referenc   
        Succeeds if timestamp X of the file  being  considered  is  newer  tha   
        timestamp  Y of the file reference.   The letters X and Y can be any o   
        the following letters   

        a   The access time of the file referenc   
        B   The birth time of the file referenc   
        c   The inode status change time of referenc   
        m   The modification time of the file referenc   
        t   reference is interpreted directly as a tim   

        Some combinations are invalid; for example, it is invalid for X  to  b   
        t.  Some combinations are not implemented on all systems; for example    
        is not supported on all systems.  If an invalid or unsupported combina   
        tion  of  XY  is specified, a fatal error results.  Time specification   
        are interpreted as for the argument to the -d option of GNU  date.   I   
        you  try  to use the birth time of a reference file, and the birth tim   
        cannot be determined, a fatal error message results.  If you specify     
        test  which refers to the birth time of files being examined, this tes   
        will fail for any files where the birth time is unknown   

 -nogrou   
        No group corresponds to file's numeric group ID   

 -nouse   
        No user corresponds to file's numeric user ID   

 -perm mod   
        File's permission bits are exactly mode (octal or symbolic).  Since  a   
        exact  match  is  required,  if  you want to use this form for symboli   
        modes, you may have to specify a rather complex mode string.  For exam   
        ple  `-perm  g=w'  will only match files which have mode 0020 (that is   
        ones for which group write permission is the only permission set).   I   
        is  more  likely  that  you  will want to use the `/' or `-' forms, fo   
        example `-perm -g=w', which matches any file with group  write  permis   
        sion.  See the EXAMPLES section for some illustrative examples   

 -perm -mod   
        All  of  the permission bits mode are set for the file.  Symbolic mode   
        are accepted in this form, and this is usually the  way  in  which  yo   
        would  want to use them.  You must specify `u', `g' or `o' if you use    
        symbolic mode.   See the EXAMPLES section for some  illustrative  exam   
        ples   

 -perm /mod   
        Any  of  the permission bits mode are set for the file.  Symbolic mode   
        are accepted in this form.  You must specify `u', `g' or `o' if you us   
        a  symbolic mode.  See the EXAMPLES section for some illustrative exam   
        ples.  If no permission bits in mode are set,  this  test  matches  an   
        file  (the  idea  here  is to be consistent with the behaviour of -per   
        -000)   
 -readabl   
        Matches  files which are readable.  This takes into account access con   
        trol lists  and  other  permissions  artefacts  which  the  -perm  tes   
        ignores.   This test makes use of the access(2) system call, and so ca   
        be fooled by NFS servers which  do  UID  mapping  (or  root-squashing)   
        since  many  systems  implement access(2) in the client's kernel and s   
        cannot make use of the UID mapping information held on the server   
 -samefile nam   
        File refers to the same inode as name.   When -L is in effect, this ca   
        include symbolic links   

 -size n[cwbkMG   
        File uses n units of space, rounding up.  The following suffixes can b   
        used   

        `b'    for 512-byte blocks (this is the default if no suffix is used   

        `c'    for byte   

        `w'    for two-byte word   

        `k'    for Kilobytes (units of 1024 bytes   

        `M'    for Megabytes (units of 1048576 bytes   

        `G'    for Gigabytes (units of 1073741824 bytes   

        The  size  does  not count indirect blocks, but it does count blocks i   
        sparse files that are not actually allocated.  Bear in  mind  that  th   
        `%k'  and `%b' format specifiers of -printf handle sparse files differ   
        ently.  The `b' suffix always denotes 512-byte blocks and never 1 Kilo   
        byte  blocks,  which is different to the behaviour of -ls.  The + and    
        prefixes signify greater than and less than, as usual, but bear in min   
        that  the  size is rounded up to the next unit (so a 1-byte file is no   
        matched by -size -1M)   

 -true  Always true   

 -type    
        File is of type c   

        b      block (buffered) specia   

        c      character (unbuffered) specia   

        d      director   

        p      named pipe (FIFO   

        f      regular fil   
        l      symbolic link; this is never true if the -L option or the  -fol   
               low option is in effect, unless the symbolic link is broken.  I   
               you want to search for symbolic links when -L is in effect,  us   
               -xtype   
        s      socke   
        D      door (Solaris   

 -uid n File's numeric user ID is n   
 -used    
        File was last accessed n days after its status was last changed   
 -user unam   
        File is owned by user uname (numeric user ID allowed)   
 -wholename patter   
        See -path.  This alternative is less portable than -path   
 -writabl   
        Matches  files which are writable.  This takes into account access control lists  and  other  permissions  artefacts  which  the  -perm  tes   
        ignores.   This test makes use of the access(2) system call, and so ca   
        be fooled by NFS servers which  do  UID  mapping   
 -xtype    
        The same as -type unless the file is a  symbolic  link.   For  symboli   
        links: if the -H or -P option was specified, true if the file is a lin   
        to a file of type c; if the -L option has been given, true if c is `l'   
        In  other words, for symbolic links, -xtype checks the type of the fil   
        that -type does not check   
 -context patter   
        (SELinux only) Security context of the file matches glob pattern   
