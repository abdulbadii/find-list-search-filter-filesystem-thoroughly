Find and list specific files and/or directory recursively   
Let a directory with path /a and /a/b/c contain main.c and added the latter with meta.c, ab.c, a.h and ab.h

  $ ls /a/b/c  
  main.c meta.c ab.c a.h ab.h   
  $ cd /   
  Tes@Linux /   
  $ l *.c *.h  
  /a/main.c
  /a/b/c/main.c   
  /a/b/c/meta.c   
  /a/b/c/ab.c    
  /a/b/c/a.h   
  /a/b/c/ab.h   

Let's add more under it    
  $ ls /a/b/c/d/e   
  menu.c memo.h cd.h   
  Tes@Linux /   
  $ l me*.?   
  /a/b/c/meta.c   
  /a/b/c/d/e/menu.c   
  /a/b/c/d/e/memo.h   
  
If we want to know their sizes precede it with -s   
  Tes@Linux /   
  $ l -s *.c   
  999 /a/main.c
  711 /a/b/c/main.c   
  33 /a/b/c/meta.c   
  70 /a/b/c/d/e/menu.c   
  27 /a/b/c/ab.c
  
while for last modification time precede it with -t, and -st for both   
And so forth, as many directories nested under it as OS could   

may be navigated as absolute path too  
$ cd /z
$ Tes@Linux /z
$ l /a/b/c/m*.c

/a/b/c/main.c   
/a/b/c/meta.c   
/a/b/c/d/e/menu.c

as absolute path it can even search for any depth more under a directory precede the "**" keyword if being given so

$ l /a/**m*.c

/a/main.c
/a/b/c/main.c   
/a/b/c/meta.c   
/a/b/c/d/e/menu.c
/a/b/min.c
/a/b/c/d/e/f/g/max.c

if such the last two do exist
