'Breakout

RANDOMIZE TIMER
SCREEN 0
CLS
WIDTH 80, 25
LOCATE 5, 37: PRINT "Breakout"
LOCATE 6, 37: PRINT "컴컴컴컴"
LOCATE 10, 35: PRINT "<        Left"
LOCATE 12, 35: PRINT ">       Right"
LOCATE 14, 35: PRINT "Z        Stop"
LOCATE 16, 35: PRINT "F1      Pause"
LOCATE 18, 35: PRINT "F2       Quit"
LOCATE 22, 30: PRINT "Press any key to play..."
ON KEY(1) GOSUB pausegame
ON KEY(2) GOSUB quitgame
KEY(1) ON
KEY(2) ON

DO
LOOP UNTIL INKEY$ <> ""
start:
SCREEN 12
WIDTH 80, 30
p% = 15000
pause% = p%

LINE (19, 19)-(620, 460), 15, B
DIM brick%(80, 2)
FOR i% = 27 TO 558 STEP 59
        FOR j% = 77 TO 252 STEP 25
                LINE (i%, j%)-(i% + 54, j% + 20), (j% - 2) / 25, BF
                brick%(INT((i% - 27) / 59) + 1 + (INT((j% - 77) / 25) * 10), 1) = i%
                brick%(INT((i% - 27) / 59) + 1 + (INT((j% - 77) / 25) * 10), 2) = j%
        NEXT
NEXT

batx% = 281: baty% = 446
LINE (batx%, baty%)-(batx% + 59, baty% + 4), 15, BF

ball% = 3

DO

DO
LOOP UNTIL INKEY$ <> ""
ballx% = 500: bally% = 300
ballspeedx% = -10
ballspeedy% = 5
ballsize% = 5
CIRCLE (ballx%, bally%), ballsize%, 15
PAINT (ballx%, bally%), 15, 15
miss% = 0
DO
k$ = INKEY$
LOOP UNTIL k$ = "," OR k$ = "." OR k$ = "<" OR k$ = ">"
IF k$ = "," OR k$ = "<" THEN batspeedx% = -20 ELSE batspeedx% = 20
bricksleft% = 80
DO
GOSUB checkkeys
GOSUB move
GOSUB checkhit
GOSUB pause
LOOP UNTIL miss% = 1 OR bricksleft% = 0
ball% = ball% - 1
LINE (ballx% - ballsize%, bally% - ballsize%)-(ballx% + ballsize%, bally% + ballsize%), 0, BF

LOOP UNTIL ball% = 0
GOSUB quitgame
GOTO start

checkkeys:
SELECT CASE INKEY$
        CASE "<", ","
                batspeedx% = -20
        CASE ">", "."
                batspeedx% = 20
        CASE "z", "Z"
                batspeedx% = 0
        CASE ELSE
END SELECT
RETURN

move:
LINE (batx%, baty%)-(batx% + 59, baty% + 4), 0, BF
batx% = batx% + batspeedx%
IF batx% < 27 THEN batx% = 27
IF batx% > 558 THEN batx% = 558
baty% = baty% + batspeedy%
LINE (batx%, baty%)-(batx% + 59, baty% + 4), 15, BF

LINE (ballx% - ballsize%, bally% - ballsize%)-(ballx% + ballsize%, bally% + ballsize%), 0, BF
ballx% = ballx% + ballspeedx%
bally% = bally% + ballspeedy%
CIRCLE (ballx%, bally%), ballsize%, 15
PAINT (ballx%, bally%), 15, 15

RETURN

checkhit:
IF bally% >= 440 AND ballspeedy% >= 0 THEN
IF ballx% >= batx% AND ballx% <= batx% + 59 THEN miss% = 0: ballspeedy% = -ballspeedy% ELSE miss% = 1
IF miss% = 0 AND ABS(ballx% - batx%) > 35 OR ABS(ballx% - batx%) < 15 THEN
        ballspeedy% = ballspeedy% + 11 * RND - 5
        ballspeedx% = ballspeedx% + 11 * RND - 5
        IF ballspeedy% > 10 THEN ballspeedy% = 10
        IF ballspeedy% < -10 THEN ballspeedy% = -10
        IF ballspeedx% > 15 THEN ballspeedx% = 15
        IF ballspeedx% < -15 THEN ballspeedx% = -15
END IF
END IF
        
IF bally% < 273 THEN
z% = INT((bally% - 77) / 25)
IF z% < 0 THEN z% = 0
FOR i% = 1 TO 10
        IF ballx% >= brick%(z% * 10 + i%, 1) AND ballx% <= brick%(z% * 10 + i%, 1) + 59 AND brick%(z% * 10 + i%, 2) <> 300 THEN
                a% = brick%(z% * 10 + i%, 1)
                b% = brick%(z% * 10 + i%, 2)
                LINE (a%, b%)-(a% + 54, b% + 20), 0, BF
                brick%(z% * 10 + i%, 2) = 300
                ballspeedy% = -ballspeedy%
                bricksleft% = bricksleft% - 1
                IF pause% > p% - (200 * (8 - z%)) THEN pause% = p% - (200 * (8 - z%))
        END IF
NEXT
END IF
IF ballx% < 39 OR ballx% > 600 THEN
        ballspeedx% = -ballspeedx%
END IF
IF bally% < 29 THEN ballspeedy% = -ballspeedy%

RETURN

pause:
FOR i% = 1 TO pause%
NEXT
RETURN

pausegame:
DO
LOOP UNTIL INKEY$ <> ""
RETURN

quitgame:
SCREEN 0
WIDTH 80, 25
CLS
LOCATE 16, 33: PRINT "Play again (Y/N)?"
DO
k$ = INKEY$
LOOP UNTIL k$ = "y" OR k$ = "Y" OR k$ = "n" OR k$ = "N"
IF k$ = "n" OR k$ = "N" THEN CLS : END
RETURN

