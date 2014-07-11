'Sprite Designer

'Declare procedures and functions
DECLARE SUB mouseinit ()
DECLARE SUB getmousestate ()
DECLARE SUB mouseon ()
DECLARE SUB coloursandtools ()
DECLARE SUB mouseoff ()
DECLARE SUB setpalette ()

'Set up arrays, variables and constants
'$DYNAMIC
COMMON SHARED inary%(), outary%()
COMMON SHARED mousex%, mousey%, button%, xmax%, ymax%, sizex%, sizey%
DIM inary%(7), outary%(7)
CONST false = 0
CONST true = 1
CONST ax = 0, bx = 1, cx = 2, dx = 3, bp = 4, si = 5, bi = 6, fl = 7
CALL mouseinit

'Screen mode selection
smode% = 12
SCREEN smode%
SELECT CASE smode%
        CASE 12
        maxcol% = 16
        xmax% = 639
        ymax% = 479
        DIM SHARED pal&(15)
END SELECT
'CALL setpalette
sizey% = 17
sizex% = 21
CIRCLE (15, 357), 7, 15
PAINT (15, 357), 15, 15
CIRCLE (15, 377), 7, 15
PAINT (15, 377), 0, 15

'Set up colours and tools
CALL coloursandtools

forecol% = 15
backcol% = 0
toolselection% = 1
gridmode% = true
button% = 0
IF INT(464 / sizex%) > INT(459 / sizey%) THEN
        scale% = INT(459 / sizey%)
ELSE
        scale% = INT(464 / sizex%)
END IF
DIM sprite%(sizex%, sizey%)
LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 15, B
CALL mouseon

DO
CALL getmousestate
       
        'tools
        IF mousex% < 48 AND mousex% > 22 THEN
                done% = 0
        DO
                CALL getmousestate
                tool% = 0
                IF button% <> 0 THEN
                        FOR toolcoord% = 10 TO 439 STEP 20
                                tool% = tool% + 1
                                IF mousey% > toolcoord% AND mousey% < (toolcoord% + 18) THEN
                                        IF button% = 1 THEN
                                                toolselection% = tool%: done% = 1
                                        ELSE
                                                toolselection% = tool% + 22: done% = 1
                                        END IF
                                END IF
                        NEXT toolcoord%
                END IF
        LOOP UNTIL done% = 1 OR mousex% > 48 OR mousex% < 22
        END IF

        'colours
        IF mousex% < 22 THEN
                done% = 0
                oldforecol% = forecol%
                oldbackcol% = backcol%
        DO
                CALL getmousestate
                col% = 0
                IF button% = 1 OR button% = 2 THEN
                        FOR colcoord% = 10 TO 310 STEP 20
                                IF mousey% > colcoord% AND mousey% < (colcoord% + 14) AND button% = 1 THEN
                                        forecol% = col%
                                        IF oldforecol% <> 15 THEN
                                                PAINT (15, 357), forecol%, 15
                                        ELSE
                                                CIRCLE (15, 357), 7, 7
                                                PAINT (15, 357), forecol%, 7
                                                CIRCLE (15, 357), 7, 15
                                        END IF
                                        done% = 1
                                ELSE
                                        IF mousey% > colcoord% AND mousey% < (colcoord% + 14) THEN
                                                backcol% = col%
                                                IF oldbackcol% <> 15 THEN
                                                        PAINT (15, 377), backcol%, 15
                                                ELSE
                                                        CIRCLE (15, 377), 7, 7
                                                        PAINT (15, 377), backcol%, 7
                                                        CIRCLE (15, 377), 7, 15
                                                END IF
                                                done% = 1
                                        END IF
                                END IF
                                col% = col% + 1
                        NEXT colcoord%
                END IF
        LOOP UNTIL done% = 1 OR mousex% > 22
        END IF

        'graphical operations
        WHILE mousex% > 55
                CALL getmousestate
                ON toolselection% GOSUB points
        WEND
              
        'one-shot operations
        IF toolselection% = 12 THEN GOSUB upshift
        IF toolselection% = 34 THEN GOSUB downshift
        IF toolselection% = 13 THEN GOSUB leftshift
        IF toolselection% = 35 THEN GOSUB rightshift
        IF toolselection% = 14 THEN GOSUB rgb
        IF toolselection% = 15 THEN GOSUB size
        IF toolselection% = 16 THEN GOSUB verflip
        IF toolselection% = 17 THEN GOSUB horflip
        IF toolselection% = 18 THEN GOSUB clr
        IF toolselection% = 19 THEN GOSUB dosshell
        IF toolselection% = 20 THEN GOSUB save
        IF toolselection% = 21 THEN GOSUB load
        IF toolselection% = 22 OR toolselection% = 44 THEN COLOR 15: END
        toolselection% = 1
