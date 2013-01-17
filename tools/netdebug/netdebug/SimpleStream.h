#pragma once

class SimpleStream
{
protected:
	unsigned char *m_base;
	unsigned char *m_current;
public:
	SimpleStream(unsigned char *base) { m_base = m_current = base; }
	void Seek(long offset) { m_current += offset; }
	void SeekTo(unsigned long offset) {m_current = m_base + offset; }
	unsigned int Tell() { return m_current - m_base; }

	unsigned char ReadUInt8() { unsigned char res = *m_current; m_current++; return res; }
	unsigned char PeekUInt8() { unsigned char res = *m_current; return res; }
	void WriteUInt8(unsigned char data) { *(unsigned char *)m_current = data; m_current++; }

	char ReadInt8() { char res = *m_current; m_current++; return res; }
	char PeekInt8() { char res = *m_current; return res; }
	void WriteInt8(char data) { *(char *)m_current = data; m_current++; }

	unsigned short ReadUInt16() { unsigned short res = *(unsigned short *)(m_current); m_current += 2; return res; }
	unsigned short PeekUInt16() { unsigned short res = *(unsigned short *)(m_current); return res; }
	void WriteUInt16(unsigned short data) { *(unsigned short*)m_current = data; m_current += 2; }

	short ReadInt16() { short res = *(short *)(m_current); m_current += 2; return res; }
	short PeekInt16() { short res = *(short *)(m_current); return res; }
	void WriteInt16(short data) { *(short *)m_current = data; m_current += 2; }

	unsigned long ReadUInt32() { unsigned long res = *(unsigned long *)(m_current); m_current += 4; return res; }
	unsigned long PeekUInt32() { unsigned long res = *(unsigned long *)(m_current); return res; }
	void WriteUInt32(unsigned long data) { *(unsigned long *)m_current = data; m_current += 4; }

	long ReadInt32() { long res = *(long *)(m_current); m_current += 4; return res; }
	long PeekInt32() { long res = *(long *)(m_current); return res; }
	void WriteInt32(long data) { *(long *)m_current = data; m_current += 4; }

	unsigned __int64 ReadUInt64() {unsigned __int64 res = *(unsigned __int64 *)(m_current); m_current += 8; return res; }
	unsigned __int64 PeekUInt64() {unsigned __int64 res = *(unsigned __int64 *)(m_current); return res; }
	void WriteUInt64(unsigned __int64 data) { *(unsigned __int64 *)m_current = data; m_current += 8;}

	__int64 ReadInt64() {__int64 res = *(__int64 *)(m_current); m_current += 8; return res; }
	__int64 PeekInt64() {__int64 res = *(__int64 *)(m_current); return res; }
	void WriteInt64(__int64 data) { *(__int64 *)m_current = data; m_current += 8; }

	void Read( unsigned char *buf, unsigned int length) { memcpy(buf, m_current, length); m_current += length; }
	void Write( unsigned char *buf, unsigned int length) { memcpy(m_current, buf, length); m_current += length; }

	unsigned long ReadCompressedInt() 
	{
		unsigned long res = ReadUInt8();
		if (res & 0x80)
		{
			res = ((res & 0x7F) << 8) | ReadUInt8();
			if (res & 0x4000)
			{
				res = ((res & 0x3FFF) << 16) | (ReadUInt8() << 8);
				res |= ReadUInt8();
			}
		}
		return res;
	}
	unsigned int Rebase() { unsigned int dif = m_current - m_base; m_base = m_current; return dif; }
	unsigned char *GetCurrentPointer() { return m_current; }
	~SimpleStream(void) {};
};
