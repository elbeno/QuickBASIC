'Letter Chaser
'written in QuickBASIC by Ben Deane

'Set up
Player% = 2
HighScore% = 0
OPTION BASE 1
ON KEY(1) GOSUB Quit
KEY(1) ON
ON KEY(2) GOSUB Hold
KEY(2) ON
Ball$(1) = CHR$(1)
Ball$(2) = CHR$(2)
CLS
LOCATE 5, 32, 0: PRINT "Letter Chaser"
PRINT TAB(32); "-------------"
LOCATE 8, 19, 0: PRINT "Press F1 to finish at any time, F2 to pause"
LOCATE 10, 35, 0: PRINT "Controls:"
LOCATE 12, 20, 0: PRINT "Ball 1 (left)            Ball 2 (right)"
LOCATE 14, 15, 0: PRINT "Up         Q                         ["
PRINT TAB(13); "Down         A                         ;"
PRINT TAB(13); "Left         Z                         <"
PRINT TAB(12); "Right         X                         >"
LOCATE 20, 26, 0: INPUT "Choose your speed (1-15)"; Speed%
LOCATE 20, 25, 0: INPUT "Number of players (1 or 2)"; NoPlay%
LOCATE 20, 25, 0: PRINT SPACE$(40)
IF NoPlay% >= 2 THEN
Player% = 2
ELSE
IF NoPlay% = 1 THEN Player% = 1
END IF
Pause% = 1500 * (16 - Speed%): IF Pause% <= 0 THEN Pause% = 1
LOCATE 20, 30, 0: PRINT "Get Ready to Play..."
Begin:
Letter%(1) = 65
Letter%(2) = 65
Ball%(1) = 1
Ball%(2) = 1
Direction%(1) = 4
Direction%(2) = 4
row%(1) = 12: col%(1) = 20: row%(2) = 12: col%(2) = 60
DO
LOOP UNTIL INKEY$ <> ""
CLS
       
'Draw two boxes on the screen
LOCATE 2, 1: PRINT CHR$(201); STRING$(38, 205); CHR$(203); STRING$(38, 205); CHR$(187)
FOR i% = 3 TO 23
LOCATE i%, 1: PRINT CHR$(186)
LOCATE i%, 40: PRINT CHR$(186)
LOCATE i%, 79: PRINT CHR$(186)
NEXT
LOCATE 24, 1: PRINT CHR$(200); STRING$(38, 205); CHR$(202); STRING$(38, 205); CHR$(188)

'Print Balls in start positions
LOCATE row%(1), col%(1), 0: PRINT Ball$(1); : LOCATE row%(2), col%(2), 0: PRINT Ball$(2);

GOSUB Letters
'Main loop
DO
GOSUB CheckKeys
GOSUB CheckLetter
GOSUB MoveBalls
GOSUB Pause
LOOP UNTIL Ball%(1) = 0 OR Ball%(2) = 0 OR Letter%(1) > 90 OR Letter%(2) > 90

'Game over
IF Letter%(1) <> Letter%(2) THEN
IF Letter%(1) > Letter%(2) THEN
LOCATE 10, 20, 0
PRINT "Ball 1 ran over" + STR$(Letter%(1) - Letter%(2)) + " more letters than Ball 2"
High% = Letter%(1) - 65
ELSE
LOCATE 10, 20, 0
PRINT "Ball 2 ran over" + STR$(Letter%(2) - Letter%(1)) + " more letters than Ball 1"
High% = Letter%(2) - 65
END IF
ELSE
IF Player% = 2 THEN LOCATE 10, 37, 0: PRINT "A draw!"
High% = Letter%(1) - 65
END IF
IF High% > HighScore% THEN HighScore% = High%
LOCATE 13, 34, 0: PRINT "High Score =" + STR$(HighScore%)
LOCATE 15, 29, 0
PRINT "Any key for another go"
Time1 = TIMER
DO
Time2 = TIMER
LOOP UNTIL Time2 - Time1 > 2
DO
LOOP UNTIL INKEY$ <> ""
GOSUB Beginagain
GOTO Begin
END

Letters:
'Left side of screen
FOR i% = 65 TO 90
Rand1:
Xpos% = INT(38 * RND + 2)
Ypos% = INT(21 * RND + 2)
IF SCREEN(Ypos%, Xpos%) = 32 THEN
LOCATE Ypos%, Xpos%
PRINT CHR$(i%)
ELSE
GOTO Rand1
END IF
NEXT
'Right side of screen
FOR i% = 65 TO 90
Rand2:
Xpos% = INT(39 * RND + 41)
Ypos% = INT(21 * RND + 2)
IF SCREEN(Ypos%, Xpos%) = 32 THEN
LOCATE Ypos%, Xpos%
PRINT CHR$(i%)
ELSE
GOTO Rand2
END IF
NEXT
RETURN