LOOP

points:      
        IF gridmode% = true AND (button% = 1 OR button% = 2) THEN
                IF button% = 2 THEN COLOR backcol% ELSE COLOR forecol%
                gridx% = INT((mousex% - 160) / scale%) + 1
                gridy% = INT((mousey% - 20) / scale%) + 1
                IF gridy% <= sizey% AND gridy% > 0 AND gridx% > 0 AND gridx% <= sizex% THEN
                        CALL mouseoff
                        LINE ((gridx% - 1) * scale% + 160, (gridy% - 1) * scale% + 20)-((gridx% - 1) * scale% + scale% + 159, (gridy% - 1) * scale% + scale% + 19), , BF
                        PSET (67 + gridx%, 17 + gridy%)
                        IF button% = 1 THEN
                                sprite%(gridx%, gridy%) = forecol%
                        ELSE
                                sprite%(gridx%, gridy%) = backcol%
                        END IF
                        COLOR 15
                        FOR i% = 27 TO 29
                                LOCATE i%, 1: PRINT SPACE$(2);
                        NEXT
                        LOCATE 27, 1: PRINT LTRIM$(STR$(sprite%(gridx%, gridy%)));
                        LOCATE 28, 1: PRINT LTRIM$(STR$(gridy%));
                        LOCATE 29, 1: PRINT LTRIM$(STR$(gridx%));
                        LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 15, B
                        IF button% = 2 THEN COLOR backcol% ELSE COLOR forecol%
                        CALL mouseon
                END IF
        END IF
RETURN

'save routine
save:
COLOR 15
LOCATE 30, 1: PRINT SPACE$(30);
LOCATE 30, 1: INPUT ; "Filename:", filename$
IF INSTR(filename$, ".") = 0 THEN
        IF LEN(filename$) > 8 THEN GOTO save ELSE filename$ = filename$ + ".spr"
ELSE
        IF LEN(LEFT$(filename$, INSTR(filename$, ".") - 1)) > 8 THEN GOTO save
        IF LEN(MID$(filename$, INSTR(filename$, ".") + 1)) > 3 THEN GOTO save
END IF
LOCATE 30, 1: PRINT SPACE$(30);
COLOR forecol%
IF filename$ = ".spr" THEN RETURN
OPEN filename$ FOR OUTPUT AS #1
PRINT #1, sizex%, sizey%
FOR i% = 0 TO 15
        PRINT #1, pal&(i%)
NEXT
FOR y% = 1 TO sizey%
        s$ = ""
        FOR x% = 1 TO sizex%
                s$ = s$ + LTRIM$(STR$(sprite%(x%, y%))) + "."
        NEXT
        PRINT #1, s$
NEXT
CLOSE #1
RETURN

'load routine
load:
COLOR 15
LOCATE 30, 1: PRINT SPACE$(30);
LOCATE 30, 1: INPUT ; "Filename:", filename$
IF INSTR(filename$, ".") = 0 THEN
        IF LEN(filename$) > 8 THEN GOTO load ELSE filename$ = filename$ + ".spr"
