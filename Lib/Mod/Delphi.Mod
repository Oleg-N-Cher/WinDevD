MODULE Delphi;

IMPORT SYSTEM;

TYPE
  ADR = POINTER [1] TO ARRAY [1] 1 OF CHAR; (* 32 or 64 bit *)

PROCEDURE HiWord* (i: INTEGER): INTEGER;
BEGIN
  RETURN i DIV 10000H
END HiWord;

PROCEDURE LoWord* (i: INTEGER): INTEGER;
BEGIN
  RETURN ORD( BITS(i) * BITS(0FFFFH) )
END LoWord;

PROCEDURE FillChar* (adr: ADR; count: INTEGER; fill: BYTE);
BEGIN
  WHILE count > 0 DO
    SYSTEM.PUT(adr, fill);
    IF SIZE(ADR) = SIZE(INTEGER) THEN
      adr := SYSTEM.VAL(ADR, SYSTEM.VAL(INTEGER, adr) + 1);
    ELSE
      adr := SYSTEM.VAL(ADR, SYSTEM.VAL(LONGINT, adr) + 1);
    END;
    DEC(count);
  END;
END FillChar;

PROCEDURE- _init* "/*-noinit*/"; 

END Delphi.
