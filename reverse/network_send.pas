// note: this module will never ever compile, all this is just a crude decompilation of NFK binary
// the author almost forgot pascal, so there are a lot of syntax errors in this code.

type PQueue = ^TQueue;
TQueue = record
    Active: boolean;                // +0x00
    IP: string[15];                 // +0x01
    Port: word;                     // +0x12
    Data: array [0..255] of byte;   // +0x14
    Size: word;                     // +0x114
    Timedout: cardinal;             // +0x118
    Important: byte;                // +0x120
end;

type PAPLEntry = ^TAPLEntry;
TAPLEntry = record
    active: boolean;                // +0x00
    packetType: byte;               // +0x01
    retriesLeft: byte;              // +0x04
    retryTime: Cardinal;            // +0x08
    ip_address: string;             // +0x0C
    port: word;                     // +0x10
    data: array [0..255] of byte;   // +0x12
    size: word;                     // +0x112
    crc: Cardinal;                  // +0x114
end;

type PSVResendEntry = ^TSVResendEntry;
TSVResendEntry = record
    active: boolean;                // +0x00
    retryTime: Cardinal;            // +0x04
    data: array [0..255] of byte;   // +0x08
    size: word;                     // +0x108
end;

type PACKPacket = ^TACKPacket;
TACKPacket = packed record
    PacketType: byte;               // +0x00
    CRC32: Cardinal;                // +0x01
    PacketSize: byte;               // +0x05
end;

const
    // packet types
    PT_NORMAL       = 0;
    PT_IMPORTANT    = 1;
    PT_ACK          = 2;    // acknowledgement upon the receiving of important packet
    PT_FLOOD        = 4;    // flood before connect
type PPacketHeader = ^TPacketHeader;
type TPacketHeader = packed record
    PacketType: byte;
    Count: byte;
    Size: byte;
end;

var
    APLList: TList;                 // 0x552B58
    SVResendList: TList;            // 0x54DB64

// 0x47E838
procedure Network_AddToQueue(var Data; Size: word; IP : shortstring; important: byte; Port : word);
var q: PQueue;
begin
    if (Size = 0) then
    begin
        AddMessage('^1warning: zero sized data added to buffer.');
        exit;
    end;

    New(q);
    q^.Active := true;
    q^.IP := IP;
    q^.Port := Port;
    q^.Size := Size;
    q^.Important := important;
    if (Size > $FF) then
        AddMessage('WARNING');
    Move(Data, q^.Data, Size);
    q^.Timedout := GAMETIME + 5000;
    QueueBuf.Add(q);
end;

// 0x47E50C
procedure Netword_SendAllQueue;
var
    entry: PQueue;
    search_ip: ShortString;
    search_port: word;
    search_importance: byte;
    totalsize, count, highpacket: word;
    i: integer;
    Header: TPacketHeader;
    dat, _dat: Pointer;
const   MAXPACKETSIZE = 250;
begin
    APLResend;
    SVResend;

    if (QueueBuf.Count = 0) then exit;

    while (QueueBuf.Count > 0) do
    begin
        entry := QueueBuf.items[i];
        search_ip := entry^.IP;
        search_port := entry^.Port;
        search_importance := entry^.Important;
        totalsize := 0;
        count := 0;
        highpacket := 0;

        for i := 0 to QueueBuf.Count - 1 do
        begin
            entry := QueueBuf.items[i];
            if (entry^.IP = search_ip) and (entry^.Port = search_port) and (entry^.Important = search_importance) then
            begin
                if (totalsize + entry^.Size + 1 > MAXPACKETSIZE) then break;

                inc(count);
                inc(totalsize, entry^.Size + 1);
                highpacket := i; // highest packet number
            end;
        end;

        if (totalsize > MAXPACKETSIZE) then
            AddMessage('WARNING: network queued size too big');

        if (search_importance = 1) then
            Header.PacketType := PT_IMPORTANT;
        // combine packets. write header
        Header.Count := count;                      // number of packets
        Header.Size := sizeof(header) + totalsize;  // total packet size.
        Getmem(dat, Header.Size);
        _dat := dat;

        CopyMemory(_dat, @Header, sizeof(header));
        inc(_dat, sizeof(Header));

        // combine packets
        for i := 0 to highpacket do
        begin
            entry := QueueBuf.items[i];
            if (entry^.IP = search_ip) and (entry^.Port = search_port) and (entry^.Important = search_importance) then
            begin
                byte(_dat^) := entry^.Size;
                inc(_dat);
                CopyMemory(_dat, @entry^.Data, entry^.Size);
                inc(_dat, entry^.Size);
                entry^.Active := false;
            end;
        end;

        BNET1.SendData(0, dat^, Header.Size, search_ip, search_port);
        if (search_importance <> 0) then
            AddToAPL(dat, Header.Size, search_ip, search_port, 1);
        FreeMem(dat);

        // dead removal.
        done := false;
        repeat
            if (QueueBuf.count = 0) then
                done := true
            else
            begin
                for i := 0 to QueueBuf.count-1 do
                begin
                    if (TQueue(QueueBuf.items[i]^).Active = false) then
                    begin
                        QueueBuf.Delete(i);
                        break;
                    end;
                    if (i = QueueBuf.count - 1) then
                        done := true;
                end;
            end;
        until done;
    end;
