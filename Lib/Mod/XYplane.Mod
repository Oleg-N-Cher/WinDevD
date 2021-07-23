MODULE XYplane; (** Some basic facilities for graphics programming. *)
IMPORT GrApp;

(* Module XYplane provides some basic facilities for graphics programming. Its interface is kept as simple as possible and is therefore more suited for programming exercises than for serious graphics applications.

XYplane provides a Cartesian plane of pixels that can be drawn and erased. The plane is mapped to some location on the screen. The variables X and Y indicate its lower left corner, W its width and H its height. All variables are read-only.

Remarks
-------
In the ETH Oberon System Open opens a viewer that takes the whole user track.  The contents of this viewer is the drawing plane provided by XYplane.


Origin
------
Designed by Martin Reiser for the book 'Programming in Oberon'. The above specification was proposed by H Moessenboeck, ETH *)

CONST
  draw* = 1; erase* = 0;

VAR
  X-, Y-, W-, H-: INTEGER;

PROCEDURE Open* ; (* Open initializes the drawing plane. *)
END Open;

PROCEDURE Clear* ; (* Clear erases all pixels in the drawing plane. *)
BEGIN
  GrApp.Clear();
END Clear;

PROCEDURE Dot (x, y, mode: INTEGER);
END Dot;

PROCEDURE IsDot (x, y: INTEGER): BOOLEAN;
END IsDot;

PROCEDURE Key (): CHAR;
END Key;

END XYplane.


Operations
----------





Dot(x, y, m) draws or erases the pixel at the coordinates (x, y) relative to the lower left corner of the plane. If m=draw the pixel is drawn, if m=erase the pixel is erased.

IsDot(x, y) returns TRUE if the pixel at the coordinates (x, y) relative to the lower left corner of the screen is drawn, otherwise it returns FALSE.

Key() reads the keyboard. If a key was pressed prior to invocation, its character value is returned, otherwise the result is 0X.



