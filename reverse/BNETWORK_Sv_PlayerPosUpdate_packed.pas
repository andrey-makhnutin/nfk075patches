// this function is fucked up in many different aspects
procedure BNETWORK_Sv_PlayerPosUpdate_packed();
var     
	Header: TPlayerPosUpdate_Packed;
	totalsize: integer;
	dat, _dat: ^byte;
	PosUpdateMsg: TMP_PlayerPosUpdate;
	PosUpdateCopyMsg: TMP_PlayerPosUpdate_copy;
	i, z, j: byte;
begin
	totalsize := 0;
	Header.Data := MMP_PLAYERPOSUPDATE_PACKED;
    Header.Count := BNETWORK_Players_collective;
    Getmem(dat, Header.Count * sizeof(TMP_PlayerPosUpdate) + sizeof(TPlayerPosUpdate_Packed));
    _dat:=dat;
    CopyMemory(_dat, @Header, sizeof(Header));
    inc(_dat, sizeof(Header));
    inc(totalsize, sizeof(Header));

    for i := 0 to 7 do
	begin
		if (players[i] = nil) then continue;
		if (players[i].netobject <> true) then continue;

		for z := 0 to 7 do
		begin
			if (players[z] = nil) then continue;
			if (i = z) then continue;
			
			if (players[z].InertiaY = players[z].NET_LastInertiaY) and (players[z].Y = players[z].NET_LastPosY) then
			begin
				MsgSize := sizeof(TMP_PlayerPosUpdate_copy);
				BNETWORK_TMP_PlayerPosUpdate_copy_fill(z, @PosUpdateCopyMsg);
				CopyMemory(_dat, @PosUpdateCopyMsg, MsgSize);
				inc(_dat, MsgSize);
				inc(totalsize, MsgSize);
            end 
			else 
			begin
loc_4E498D:
				BNETWORK_TMP_PlayerPosUpdate_fill(z, @PosUpdateMsg);
				MsgSize := SizeOf(TMP_PlayerPosUpdate);
				CopyMemory(_dat, @PosUpdateMsg, MsgSize);
				inc(_dat, MsgSize);
				inc(totalsize, MsgSize);
				players[z].NET_LastInertiaY := players[z].InertiaY;
				players[z].NET_LastPosY := players[z].Y;
			end;
loc_4E4A51:
		end;
				
        mainform.BNETSendData2IP_(players[i].ip_addr, players[i].Port, dat^, totalsize, 0);
		
		if (ismultip() = 1) and (SpectatorList.Length > 0) then
		begin
			for j := 0 to SpectatorList.Length - 1 do
				mainform.BNETSendData2IP_(SpectatorList[j].address, SpectatorList[j].port, dat^, totalsize, 0);
		end;
		
loc_4E4B48:
    end;
    FreeMem(dat);
end;