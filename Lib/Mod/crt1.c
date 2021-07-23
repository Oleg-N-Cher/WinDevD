int argc; char **argv;

void __attribute__((__stdcall__)) ExitProcess (int);
//__declspec(dllimport) int __getmainargs (int*, char***, char**, int, void*);
extern int _WinMain (int argc, char **argv);

void WinMain (void) {
  char* tmp;
  //__getmainargs(&argc, &argv, &tmp, 0, &tmp);
  ExitProcess(
    _WinMain(argc, argv)
  );
} //WinMain
