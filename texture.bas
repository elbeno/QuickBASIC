REM texture mapping

SCREEN 13

DIM bitmap(15, 15)

'Do a bitmap
FOR i% = 0 TO 15
  FOR j% = 0 TO 15
    bitmap(i%, j%) = i% * 16 + j%
  NEXT
NEXT

pi = 3.141592653589#

eyeheight% = 100
eyedistance% = 100
ymax% = 199
xmax% = 319
xoffset% = 0
yoffset% = 0
angle = 0


DO

FOR i% = ymax% TO ymax% / 2 STEP -1
  factor = eyeheight% / ymax%
  py% = eyedistance% * (eyeheight% / i%)
  FOR j% = 0 TO xmax%
    px% = eyeheight% * (j% / i%)
    PSET (j%, i%), bitmap((px% + xoffset%) MOD 16, (py% + yoffset%) MOD 16)
  NEXT
NEXT

getkey:
DO
  k$ = INKEY$
LOOP UNTIL k$ <> ""

IF k$ = CHR$(27) THEN END
k% = ASC(k$)

IF k% = 0 THEN
  k% = ASC(MID$(k$, 2)) + 500
END IF

SELECT CASE k%
  CASE 575
    xoffset% = xoffset% - 1: IF xoffset% = -1 THEN xoffset% = 15
  CASE 577
    xoffset% = xoffset% + 1: IF xoffset% = 16 THEN xoffset% = 0
  CASE 580
    yoffset% = yoffset% - 1: IF yoffset% = -1 THEN yoffset% = 15
  CASE 572
    yoffset% = yoffset% + 1: IF yoffset% = 16 THEN yoffset% = 0
  CASE 122
    angle = angle + pi: IF angle > 2 * pi THEN angle = angle - 2 * pi
  CASE 120
    angle = angle - pi: IF angle < 0 THEN angle = 2 * pi - angle
  CASE 97
    eyeheight% = eyeheight% - 20: IF eyeheight% < 20 THEN eyeheight% = 20
  CASE 113
    eyeheight% = eyeheight% + 20: IF eyeheight% > 500 THEN eyeheight% = 500
  CASE ELSE
    GOTO getkey
END SELECT

LOOP