MoveBalls:
FOR i% = 1 TO Player%
ON Direction%(i%) + 1 GOSUB Up, Down, Left, Right
NEXT
RETURN

CheckKeys:
SELECT CASE INKEY$
CASE "q", "Q"
Direction%(1) = 0
CASE "a", "A"
Direction%(1) = 1
CASE "z", "Z"
Direction%(1) = 2
CASE "x", "X"
Direction%(1) = 3
CASE "[", "{"
Direction%(2) = 0
CASE ";", ":"
Direction%(2) = 1
CASE ",", "<"
Direction%(2) = 2
CASE ".", ">"
Direction%(2) = 3
END SELECT
RETURN

CheckLetter:
FOR i% = 1 TO 2
SELECT CASE Direction%(i%)
CASE 0
IF SCREEN(row%(i%) - 1, col%(i%)) > 128 THEN Ball%(i%) = 0
IF SCREEN(row%(i%) - 1, col%(i%)) = Letter%(i%) THEN
Letter%(i%) = Letter%(i%) + 1
ELSE
IF SCREEN(row%(i%) - 1, col%(i%)) < 91 AND SCREEN(row%(i%) - 1, col%(i%)) > 64 THEN Ball%(i%) = 0
END IF
CASE 1
IF SCREEN(row%(i%) + 1, col%(i%)) > 128 THEN Ball%(i%) = 0
IF SCREEN(row%(i%) + 1, col%(i%)) = Letter%(i%) THEN
Letter%(i%) = Letter%(i%) + 1
ELSE
IF SCREEN(row%(i%) + 1, col%(i%)) < 91 AND SCREEN(row%(i%) + 1, col%(i%)) > 64 THEN Ball%(i%) = 0
END IF
CASE 2
IF SCREEN(row%(i%), col%(i%) - 1) > 128 THEN Ball%(i%) = 0
IF SCREEN(row%(i%), col%(i%) - 1) = Letter%(i%) THEN
Letter%(i%) = Letter%(i%) + 1
ELSE
IF SCREEN(row%(i%), col%(i%) - 1) < 91 AND SCREEN(row%(i%), col%(i%) - 1) > 64 THEN Ball%(i%) = 0
END IF
CASE 3
IF SCREEN(row%(i%), col%(i%) + 1) > 128 THEN Ball%(i%) = 0
IF SCREEN(row%(i%), col%(i%) + 1) = Letter%(i%) THEN
Letter%(i%) = Letter%(i%) + 1
ELSE
IF SCREEN(row%(i%), col%(i%) + 1) < 91 AND SCREEN(row%(i%), col%(i%) + 1) > 64 THEN Ball%(i%) = 0
END IF
CASE ELSE
END SELECT
NEXT
RETURN

Up:
LOCATE row%(i%), col%(i%), 0
PRINT " "
LOCATE row%(i%) - 1, col%(i%), 0
PRINT Ball$(i%)
row%(i%) = row%(i%) - 1
RETURN

Down:
LOCATE row%(i%), col%(i%), 0
PRINT " "
LOCATE row%(i%) + 1, col%(i%), 0
PRINT Ball$(i%)
row%(i%) = row%(i%) + 1
RETURN

Left:
LOCATE row%(i%), col%(i%), 0
PRINT " "
LOCATE row%(i%), col%(i%) - 1, 0
PRINT Ball$(i%)
col%(i%) = col%(i%) - 1
RETURN

Right:
LOCATE row%(i%), col%(i%), 0
PRINT " "
LOCATE row%(i%), col%(i%) + 1, 0
PRINT Ball$(i%)
col%(i%) = col%(i%) + 1
RETURN

Pause:
FOR i% = 1 TO Pause%
NEXT i%
RETURN

Beginagain:
CLS
LOCATE 10, 26, 0: INPUT "Choose your speed (1-15)"; Speed%
LOCATE 10, 25, 0: INPUT "Number of players (1 or 2)"; NoPlay%
LOCATE 10, 25, 0: PRINT SPACE$(40)
IF NoPlay% >= 2 THEN
Player% = 2
ELSE
IF NoPlay% = 1 THEN Player% = 1
END IF
Pause% = 1500 * (16 - Speed%): IF Pause% <= 0 THEN Pause% = 1
LOCATE 10, 30, 0: PRINT "Get Ready to Play..."
RETURN

Quit:
CLS
LOCATE 10, 22, 0
PRINT "Thank you for playing Letter Chaser."
END
RETURN

Hold:
DO
LOOP UNTIL INKEY$ <> ""
RETURN

