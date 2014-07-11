'Meteoroids
'written in QuickBASIC by Ben Deane

CLS
ON KEY(1) GOSUB Quit
KEY(1) ON
ON KEY(2) GOSUB Hold
KEY(2) ON
LOCATE 3, 35: PRINT "Meteoroids"
PRINT TAB(35); "----------"
Begin:
col% = 40: Pause% = 0
Hit% = 0
LOCATE 7, 30: PRINT "Press Any Key to Play"
LOCATE 10, 35: PRINT "Controls:"
LOCATE 12, 30: PRINT "Left            <"
LOCATE 14, 29: PRINT "Right            >"
LOCATE 18, 20: PRINT "Warning: The Game Speeds up as it Progresses!"
LOCATE 20, 23: PRINT "Hit F1 at any time to end, F2 to pause"
DO
LOOP UNTIL INKEY$ <> ""
CLS
LOCATE 10, 29: INPUT "Difficulty Level (1-4)"; Diff%
IF Diff% <= 0 THEN Diff% = 1
IF Diff% > 4 THEN Diff% = 4
Diff% = Diff% * 2
LOCATE 10, 29: PRINT SPACE$(30)
LOCATE 1, col%: PRINT "V"

'Main loop
DO
GOSUB CheckKeys
GOSUB Meteors
GOSUB Ship
GOSUB CheckCrash
GOSUB Pause
Pause% = Pause% + 5
LOOP UNTIL Hit% = 1 OR Pause% = 3000

'End of game
CLS
LOCATE 8, 21: PRINT "You managed to traverse" + STR$(INT(Pause% / 25)) + " Light Years."
IF Pause% = 3000 THEN
LOCATE 10, 12: PRINT "And you have flown successfully through the meteor storm!"
END IF
LOCATE 14, 26: PRINT "Hit Space to Start again"
DO
LOOP UNTIL INKEY$ = " "
CLS
GOTO Begin

CheckKeys:
LOCATE 1, col%: PRINT " "
SELECT CASE INKEY$
CASE "<", ","
col% = col% - 1
IF col% < 1 THEN col% = 80
CASE ">", "."
col% = col% + 1
IF col% > 80 THEN col% = 1
END SELECT
RETURN

Meteors:
FOR i% = 1 TO Diff%
LOCATE 23, INT(80 * RND + 1)
PRINT "*"
NEXT
PRINT
RETURN

Ship:
LOCATE 1, col%: PRINT "V"
RETURN

Pause:
FOR i% = 1 TO 20000 - Pause%
NEXT i%
RETURN

CheckCrash:
IF SCREEN(2, col%) = 42 THEN Hit% = 1
RETURN

Hold:
DO
LOOP UNTIL INKEY$ <> ""
RETURN

Quit:
CLS
LOCATE 10, 23: PRINT "Thank you for playing Meteoroids."
END
RETURN