ELSE
        IF LEN(LEFT$(filename$, INSTR(filename$, ".") - 1)) > 8 THEN GOTO load
        IF LEN(MID$(filename$, INSTR(filename$, ".") + 1)) > 3 THEN GOTO load
END IF
LOCATE 30, 1: PRINT SPACE$(30);
COLOR forecol%
IF filename$ = ".spr" THEN RETURN
OPEN filename$ FOR APPEND AS #1
IF LOF(1) = 0 THEN CLOSE #1: KILL filename$: GOTO load
CLOSE #1
OPEN filename$ FOR INPUT AS #1
INPUT #1, sizex%, sizey%
FOR i% = 0 TO 15
        INPUT #1, a&
        pal&(i%) = a&
NEXT
REDIM sprite%(sizex%, sizey%)
IF INT(464 / sizex%) > INT(459 / sizey%) THEN
        scale% = INT(459 / sizey%)
ELSE
        scale% = INT(464 / sizex%)
END IF
CALL mouseoff
PALETTE USING pal&(0)
FOR y% = 1 TO sizey%
        INPUT #1, s$
        x% = 1
        DO
        a% = VAL(LEFT$(s$, INSTR(s$, ".") - 1))
        s$ = RIGHT$(s$, LEN(s$) - INSTR(s$, "."))
        LINE ((x% - 1) * scale% + 160, (y% - 1) * scale% + 20)-((x% - 1) * scale% + scale% + 159, (y% - 1) * scale% + scale% + 19), a%, BF
        LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 15, B
        PSET (67 + x%, 17 + y%), a%
        sprite%(x%, y%) = a%
        x% = x% + 1
        LOOP UNTIL x% > sizex%
NEXT
CALL mouseon
CLOSE #1
RETURN

'clear routine
clr:
CALL mouseoff
LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 0, BF
LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 15, B
FOR y% = 1 TO sizey%
        x% = 1
        DO
        PSET (67 + x%, 17 + y%), 0
        sprite%(x%, y%) = 0
        x% = x% + 1
        LOOP UNTIL x% > sizex%
NEXT
CALL mouseon
RETURN

'upshift routine
upshift:
CALL mouseoff
DIM oldsprite%(sizex%)
FOR x% = 1 TO sizex%
        oldsprite%(x%) = sprite%(x%, 1)
NEXT
FOR x% = 1 TO sizex%
        y% = 1
        DO
        IF y% < sizey% THEN
                sprite%(x%, y%) = sprite%(x%, y% + 1)
        ELSE
                sprite%(x%, y%) = oldsprite%(x%)
        END IF
        LINE ((x% - 1) * scale% + 160, (y% - 1) * scale% + 20)-((x% - 1) * scale% + scale% + 159, (y% - 1) * scale% + scale% + 19), sprite%(x%, y%), BF
        LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 15, B
        PSET (67 + x%, 17 + y%), sprite%(x%, y%)
        y% = y% + 1
        LOOP UNTIL y% > sizey%
NEXT
ERASE oldsprite%
CALL mouseon
RETURN

'downshiftroutine
downshift:
CALL mouseoff
DIM oldsprite%(sizex%)
FOR x% = 1 TO sizex%
        oldsprite%(x%) = sprite%(x%, sizey%)
NEXT
FOR x% = 1 TO sizex%
        y% = sizey%
        DO
        IF y% > 1 THEN
                sprite%(x%, y%) = sprite%(x%, y% - 1)
        ELSE
                sprite%(x%, y%) = oldsprite%(x%)
        END IF
        LINE ((x% - 1) * scale% + 160, (y% - 1) * scale% + 20)-((x% - 1) * scale% + scale% + 159, (y% - 1) * scale% + scale% + 19), sprite%(x%, y%), BF
        LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 15, B
        PSET (67 + x%, 17 + y%), sprite%(x%, y%)
        y% = y% - 1
        LOOP UNTIL y% = 0
