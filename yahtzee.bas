'Yahtzee
'Written in QuickBASIC by Ben Deane

DECLARE SUB setmousepos (xmouse%, ymouse%)
DECLARE SUB getmousestate (mousex%, mousey%, button%)
DECLARE SUB mouseoff ()
DECLARE SUB mouseon ()
DECLARE SUB initmouse ()
DECLARE SUB promptdisplay (prompt$, promptline%, clearline%)
DECLARE SUB putscorebox (dice$, playernumber%)
DECLARE SUB haveago (playernumber%, dice$)
DECLARE SUB scoresheet (numberofplayers%)
DECLARE SUB drawdice (dice%, xpos%, ypos%)

TYPE RegType
     ax    AS INTEGER
     bx    AS INTEGER
     cx    AS INTEGER
     dx    AS INTEGER
     bp    AS INTEGER
     si    AS INTEGER
     di    AS INTEGER
     flags AS INTEGER
END TYPE

DECLARE SUB interrupt (intnum AS INTEGER, inreg AS RegType, outreg AS RegType)
DIM SHARED inreg AS RegType
DIM SHARED outreg AS RegType
DIM SHARED player$(5), scorebox%(5, 13), score%(5), ybonus%(5), uptotal%(5), downtotal%(5), mouse%

ON KEY(1) GOSUB endprog
KEY(1) ON


Start:
ON KEY(1) GOSUB endprog
KEY(1) ON
CLS
SCREEN 12
RANDOMIZE TIMER
FOR i% = 1 TO 5
        score%(i%) = 0
        player$(i%) = ""
        uptotal%(i%) = 0
        downtotal%(i%) = 0
        ybonus%(i%) = 0
        FOR j% = 1 TO 13
                scorebox%(i%, j%) = -1
        NEXT
NEXT

CALL initmouse

'Draw the dice on the title screen
FOR i% = 1 TO 6
        CALL drawdice(i%, 10 + i% * 80, 100)
NEXT

CALL promptdisplay("YAHTZEE!", 15, 1)
CALL promptdisplay("Press Any Key to Play", 18, 1)
DO
        IF mouse% = 1 THEN CALL getmousestate(mousex%, mousey%, button%)
LOOP UNTIL INKEY$ <> "" OR button% <> 0

'Input the players

CALL promptdisplay("How Many Players (1-5)?", 20, 1)
getplayers:
DO
        k$ = INKEY$
LOOP UNTIL k$ <> ""
IF VAL(k$) > 5 OR VAL(k$) < 1 THEN GOTO getplayers
player% = VAL(k$)
LOCATE 18, 30: PRINT SPACE$(21);
LOCATE 20, 29: PRINT SPACE$(23);

FOR i% = 1 TO player%
        LOCATE 20, 1: PRINT SPACE$(80);
        LOCATE 20, 30: PRINT "Player" + STR$(i%) + " Name : ";
getkey:      
        LOCATE 20, 46: PRINT SPACE$(8); : LOCATE 20, 46: PRINT player$(i%);
        DO
                k$ = INKEY$
        LOOP UNTIL k$ <> ""
        IF k$ = CHR$(13) AND player$(i%) <> "" THEN
                GOTO nextname
        ELSEIF ASC(k$) > 31 AND ASC(k$) < 127 THEN
                IF LEN(player$(i%)) < 8 THEN player$(i%) = player$(i%) + k$
                GOTO getkey
        ELSEIF k$ = CHR$(8) THEN
                IF LEN(player$(i%)) > 0 THEN player$(i%) = LEFT$(player$(i%), LEN(player$(i%)) - 1)
                GOTO getkey
        ELSE
                GOTO getkey
        END IF
nextname:
NEXT

'Set up the scoresheet
CLS
CALL scoresheet(player%)
FOR i% = 1 TO 5
        CALL drawdice(i%, 560, 50 + (i% - 1) * 80)
        LOCATE 7 + (i% - 1) * 5, 68
        PRINT LTRIM$(STR$(i%));
NEXT

