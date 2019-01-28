Find and list specific files and/or directory recursively   
Let a directory with path /a/b/c/ contains

  $ ls /a/b/c  
  main.c meta.c a.h b.h ab.h   
  $ cd /   
  Tes@Linux /   
  $ l *.h   
  /a/b/c/a.h   
  /a/b/c/b.h   
  /a/b/c/ab.h   
  $ l ?.h  
  /a/b/c/a.h   
  /a/b/c/b.h   

Let's have more     
  $ ls /a/b/c/d/e   
  menu.c memo.h cd.h   
  Tes@Linux /   
  $ l me*.?   
  /a/b/c/meta.c   
  /a/b/c/d/e/menu.c   
  /a/b/c/d/e/memo.h   
  
If want to know their size precede it with -s   
  Tes@Linux /   
  $ l -s *.c   
  711 /a/b/c/main.c   
  33 /a/b/c/meta.c   
  27 /a/b/c/d/e/menu.c
  
If want to know their last modification time precede it with -t and if both with -st
And so forth many more directories nested under it as many as OS can do 
