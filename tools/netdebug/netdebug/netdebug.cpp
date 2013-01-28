// netdebug.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "netdebug.h"
#include <stdio.h>
#include <vector>
#include "nfk.h"

#define ND_SESSION_STATE_REQUEST		1
#define ND_SESSION_STATE_ESTABLISHED	2                         

typedef char SessionKey[20];
void makeSessionKey(SessionKey *key, ShortString *ip_address, int port)
{
	memset(key, 0, sizeof(SessionKey));
	*(unsigned short *)key = port;
	strcpy_s((char *)key + 2, 18, ip_address->string);
}

class Session
{
public:
	SessionKey key;
	unsigned short lastPacketID;
	int state;

	Session(ShortString *ip_address, int port) 
	{
		makeSessionKey(&key, ip_address, port);
		lastPacketID = 0;
		state = 0;
	}
};

std::vector<Session> sessionList;
Session *findSession(ShortString *ip_address, int port)
{
	SessionKey t;
	makeSessionKey(&t, ip_address, port);

	for (std::vector<Session>::iterator i = sessionList.begin();
		i != sessionList.end(); i++)
	{
		if (memcmp(&t, &(i->key), sizeof(SessionKey)) == 0)
			return &(*i);

	}
	return NULL;
}

void addSession(ShortString *ip_address, int port, int state)
{
	Session t(ip_address, port);
	t.state = state;
	sessionList.push_back(t);
}

NETDEBUG_API int __stdcall getVersion(void)
{
	return 2;
}

void dumbDump(unsigned char *data, unsigned int size)
{
	char text[754];
	char *t = text;

	if (size > 250)
		return;

	*t++ = '\t';
	for (unsigned int i = 0; i < size; i++)
	{
		t += sprintf_s(t, 754 - (t - text), (i == size - 1) ? "%02X" : "%02X ", data[i]);
	}
	log("%s\n", text);
}

int __stdcall nd_AddToQueue(unsigned char *data, unsigned int *size, ShortString *ip_address, int port, int flags)
{
	Session *s = findSession(ip_address, port);

	if (s == NULL || s->state != ND_SESSION_STATE_ESTABLISHED)
	{
		// don't do anything to packets outside the debugging session, because they may have come from
		//  peers not supporting the debugging
		
		// report messages nevertheless (also look for the initiation of any new sessions)
		switch (*data)
		{
		case NFK_MMP_LOBBY_PING:
			log("->q %s:%d asking for ping\n", ip_address->string, port);
			break;
		case NFK_MMP_LOBBY_ANSWERPING:
			log("->q %s:%d answering on ping request\n", ip_address->string, port);
			break;
		case NFK_MMP_GAMESTATEREQUEST:
			{
				NFK_TMP_GamestateRequest *msg = (NFK_TMP_GamestateRequest *)data;
				log("->q %s:%d requesting gamestate\n", ip_address->string, port);
				if (msg->signature != NFK_SIGNATURE)
				{
					log("WARNING: wrong signature in gamestate request %04X\n", msg->signature);
				}
				else
				{
					addSession(ip_address, port, ND_SESSION_STATE_REQUEST);
					msg->signature = NFK_DEBUG_SIGNATURE;
				}
			}
			break;
		case NFK_MMP_GAMESTATEANSWER:
			{
				NFK_TMP_GamestateAnswer *msg = (NFK_TMP_GamestateAnswer *)data;
				log("->q %s:%d responding with gamestate%s\n", ip_address->string, port, (msg->dodrop ? " (refusing connect)": ""));
				if (msg->dodrop == 0 && s->state == ND_SESSION_STATE_REQUEST)
				{
					// session has been established, begin extended debugging
					s->state = ND_SESSION_STATE_ESTABLISHED;
				}
				break;
			}

		default:
			log("->q %s:%d adding strange messages to the queue outside the debugging session\n", ip_address->string, port);
			dumbDump(data, *size);
		}
	}
	else
	{
		// if the client is trying to send a gamestate request with the session already established
		//   report and block
		if (*data == NFK_MMP_GAMESTATEREQUEST)
		{
			log("WARNING: requesting gamestate from %s:%d in an established connection\n", ip_address->string, port);
			return 0;
		}
		// if the server is sending a gamestate response in an initialized session, report and 
		//   pretend that the session has just begun (fist message is without ID, ID is set to zero)
		if (*data == NFK_MMP_GAMESTATEANSWER)
		{
			log("WARNING: sending gamestate to %s:%d in an established connection\n", ip_address->string, port);
			s->lastPacketID = 0;
			return 1;
		}

		if (*size > 248)
		{
			log("WARNING: trying to add a very big message (%d bytes) to the queue. Dropped\n", *size);
			return 0;
		}
		
		// in established sessions, prepend an ID to every message
		memmove(data + 2, data, *size);
		*size += 2;
		*(unsigned short*)data = s->lastPacketID;

		// dump packet to the log file
		switch (data[2])	// allow different dump procedures for various message types
		{
		default:
			// dump procedure for all unknown messages
			{
				char text[754];
				char *t = text;

				log("->q %s:%d Adding message %d (%d bytes) to the queue, importance = %d\n", ip_address->string, port, s->lastPacketID, *size - 2, flags);
				dumbDump(data + 2, *size - 2);
			}
		}
		s->lastPacketID++;
	}
	return 1;
}

