#ifndef _NFK_H
#define _NFK_H

#pragma pack(push, 1)
typedef struct {
	unsigned char length;
	char string[1];
} ShortString;

typedef struct {
	unsigned char packetType;
	unsigned char messageCount;
	unsigned char size;
} NFK_PacketHeader;

typedef struct {
	unsigned char packetType;
	unsigned long CRC32;
	unsigned char size;
} NFK_ACKPacket;

typedef struct {
	unsigned char packetType;
	unsigned char floodNum;
	unsigned char ignore;
} NFK_FloodPacket;

typedef struct {
	unsigned char size;
	unsigned char type;
} NFK_MessageHeader;

typedef struct {
	unsigned char size;
	unsigned short ID;
	unsigned char type;
} NFK_NewMessageHeader;

typedef struct {
	unsigned char data;
	unsigned short signature;
	unsigned char spectator;
} NFK_TMP_GamestateRequest;

typedef struct {
	unsigned char data;
	unsigned char gametype;
	unsigned char dodrop;
	unsigned long MapCRC32;
	unsigned char mapLength;
	char mapName[30];
	unsigned char versionLength;
	char version[30];
} NFK_TMP_GamestateAnswer;
#pragma pack(pop)

#define NFK_PT_NORMAL		0
#define NFK_PT_IMPORTANT	1
#define NFK_PT_ACK			2
#define NFK_PT_FLOOD		4

#define NFK_MMP_GAMESTATEREQUEST	33
#define NFK_MMP_GAMESTATEANSWER		34
#define NFK_MMP_LOBBY_PING			72
#define NFK_MMP_LOBBY_ANSWERPING	73

#define NFK_SIGNATURE		0xBEFA
#define NFK_DEBUG_SIGNATURE	0xBEDA

// word BNET_ISMULTIP
#define NFK_BNET_ISMULTIP *(unsigned short*)(0x54BF00)

#endif