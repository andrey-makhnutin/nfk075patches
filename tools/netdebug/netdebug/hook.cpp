#include "stdafx.h"
#include "SimpleStream.h"

#define WRAPPERS_BUF_SIZE	4096

// base address of wrappers code
unsigned char *wrappers;
// address of available space for the next wrapper
unsigned char *nextWrapperAddr;
// total length of wrappers code buffer
unsigned int wrappersBufLength;
// size of available space for new wrappers
unsigned int wrappersSizeLeft;

int hookInit()
{
	wrappers = (unsigned char *)VirtualAlloc(NULL, WRAPPERS_BUF_SIZE, MEM_COMMIT, PAGE_EXECUTE);
	if (!wrappers)
	{
		log("couldn't alloc buffer for hook wrappers\n");
		return 0;
	}
	nextWrapperAddr = wrappers;
	wrappersBufLength = WRAPPERS_BUF_SIZE;
	wrappersSizeLeft = wrappersBufLength;

	return 1;
}

int hook(unsigned char *hookAddr, void (__stdcall * proc)(unsigned int), unsigned int procParam,
		 unsigned int borrowedCodeLength, unsigned char *borrowedCodeRelocs)
{
	if (borrowedCodeLength < 5)
	{
		log("borrowed code length is less than 5 bytes, this is madness!\n");
		return 0;
	}
	// wrapper is param push + call of the proc + borrowedBytes + jump back, so wrapper size is
	//	borrowedCodeLength + 15 bytes
	unsigned int wrapperSize = borrowedCodeLength + 15;

	if (wrapperSize > wrappersSizeLeft)
	{
		log("no place left for wrappers\n");
		return 0;
	}

	// allow writing in wrappers buf
	DWORD oldProtect;
	if (!VirtualProtect((LPVOID)nextWrapperAddr, wrapperSize, PAGE_READWRITE, &oldProtect))
	{
		log("can't set protect on wrappers buf\n");
		return 0;
	}
	
	// use SimpleStream class to write data simply
	unsigned char *p = nextWrapperAddr;
	SimpleStream s(p);

	// write param push
	s.WriteUInt8(0x68);
	s.WriteUInt32(procParam);
	// write call to proc
	s.WriteUInt8(0xE8);	// call opcode
	s.WriteInt32((long)proc - ((long)s.GetCurrentPointer() + 4));
	// write borrowed code
	s.Write((unsigned char *)hookAddr, borrowedCodeLength);
	// process relocs
	if (borrowedCodeRelocs)
	{
		SimpleStream r(borrowedCodeRelocs);
		unsigned long o;
		unsigned int oldOffset = s.Tell();

		while (o = r.ReadCompressedInt())
		{
			s.SeekTo(10 + o);
			s.WriteInt32(s.PeekInt32() - (hookAddr - p));
		}
		s.SeekTo(oldOffset);
	}
	// write jump back
	s.WriteUInt8(0xE9);	// long jump opcode
	s.WriteInt32((long)(hookAddr + borrowedCodeLength) - ((long)s.GetCurrentPointer() + 4));

	// set page protection back to execute only
	if (!VirtualProtect((LPVOID)p, wrapperSize, PAGE_EXECUTE, &oldProtect))
	{
		log("can't set protect on wrappers buf\n");
		return 0;
	}

	// set the hook
	if (!VirtualProtect((LPVOID)hookAddr, 5, PAGE_READWRITE, &oldProtect))
	{
		log("can't set protect on hooked address\n");
	}
	*(unsigned char*)hookAddr = 0xE9;
	*(long*)(hookAddr + 1) = (long)p - ((long)hookAddr + 5);
	if (!VirtualProtect((LPVOID)hookAddr, 5, oldProtect, &oldProtect))
	{
		log("can't set protect on hooked address\n");
	}

	if (wrapperSize & 0xF)
		wrapperSize += 0x10 - (wrapperSize & 0xF);
	nextWrapperAddr += wrapperSize;
	wrappersSizeLeft -= wrapperSize;

	return 1;
}