round% = 1
DO
        FOR i% = 1 TO player%
                CALL haveago(i%, dice$)
                CALL putscorebox(dice$, i%)
        NEXT
        round% = round% + 1
LOOP UNTIL round% = 14

biggest% = 0
FOR i% = 1 TO player%
        IF score%(i%) = biggest% THEN winner$ = ""
        IF score%(i%) > biggest% THEN biggest% = score%(i%): winner$ = player$(i%)
NEXT

IF winner$ = "" THEN
        CALL promptdisplay("A Draw!", 28, 1)
ELSE
        CALL promptdisplay(winner$ + " is the Winner - Well Done!", 28, 1)
END IF
endprog:
CALL promptdisplay("Another Game (Y/N)?", 29, 1)
DO
        k$ = INKEY$
        IF mouse% = 1 THEN CALL getmousestate(mousex%, mousey%, button%)
LOOP UNTIL k$ <> "" OR button% <> 0
IF k$ = "y" OR k$ = "Y" OR button% = 1 THEN GOTO Start
END

SUB drawdice (dice%, xpos%, ypos%)

'Draws the dice number dice%
'Assuming the (60*60) box has top left corner (xpos%,ypos%)

LINE (xpos%, ypos%)-(xpos% + 60, ypos% + 60), 0, BF
LINE (xpos%, ypos%)-(xpos% + 60, ypos% + 60), 15, B
ON dice% GOSUB Ace, Two, Three, Four, Five, Six
EXIT SUB

Ace:
CIRCLE (xpos% + 30, ypos% + 30), 5, 15
PAINT (xpos% + 30, ypos% + 30), 15, 15
RETURN
Two:
CIRCLE (xpos% + 45, ypos% + 15), 5, 15
PAINT (xpos% + 45, ypos% + 15), 15, 15
CIRCLE (xpos% + 15, ypos% + 45), 5, 15
PAINT (xpos% + 15, ypos% + 45), 15, 15
RETURN
Three:
CIRCLE (xpos% + 30, ypos% + 30), 5, 15
PAINT (xpos% + 30, ypos% + 30), 15, 15
CIRCLE (xpos% + 45, ypos% + 15), 5, 15
PAINT (xpos% + 45, ypos% + 15), 15, 15
CIRCLE (xpos% + 15, ypos% + 45), 5, 15
PAINT (xpos% + 15, ypos% + 45), 15, 15
RETURN
Four:
CIRCLE (xpos% + 15, ypos% + 15), 5, 15
PAINT (xpos% + 15, ypos% + 15), 15, 15
CIRCLE (xpos% + 45, ypos% + 45), 5, 15
PAINT (xpos% + 45, ypos% + 45), 15, 15
CIRCLE (xpos% + 45, ypos% + 15), 5, 15
PAINT (xpos% + 45, ypos% + 15), 15, 15
CIRCLE (xpos% + 15, ypos% + 45), 5, 15
PAINT (xpos% + 15, ypos% + 45), 15, 15
RETURN
Five:
CIRCLE (xpos% + 15, ypos% + 15), 5, 15
PAINT (xpos% + 15, ypos% + 15), 15, 15
CIRCLE (xpos% + 45, ypos% + 45), 5, 15
PAINT (xpos% + 45, ypos% + 45), 15, 15
CIRCLE (xpos% + 45, ypos% + 15), 5, 15
PAINT (xpos% + 45, ypos% + 15), 15, 15
CIRCLE (xpos% + 15, ypos% + 45), 5, 15
PAINT (xpos% + 15, ypos% + 45), 15, 15
CIRCLE (xpos% + 30, ypos% + 30), 5, 15
PAINT (xpos% + 30, ypos% + 30), 15, 15
RETURN
Six:
CIRCLE (xpos% + 15, ypos% + 15), 5, 15
PAINT (xpos% + 15, ypos% + 15), 15, 15
CIRCLE (xpos% + 45, ypos% + 45), 5, 15
PAINT (xpos% + 45, ypos% + 45), 15, 15
CIRCLE (xpos% + 45, ypos% + 15), 5, 15
PAINT (xpos% + 45, ypos% + 15), 15, 15
CIRCLE (xpos% + 15, ypos% + 45), 5, 15
PAINT (xpos% + 15, ypos% + 45), 15, 15
CIRCLE (xpos% + 45, ypos% + 30), 5, 15
PAINT (xpos% + 45, ypos% + 30), 15, 15
CIRCLE (xpos% + 15, ypos% + 30), 5, 15
PAINT (xpos% + 15, ypos% + 30), 15, 15
RETURN

