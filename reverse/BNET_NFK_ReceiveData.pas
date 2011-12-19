procedure TMainForm.BNET_NFK_ReceiveData(Data: Pointer; FromIP : shortstring; FromPort : integer; DataSize : integer);
var
	i: integer;
begin
//	...
	case byte(Data^) of
//	...
		MMP_CL_OBJDESTROY: 
		begin
			if (TMP_CL_ObjDestroy(Data^).killDXID = 0) then
			begin
				AddMessage('neterror: null TMP_cl_ObjDestroy...');
				exit;
			end;

			for i := 0 to 1000 do
			begin
				if (aaa[i].dead <> 0) then
					continue;
				if (aaa[i].DXID <> TMP_CP_ObjDestroy(Data^).killDXID) then
					continue;		
			
				if (aaa[i].name = 'rocket') then
				begin
					aaa[i].x := TMP_CP_ObjDestroy(Data^).x;
					aaa[i].y := TMP_CP_ObjDestroy(Data^).y;
					aaa[i].dead := true;
					aaa[i].weapon := false;
					aaa[i].frame := 0;
					aaa[i].topdraw := 2;
					aaa[i].speed := RandInt(8);
				end;
				
				if (aaa[i].name = 'plasma') or (aaa[i].name = 'weapon') then
				begin
					if (MATCH_DRECORD <> 0) then
					begin
						DData.data := 5;
						DData.gametic := gametic;
						DData.gametime := gametime;
						DDXIDKill.x := Round(TMP_CP_ObjDestroy(Data^).x);
						DDXIDKill.y := Round(TMP_CP_ObjDestroy(Data^).y);
						DDXIDKill.DXID := TMP_CP_ObjDestroy(Data^).DXID;
						DemoStream.Write(DData, 4);
						DemoStream.Write(DDXIDKill, 6);
					end;
					
					if (aaa[i].name = 'plasma') then	// removed in 077
					begin								// removed in 077
						aaa[i].dead := 2;
						PartEngine.sub_5460DC(aaa[i].x, aaa[i].y);
					end;								// removed in 077
				end;
loc_512D48:
				if (aaa[i].name = 'grenade') then
				begin
					aaa[i].x := TMP_CP_ObjDestroy(Data^).x;
					aaa[i].y := TMP_CP_ObjDestroy(Data^).y
					aaa[i].dead := 1;
					aaa[i].weapon := true;
					aaa[i].speed := RandInt(8);
					aaa[i].frame := 0;
					aaa[i].name := 'rocket';
					aaa[i].topdraw := 2;
				end;
			end;	// loop through all objects
		end;	// message handler
//	...
	end;
//	...
end;