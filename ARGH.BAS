SCREEN 12

 FOR x = 1 TO 1000
  x = (RND * 639 + 1)
  y = (RND * 479 + 1)
  r = (RND * 100 + 1)
  c = (RND * 15 + 1)
  CIRCLE (x, y), r, c
  PAINT (x, y), (RND * 15 + 1), c
  x = 0
  y = 0
  r = 0
  c = 0
  REM  (RND * 3.14159256), (RND * 3.14159256)
 NEXT x

