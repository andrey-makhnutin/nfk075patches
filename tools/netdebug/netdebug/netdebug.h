// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the NETDEBUG_EXPORTS
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// NETDEBUG_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef NETDEBUG_EXPORTS
#define NETDEBUG_API extern "C" __declspec(dllexport)
#else
#define NETDEBUG_API extern "C" __declspec(dllimport)
#endif

#pragma pack(push, 1)
typedef struct {
	unsigned char length;
	char string[1];
} ShortString;
#pragma pack(pop)

NETDEBUG_API int __stdcall getVersion(void);
NETDEBUG_API void __stdcall getExports(unsigned int *exports);

void __stdcall sessionStart(unsigned int isServer);