end;

procedure SendACK(crc32: Cardinal; size: byte; ip_address: ShortString; port: word);
var
    packet: TACKPacket;
begin
    packet.PacketType := PT_ACK;
    packet.CRC32 := crc32;
    packet.PacketSize := size;
    BNET1.SendData(0, @packet, sizeof(packet), ip_address, port);
end;

function FindACKInAPLList(crc32: Cardinal; size: byte): boolean;
var
    i: integer;
    aple: PAPLEntry;
begin
    Result := false;
    if (APLList.Count = 0) then
        exit;

    for i := 0 to APLList.Count - 1 do
    begin
        aple := APLList.items[i];
        if (aple^.active = 0) or (aple^.crc <> crc32) or (aple^.size <> size) or (aple^.packetType <> PT_ACK) then
            continue;
        Result := 1;
    end;
end;

procedure RemoveFromAPLList(crc32: Cardinal; size: byte)
var
    i: integer;
    aple: PAPLEntry;
begin
    if (APLList.Count = 0) then
        exit;
    for i := 0 to APLList.Count do
    begin
        aple := APLList.items[i];
        if (aple^.active = 0) or (aple^.crc <> crc32) or (aple^.size <> size) then
            continue;
        aple^.active := 0;
    end;
end;

procedure Network_ParsePacket(ip_address: string[15]; port: word)
var
    hdr: PPacketHeader;
    Data: Pointer;
    packetSize: byte;
    packetCRC: Cardinal;
    count, i: byte;
begin
    hdr := PPacketHeader(@ReadBuf);
    if (hdr.PacketType = PT_FLOOD) then
    begin
        if (hdr.Count = 0) then
            SendFloodTo(ip_address, port, 1);
        if (hdr.Count = 1) then
            SendFloodTo(ip_address, port, 2);
        exit;
    end;
    if (hdr.PacketType = PT_IMPORTANT) then
    begin
        packetSize := hdr.Size;
        packetCRC := crc32calc($FFFFFFFF, @ReadBuf, packetSize);
        sendACK(packetCRC, packetSize, ip_address, port);
        if (FindACKInAPLList(packetCRC, packetSize) <> 0) then  // anti double-message check
            exit;
        AddToAPL(@ReadBuf, packetSize, ip_address, port, PT_ACK);    // add ACK to the list for the check above to work
    end
    else
    begin
loc_47E9DC:
        if (hdr.PacketType = PT_ACK) then
        begin
            RemoveFromAPLList(PACKPacket(@ReadBuf)^.CRC32, PACKPacket(@ReadBuf)^.PacketSize);
            exit;
        end;
        if (hdr.PacketType <> PT_NORMAL) then
            exit;
    end;
loc_47E9F3:
    Data := @ReadBuf;
    inc(Data);
    count := byte(Data^);
    inc(Data, 2);   // ignore hdr.PacketSize

    for i := 0 to count - 1 do
    begin
        packetSize := byte(Data^);
        if (packetSize = 0) then
        begin
            AddMessage('^1NETUNIT ERROR: ZERO SIZED DATA!');
        end;
        inc(Data);

        MainForm.BNET_NFK_ReceiveData(Data, ip_address, port, packetSize);
    end;
