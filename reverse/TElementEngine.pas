TBloodSplash = class
	field_0:	integer;
	field_4:	single;
	field_8:	single;
	field_0C:	single;
	field_10:	single;
	field_14:	integer;
	field_18:	integer;
	field_1C:	integer;
	field_20:	integer;
	field_24:	integer;
	field_28:	integer;
	
	procedure	Draw();
end;

TElementEngine = record
	field_0:	integer;
	ElementsList:	TList;	// List of TBloodSplash
	ElementCreateDelay:	integer;
	
	procedure AddElement(spotpattern: byte, angle: byte, x: single, y: single);	
end;

// 546300h
procedure TBloodSplash.Draw()
begin
	if (OPT_R_MASSACRE <> 0) then
	begin
		if ((gy + this.field_8) > 0) and ((gx + this.field_0C + 12) > 0) and 
			((gx + this.field_0C - 4) <= MainForm.PowerGraph.Width) and
			((gy + this.field_10) <= MainForm.PowerGraph.Height) then
		begin
			MainForm.PowerGraph.TextureCol(MainForm.Images[36], Round(this.field_0C) + gx - 4,
				Round(this.field_10) + gy, Round(this.field_0C) + gx + 12, Round(this.field_10) + gy, 
				Round(this.field_4) + gx + 8, Round(this.field_8) + gy + 8, Round(this.field_4) + gx,
				Round(this.field_8) + gy + 8, (this.field_1C shl 24) + $FFFFFF, 0, this.field_28 or $102);
		end;
	end;
loc_546430:
end;

// 546448h
procedure TElementEngine.AddElement(spotpattern: byte, angle: byte, x: single, y: single)
begin
	if (this.ElementsList.size >= 1500) then
		exit;
	
	if (this.ElementCreateDelay > 0) then
	begin
		dec(this.ElementCreateDelay);
		exit;
	end;
	
	this.ElementCreateDelay := 7 - OPT_R_MASSACRE div 2;
	// ...
end