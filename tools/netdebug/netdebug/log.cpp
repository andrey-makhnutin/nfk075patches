#include "stdafx.h"
#include <stdio.h>
#include <stdarg.h>

FILE *logFile;

void setLogFilename(char *fn)
{
	if (logFile)
		fclose(logFile);

	fopen_s(&logFile, fn, "at");
}

void log(char *format, ...)
{
	//TODO: actual logging
	if (!logFile)
		return;

	SYSTEMTIME currTime;
	GetLocalTime(&currTime);
	fprintf(logFile, "[%02d:%02d:%02d.%03d] ", currTime.wHour, currTime.wMinute,
		currTime.wSecond, currTime.wMilliseconds);
	va_list args;
	va_start(args, format);
	vprintf(format, args);
	vfprintf(logFile, format, args);
	//fflush(logFile);
	va_end(args);
}

void closeLog()
{
	if (logFile)
		fclose(logFile);
}