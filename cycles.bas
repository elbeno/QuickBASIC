'Light Cycles
'written in QuickBASIC by Ben Deane

'Set up
OPTION BASE 0
WIDTH 80, 50
RANDOMIZE TIMER
ON KEY(1) GOSUB Quit
KEY(1) ON
ON KEY(2) GOSUB Hold
KEY(2) ON
DIM Scr(0 TO 51, 0 TO 81)
DIM Direction%(2, 2)
Cycle$(1) = CHR$(1)
Cycle$(2) = CHR$(2)
CLS
LOCATE 5, 33, 0: PRINT "Light Cycles"
PRINT TAB(33); "------------";
LOCATE 8, 25, 0: PRINT "Press F1 to finish at any time";
LOCATE 10, 35, 0: PRINT "Controls:";
LOCATE 12, 20, 0: PRINT "Cycle 1 (left)            Cycle 2 (right)";
LOCATE 14, 15, 0: PRINT "Up         Q                         [";
PRINT TAB(13); "Down         A                         ;";
PRINT TAB(13); "Left         Z                         <";
PRINT TAB(12); "Right         X                         >";
LOCATE 20, 28, 0: PRINT "How Many Players (1-2)?";
DO
        DO
                k$ = INKEY$
        LOOP UNTIL k$ <> ""
LOOP UNTIL ASC(k$) > 48 AND ASC(k$) < 51
player% = ASC(k$) - 48
LOCATE 20, 28, 0: PRINT "                       ";
LOCATE 20, 28, 0: PRINT "Choose your speed (1-9)";
DO
        DO
                k$ = INKEY$
        LOOP UNTIL k$ <> ""
LOOP UNTIL ASC(k$) > 48 AND ASC(k$) < 58
speed% = ASC(k$) - 48
LOCATE 20, 28, 0: PRINT "                       ";
Pause% = 1000 * (16 - speed%): IF Pause% <= 0 THEN Pause% = 1
LOCATE 20, 30, 0: PRINT "Get Ready to Play...";
Score%(1) = 0: Score%(2) = 0

Begin:
Cycle%(1) = 1
Cycle%(2) = 1
Direction%(1, 1) = 3
Direction%(1, 2) = 3
Direction%(2, 1) = 2
Direction%(2, 2) = 2
row%(1) = 24: col%(1) = 20: row%(2) = 24: col%(2) = 60
DO
LOOP UNTIL INKEY$ <> ""
CLS
       
'Draw a box around the screen
LOCATE 1, 1: PRINT CHR$(201); STRING$(78, 205); CHR$(187);
FOR i% = 2 TO 49
LOCATE i%, 1: PRINT CHR$(186);
LOCATE i%, 80: PRINT CHR$(186);
Scr(i%, 1) = 1
Scr(i%, 80) = 1
NEXT
LOCATE 50, 1: PRINT CHR$(200); STRING$(78, 205); CHR$(188);
FOR i% = 1 TO 80
Scr(1, i%) = 1
Scr(50, i%) = 1
NEXT

'Print Secret Passages
LOCATE 1, 40: PRINT " ";
LOCATE 50, 40: PRINT " ";
LOCATE 25, 1: PRINT " ";
LOCATE 25, 80: PRINT " ";
Scr(1, 40) = 0
Scr(50, 40) = 0
Scr(25, 1) = 0
Scr(25, 80) = 0

'Print cycles in start positions
LOCATE row%(1), col%(1), 0: PRINT Cycle$(1); : LOCATE row%(2), col%(2), 0: PRINT Cycle$(2);

'Main loop
DO
GOSUB MoveCycles
GOSUB CheckKeys
GOSUB CheckCrash
GOSUB Pause
LOOP UNTIL Cycle%(1) = 0 OR Cycle%(2) = 0

'A cycle has crashed
LOCATE 10, 25, 0
IF Cycle%(1) = 0 AND Cycle%(2) = 0 THEN
PRINT "Both Light Cycles have Crashed!";
ELSE
PRINT "Light Cycle" + STR$(2 - Cycle%(1)) + " is the Winner!";
Score%(2 - Cycle%(1)) = Score%(2 - Cycle%(1)) + 1
END IF
LOCATE 12, 26, 0: PRINT "Cycle 1 :" + STR$(Score%(1)) + "      Cycle 2 :" + STR$(Score%(2));
LOCATE 15, 29, 0
PRINT "Any key for another go";
Time1 = TIMER
DO
Time2 = TIMER
LOOP UNTIL Time2 - Time1 > 2
DO
LOOP UNTIL INKEY$ <> ""
GOSUB Beginagain
GOTO Begin
END