void __stdcall nd_SendData(unsigned int caller, unsigned char *data, int size, ShortString *ip_address, int port)
{
	char callerName[16];
	Session *session = findSession(ip_address, port);
	
	switch (caller)
	{
	default:
		sprintf_s(callerName, 16, "%08X", caller);
	}

	if (size < 3)
	{
		log("->  %s:%d SendData called from %s with too short packet (%d bytes)\n", ip_address->string, port, callerName, size);
		return;
	}

	switch (*data)	// first byte is packet type
	{
	case NFK_PT_NORMAL:
	case NFK_PT_IMPORTANT:
		{
			NFK_PacketHeader *header = (NFK_PacketHeader *)data;
			char messageList[64 * 7];	// 64 is maximum possible number of messages in the packet
			char *t = messageList;
			unsigned char *d = data + sizeof(NFK_PacketHeader);

			if (session == NULL || session->state != ND_SESSION_STATE_ESTABLISHED)
			{
				for (int i = 0; i < header->messageCount; i++)
				{
					unsigned int messageSize = *d;
					if ((d - data) > size || (d - data + messageSize) > size)
					{
						log("->  %s:%d SendData called from %s with malformed data (message %d out of bounds)\n", ip_address->string, port, callerName, i);
						dumbDump(data, size);
						return;
					}
					if (messageSize == 0)
					{
						log("->  %s:%d SendData called from %s is trying to send a zero sized message (%d)\n", ip_address->string, port, callerName, i);
						dumbDump(data, size);
						return;
					}
					// adding message types to the list

					NFK_MessageHeader *msgHeader = (NFK_MessageHeader *)d;
					
					t += sprintf_s(t, 64 * 7 - (t - messageList), (i == header->messageCount - 1) ? "%d" : "%d, ", msgHeader->type);
					
					d += msgHeader->size;
				}
				log("->  %s:%d sending messages %s, importance = %d, called from %s\n", ip_address->string, port, messageList, 
					header->packetType, callerName);
			}

			for (int i = 0; i < header->messageCount; i++)
			{
				unsigned int messageSize = *d;
				if ((d - data) > size || (d - data + messageSize) > size)
				{
					log("->  %s:%d SendData called from %s with malformed data (message %d out of bounds)\n", ip_address->string, port, callerName, i);
					dumbDump(data, size);
					return;
				}
				if (messageSize < sizeof(NFK_NewMessageHeader) - 1)
				{
					log("->  %s:%d SendData called from %s is trying to send a message without a header (%d)\n", ip_address->string, port, callerName, i);
					dumbDump(data, size);
					return;
				}
				// adding message IDs to the list

				NFK_NewMessageHeader *msgHeader = (NFK_NewMessageHeader *)d;
				
				t += sprintf_s(t, 64 * 7 - (t - messageList), (i == header->messageCount - 1) ? "%d" : "%d, ", msgHeader->ID);
				
				d += msgHeader->size;
			}
			log("->  %s:%d sending messages %s, importance = %d, called from %s\n", ip_address->string, port, messageList, 
				header->packetType, callerName);
			break;
		}
	case NFK_PT_ACK:
		{
			NFK_ACKPacket *header = (NFK_ACKPacket *)data;
			log("->  %s:%d sending ACK, crc = %08X (called from %s)\n", ip_address->string, port, header->CRC32, callerName);
			break;
		}
	case NFK_PT_FLOOD:
		{
			NFK_FloodPacket *header = (NFK_FloodPacket *)data;
			log("->  %s:%d sending flood %d (called from %s)\n", ip_address->string, port, header->floodNum, callerName);
			break;
		}
	default:
		log("->  %s:%d sending packet of unknown type %d (called from %s)\n", ip_address->string, port, *data, callerName);
	}
}

