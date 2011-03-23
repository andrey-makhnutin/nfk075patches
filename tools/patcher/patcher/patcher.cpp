// patcher.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

typedef struct _peCtx
{
	unsigned long baseAddress;
	unsigned int sectionCount;
	IMAGE_SECTION_HEADER *sections;
} peCtx;

typedef struct _patchInfo
{
	unsigned long patchAddress;
	unsigned long patchLength;
} patchInfo;

#define GETWORD(buf, offset) (*(unsigned short*)(buf + offset))
#define GETDWORD(buf, offset) (*(unsigned long*)(buf + offset))

unsigned long VAtoRAW(peCtx *ctx, unsigned long VA)
{
	unsigned int i;

	if (VA <= ctx->baseAddress)
	{
		return 0;
	}

	VA -= ctx->baseAddress;
	for (i = 0; i < ctx->sectionCount; i++)
	{
		if (ctx->sections[i].VirtualAddress <= VA &&
			VA < (ctx->sections[i].VirtualAddress + ctx->sections[i].SizeOfRawData))
		{
			return ctx->sections[i].PointerToRawData + (VA - ctx->sections[i].VirtualAddress);
		}
	}

	return 0;
}

int applyPatch(char *nfk, peCtx *nfkCtx, char *patch, peCtx *patchCtx)
{
	__try
	{
		unsigned long patchAddress;
		unsigned int patchCount;
		patchInfo *patches;
		unsigned int i;

		patchAddress = VAtoRAW(patchCtx, GETDWORD(patch, patchCtx->sections[0].PointerToRawData));
		patchCount = GETDWORD(patch, patchAddress);
		patches = (patchInfo *)(patch + patchAddress + 4);

		for (i = 0; i < patchCount; i++)
		{
			unsigned long patchAddr = VAtoRAW(patchCtx, patches[i].patchAddress);
			unsigned long nfkAddr = VAtoRAW(nfkCtx, patches[i].patchAddress);

			_tprintf(_T("Patch %d..."), i);
			if (patchAddr == 0 || nfkAddr == 0)
			{
				_putts(_T("address translation failed"));
				return 1;
			}
			memcpy(nfk + nfkAddr, patch + patchAddr, patches[i].patchLength);
			_putts(_T("OK"));
		}
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
	{
		_tprintf(_T("Exception %08x"), GetExceptionCode());
		return GetExceptionCode();
	}

	return 0;
}

int getCtx(char *fileBuf, unsigned int fileLength, peCtx *ctx)
{
	__try
	{
		IMAGE_DOS_HEADER *dosHdr;
		IMAGE_NT_HEADERS32 *ntHdr;

		if (fileLength < sizeof(IMAGE_DOS_HEADER))
		{
			return 1;
		}
		dosHdr = (IMAGE_DOS_HEADER *)fileBuf;
		if (dosHdr->e_magic != 0x5A4D)
		{
			return 2;
		}
		if (dosHdr->e_lfanew + sizeof(IMAGE_NT_HEADERS32) >= fileLength)
		{
			return 3;
		}
		ntHdr = (IMAGE_NT_HEADERS32 *)(fileBuf + dosHdr->e_lfanew);
		if (ntHdr->Signature != 0x00004550)
		{
			return 4;
		}

		ctx->sectionCount = ntHdr->FileHeader.NumberOfSections;
		ctx->sections = (IMAGE_SECTION_HEADER *)((char *)(&ntHdr->OptionalHeader) + ntHdr->FileHeader.SizeOfOptionalHeader);
		ctx->baseAddress = ntHdr->OptionalHeader.ImageBase;
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
	{
		return GetExceptionCode();
	}
	return 0;
}

int _tmain(int argc, _TCHAR* argv[])
{	
	HANDLE nfkFile = INVALID_HANDLE_VALUE, patchFile = INVALID_HANDLE_VALUE;
	HANDLE nfkMapping = NULL, patchMapping = NULL;
	unsigned long nfkLength, patchLength;
	char *nfk, *patch;
	peCtx nfkCtx, patchCtx;
	int temp;
	_TCHAR newName[MAX_PATH];

	if (argc < 3)
	{
		_putts(_T("Usage: patcher.exe <NFK executable> <patch binary>"));
		return 1;
	}

	_tcscpy_s(newName, MAX_PATH, argv[1]);
	_tcscpy_s(newName + _tcslen(newName) - 3, MAX_PATH, _T("upd.exe"));

	if (!CopyFile(argv[1], newName, 0))
	{
		_tprintf(_T("Cant copy %s to %s\n"), argv[1], newName);
		return 1;
	}

	nfkFile = CreateFile(newName, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL);
	if (nfkFile == INVALID_HANDLE_VALUE)
	{
		_tprintf(_T("Cant open %s\n"), newName);
		goto cleanup;
	}
	nfkLength = GetFileSize(nfkFile, NULL);
	if (nfkLength == 0)
	{
		_tprintf(_T("NFK file is empty"));
		goto cleanup;
	}

	patchFile = CreateFile(argv[2], GENERIC_READ, 0, NULL, OPEN_EXISTING, 0, NULL);
	if (patchFile == INVALID_HANDLE_VALUE)
	{
		_tprintf(_T("Cant open %s\n"), argv[2]);
		goto cleanup;
	}
	patchLength = GetFileSize(nfkFile, NULL);
	if (patchLength == 0)
	{
		_tprintf(_T("Patch file is empty"));
		goto cleanup;
	}

	nfkMapping = CreateFileMapping(nfkFile, NULL, PAGE_READWRITE, 0, 0, NULL);
	if (nfkMapping == NULL)
	{
		_putts(_T("Cant create NFK mapping"));
		goto cleanup;
	}
	CloseHandle(nfkFile);
	nfkFile = INVALID_HANDLE_VALUE;
	
	patchMapping = CreateFileMapping(patchFile, NULL, PAGE_READONLY, 0, 0, NULL);
	if (patchMapping == NULL)
	{
		_putts(_T("Cant create patch mapping"));
		goto cleanup;
	}
	CloseHandle(patchFile);
	patchFile = INVALID_HANDLE_VALUE;

	nfk = (char *)MapViewOfFile(nfkMapping, FILE_MAP_WRITE, 0, 0, 0);
	if (nfk == NULL)
	{
		_putts(_T("Cant map NFK"));
		goto cleanup;
	}

	patch = (char *)MapViewOfFile(patchMapping, FILE_MAP_READ, 0, 0, 0);
	if (patch == NULL)
	{
		_putts(_T("Cant map patch"));
		goto cleanup;
	}

	temp = getCtx(nfk, nfkLength, &nfkCtx);
	if (temp != 0)
	{
		_tprintf(_T("Failed to get NFK pe ctx, code %d\n"), temp);
		goto cleanup;
	}

	temp = getCtx(patch, patchLength, &patchCtx);
	if (temp != 0)
	{
		_tprintf(_T("Failed to get patch pe ctx, code %d\n"), temp);
		goto cleanup;
	}

	applyPatch(nfk, &nfkCtx, patch, &patchCtx);
	
cleanup:
	if (nfkFile != INVALID_HANDLE_VALUE) CloseHandle(nfkFile);
	if (patchFile != INVALID_HANDLE_VALUE) CloseHandle(patchFile);
	if (nfkMapping != NULL) CloseHandle(nfkMapping);
	if (patchMapping != NULL) CloseHandle(patchMapping);

	return 0;
}

