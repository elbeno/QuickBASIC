'Ed's formula program,
'featuring full support for quartics, cubics, quadratics and linear equations
'in x.
'Upgrades coming soon... if I can find the time and the brainpower!

'Declare subroutines
DECLARE SUB Triangle ()
DECLARE SUB StartRoutine ()

'Dimension arrays and declare variables
OPTION BASE 0
DIM SHARED Number(5)
DIM SHARED Difference1(4)
DIM SHARED Difference2(3)
DIM SHARED Difference3(2)
DIM SHARED Difference4(1)
COMMON SHARED ExitCondition%, false, true
false = 0
true = NOT false

'Setup
BEGIN:
CLS
CALL StartRoutine
CALL Triangle
ON ExitCondition% GOSUB AllTheSame, Formula1, Formula2, Formula3, Formula4, NoFormula
ERASE Number, Difference1, Difference2, Difference3, Difference4
constantterm = 0: xterm = 0: squaredterm = 0: cubedterm = 0: quarticterm = 0
DO
LOOP UNTIL INKEY$ <> ""
GOTO BEGIN

AllTheSame:
PRINT "These numbers"
FOR a% = 0 TO 5
PRINT Number(a%);
NEXT a%
PRINT
PRINT "Are all the same you dimwit!"
RETURN

Formula1:
'Linear Equation
constantterm = Number(0) - Difference1(0)
xterm = Difference1(0)
GOSUB display
RETURN

Formula2:
'Quadratic Equation
squaredterm = Difference2(0) / 2
xterm = (Difference1(0)) - 3 * squaredterm
constantterm = Number(0) - squaredterm - xterm
GOSUB display
RETURN

Formula3:
'Cubic Equation
cubedterm = Difference3(0) / 6
squaredterm = (((Number(2) - Number(1)) - (Number(1) - Number(0))) - 12 * cubedterm) / 2
xterm = (Number(1) - Number(0)) - (7 * cubedterm) - (3 * squaredterm)
constantterm = Number(0) - cubedterm - squaredterm - xterm
GOSUB display
RETURN

Formula4:
'Quartic Equation
quarticterm = Difference4(0) / 24
cubedterm = (((Number(3) - Number(2)) - (Number(2) - Number(1))) - ((Number(2) - Number(1)) - (Number(1) - Number(0))) - 60 * quarticterm) / 6
squaredterm = (((Number(2) - Number(1)) - (Number(1) - Number(0))) - (50 * quarticterm) - (12 * cubedterm)) / 2
xterm = (Number(1) - Number(0)) - (15 * quarticterm) - (7 * cubedterm) - (3 * squaredterm)
constantterm = Number(0) - quarticterm - cubedterm - squaredterm - xterm
GOSUB display
RETURN

NoFormula:
PRINT "These numbers"
FOR a% = 0 TO 5
PRINT Number(a%);
NEXT a%
PRINT
PRINT "Have no formula that this program can detect!"
RETURN