NEXT
ERASE oldsprite%
CALL mouseon
RETURN

'leftshift routine
leftshift:
CALL mouseoff
DIM oldsprite%(sizey%)
FOR y% = 1 TO sizey%
        oldsprite%(y%) = sprite%(1, y%)
NEXT
FOR y% = 1 TO sizey%
        x% = 1
        DO
        IF x% < sizex% THEN
                sprite%(x%, y%) = sprite%(x% + 1, y%)
        ELSE
                sprite%(x%, y%) = oldsprite%(y%)
        END IF
        LINE ((x% - 1) * scale% + 160, (y% - 1) * scale% + 20)-((x% - 1) * scale% + scale% + 159, (y% - 1) * scale% + scale% + 19), sprite%(x%, y%), BF
        LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 15, B
        PSET (67 + x%, 17 + y%), sprite%(x%, y%)
        x% = x% + 1
        LOOP UNTIL x% > sizex%
NEXT
ERASE oldsprite%
CALL mouseon
RETURN

'rightshift routine
rightshift:
CALL mouseoff
DIM oldsprite%(sizey%)
FOR y% = 1 TO sizey%
        oldsprite%(y%) = sprite%(sizex%, y%)
NEXT
FOR y% = 1 TO sizey%
        x% = sizex%
        DO
        IF x% > 1 THEN
                sprite%(x%, y%) = sprite%(x% - 1, y%)
        ELSE
                sprite%(x%, y%) = oldsprite%(y%)
        END IF
        LINE ((x% - 1) * scale% + 160, (y% - 1) * scale% + 20)-((x% - 1) * scale% + scale% + 159, (y% - 1) * scale% + scale% + 19), sprite%(x%, y%), BF
        LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 15, B
        PSET (67 + x%, 17 + y%), sprite%(x%, y%)
        x% = x% - 1
        LOOP UNTIL x% = 0
NEXT
ERASE oldsprite%
CALL mouseon
RETURN

'horizontal flip routine
horflip:
CALL mouseoff
FOR y% = 1 TO sizey%
        x% = 1
        DO
        IF x% <= sizex% / 2 THEN SWAP sprite%(x%, y%), sprite%(sizex% + 1 - x%, y%)
        LINE ((x% - 1) * scale% + 160, (y% - 1) * scale% + 20)-((x% - 1) * scale% + scale% + 159, (y% - 1) * scale% + scale% + 19), sprite%(x%, y%), BF
        LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 15, B
        PSET (67 + x%, 17 + y%), sprite%(x%, y%)
        x% = x% + 1
        LOOP UNTIL x% > sizex%
NEXT
CALL mouseon
RETURN

'vertical flip routine
verflip:
CALL mouseoff
FOR x% = 1 TO sizex%
        y% = 1
        DO
        IF y% <= sizey% / 2 THEN SWAP sprite%(x%, y%), sprite%(x%, sizey% + 1 - y%)
        LINE ((x% - 1) * scale% + 160, (y% - 1) * scale% + 20)-((x% - 1) * scale% + scale% + 159, (y% - 1) * scale% + scale% + 19), sprite%(x%, y%), BF
        LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 15, B
        PSET (67 + x%, 17 + y%), sprite%(x%, y%)
        y% = y% + 1
        LOOP UNTIL y% > sizey%
NEXT
CALL mouseon
RETURN

'changing the size routine
size:
CALL mouseoff
oldx% = sizex%: oldy% = sizey%
COLOR 15
DO
        LOCATE 30, 1: INPUT ; "X(width):", sizex%
LOOP UNTIL sizex% > 0 AND sizex% <= 60
LOCATE 30, 1: PRINT SPACE$(20);
ysize:
DO
        LOCATE 30, 1: INPUT ; "Y(height):", sizey%
