DECLARE FUNCTION eval# (a$)
DECLARE SUB evalpost (a$, r#)
DECLARE SUB parse (l$)
DECLARE SUB push (a#)
DECLARE SUB pop (a#)
DECLARE SUB buildpost (a$, t%, tval#)

'Infix to postfix form

DIM SHARED stack#(100)
COMMON SHARED top%

top% = 0
DO
INPUT "Expression in infix form:", in$
PRINT eval(in$)
LOOP

END



SUB buildpost (a$, t%, tval#)

SELECT CASE t%
CASE 42, 43, 45, 47
  a$ = a$ + CHR$(t%) + ";"
CASE 256
  a$ = a$ + LTRIM$(STR$(tval#)) + ";"
CASE ELSE
END SELECT

END SUB

FUNCTION eval# (a$)

CALL parse(a$)
CALL evalpost(a$, result#)
eval# = result#

END FUNCTION

SUB evalpost (a$, r#)

DO
  op% = 0
  n# = VAL(a$)
  IF n# = 0 THEN
    op% = ASC(a$)
    a$ = RIGHT$(a$, LEN(a$) - 1)
  ELSE
    a$ = RIGHT$(a$, LEN(a$) - LEN(STR$(n#)))
  END IF
  SELECT CASE op%
    CASE 0
      CALL push(n#)
    CASE 42
      CALL pop(a#)
      CALL pop(b#)
      CALL push(a# * b#)
    CASE 43
      CALL pop(a#)
      CALL pop(b#)
      CALL push(a# + b#)
    CASE 45
      CALL pop(a#)
      CALL pop(b#)
      CALL push(b# - a#)
    CASE 47
      CALL pop(a#)
      CALL pop(b#)
      CALL push(b# / a#)
    END SELECT
LOOP UNTIL a$ = ""
CALL pop(r#)

END SUB

SUB parse (l$)

GOSUB lexan
WHILE lookahead% <> 260
  GOSUB expr
  matchchar% = 59
  GOSUB match
WEND

l$ = LEFT$(b$, LEN(b$) - 1)

EXIT SUB

expr:
  GOSUB term
  DO
    SELECT CASE lookahead%
    CASE 43, 45
      expr% = lookahead%
      matchchar% = expr%
      GOSUB match
      GOSUB term
      CALL buildpost(b$, expr%, 0)
    CASE ELSE
      RETURN
    END SELECT
  LOOP
RETURN

term:
  GOSUB factor
  DO
    SELECT CASE lookahead%
    CASE 42, 47
      term% = lookahead%
      matchchar% = term%
      GOSUB match
      GOSUB factor
      CALL buildpost(b$, term%, 0)
    CASE ELSE
      RETURN
    END SELECT
  LOOP
RETURN

factor:
  SELECT CASE lookahead%
  CASE 40
    matchchar% = 40
    GOSUB match
    GOSUB expr
    matchchar% = 41
    GOSUB match
  CASE 256
    CALL buildpost(b$, 256, tokenval#)
    matchchar% = 256
    GOSUB match
  CASE ELSE
    PRINT "Syntax error"
  END SELECT
RETURN

match:
  IF lookahead% = matchchar% THEN
    GOSUB lexan
  ELSEIF lookahead% <> 260 THEN
    PRINT "Syntax error"
  END IF
RETURN

lexan:
DO
  IF LEN(l$) = 0 THEN lookahead% = 260: RETURN
  lex% = ASC(l$)
  l$ = RIGHT$(l$, LEN(l$) - 1)
  SELECT CASE lex%
    CASE 32, 9
    CASE 13
      lineno% = lineno% + 1
    CASE 48 TO 57
      l$ = CHR$(lex%) + l$
      l# = VAL(l$)
      l$ = RIGHT$(l$, LEN(l$) - LEN(LTRIM$(STR$(l#))))
      tokenval# = l#
      lookahead% = 256
      RETURN
    CASE 65 TO 90, 97 TO 122
    CASE ELSE
      tokenval# = 0
      lookahead% = lex%
      RETURN
    END SELECT
LOOP
RETURN

END SUB

SUB pop (a#)

top% = top% - 1
IF top% < 0 THEN
  a# = 0
  top% = 0
  EXIT SUB
END IF
a# = stack#(top%)

END SUB

SUB push (a#)

IF top% > 100 THEN EXIT SUB
stack#(top%) = a#
top% = top% + 1

END SUB

