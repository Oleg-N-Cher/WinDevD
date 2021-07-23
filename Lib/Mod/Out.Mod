MODULE Out; (** A set of basic routines for formatted output. *)
IMPORT SYSTEM, Console;

PROCEDURE -Open* " "; (** initializes the output stream. *)

(* writes the character ch to the end of the output stream. *)
PROCEDURE -Char* (ch: CHAR) "Console_WriteCh(ch)";

(*
PROCEDURE  String (str: ARRAY OF CHAR); (* writes the null-terminated character sequence s to the end of the output stream (without 0X). *)

*)

(*
  Int(i, n) writes the integer number i to the end of the output stream.
  If the textual represen­tation of i requires m characters, i is right
  adjusted in a field of Max(n, m) characters pad­ded with blanks at
  the left end. A plus sign is not written.
*)
PROCEDURE Int* (i: LONGINT; n: INTEGER);
VAR
  s: ARRAY 32 OF CHAR; i1: LONGINT; k: INTEGER;
BEGIN
  IF i = SYSTEM.LSH(LONG(LONG(1)), SIZE(LONGINT)*8 - 1) THEN
    IF SIZE(LONGINT) = 8 THEN
      s := "8085774586302733229"; k := 19;
    ELSE
      s := "8463847412"; k := 10;
    END;
  ELSE
    i1 := ABS(i);
    s[0] := CHR(i1 MOD 10 + ORD("0")); i1 := i1 DIV 10; k := 1;
    WHILE i1 > 0 DO
      s[k] := CHR(i1 MOD 10 + ORD("0")); i1 := i1 DIV 10; INC(k);
    END;
  END;
  IF i < 0 THEN s[k] := "-"; INC(k) END;
  WHILE n > k DO Char(" "); DEC(n) END;
  WHILE k > 0 DO DEC(k); Char(s[k]) END;
END Int;

(*
PROCEDURE  Real   (x:   REAL;   n:   INTEGER);
PROCEDURE  LongReal   (x:   LONGREAL;   n:   INTEGER);
PROCEDURE Ln;
END Out.

1.2.4.1 Operations


Char(ch) 
String(s) writes the null-terminated character sequence s to the end of the output stream (without 0X).
Int(i, n) writes the integer number i to the end of the output stream. If the textual represen­tation of i requires m characters, i is right adjusted in a field of Max(n, m) characters pad­ded with blanks at the left end. A plus sign is not written.
Real(x, n) writes the real number x to the end of the output stream using an exponential form. If the textual representation of x requires m characters (including a two-digit signed exponent), x is right adjusted in a field of Max(n, m) characters padded with blanks at the left end. A plus sign of the mantissa is not written.
LongReal(x, n) writes the long real number x to the end of the output stream using an exponential form. If the textual representation of x requires m characters (including a three-digit signed exponent), x is right adjusted in a field of Max(n, m) characters padded with blanks at the left end. A plus sign of the mantissa is not written.
Ln writes an end-of-line symbol to the end of the output stream.
Examples
output (asterisks denote blanks)
Out.Open;
Out.Int(-3,   5);  ***3
Out.Int(3,   0);  3
Out.Real(1.5,   10);  **1.50E+00
Out.Real(-0.005;   0)  -5.0E-03

1.2.4.2  Remarks
In the ETH Oberon System the output is appended to an output text that is cleared when module Out is loaded. The output text can be displayed in a new viewer by a call to the procedure Open (Open can also be called as a command).

1.2.4.3  Origin
Designed by Martin Reiser for the book 'Programming in Oberon'. The above specifica­tion was proposed by H Mossenbock, ETH.
*)

END Out.