LOOP UNTIL sizey% > 0 AND sizey% <= 60
COLOR forecol%
LOCATE 30, 1: PRINT SPACE$(20);
IF sizex% = oldx% AND sizey% = oldy% THEN CALL mouseon: RETURN
oldscale% = scale%
IF INT(464 / sizex%) > INT(459 / sizey%) THEN
        scale% = INT(459 / sizey%)
ELSE
        scale% = INT(464 / sizex%)
END IF
REDIM sprite%(sizex%, sizey%)
IF oldx% > sizex% THEN ox% = sizex% ELSE ox% = oldx%
IF oldy% > sizey% THEN oy% = sizey% ELSE oy% = oldy%
FOR y% = 1 TO oy%
        FOR x% = 1 TO ox%
                sprite%(x%, y%) = POINT(67 + x%, 17 + y%)
        NEXT
NEXT
LINE (160, 20)-((oldx% - 1) * oldscale% + oldscale% + 159, (oldy% - 1) * oldscale% + oldscale% + 19), 0, BF
LINE (65, 15)-(70 + oldx%, 20 + oldy%), 0, BF
LINE (65, 15)-(70 + sizex%, 20 + sizey%), 15, B
FOR y% = 1 TO sizey%
        FOR x% = 1 TO sizex%
                LINE ((x% - 1) * scale% + 160, (y% - 1) * scale% + 20)-((x% - 1) * scale% + scale% + 159, (y% - 1) * scale% + scale% + 19), sprite%(x%, y%), BF
                PSET (67 + x%, 17 + y%), sprite%(x%, y%)
        NEXT
NEXT
LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 15, B
CALL mouseon
RETURN

dosshell:
CALL mouseoff
SCREEN 0
CLS
PRINT "Type EXIT to get back to Sprite Designer"
SHELL
SCREEN smode%
PALETTE USING pal&(0)
CALL coloursandtools
CIRCLE (15, 357), 7, 15
PAINT (15, 357), forecol%, 15
CIRCLE (15, 377), 7, 15
PAINT (15, 377), backcol%, 15
FOR y% = 1 TO sizey%
        FOR x% = 1 TO sizex%
                LINE ((x% - 1) * scale% + 160, (y% - 1) * scale% + 20)-((x% - 1) * scale% + scale% + 159, (y% - 1) * scale% + scale% + 19), sprite%(x%, y%), BF
                PSET (67 + x%, 17 + y%), sprite%(x%, y%)
        NEXT
NEXT
LINE (160, 20)-((sizex% - 1) * scale% + scale% + 159, (sizey% - 1) * scale% + scale% + 19), 15, B
CALL mouseon
RETURN

rgb:
CALL mouseoff
COLOR 15
attrib:
LOCATE 30, 1: PRINT SPACE$(25);
LOCATE 30, 1: INPUT ; "Change Attribute:", attrib$
IF attrib$ = "" THEN GOTO done
attrib% = VAL(attrib$)
IF attrib% < 0 OR attrib% > 15 THEN GOTO attrib
red:
LOCATE 30, 1: PRINT SPACE$(25);
LOCATE 30, 1: INPUT ; "Red Coefficient:", red$
IF red$ = "" THEN GOTO done
red% = VAL(red$)
IF red% < 0 OR red% > 63 THEN GOTO red
green:
LOCATE 30, 1: PRINT SPACE$(25);
LOCATE 30, 1: INPUT ; "Green Coefficient:", green$
IF green$ = "" THEN GOTO done
green% = VAL(green$)
IF green% < 0 OR green% > 63 THEN GOTO green
blue:
LOCATE 30, 1: PRINT SPACE$(25);
LOCATE 30, 1: INPUT ; "Blue Coefficient:", blue$
LOCATE 30, 1: PRINT SPACE$(25);
IF blue$ = "" THEN GOTO done
blue% = VAL(blue$)
IF blue% < 0 OR blue% > 63 THEN GOTO blue
IF attrib% = 15 AND (blue% = 0 OR green% = 0 OR red% = 0) THEN GOTO done
col& = 65536 * blue% + 256 * green% + red%
PALETTE attrib%, col&
pal&(attrib%) = col&
done:
CALL mouseon
RETURN

