Find and list specific files and/or directory recursively   
Let a directory with path /a/b/c/ contain main.c, meta.c, ab.c, a.h and ab.h

  $ ls /a/b/c  
  main.c meta.c ab.c a.h ab.h   
  $ cd /   
  Tes@Linux /   
  $ l *.c   
  /a/b/c/main.c   
  /a/b/c/meta.c   
  /a/b/c/ab.c   
  $ l *.h  
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
  711 /a/b/c/main.c   
  33 /a/b/c/meta.c   
  70 /a/b/c/d/e/menu.c   
  27 /a/b/c/ab.c
  
and to know their last modification time precede it with -t, while -st for both   
So forth as many directories nested under it as OS could do  

may be navigated as absolute path too  
$ cd /z
$ Tes@Linux /z
$ l /a/b/c/m*.c

/a/b/c/main.c   
/a/b/c/meta.c   
/a/b/c/d/e/menu.c

as absolute path it can even search to anyone more than one depth at "**" string if being input so

$ l /a/**m*.c

/a/main.c
/a/b/c/main.c   
/a/b/c/meta.c   
/a/b/c/d/e/menu.c
/a/b/c/d/e/f/g/man.c

if such the 1st and last do exist