MoveCycles:
FOR i% = 1 TO 2
Scr(row%(i%), col%(i%)) = 1
ON Direction%(i%, 1) + 1 GOSUB up, down, left, right
NEXT
RETURN

CheckKeys:
Direction%(1, 2) = Direction%(1, 1)
Direction%(2, 2) = Direction%(2, 1)
SELECT CASE INKEY$
CASE "q", "Q"
Direction%(1, 1) = 0
CASE "a", "A"
Direction%(1, 1) = 1
CASE "z", "Z"
Direction%(1, 1) = 2
CASE "x", "X"
Direction%(1, 1) = 3
CASE "[", "{"
IF player% = 2 THEN Direction%(2, 1) = 0
CASE ";", ":"
IF player% = 2 THEN Direction%(2, 1) = 1
CASE ",", "<"
IF player% = 2 THEN Direction%(2, 1) = 2
CASE ".", ">"
IF player% = 2 THEN Direction%(2, 1) = 3
END SELECT
IF player% = 1 THEN
        SELECT CASE Direction%(2, 1)
        CASE 0
        IF Scr(row%(2) - 1, col%(2)) = 1 AND Scr(row%(2), col%(2) - 1) = 1 THEN
                Direction%(2, 1) = 3
        ELSEIF Scr(row%(2) - 1, col%(2)) = 1 AND Scr(row%(2), col%(2) + 1) = 1 THEN
                Direction%(2, 1) = 2
        ELSEIF Scr(row%(2) - 1, col%(2)) = 1 THEN
                Direction%(2, 1) = INT((2 * RND) + 2)
        ELSEIF Scr(row%(2) - 1, col%(2)) = 0 THEN
                IF col%(2) > col%(1) THEN
                        left = .3: right = .05
                        prob = RND
                        IF prob > left AND Scr(row%(2), col%(2) - 1) = 0 THEN Direction%(2, 1) = 2
                        IF prob < right AND Scr(row%(2), col%(2) + 1) = 0 THEN Direction%(2, 1) = 3
                END IF
                IF col%(2) < col%(1) THEN
                        left = .05: right = .3
                        prob = RND
                        IF prob < left AND Scr(row%(2), col%(2) - 1) = 0 THEN Direction%(2, 1) = 2
                        IF prob > right AND Scr(row%(2), col%(2) + 1) = 0 THEN Direction%(2, 1) = 3
                END IF
                IF col%(2) = col%(1) THEN
                        left = .05: right = .95
                        prob = RND
                        IF prob < left AND Scr(row%(2), col%(2) - 1) = 0 THEN Direction%(2, 1) = 2
                        IF prob > right AND Scr(row%(2), col%(2) + 1) = 0 THEN Direction%(2, 1) = 3
                END IF
                IF row%(2) > row%(1) AND RND > .2 THEN Direction%(2, 1) = 0
        END IF
        CASE 1
        IF Scr(row%(2) + 1, col%(2)) = 1 AND Scr(row%(2), col%(2) - 1) = 1 THEN
                Direction%(2, 1) = 3
        ELSEIF Scr(row%(2) + 1, col%(2)) = 1 AND Scr(row%(2), col%(2) + 1) = 1 THEN
                Direction%(2, 1) = 2
        ELSEIF Scr(row%(2) + 1, col%(2)) = 1 THEN
                Direction%(2, 1) = INT((2 * RND) + 2)
        ELSEIF Scr(row%(2) + 1, col%(2)) = 0 THEN
                IF col%(2) > col%(1) THEN
                        left = .3: right = .05
                        prob = RND
                        IF prob > left AND Scr(row%(2), col%(2) - 1) = 0 THEN Direction%(2, 1) = 2
                        IF prob < right AND Scr(row%(2), col%(2) + 1) = 0 THEN Direction%(2, 1) = 3
                END IF
                IF col%(2) < col%(1) THEN
                        left = .05: right = .3
                        prob = RND
                        IF prob < left AND Scr(row%(2), col%(2) - 1) = 0 THEN Direction%(2, 1) = 2
                        IF prob > right AND Scr(row%(2), col%(2) + 1) = 0 THEN Direction%(2, 1) = 3
                END IF
                IF col%(2) = col%(1) THEN
                        left = .05: right = .95
                        prob = RND
                        IF prob < left AND Scr(row%(2), col%(2) - 1) = 0 THEN Direction%(2, 1) = 2
                        IF prob > right AND Scr(row%(2), col%(2) + 1) = 0 THEN Direction%(2, 1) = 3
                END IF
                IF row%(2) < row%(1) AND RND > .2 THEN Direction%(2, 1) = 1
        END IF
        CASE 2
        IF Scr(row%(2), col%(2) - 1) = 1 AND Scr(row%(2) - 1, col%(2)) = 1 THEN
                Direction%(2, 1) = 1
        ELSEIF Scr(row%(2), col%(2) - 1) = 1 AND Scr(row%(2) + 1, col%(2)) = 1 THEN
                Direction%(2, 1) = 0
        ELSEIF Scr(row%(2), col%(2) - 1) = 1 THEN
                Direction%(2, 1) = INT(2 * RND)
        ELSEIF Scr(row%(2), col%(2) - 1) = 0 THEN
                IF row%(2) > row%(1) THEN
                        up = .3: down = .05
                        prob = RND
                        IF prob > up AND Scr(row%(2) - 1, col%(2)) = 0 THEN Direction%(2, 1) = 0
                        IF prob < down AND Scr(row%(2) + 1, col%(2)) = 0 THEN Direction%(2, 1) = 1
                END IF
                IF row%(2) < row%(1) THEN
                        up = .05: down = .3
                        prob = RND
                        IF prob < up AND Scr(row%(2) - 1, col%(2)) = 0 THEN Direction%(2, 1) = 0
                        IF prob > down AND Scr(row%(2) + 1, col%(2)) = 0 THEN Direction%(2, 1) = 1
                END IF
                IF row%(2) = row%(1) THEN
                        up = .95: down = .05
                        prob = RND
                        IF prob > up AND Scr(row%(2) - 1, col%(2)) = 0 THEN Direction%(2, 1) = 0
                        IF prob < down AND Scr(row%(2) + 1, col%(2)) = 0 THEN Direction%(2, 1) = 1
                END IF
                IF col%(2) > col%(1) AND RND > .2 THEN Direction%(2, 1) = 2
        END IF
        CASE 3
        IF Scr(row%(2), col%(2) + 1) = 1 AND Scr(row%(2) - 1, col%(2)) = 1 THEN
                Direction%(2, 1) = 1
        ELSEIF Scr(row%(2), col%(2) + 1) = 1 AND Scr(row%(2) + 1, col%(2)) = 1 THEN
                Direction%(2, 1) = 0
        ELSEIF Scr(row%(2), col%(2) + 1) = 1 THEN
                Direction%(2, 1) = INT(2 * RND)
        ELSEIF Scr(row%(2), col%(2) + 1) = 0 THEN
                IF row%(2) > row%(1) THEN
                        up = .3: down = .05
                        prob = RND
                        IF prob > up AND Scr(row%(2) - 1, col%(2)) = 0 THEN Direction%(2, 1) = 0
                        IF prob < down AND Scr(row%(2) + 1, col%(2)) = 0 THEN Direction%(2, 1) = 1
                END IF
                IF row%(2) < row%(1) THEN
                        up = .05: down = .3
                        prob = RND
                        IF prob < up AND Scr(row%(2) - 1, col%(2)) = 0 THEN Direction%(2, 1) = 0
                        IF prob > down AND Scr(row%(2) + 1, col%(2)) = 0 THEN Direction%(2, 1) = 1
                END IF
                IF row%(2) = row%(1) THEN
                        up = .95: down = .05
                        prob = RND
                        IF prob > up AND Scr(row%(2) - 1, col%(2)) = 0 THEN Direction%(2, 1) = 0
                        IF prob < down AND Scr(row%(2) + 1, col%(2)) = 0 THEN Direction%(2, 1) = 1
                END IF
                IF col%(2) < col%(1) AND RND > .2 THEN Direction%(2, 1) = 3
        END IF
