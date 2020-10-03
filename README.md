Click, copy "list.sh"  above, then paste, prepend the Bash functions inside to ~/.bashrc file   
the "list-su.sh" differs only in having superuser request (sudo prefixed command) but not if using -d, -i option   

Find and list specific file, directory, or link recursively while keep utilizing "find" utility useful options   

Would print its:
- Size                                             -s
- Last modification time                        -t
- Information on file found (whether 64/32 bit binary etc)    -i
- Dependencies of file found in one level depth             -d

Would narrow down search:
- Limit to find only directory or file or link type :    suffix the object with / . or \
- Limit to certain depth only :                  -1...9 or prefix with ./ as one depth
- In greater control by regular expression      -E
- All the 'Test' option of 'find' test option  -   (below some excerpt of its manual for options)

Simply type l   
$ l   
list every file, directory, and other kind of filesystem under current directory entirely   

$ l /   
list every directory only under current directory entirely   

$ l //  
list every files only under current directory   

$ l ///   
list every links only under current directory   

It tells us that just put suffix / to mean searching for directory only,   
put suffix // to mean searching for file only,   
put suffix /// to mean searching for link only.  

$ l \\/   
list every filesystem type under / (root) directory entirely, the preceding \\ is to differentiate it with second use above: list every directory only under current directory   

$ l -s -i *.bin   
query any object having 'bin' name suffix then list it with the size and file information under current directory entirely    

$ l  -t ./*.bin.   
list every file only (excluding others) having type name 'bin' on this directory only, with the last modification   

It always searchs up to directories depths given explicitly, either with or without wildcard, on path such:   

/qt/\*/\*/core/meta   
means to search for any file type "meta" under "core" dir. being under any directory being under any directory under "qt" directory on top/root of filesystem.   

To search somewhere deeper than such up to maximum, add "\*\*", double wildcard asterisks, in the context of intended depth ply e.g.   
$ l /qt/\*/\*/core/\*\*/meta   

Will find   
/qt/src/lib/core/meta   
/qt/src/lib/core/c/meta   
/qt/src/lib/core/cc/meta   
/qt/src/lib/core/c/obj/meta   
/qt/lib/so/core/src/c/obj/meta
so on... with indefinite number of depth ply between "qt" and "core" directory, and between it and "meta" directory   

If being navigated in relative path way i.e. not started with slash character (/), then the given path will always be searched for anywhere in any depth of under current directory, does not have to be directly on current directory.   
If it needs to be limited to search for directly on current directory only, precede (prefix) it with ./   

Suppose previous explicit part of path exists only where it's specified i.e. "meta" is only a file/directory under "core" directory being under any directory being under any dir. under qt directory.   

$ cd /qt   
$ l core/meta   

will find one as e.g:   
/qt/src/dev/core/meta   

while doing such:
$ l ./core/meta   
will not find it since there is no /qt/core/meta    

In this way of having relative path preceded by ./, if it is explicit i.e. there is not any wildcard, while being searched and a directory is found, then this way the entire directory content will automatically be shown.

If this action is needed in another way of path described above, put -l option in order to show content of directory found only in one depth   
To have it shown up to certain depth add the number e.g. -l3 option will show to 3 directory plies.   
To have the found directory's content shown  entirely the number meant for it is 0.   
So be prepared if to put -l0 option, it will list entirely  the content of every found directory which could be a bit overwhelming.   

If it needs to be limited again, put -1...9 options,  e.g:   
search for only on current and 1 directory below it put -2,   
only on current and 2 directories below add -3, etc.   

can even navigate by way of absolute path immediately followed relative path in a single line   

$ l /a/\*/m\*.c  \*.h   
   
Can search in  POSIX extended regular expression by enclosing it with ' ' and preceding it with -E option   
$ l -E '/a/*/m\w{1,2}\\.[c-h]'   

/a/b/min.c
/a/b/c/d/e/min.h

