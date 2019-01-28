Find and list specific files and/or directory recursively

Let a directory with path /a/b/c/ contains
  $ ls /a/b/c
  main.c meta.c a.h b.h abc.h
  $ cd /
  Tes@Linux /
  $ l *.h
  /a/b/c/a.h
  /a/b/c/b.h
  /a/b/c/abc.h
  $ l ?.h
  /a/b/c/a.h
  /a/b/c/b.h

Let's have more
  $ ls /a/b/c/d/e
  menu.c memo.h c.h
  Tes@Linux /
  $ l me*.?
  /a/b/c/meta.c
  /a/b/c/d/e/memo.h
  
If want to know their size precede it with -s
  Tes@Linux /
  $ l -s me*.?
  313 /a/b/c/meta.c
  17 /a/b/c/d/e/memo.h
  
If want to know their last modification time precede it with -t and if both with -st
