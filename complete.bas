'Program to complete words

DECLARE SUB match (c$, m%)

CLS

DO
  DO
    k$ = INKEY$
  LOOP UNTIL k$ <> ""
  SELECT CASE k$
    CASE "A" TO "Z", "a" TO "z"
      a$ = a$ + k$
    CASE CHR$(8)
      IF LEN(a$) > 0 THEN a$ = LEFT$(a$, LEN(a$) - 1)
    CASE CHR$(9)
      CALL match(a$, n%)
    CASE ELSE
  END SELECT
  LOCATE 1, 1, 1: PRINT SPACE$(80); : LOCATE 1, 1, 1: PRINT a$;
LOOP UNTIL k$ = CHR$(27)

END

SUB match (c$, m%)

DIM arr$(99)

i% = 0
OPEN "words" FOR INPUT AS #1
DO WHILE (NOT EOF(1) AND i% < 99)
  LINE INPUT #1, test$
  test$ = LCASE$(test$)
  IF c$ = LEFT$(test$, LEN(c$)) THEN
    arr$(i%) = test$
    i% = i% + 1
  END IF
LOOP
CLOSE #1

IF i% = 0 THEN
  m% = 0: GOTO printmatches
ELSE
  m% = i%
END IF

FOR j% = LEN(c$) + 1 TO LEN(arr$(0))
  ok% = 1
  FOR k% = 1 TO i% - 1
    IF (LEFT$(arr$(k%), j%) <> LEFT$(arr$(0), j%)) THEN ok% = 0
  NEXT
  IF ok% = 1 THEN c$ = LEFT$(arr$(0), j%) ELSE EXIT FOR
NEXT

printmatches:

CLS
LOCATE 2, 1, 0: PRINT "Possible matches:";
LOCATE 3, 1, 0
FOR j% = 0 TO i% - 1
  IF CSRLIN = 24 THEN PRINT "(And more...)"; : EXIT FOR
  IF 80 - POS(0) < LEN(arr$(j%)) + 2 THEN PRINT CHR$(13);
  PRINT arr$(j%); "  ";
NEXT
IF i% = 0 THEN
  LOCATE 3, 1, 0: PRINT SPACE$(80);
  LOCATE 3, 1, 0: PRINT "None"
END IF

END SUB

