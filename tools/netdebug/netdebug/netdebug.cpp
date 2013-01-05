// netdebug.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "netdebug.h"

NETDEBUG_API int __stdcall getVersion(void)
{
	return 1;
}

int __stdcall nd_AddToQueue(char *data, int size, ShortString *ip_address, int port, int flags)
{
	return 1;
}

void __stdcall nd_SendData(unsigned int caller, char *data, int size, ShortString *ip_address, int port)
{
}

void __stdcall nd_ReceiveData(char *data, ShortString *ip_address, int port, int proc_state)
{
}

NETDEBUG_API void __stdcall getExports(unsigned int *exports)
{
	exports[0] = (unsigned int)nd_AddToQueue;
	exports[1] = (unsigned int)nd_SendData;
	exports[2] = (unsigned int)nd_ReceiveData;
}