END SUB

SUB getmousestate (mousex%, mousey%, button%)
        inreg.ax = &H3
        CALL interrupt(&H33, inreg, outreg)
        mousex% = outreg.cx
        mousey% = outreg.dx
        button% = outreg.bx
        IF button% = 2 OR button% = 1 THEN
                DO
                        CALL interrupt(&H33, inreg, outreg)
                LOOP UNTIL outreg.bx = 0
        END IF
END SUB

SUB haveago (playernumber%, dice$)

top% = 3

roll% = 1
dice$ = "12345"
DIM held%(5)
CALL promptdisplay(player$(playernumber%) + " - Roll" + STR$(roll%) + " - Press Space to Roll", 28, 1)
IF mouse% = 1 THEN CALL mouseon
DO
        IF mouse% = 1 THEN CALL getmousestate(mousex%, mousey%, button%)
LOOP UNTIL INKEY$ = " " OR button% = 2
IF mouse% = 1 THEN CALL mouseoff
DO
        FOR j% = 1 TO 10
        FOR i% = 1 TO 5
                IF held%(i%) = 0 THEN
                        d% = INT(6 * RND + 1)
                        CALL drawdice(d%, 560, 50 + (i% - 1) * 80)
                        dice$ = LEFT$(dice$, i% - 1) + LTRIM$(STR$(d%)) + RIGHT$(dice$, 5 - i%)
                END IF
        FOR k% = 1 TO 800 + held%(i%) * 3000
        NEXT
        NEXT
        NEXT
        IF roll% < 3 THEN CALL promptdisplay("Hold Which Dice (1-5)?", 28, 1)
        IF roll% < 3 THEN
                CALL promptdisplay(player$(playernumber%) + " - Roll" + STR$(roll% + 1) + " - Press Space to Roll", 29, 1)
        ELSE
                GOTO nextroll
        END IF
        IF mouse% = 1 THEN CALL mouseon
getheld:
        k% = 0
        DO
                k$ = INKEY$
                IF mouse% = 1 THEN CALL getmousestate(mousex%, mousey%, button%)
        LOOP UNTIL k$ <> "" OR button% <> 0
        IF k$ = " " OR button% = 2 THEN
                IF mouse% = 1 THEN CALL mouseoff
                GOTO nextroll
        END IF
        IF mouse% = 1 AND button% = 1 THEN
                FOR i% = 1 TO 5
                        IF mousex% >= 560 AND mousex% <= 620 AND mousey% >= 50 + (i% - 1) * 80 AND mousey% <= 110 + (i% - 1) * 80 THEN k% = i%
                NEXT
                IF k% = 0 THEN GOTO getheld
        ELSE
                k% = VAL(k$)
        END IF
        IF k% > 5 OR k% < 1 THEN GOTO getheld
        held%(k%) = 1 - held%(k%)
        IF held%(k%) = 1 THEN
                LOCATE 5 + (k% - 1) * 5, 68
                PRINT "H";
        ELSE
                LOCATE 5 + (k% - 1) * 5, 68
                PRINT " ";
        END IF
        GOTO getheld
nextroll:   
        roll% = roll% + 1
        CALL promptdisplay("", 29, 1)
        CALL promptdisplay("", 28, 1)
        allheld% = 1
        FOR i% = 1 TO 5
                IF held%(i%) = 0 THEN allheld% = 0
        NEXT
        IF allheld% = 1 THEN roll% = 4