display:
IF ABS(quarticterm) = 1 THEN quar$ = " x^4 " ELSE quar$ = STR$(quarticterm) + "x^4 "
IF ABS(cubedterm) = 1 THEN cub$ = " x^3 " ELSE cub$ = STR$(ABS(cubedterm)) + "x^3 "
IF ABS(squaredterm) = 1 THEN sq$ = " xý " ELSE sq$ = STR$(ABS(squaredterm)) + "xý "
IF ABS(xterm) = 1 THEN xterm$ = " x " ELSE xterm$ = STR$(ABS(xterm)) + "x "
IF constantterm = 0 THEN constant$ = "" ELSE constant$ = STR$(ABS(constantterm))
IF xterm = 0 THEN xterm$ = ""
IF constantterm = 0 THEN constant$ = ""
IF squaredterm = 0 THEN sq$ = ""
IF cubedterm = 0 THEN cub$ = ""
IF quarticterm = 0 THEN quar$ = ""
IF SGN(cubedterm) = 1 THEN cubsgn$ = "+"
IF SGN(cubedterm) = -1 THEN cubsgn$ = "-"
IF SGN(cubedterm) = 0 THEN cubsgn$ = ""
IF SGN(squaredterm) = 1 THEN sqsgn$ = "+"
IF SGN(squaredterm) = -1 THEN sqsgn$ = "-"
IF SGN(squaredterm) = 0 THEN sqsgn$ = ""
IF SGN(xterm) = 1 THEN xsgn$ = "+"
IF SGN(xterm) = -1 THEN xsgn$ = "-"
IF SGN(xterm) = 0 THEN xsgn$ = ""
IF SGN(constantterm) = 1 THEN consgn$ = "+"
IF SGN(constantterm) = -1 THEN consgn$ = "-"
IF SGN(constantterm) = 0 THEN consgn$ = ""
IF quar$ = "" AND cubsgn$ = "+" THEN cubsgn$ = ""
IF quar$ = "" AND cubsgn$ = "-" THEN cubsgn$ = "": cub$ = "-" + LTRIM$(cub$)
IF quar$ = "" AND cub$ = "" AND sqsgn$ = "+" THEN sqsgn$ = ""
IF quar$ = "" AND cub$ = "" AND sqsgn$ = "-" THEN sqsgn$ = "": sq$ = "-" + LTRIM$(sq$)
IF quar$ = "" AND cub$ = "" AND sq$ = "" AND xsgn$ = "+" THEN xsgn$ = ""
IF quar$ = "" AND cub$ = "" AND sq$ = "" AND xsgn$ = "-" THEN xsgn$ = "": xterm$ = "-" + LTRIM$(xterm$)
r$ = quar$ + cubsgn$ + cub$ + sqsgn$ + sq$ + xsgn$ + xterm$ + consgn$ + constant$
PRINT "The formula is:  y = " + LTRIM$(r$)
RETURN


NumberData:
DATA "First","Second","Third","Fourth","Fifth","Sixth"

SUB StartRoutine
        LOCATE 10, 5: PRINT "Please type in the series of numbers."
        PRINT TAB(5); "All numbers must be in the range 0 to 10^5 inclusive."
        PRINT TAB(5); "The equation must be of the form y = ax^4 + bx^3 + cxý + dx + e."
        RESTORE NumberData
        FOR a% = 0 TO 5
                READ a$
Again:
                PRINT a$ + " number ";
                INPUT Number(a%)
                IF Number(a%) < 0 OR Number(a%) > 10 ^ 5 THEN PRINT "Number unacceptable. Enter another.": GOTO Again
        NEXT
END SUB

SUB Triangle
        Equal = true
        FOR a% = 0 TO 4
        IF Number(a%) <> Number(a% + 1) THEN Equal = false
        NEXT
        IF Equal = true THEN
        ExitCondition% = 1: EXIT SUB
        END IF
        Equal = true
        FOR a% = 1 TO 5
        Difference1(a% - 1) = ABS(Number(a% - 1) - Number(a%))
        NEXT
        FOR a% = 1 TO 4
        IF Difference1(a% - 1) <> Difference1(a%) THEN Equal = false
        NEXT
        IF Equal = true THEN
        ExitCondition% = 2: EXIT SUB
        END IF
        Equal = true
        FOR a% = 1 TO 4
        Difference2(a% - 1) = ABS(Difference1(a% - 1) - Difference1(a%))
        NEXT
        FOR a% = 1 TO 3
        IF Difference2(a% - 1) <> Difference2(a%) THEN Equal = false
        NEXT
        IF Equal = true THEN
        ExitCondition% = 3: EXIT SUB
        END IF
        Equal = true
        FOR a% = 1 TO 3
        Difference3(a% - 1) = ABS(Difference2(a% - 1) - Difference2(a%))
        NEXT
        FOR a% = 1 TO 2
        IF Difference3(a% - 1) <> Difference3(a%) THEN Equal = false
        NEXT
        IF Equal = true THEN
        ExitCondition% = 4: EXIT SUB
        END IF
        Equal = true
        Difference4(0) = ABS(Difference3(1) - Difference3(0))
        Difference4(1) = ABS(Difference3(2) - Difference3(1))
        IF Difference4(0) <> Difference4(1) THEN Equal = false
        IF Equal = true THEN ExitCondition% = 5 ELSE ExitCondition% = 6
END SUB