spritefiles:
DATA vshift,hshift,rgb,size
DATA verflip,horflip,clear
DATA dos,save,load,quit

REM $STATIC
SUB coloursandtools

'Colours
bcol% = 0
FOR circles% = 17 TO 317 STEP 20
        CIRCLE (15, circles%), 7, 15
        PAINT (15, circles%), bcol%, 15
        bcol% = bcol% + 1
NEXT circles%

'Tools
FOR tools% = 10 TO ymax% - 40 STEP 20
        LINE (25, tools%)-(47, tools% + 18), 15, B
NEXT tools%

OPEN "points.spr" FOR INPUT AS #1
INPUT #1, xmax%, ymax%
FOR y% = 1 TO ymax%
        INPUT #1, s$
        x% = 1
        DO
        a% = VAL(LEFT$(s$, INSTR(s$, ".") - 1))
        s$ = RIGHT$(s$, LEN(s$) - INSTR(s$, "."))
        PSET (25 + x%, 10 + y%), a%
        x% = x% + 1
        LOOP UNTIL x% > xmax%
NEXT
CLOSE #1

RESTORE spritefiles
FOR i% = 1 TO 11
READ filename$
OPEN filename$ + ".spr" FOR INPUT AS #1
INPUT #1, x%, y%
FOR y% = 1 TO 17
        INPUT #1, s$
        x% = 1
        DO
        a% = VAL(LEFT$(s$, INSTR(s$, ".") - 1))
        s$ = RIGHT$(s$, LEN(s$) - INSTR(s$, "."))
        PSET (25 + x%, 210 + (i% * 20) + y%), a%
        x% = x% + 1
        LOOP UNTIL x% > 21
NEXT
CLOSE #1
NEXT

LINE (65, 15)-(70 + sizex%, 20 + sizey%), 15, B

END SUB

SUB getmousestate
        inary%(ax) = &H3
        CALL int86old(&H33, inary%(), outary%())
        mousex% = outary%(cx)
        mousey% = outary%(dx)
        button% = outary%(bx)
END SUB

SUB mouseinit
        inary%(ax) = 0
        CALL int86old(&H33, inary%(), outary%())
END SUB

SUB mouseoff
        inary%(ax) = &H2
        CALL int86old(&H33, inary%(), outary%())
END SUB

SUB mouseon
        inary%(ax) = &H1
        CALL int86old(&H33, inary%(), outary%())
END SUB

SUB setpalette
pal&(0) = 0
pal&(1) = 65536 * 3 + 256 * 3 + 3
pal&(2) = 65536 * 7 + 256 * 7 + 7
pal&(3) = 65536 * 11 + 256 * 11 + 11
pal&(4) = 65536 * 15 + 256 * 15 + 15
pal&(5) = 65536 * 19 + 256 * 19 + 19
pal&(6) = 65536 * 23 + 256 * 23 + 23
pal&(7) = 65536 * 27 + 256 * 27 + 27
pal&(8) = 65536 * 31 + 256 * 31 + 31
pal&(9) = 65536 * 35 + 256 * 35 + 35
pal&(10) = 65536 * 39 + 256 * 39 + 39
pal&(11) = 65536 * 43 + 256 * 43 + 43
pal&(12) = 65536 * 47 + 256 * 47 + 47
pal&(13) = 65536 * 51 + 256 * 51 + 51
pal&(14) = 65536 * 55 + 256 * 55 + 55
pal&(15) = 65536 * 63 + 256 * 63 + 63
PALETTE USING pal&(0)

END SUB