LOOP UNTIL roll% = 4
FOR i% = 1 TO 5
        LOCATE 5 + (i% - 1) * 5, 68
        PRINT " ";
        held%(i%) = 0
NEXT

END SUB

SUB initmouse

inreg.ax = 0
CALL interrupt(&H33, inreg, outreg)
IF outreg.ax <> 0 AND (outreg.bx = 2 OR outreg.bx = 3) THEN mouse% = 1 ELSE mouse% = 0

END SUB

SUB mouseoff
        inreg.ax = &H2
        CALL interrupt(&H33, inreg, outreg)
END SUB

SUB mouseon
        inreg.ax = &H1
        CALL interrupt(&H33, inreg, outreg)
END SUB

SUB promptdisplay (prompt$, promptline%, clearline%)
    
        curline% = CSRLIN
        IF clearline% = 1 THEN LOCATE promptline%, 1, 0: PRINT SPACE$(80);
        IF LEN(prompt$) MOD 2 = 1 THEN prompt$ = prompt$ + " "
        LOCATE promptline%, ((80 - LEN(prompt$)) / 2) + 1: PRINT prompt$;
        LOCATE curline%

END SUB

SUB putscorebox (dice$, playernumber%)
top% = 3
DIM possible%(13)
DIM zeroposs%(13)
FOR i% = 1 TO 13
        IF scorebox%(playernumber%, i%) = -1 THEN zeroposs%(i%) = 1
NEXT

FOR i% = 1 TO 6
        IF INSTR(dice$, LTRIM$(STR$(i%))) > 0 AND scorebox%(playernumber%, i%) = -1 THEN possible%(i%) = 1
NEXT
IF scorebox%(playernumber%, 13) = -1 THEN possible%(13) = 1
IF (dice$ = "11111" OR dice$ = "22222" OR dice$ = "33333" OR dice$ = "44444" OR dice$ = "55555" OR dice$ = "66666") THEN yahtzee% = 1
IF scorebox%(playernumber%, 12) = -1 AND yahtzee% = 1 THEN possible%(12) = 1

FOR i% = 1 TO 6
        fourkind% = 1
        j% = 0
        d$ = dice$
        DO
                IF INSTR(d$, LTRIM$(STR$(i%))) = 0 THEN fourkind% = 0 ELSE d$ = RIGHT$(d$, LEN(d$) - INSTR(d$, LTRIM$(STR$(i%)))): j% = j% + 1
        LOOP UNTIL fourkind% = 0 OR j% = 4
        IF j% = 4 THEN EXIT FOR
NEXT
IF fourkind% = 1 AND scorebox%(playernumber%, 8) = -1 THEN possible%(8) = 1

FOR i% = 1 TO 6
        threekind% = 1
        j% = 0
        d$ = dice$
        DO
                IF INSTR(d$, LTRIM$(STR$(i%))) = 0 THEN threekind% = 0 ELSE d$ = RIGHT$(d$, LEN(d$) - INSTR(d$, LTRIM$(STR$(i%)))): j% = j% + 1
        LOOP UNTIL threekind% = 0 OR j% = 3
        IF j% = 3 THEN full3% = i%: EXIT FOR
NEXT
IF threekind% = 1 AND scorebox%(playernumber%, 7) = -1 THEN possible%(7) = 1

FOR i% = 1 TO 6
        pair% = 1
        j% = 0
        d$ = dice$
        DO
                IF INSTR(d$, LTRIM$(STR$(i%))) = 0 THEN pair% = 0 ELSE d$ = RIGHT$(d$, LEN(d$) - INSTR(d$, LTRIM$(STR$(i%)))): j% = j% + 1
        LOOP UNTIL pair% = 0 OR j% = 2
        IF i% <> full3% AND j% = 2 THEN EXIT FOR
        IF i% = full3% THEN pair% = 0
NEXT
IF pair% = 1 AND threekind% = 1 AND scorebox%(playernumber%, 9) = -1 THEN possible%(9) = 1

