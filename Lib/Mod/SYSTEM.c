/*
*   The body prefix file of the voc(jet backend) runtime system, Version 1.0
*
*   Copyright (c) Software Templ, 1994, 1995
*
*   Module SYSTEM is subject to change any time without prior notification.
*   Software Templ disclaims all warranties with regard to module SYSTEM,
*   in particular shall Software Templ not be liable for any damage resulting
*   from inappropriate use or modification of module SYSTEM.
*
*   Version 1.1  jt, 24.11.95  fixes for correct pointer arithmetic on Cray computers
*   jt 31.1.2007  ANSI prototypes for malloc and exit in order to avoid cc warnings
*
*/

#include "SYSTEM.oh"
#include <math.h>
#include <stdarg.h>
#include <signal.h>
#include <stdlib.h>


void (*SYSTEM_AssertFailHandler)(INTEGER n, CHAR *mod, INTEGER pos);
void (*SYSTEM_HaltHandler)(INTEGER n, CHAR *mod, INTEGER pos);


// Procedure verions of SYSTEM.H versions used when a multiply accessed
// parameter has side effects.

LONGINT SYSTEM_XCHK(LONGINT i, LONGINT ub, CHAR *mod, INTEGER pos) {return __X(i, ub, mod, pos);}
LONGINT SYSTEM_RCHK(LONGINT i, LONGINT ub, CHAR *mod, INTEGER pos) {return __R(i, ub, mod, pos);}
INTEGER SYSTEM_ASH (INTEGER x, INTEGER n)  {return __ASH(x, n, INTEGER);}
LONGINT SYSTEM_ASHL(LONGINT x, INTEGER n)  {return __ASH(x, n, LONGINT);}


INTEGER SYSTEM_ENTIER(REAL x)
{
  INTEGER i;
  i = (INTEGER)x;
  if (i > x) i--;
  return i;
}

LONGINT SYSTEM_ENTIERL(REAL x)
{
  LONGINT i;
  i = (LONGINT)x;
  if (i > x) i--;
  return i;
}

// String comparison

int SYSTEM_STRCMP(CHAR *x, CHAR *y)
{
  int i = 0;
  CHAR ch1, ch2;
  do {ch1 = x[i]; ch2 = y[i]; i++;
    if (!ch1) return -(int)ch2;
  } while (ch1==ch2);
  return (int)ch1 - (int)ch2;
}


void SYSTEM_INIT(INTEGER argc, void *argv)
{
  //SYSTEM_MainStackFrame = stktop; // MUST be aligned
  //SYSTEM_ArgCount = argc;
  //SYSTEM_ArgVector = argv;
  SYSTEM_AssertFailHandler = 0;
  SYSTEM_HaltHandler = 0;
  // This function (SYSTEM_INIT) is called at program startup BEFORE any
  // modules have been initalized. In turn we must initialize the heap
  // before module startup (xxx__init) code is run.
  //Heap_InitHeap();
}


typedef void (*SystemSignalHandler)(INTEGER); // = Platform_SignalHandler

#ifndef _WIN32

    void SYSTEM_HALT(INTEGER n, CHAR *mod, INTEGER pos) {
      if (SYSTEM_HaltHandler != 0) SYSTEM_HaltHandler(n, mod, pos);
      exit(n);
    }

    void SYSTEM_ASSERT_FAIL(INTEGER n, CHAR *mod, INTEGER pos) {
      if (SYSTEM_AssertFailHandler != 0) SYSTEM_AssertFailHandler(n, mod, pos);
      exit(n);
    }


    SystemSignalHandler handler[3] = {0};

    // Provide signal handling for Unix based systems
    void signalHandler(int s) {
        if (s >= 2  &&  s <= 4) handler[s-2](s);
        // (Ignore other signals)
    }

    void SystemSetHandler(int s, SYSTEM_ADRINT h) {
        if (s >= 2 && s <= 4) {
            int needtosetsystemhandler = handler[s-2] == 0;
            handler[s-2] = (SystemSignalHandler)h;
            if (needtosetsystemhandler) {signal(s, signalHandler);}
        }
    }

    void SystemSetInterruptHandler(SYSTEM_ADRINT h) {
        SystemSetHandler(2, h);
    }

    void SystemSetQuitHandler(SYSTEM_ADRINT h) {
        SystemSetHandler(3, h);
    }

    void SystemSetBadInstructionHandler(SYSTEM_ADRINT h) {
        SystemSetHandler(4, h);
    }

#else

    void __attribute__((__stdcall__)) ExitProcess (int);

    void SYSTEM_HALT(INTEGER n, CHAR *mod, INTEGER pos) {
      if (SYSTEM_HaltHandler != 0) SYSTEM_HaltHandler(n, mod, pos);
      ExitProcess(n);
    }

    void SYSTEM_ASSERT_FAIL(INTEGER n, CHAR *mod, INTEGER pos) {
      if (SYSTEM_AssertFailHandler != 0) SYSTEM_AssertFailHandler(n, mod, pos);
      ExitProcess(n);
    }


    // Provides Windows callback handlers for signal-like scenarios

    SystemSignalHandler SystemInterruptHandler = 0;
    SystemSignalHandler SystemQuitHandler      = 0;

#endif