to better narrow down the search we could utilize Linux core util, "find", options to test/filter the search

$ l -cmin -7 -E '/a/**m\w{1,2}\\.[c-h]'

will give as above which has been modified less than 7 minutes ago

The 'find' filter options copied from its manual:
  Note if a number n specified:
     +n     for greater than n
     -n     for less than n
      n      for exactly n

-amin n
       File was last accessed n minutes ago
-anewer file
        File was last accessed more recently than file was modified.   If  file
        is a symbolic link and the -H option or the -L option is in effect, the
        access time of the file it points to is always used.
 -atime n
        File was last accessed n*24 hours ago.  When find figures out how  many
        24-hour  periods ago the file was last accessed, any fractional part is
        ignored, so to match -atime +1, a file has to  have  been  accessed  at
        least two days ago.

 -cmin n
        File's status was last changed n minutes ago.

 -cnewer file
        File's  status  was  last changed more recently than file was modified.
        If file is a symbolic link and the -H option or the  -L  option  is  in
        effect, the status-change time of the file it points to is always used.

 -ctime n
        File's  status  was  last changed n*24 hours ago.  See the comments for
        -atime to understand how rounding affects the  interpretation  of  file
        status change times.

 -empty File is empty and is either a regular file or a directory.

 -executable
        Matches files which are executable and directories which are searchable
        (in a file name resolution sense).  This takes into account access con‐
        trol  lists  and  other  permissions  artefacts  which  the  -perm test
        ignores.  This test makes use of the access(2) system call, and so  can
        be  fooled  by  NFS  servers  which do UID mapping (or root-squashing),
        since many systems implement access(2) in the client's  kernel  and  so
        cannot  make  use  of  the  UID mapping information held on the server.
        Because this test is based only on the result of the  access(2)  system
        call,  there  is  no guarantee that a file for which this test succeeds
        can actually be executed.

 -false Always false.

 -fstype type
        File is on a filesystem of type type.  The valid filesystem types  vary
        among  different  versions  of  Unix;  an incomplete list of filesystem
        types that are accepted on some version of Unix  or  another  is:  ufs,
        4.2,  4.3,  nfs, tmp, mfs, S51K, S52K.  You can use -printf with the %F
        directive to see the types of your filesystems.

 -gid n File's numeric group ID is n.

 -group gname
        File belongs to group gname (numeric group ID allowed)
 -inum n
        File has inode number n.  It is normally easier to  use  the  -samefile
        test instead.
 -links n
        File has n links.

 -mmin n
        File's data was last modified n minutes ago.

 -mtime n
        File's data was last modified n*24 hours ago.   See  the  comments  for
        -atime  to  understand  how rounding affects the interpretation of file
        modification times.
 -newer file
        File was modified more recently than file.  If file is a symbolic  link
        and  the -H option or the -L option is in effect, the modification time
        of the file it points to is always used.

 -newerXY reference
        Succeeds if timestamp X of the file  being  considered  is  newer  than
        timestamp  Y of the file reference.   The letters X and Y can be any of
        the following letters:

        a   The access time of the file reference
        B   The birth time of the file reference
        c   The inode status change time of reference
        m   The modification time of the file reference
        t   reference is interpreted directly as a time

        Some combinations are invalid; for example, it is invalid for X  to  be
        t.  Some combinations are not implemented on all systems; for example B
        is not supported on all systems.  If an invalid or unsupported combina‐
        tion  of  XY  is specified, a fatal error results.  Time specifications
        are interpreted as for the argument to the -d option of GNU  date.   If
        you  try  to use the birth time of a reference file, and the birth time
        cannot be determined, a fatal error message results.  If you specify  a
        test  which refers to the birth time of files being examined, this test
        will fail for any files where the birth time is unknown.

 -nogroup
        No group corresponds to file's numeric group ID.

 -nouser
        No user corresponds to file's numeric user ID.

 -perm mode
        File's permission bits are exactly mode (octal or symbolic).  Since  an
        exact  match  is  required,  if  you want to use this form for symbolic
        modes, you may have to specify a rather complex mode string.  For exam‐
        ple  `-perm  g=w'  will only match files which have mode 0020 (that is,
        ones for which group write permission is the only permission set).   It
        is  more  likely  that  you  will want to use the `/' or `-' forms, for
        example `-perm -g=w', which matches any file with group  write  permis‐
        sion.  See the EXAMPLES section for some illustrative examples.

 -perm -mode
        All  of  the permission bits mode are set for the file.  Symbolic modes
        are accepted in this form, and this is usually the  way  in  which  you
        would  want to use them.  You must specify `u', `g' or `o' if you use a
        symbolic mode.   See the EXAMPLES section for some  illustrative  exam‐
        ples.

 -perm /mode
        Any  of  the permission bits mode are set for the file.  Symbolic modes
        are accepted in this form.  You must specify `u', `g' or `o' if you use
        a  symbolic mode.  See the EXAMPLES section for some illustrative exam‐
        ples.  If no permission bits in mode are set,  this  test  matches  any
        file  (the  idea  here  is to be consistent with the behaviour of -perm
        -000).
 -readable
        Matches  files which are readable.  This takes into account access con‐
        trol lists  and  other  permissions  artefacts  which  the  -perm  test
        ignores.   This test makes use of the access(2) system call, and so can
        be fooled by NFS servers which  do  UID  mapping  (or  root-squashing),
        since  many  systems  implement access(2) in the client's kernel and so
        cannot make use of the UID mapping information held on the server.
 -samefile name
        File refers to the same inode as name.   When -L is in effect, this can
        include symbolic links.

 -size n[cwbkMG]
        File uses n units of space, rounding up.  The following suffixes can be
        used:

        `b'    for 512-byte blocks (this is the default if no suffix is used)

        `c'    for bytes

        `w'    for two-byte words

        `k'    for Kilobytes (units of 1024 bytes)

        `M'    for Megabytes (units of 1048576 bytes)

        `G'    for Gigabytes (units of 1073741824 bytes)

        The  size  does  not count indirect blocks, but it does count blocks in
        sparse files that are not actually allocated.  Bear in  mind  that  the
        `%k'  and `%b' format specifiers of -printf handle sparse files differ‐
        ently.  The `b' suffix always denotes 512-byte blocks and never 1 Kilo‐
        byte  blocks,  which is different to the behaviour of -ls.  The + and -
        prefixes signify greater than and less than, as usual, but bear in mind
        that  the  size is rounded up to the next unit (so a 1-byte file is not
        matched by -size -1M).

 -true  Always true.

 -type c
        File is of type c:

        b      block (buffered) special

        c      character (unbuffered) special

        d      directory

        p      named pipe (FIFO)

        f      regular file
        l      symbolic link; this is never true if the -L option or the  -fol‐
               low option is in effect, unless the symbolic link is broken.  If
               you want to search for symbolic links when -L is in effect,  use
               -xtype.
        s      socket
        D      door (Solaris)

 -uid n File's numeric user ID is n.
 -used n
        File was last accessed n days after its status was last changed.
 -user uname
        File is owned by user uname (numeric user ID allowed).
 -wholename pattern
        See -path.  This alternative is less portable than -path.
 -writable
        Matches  files which are writable.  This takes into account access control lists  and  other  permissions  artefacts  which  the  -perm  test
        ignores.   This test makes use of the access(2) system call, and so can
        be fooled by NFS servers which  do  UID  mapping.
 -xtype c
        The same as -type unless the file is a  symbolic  link.   For  symbolic
        links: if the -H or -P option was specified, true if the file is a link
        to a file of type c; if the -L option has been given, true if c is `l'.
        In  other words, for symbolic links, -xtype checks the type of the file
        that -type does not check.
 -context pattern
        (SELinux only) Security context of the file matches glob pattern.