IF INSTR(dice$, "1") > 0 THEN
IF INSTR(dice$, "2") > 0 THEN
IF INSTR(dice$, "3") > 0 THEN
IF INSTR(dice$, "4") > 0 THEN
IF INSTR(dice$, "5") > 0 THEN
IF scorebox%(playernumber%, 11) = -1 THEN possible%(11) = 1
END IF
END IF
END IF
END IF
END IF

IF INSTR(dice$, "6") > 0 THEN
IF INSTR(dice$, "2") > 0 THEN
IF INSTR(dice$, "3") > 0 THEN
IF INSTR(dice$, "4") > 0 THEN
IF INSTR(dice$, "5") > 0 THEN
IF scorebox%(playernumber%, 11) = -1 THEN possible%(11) = 1
END IF
END IF
END IF
END IF
END IF

IF INSTR(dice$, "1") > 0 THEN
IF INSTR(dice$, "2") > 0 THEN
IF INSTR(dice$, "3") > 0 THEN
IF INSTR(dice$, "4") > 0 THEN
IF scorebox%(playernumber%, 10) = -1 THEN possible%(10) = 1
END IF
END IF
END IF
END IF

IF INSTR(dice$, "5") > 0 THEN
IF INSTR(dice$, "6") > 0 THEN
IF INSTR(dice$, "3") > 0 THEN
IF INSTR(dice$, "4") > 0 THEN
IF scorebox%(playernumber%, 10) = -1 THEN possible%(10) = 1
END IF
END IF
END IF
END IF

IF INSTR(dice$, "5") > 0 THEN
IF INSTR(dice$, "2") > 0 THEN
IF INSTR(dice$, "3") > 0 THEN
IF INSTR(dice$, "4") > 0 THEN
IF scorebox%(playernumber%, 10) = -1 THEN possible%(10) = 1
END IF
END IF
END IF
END IF

IF yahtzee% = 1 AND scorebox%(playernumber%, 12) <> -1 THEN
        IF scorebox%(playernumber%, VAL(LEFT$(dice$, 1))) <> -1 THEN
                IF scorebox%(playernumber%, 10) = -1 THEN possible%(10) = 1
                IF scorebox%(playernumber%, 11) = -1 THEN possible%(11) = 1
                IF scorebox%(playernumber%, 7) = -1 THEN possible%(7) = 1
                IF scorebox%(playernumber%, 8) = -1 THEN possible%(8) = 1
                IF scorebox%(playernumber%, 9) = -1 THEN possible%(9) = 1
        END IF
END IF


CALL promptdisplay("Put Score Where ?", 28, 1)
box% = 1
DO
        IF zeroposs%(box%) = 0 AND up% = 0 THEN GOTO nextbox
        IF zeroposs%(box%) = 0 AND up% = 1 THEN GOTO prevbox

        IF box% < 7 THEN
                LOCATE top% + box%, 2: PRINT "*";
        ELSE
                LOCATE top% + box% + 4, 2: PRINT "*";
        END IF
        IF mouse% = 1 THEN CALL setmousepos(320, 240)
        DO
                k$ = INKEY$
                IF mouse% = 1 THEN CALL getmousestate(mousex%, mousey%, button%)
        LOOP UNTIL k$ <> "" OR button% <> 0 OR mousey% > 260 OR mousey% < 220
        IF k$ = "" THEN k$ = "  "
        IF ASC(k$) = 0 OR mousey% > 260 OR mousey% < 220 THEN
                IF ASC(MID$(k$, 2)) + 500 = 572 OR mousey% < 220 THEN
                        up% = 1
                        IF box% < 7 THEN
                                LOCATE top% + box%, 2: PRINT " ";
                        ELSE
                                LOCATE top% + box% + 4, 2: PRINT " ";
                        END IF
                        GOTO prevbox
                ELSEIF ASC(MID$(k$, 2)) + 500 = 580 OR mousey% > 260 THEN
                        up% = 0
                        IF box% < 7 THEN
                                LOCATE top% + box%, 2: PRINT " ";
                        ELSE
                                LOCATE top% + box% + 4, 2: PRINT " ";
                        END IF
                        GOTO nextbox
                ELSE
                        GOTO done
                END IF
        ELSEIF k$ = CHR$(13) OR button% <> 0 THEN
                IF box% < 7 THEN
                        LOCATE top% + box%, 2: PRINT " ";
                ELSE
                        LOCATE top% + box% + 4, 2: PRINT " ";
                END IF
                GOTO done
        ELSE
                GOTO done
        END IF
