MODULE FBWindow;

IMPORT SYSTEM, W := WinApi;

PROCEDURE OpenWindowEx* (
  IN name: ARRAY OF CHAR; x, y, width, height: INTEGER; style1, style2: SET)
    : W.HWND;
VAR
  wc: W.WNDCLASSEX; err: INTEGER; hwn: W.HWND;
BEGIN (*
  Static doba As Integer
  doba= doba+1
  If LOLILOLILOLI=0 Then
    LISALIST= New List10
    CLASSLIST=New List10
    ColorList=New List10
    LOLILOLILOLI=1
  EndIf
  CLASSLIST->AddLastS10("CLASSCLASS_"+Str(Time())+ Str(doba))
*)

    wc.cbSize := SIZE( W.WNDCLASSEX );
    wc.style := W.CS_HREDRAW + W.CS_VREDRAW;
    (* wc.lpfnWndProc := Cast(WNDPROC,GetFbGuiWinProc()); *)
    wc.hInstance := W.GetModuleHandle(NIL);
    wc.hbrBackground := SYSTEM.VAL(W.HGDIOBJ, 16);
    (* wc.lpszClassName := StrPtr(CLASSLIST->FindByID10(doba)->VALUES); *)
    wc.hIcon := W.LoadIcon( NIL, SYSTEM.VAL(W.HICON, W.IDI_APPLICATION) );
    wc.hIconSm := wc.hIcon;
    wc.hCursor := W.LoadCursor( NIL, SYSTEM.VAL(W.HCURSOR, W.IDC_ARROW) );

  IF W.RegisterClassEx(wc) = 0 THEN
    err := W.GetLastError();
    (*C.printfd("Not Registered class , Error = " & e *)
    RETURN NIL
  END;

  hwn := W.CreateWindowEx(
    style2,
    NIL(* StrPtr(CLASSLIST->FindByID10(doba)->VALUES) *) ,
    SYSTEM.VAL(W.PtrSTR, SYSTEM.ADR( name )),
    style1, x, y, width, height, NIL, NIL, NIL, NIL
  );
  (* LISALIST->Setgurrent(hwn) *)

  RETURN hwn
END OpenWindowEx;

PROCEDURE OpenWindow* (IN name: ARRAY OF CHAR; x, y, width, height: INTEGER)
  : W.HWND;
BEGIN
  RETURN OpenWindowEx(
    name, x, y, width, height, W.WS_OVERLAPPEDWINDOW + W.WS_VISIBLE, {}
  )
END OpenWindow;

END FBWindow.
