MODULE PureWindow;

IMPORT W := WinApi;

(*

HWND OpenWindow(int a1, int X, int Y, LONG a4, LONG a5, LPCSTR lpWindowName, int a7, HWND hWndParent)

*)
PROCEDURE OpenWindow* (window, x, y, innerWidth, innerHeight: INTEGER;
  IN title: ARRAY OF CHAR; flags: SET; parentWindowID: INTEGER): INTEGER;
VAR
  v8: INTEGER; (*?*)
  dwExStyle: SET;
  v31: INTEGER; (*?*)
  v9: INTEGER; (*?*)
BEGIN
  (* v8 = 0; *)
  v8 := 0;
  (* dwExStyle = 0; *)
  dwExStyle := {};
  (* v31 = 1; *)
  v31 := 1;
  (* v9 = sub_4053AB(dword_408A2C, a1); *)
  v9 = sub_4053AB(dword_408A2C, window);

  RegisterClassA

END OpenWindow;

END PureWindow.
