/*  Ofront+ SYSTEM config */

#ifndef __SYSTEM_Cfg__h
#define __SYSTEM_Cfg__h

/* depending on kernel32.dll or msvcrt.dll */
#define SYSTEM_Cfg_KERNEL32
//#define SYSTEM_Cfg_MSVCRT

/* runtime system routines */
//#define SYSTEM_Cfg_IncRef

/* module registry */
#define SYSTEM_Cfg_NotRegisterModules
#define SYSTEM_Cfg_NotRegisterMain
#define SYSTEM_Cfg_NotRegisterCommands

/* record type descriptors */
#define SYSTEM_Cfg_NoRecTypeDesc
#define SYSTEM_Cfg_NoInitTypes

/* Oberon-2 type bound procedures support */
#define SYSTEM_Cfg_SimpleTypeBoundProc

/* Garbage collector */
#define SYSTEM_Cfg_NoGC
#define SYSTEM_Cfg_NoInitPlatform

/* runtime checks */
#define SYSTEM_Cfg_NoCheck_X
#define SYSTEM_Cfg_NoASSERT

#endif //__SYSTEM_Cfg__h