void __stdcall nd_ReceiveData(unsigned char *data, ShortString *ip_address, int port, int proc_state)
{
	switch (*data)
	{
	case NFK_PT_NORMAL:
	case NFK_PT_IMPORTANT:
		{
			NFK_PacketHeader *header = (NFK_PacketHeader *)data;
			char messageList[64 * 7];	// 64 is maximum possible number of messages in the packet
			char *t = messageList;
			unsigned char *d = data + sizeof(NFK_PacketHeader);

			for (int i = 0; i < header->messageCount; i++)
			{
				if ((d - data) > 253 || (d - data + *d) > 253)
				{
					log("<-  %s:%d received malformed packet (message %d out of bounds)\n", ip_address->string, port, i);
					dumbDump(data, 255);
					return;
				}
				if (*d < sizeof(NFK_NewMessageHeader))
				{
					log("<-  %s:%d received malformed packet (message %d has no header)\n", ip_address->string, port, i);
					dumbDump(data, 255);
					return;
				}
				NFK_NewMessageHeader *msgHeader = (NFK_NewMessageHeader *)d;
				
				t += sprintf_s(t, 64 * 7 - (t - messageList), (i == header->messageCount - 1) ? "%d" : "%d, ", msgHeader->ID);

				if (proc_state == 1)
				{
					unsigned char *nextMsg = d + msgHeader->size;
					unsigned char msgSize = msgHeader->size - 2;
					// remove message IDs before sending it to BNET_NFK_ReceiveData
					memmove(d - i * 2 + 1, d + 3, msgSize);
					*(d - i * 2) = msgSize;
					d = nextMsg;
				}
				else
				{
					d += msgHeader->size;
				}
			}
			log("<-  %s:%d %s messages %s, importance = %d\n", ip_address->string, port, (proc_state ? "processing" : "received"),
				messageList, header->packetType);
			break;
		}
	case NFK_PT_ACK:
		{
			NFK_ACKPacket *header = (NFK_ACKPacket *)data;
			log("<-  %s:%d received ACK, crc = %08X\n", ip_address->string, port, header->CRC32);
			break;
		}
	case NFK_PT_FLOOD:
		{
			NFK_FloodPacket *header = (NFK_FloodPacket *)data;
			log("<-  %s:%d received flood %d\n", ip_address->string, port, header->floodNum);
			break;
		}
	default:
		log("<-  %s:%d received packet of unknown type %d\n", ip_address->string, port, *data);
		dumbDump(data, 255);
	}
}

void __stdcall sessionStart(unsigned int isServer)
{
	char fn[40];
	SYSTEMTIME currTime;
	GetLocalTime(&currTime);
	sprintf_s(fn, 40, "%s%04d-%02d-%02d-%02d-%02d-%02d.txt", isServer ? "server" : "client",
		currTime.wYear, currTime.wMonth, currTime.wDay, 
		currTime.wHour, currTime.wMinute, currTime.wSecond);
	setLogFilename(fn);
}

void __stdcall sessionEnd(unsigned int ignore)
{
	closeLog();
}

NETDEBUG_API void __stdcall getExports(unsigned int *exports)
{
	exports[0] = (unsigned int)nd_AddToQueue;
	exports[1] = (unsigned int)nd_SendData;
	exports[2] = (unsigned int)nd_ReceiveData;
}