END SELECT
END IF
RETURN

CheckCrash:
FOR i% = 1 TO 2
SELECT CASE Direction%(i%, 1)
CASE 0
IF Scr(row%(i%) - 1, col%(i%)) = 1 THEN Cycle%(i%) = 0
CASE 1
IF Scr(row%(i%) + 1, col%(i%)) = 1 THEN Cycle%(i%) = 0
CASE 2
IF Scr(row%(i%), col%(i%) - 1) = 1 THEN Cycle%(i%) = 0
CASE 3
IF Scr(row%(i%), col%(i%) + 1) = 1 THEN Cycle%(i%) = 0
END SELECT
Cont:
NEXT
RETURN

up:
LOCATE row%(i%), col%(i%), 0
d% = 1
GOSUB PrintTrail
row%(i%) = row%(i%) - 1
IF row%(i%) = 0 THEN row%(i%) = 50
LOCATE row%(i%), col%(i%), 0
PRINT Cycle$(i%);
RETURN

down:
LOCATE row%(i%), col%(i%), 0
d% = 2
GOSUB PrintTrail
row%(i%) = row%(i%) + 1
IF row%(i%) = 51 THEN row%(i%) = 1
LOCATE row%(i%), col%(i%), 0
PRINT Cycle$(i%);
RETURN