end;

// 0x47E270
procedure APLResend;
var
    entry: PAPLEntry;
    i: integer;
    done: boolean;
begin
    if (APLList.Count = 0) then
        exit;

    for i := 0 to APLList.Count - 1 do
    begin
        entry := APLList.items[i];
        if (entry^.active = 0) then continue;
        if (entry^.retriesLeft = 0) then continue;

        if (entry^.retryTime < GAMETIME) then
        begin
            if (entry^.retriesLeft > 0) then        // so useless
                dec(entry^.retriesLeft);
            if (entry^.retriesLeft = 0) then        // very much useless
                entry^.active := 0;                 // very much useless

            if (entry^.packetType = 1) then
            begin
                BNET1.SendData(0, @entry^.data, entry^.size, entry^.ip_address, entry^.port);
                entry^.retryTime := GAMETIME + GetPlayerResendTime(entry^.ip_address, entry^.port);

                if (OPT_NET_SHOWBANDWIDTH = 0) then continue;

                AddMessage('Doing Anti Packet Lost [resended] [' + IntToStr(entry^.data[4]) + ']');   // probably shows type of the first message in the packet
            end;
loc_47E438:
            entry.active := 0;
        end;
    end;
loc_47E44F:
    done := false;
    repeat
        if (APLList.Count = 0) then
        begin
            done := true;
        end
        else
        begin
            for i := 0 to APLList.Count - 1 do
            begin
                if (PAPLList(APLList.items[i])^.active = 0) then
                    APLList.Delete(i);
                if (i = APLList.Count - 1) then
                    done := true;
            end;
        end;
    until done;
end;

// 0x47DE68
procedure SVResend;
var
    entry: PSVResentEntry;
    i: integer;
begin
    if (SVResendList.Count = 0) then exit;

    for i := 0 to SVResendList.Count - 1 do
    begin
        entry = SVResendList.items[i];
        if (entry^.active = 0) then continue;
        if (entry^.retryTime < GAMETIME) then
        begin
            mainform.BNETSendData2All(@entry^.data, entry^.size);
            entry^.active := 0;
        end;
    end;

    done := false;
    repeat
        if (SVResendList.Count = 0) then
        begin
            done := true;
        end
        else
        begin
            for i := 0 to APLList.Count - 1 do
            begin
                if (PSVResendEntry(SVResendList.items[i])^.active = 0) then
                    SVResendList.Delete(i);
                if (i = SVResendList.Count - 1) then
                    done := true;
            end;
        end;
    until done;
end;

// 0x47E11C
procedure AddToAPL(data: Pointer; size: integer; ip_address: string; port: word; packetType: integer)
var
    resendTime: word;
    aple: PAPLEntry;
begin
    if (OPT_SNAPS = 0) and (packetType = 1) then
        exit;
    resendTime := GetPlayerResendTime(ip_address, port);
    if (resendTime > 600) then exit;
    New(aple);
    aple^.active := 1;
    aple^.packetType := packetType;
    aple^.ip_address := ip_address;
    aple^.port := port;
    aple^.size := size;
    aple^.retriesLeft := OPT_SNAPS;
    if (packetType = 2) then
        aple^.retryTime := GAMETIME + 1200
    else
        aple^.retryTime := GAMETIME + resendTime;
    Move(data, aple^.data, size);
    aple^.crc := crc32calc($FFFFFFFF, data, size);
    aple^.packetType := packetType;

    APLList.Add(aple);
end;

// 0x484FCC
function GetPlayerResendTime(ip_address: string; port: word): integer;
var
    i: integer;
begin
    for i := 0 to 7 do
    begin
        if (players[i] = nil) then continue;

        if ((ismultip() = 1) and (players[i].ip_addr = ip_address) and (players[i].port = port)) or
           ((ismultip() = 0) and (players[i].netobject = 0)) then
        begin
            Result := players[i].ping * 2;
            if (Result < 150) then Result := 150;
            if (Result > 1500) then Result := 1500;
        end;
    end;
end;