prevbox:
        box% = box% - 1: IF box% = 0 THEN box% = 13
        GOTO done
nextbox:
        box% = box% + 1: IF box% = 14 THEN box% = 1
done:
LOOP UNTIL k$ = CHR$(13) OR button% <> 0
LOCATE 28, 32: PRINT SPACE$(17);

'Work out the score

s% = 0
IF box% < 7 THEN
        FOR i% = 1 TO 5
                IF VAL(MID$(dice$, i%, 1)) = box% THEN s% = s% + box%
        NEXT
END IF
IF box% = 7 OR box% = 8 OR box% = 13 THEN
        FOR i% = 1 TO 5
                s% = s% + VAL(MID$(dice$, i%, 1))
        NEXT
END IF

IF box% = 9 THEN s% = 25
IF box% = 10 THEN s% = 30
IF box% = 11 THEN s% = 40
IF box% = 12 THEN s% = 50


IF possible%(box%) = 0 THEN s% = 0
IF yahtzee% = 1 AND scorebox%(playernumber%, 12) = 50 THEN ybonus%(playernumber%) = ybonus%(playernumber%) + 100
scorebox%(playernumber%, box%) = s%

IF box% < 7 THEN
        LOCATE top% + box%, 11 + 9 * playernumber%: PRINT SPACE$(7 - LEN(STR$(s%))); s%;
        uptotal%(playernumber%) = uptotal%(playernumber%) + s%
ELSE
        LOCATE top% + box% + 4, 11 + 9 * playernumber%: PRINT SPACE$(7 - LEN(STR$(s%))); s%;
        downtotal%(playernumber%) = downtotal%(playernumber%) + s%
END IF

LOCATE top% + 7, 11 + 9 * playernumber%: PRINT SPACE$(7 - LEN(STR$(uptotal%(playernumber%)))); uptotal%(playernumber%);
IF uptotal%(playernumber%) > 62 THEN bonus% = 35
LOCATE top% + 8, 11 + 9 * playernumber%: PRINT SPACE$(7 - LEN(STR$(bonus%))); bonus%;
LOCATE top% + 9, 11 + 9 * playernumber%: PRINT SPACE$(7 - LEN(STR$(bonus% + uptotal%(playernumber%)))); bonus% + uptotal%(playernumber%);
LOCATE top% + 19, 11 + 9 * playernumber%: PRINT SPACE$(7 - LEN(STR$(bonus% + uptotal%(playernumber%)))); bonus% + uptotal%(playernumber%);
LOCATE top% + 18, 11 + 9 * playernumber%: PRINT SPACE$(7 - LEN(STR$(downtotal%(playernumber%)))); downtotal%(playernumber%);
score%(playernumber%) = uptotal%(playernumber%) + downtotal%(playernumber%) + bonus% + ybonus%(playernumber%)
LOCATE top% + 20, 11 + 9 * playernumber%: PRINT SPACE$(7 - LEN(STR$(score%(playernumber%)))); score%(playernumber%);
LOCATE top% + 22, 11 + 9 * playernumber%: PRINT SPACE$(7 - LEN(STR$(ybonus%(playernumber%)))); ybonus%(playernumber%);

END SUB

SUB scoresheet (numberofplayers%)