left:
LOCATE row%(i%), col%(i%), 0
d% = 3
GOSUB PrintTrail
col%(i%) = col%(i%) - 1
IF col%(i%) = 0 THEN col%(i%) = 80
LOCATE row%(i%), col%(i%), 0
PRINT Cycle$(i%);
RETURN

right:
LOCATE row%(i%), col%(i%), 0
d% = 4
GOSUB PrintTrail
col%(i%) = col%(i%) + 1
IF col%(i%) = 81 THEN col%(i%) = 1
LOCATE row%(i%), col%(i%), 0
PRINT Cycle$(i%);
RETURN

Pause:
FOR i% = 1 TO Pause%
NEXT i%
RETURN

PrintTrail:
SELECT CASE Direction%(i%, 2)
CASE 0
        IF Direction%(i%, 1) = 0 THEN PRINT CHR$(179);
        IF Direction%(i%, 1) = 1 THEN PRINT CHR$(179);
        IF Direction%(i%, 1) = 2 THEN PRINT CHR$(191);
        IF Direction%(i%, 1) = 3 THEN PRINT CHR$(218);
CASE 1
        IF Direction%(i%, 1) = 0 THEN PRINT CHR$(179);
        IF Direction%(i%, 1) = 1 THEN PRINT CHR$(179);
        IF Direction%(i%, 1) = 2 THEN PRINT CHR$(217);
        IF Direction%(i%, 1) = 3 THEN PRINT CHR$(192);
CASE 2
        IF Direction%(i%, 1) = 0 THEN PRINT CHR$(192);
        IF Direction%(i%, 1) = 1 THEN PRINT CHR$(218);
        IF Direction%(i%, 1) = 2 THEN PRINT CHR$(196);
        IF Direction%(i%, 1) = 3 THEN PRINT CHR$(196);
CASE 3
        IF Direction%(i%, 1) = 0 THEN PRINT CHR$(217);
        IF Direction%(i%, 1) = 1 THEN PRINT CHR$(191);
        IF Direction%(i%, 1) = 2 THEN PRINT CHR$(196);
        IF Direction%(i%, 1) = 3 THEN PRINT CHR$(196);
END SELECT
RETURN


Beginagain:
CLS
LOCATE 20, 28, 0: PRINT "How Many Players (1-2)?";
DO
        DO
                k$ = INKEY$
        LOOP UNTIL k$ <> ""
LOOP UNTIL ASC(k$) > 48 AND ASC(k$) < 51
player% = ASC(k$) - 48
LOCATE 20, 28, 0: PRINT "                       ";
LOCATE 20, 28, 0: PRINT "Choose your speed (1-9)";
DO
        DO
                k$ = INKEY$
        LOOP UNTIL k$ <> ""
LOOP UNTIL ASC(k$) > 48 AND ASC(k$) < 58
speed% = ASC(k$) - 48
LOCATE 10, 28, 0: PRINT "                       ";
Pause% = 1000 * (16 - speed%): IF Pause% <= 0 THEN Pause% = 1
LOCATE 10, 30, 0: PRINT "Get Ready to Play...";
ERASE Scr
RETURN

Hold:
DO
LOOP UNTIL INKEY$ <> ""
RETURN

Quit:
CLS
LOCATE 10, 22, 0
PRINT "Thank you for playing Light Cycles.";
END
RETURN

