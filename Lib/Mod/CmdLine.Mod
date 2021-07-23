MODULE CmdLine;	(** Command line parameter handling *)

IMPORT Platform;

TYPE
  Char* = CHAR;
  String* = ARRAY 1024 OF Char;

VAR
  ParamCount-: INTEGER; (* argc - 1 *)

PROCEDURE GetParam* (n: INTEGER; VAR param: ARRAY OF Char);
(**
  Under Windows all wide characters are replaced by "?".
  Under Linux all non-ASCII characters provided in UTF-8.
*)
BEGIN
  Platform.GetArg(n, param);
END GetParam;

BEGIN
  ParamCount := Platform.ArgCount - 1;
END CmdLine.