LOCATE 1, 37: PRINT "YAHTZEE!"
top% = 3
LOCATE top% + 1, 4: PRINT "Aces"
LOCATE top% + 2, 4: PRINT "Twos"
LOCATE top% + 3, 4: PRINT "Threes"
LOCATE top% + 4, 4: PRINT "Fours"
LOCATE top% + 5, 4: PRINT "Fives"
LOCATE top% + 6, 4: PRINT "Sixes"
LOCATE top% + 7, 4: PRINT "TOTAL"
LOCATE top% + 8, 4: PRINT "BONUS"
LOCATE top% + 9, 4: PRINT "TOTAL"
LOCATE top% + 11, 4: PRINT "3 of a kind"
LOCATE top% + 12, 4: PRINT "4 of a kind"
LOCATE top% + 13, 4: PRINT "Full House"
LOCATE top% + 14, 4: PRINT "Low Straight"
LOCATE top% + 15, 4: PRINT "High Straight"
LOCATE top% + 16, 4: PRINT "YAHTZEE"
LOCATE top% + 17, 4: PRINT "Chance"
LOCATE top% + 18, 4: PRINT "TOTAL (Lower)"
LOCATE top% + 19, 4: PRINT "TOTAL (Upper)"
LOCATE top% + 20, 4: PRINT "GRAND TOTAL"
LOCATE top% + 22, 4: PRINT "Extra YAHTZEES"
FOR i% = 1 TO 9
        LOCATE top% + i%, 1: PRINT CHR$(179);
        LOCATE top% + i%, 3: PRINT CHR$(179);
        LOCATE top% + i%, 19: PRINT CHR$(179);
NEXT
FOR i% = 11 TO 20
        LOCATE top% + i%, 1: PRINT CHR$(179);
        LOCATE top% + i%, 3: PRINT CHR$(179);
        LOCATE top% + i%, 19: PRINT CHR$(179);
NEXT
LOCATE top% + 22, 19: PRINT CHR$(179);
LOCATE top% + 22, 3: PRINT CHR$(179);
LOCATE top% + 22, 1: PRINT CHR$(179);
       
LOCATE top%, 1: PRINT CHR$(218); CHR$(196); CHR$(194); STRING$(15, 196); CHR$(194);
LOCATE top% + 10, 1: PRINT CHR$(195); CHR$(196); CHR$(197); STRING$(15, 196); CHR$(197);
LOCATE top% + 21, 1: PRINT CHR$(195); CHR$(196); CHR$(197); STRING$(15, 196); CHR$(197);
LOCATE top% + 23, 1: PRINT CHR$(192); CHR$(196); CHR$(193); STRING$(15, 196); CHR$(193);

FOR i% = 1 TO numberofplayers%
        LOCATE top% - 1, 11 + 9 * i%: PRINT player$(i%)
        FOR j% = 1 TO 9
                LOCATE top% + j%, 10 + 9 * (i% + 1): PRINT CHR$(179);
        NEXT
        FOR j% = 11 TO 20
                LOCATE top% + j%, 10 + 9 * (i% + 1): PRINT CHR$(179);
        NEXT
        LOCATE top% + 22, 10 + 9 * (i% + 1): PRINT CHR$(179);
        LOCATE top%, 11 + 9 * i%: PRINT STRING$(8, 196);
        IF i% = numberofplayers% THEN PRINT CHR$(191);  ELSE PRINT CHR$(194);
        LOCATE top% + 10, 11 + 9 * i%: PRINT STRING$(8, 196);
        IF i% = numberofplayers% THEN PRINT CHR$(180);  ELSE PRINT CHR$(197);
        LOCATE top% + 21, 11 + 9 * i%: PRINT STRING$(8, 196);
        IF i% = numberofplayers% THEN PRINT CHR$(180);  ELSE PRINT CHR$(197);
        LOCATE top% + 23, 11 + 9 * i%: PRINT STRING$(8, 196);
        IF i% = numberofplayers% THEN PRINT CHR$(217);  ELSE PRINT CHR$(193);
NEXT

END SUB

SUB setmousepos (xmouse%, ymouse%)

inreg.ax = 4
inreg.cx = xmouse%
inreg.dx = ymouse%
CALL interrupt(&H33, inreg, outreg)

END SUB

