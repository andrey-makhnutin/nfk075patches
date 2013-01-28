// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"
#include "netdebug.h"
#include "hook.h"

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		setLogFilename("netdebuglog.txt");
		if (!hookInit())
			return FALSE;
		if (!hook((unsigned char *)0x4BABF0, sessionStart, 0, 9, NULL))
			return FALSE;
		if (!hook((unsigned char *)0x4C0785, sessionStart, 1, 9, NULL))
			return FALSE;
		if (!hook((unsigned char *)0x536D27, sessionStart, 1, 9, NULL))
			return FALSE;
		if (!hook((unsigned char *)0x5078FF, sessionEnd, 0, 5, NULL))
			return FALSE;
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

