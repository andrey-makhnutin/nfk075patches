#ifndef _HOOK_H
#define _HOOK_H

int hookInit();
int hook(unsigned char *hookAddr, void (__stdcall * proc)(unsigned int), unsigned int procParam, 
		 unsigned int borrowedCodeLength, unsigned char *borrowedCodeRelocs);

#endif