    .686
    .model flat, stdcall
    option casemap :none   ; case sensitive
	assume fs:nothing

;windows.inc goes here
OPEN_ALWAYS                          equ 4
GENERIC_WRITE                        equ 40000000h
FILE_END                             equ 2

;nfk defs
g_players   equ     00757B80h
MMP_PING    equ     26
MMP_INVITE  equ		78
MMP_LOBBY_ANSWERPING		equ		73
MMP_LOBBY_GAMESTATE_RESULT	equ		85
MMP_SPECTATORDISCONNECT		equ		38
MMP_IAMQUIT	equ		75

Gametype_DOM	equ	7

exeAddr MACRO va
org va - 401000h
ENDM

    .code
start:
dd      patchCount

exeAddr 4011DCh
CloseHandle:                nop
exeAddr 4011E4h
CreateFileA:                nop
exeAddr	401294h
GetModuleHandleA:			nop
exeAddr	40129Ch
GetProcAddress:				nop
exeAddr 4013A0h
InitializeCriticalSection:  nop
exeAddr 4013A8h
EnterCriticalSection:       nop
exeAddr 4013B0h
LeaveCriticalSection:       nop

exeAddr 4026EAh
l4026EA:    nop  
exeAddr 4026EEh
l4026EE:    nop
exeAddr 4026F8h
FreeMem:    nop
exeAddr 402702h
l402702:    nop
exeAddr 402706h
l402706:    nop
exeAddr 402716h
l402716:    nop
exeAddr 402748h
l402748:    nop

exeAddr	402AC0h
TRUNC:		nop

exeAddr 402AF8h
PStrNCat:	nop
exeAddr 402B28h
PStrCpy:	nop
exeAddr	402B44h
PStrNCpy:	nop			;params: 
							;eax - destination:	shortstring
							;edx - source:		shortstring
							;cl - destSize:		byte
exeAddr	402B74h
PStrCmp:	nop

exeAddr	4036E4h
HandleFinally:	nop

exeAddr 403B14h
l403B14h:   nop

exeAddr 403C4Ch
LStrClr:    nop			;params:
							;eax - source: PLStr

exeAddr	403C70h
LStrArrayClr:	nop

exeAddr 403CA0h
LStrAsg:    nop			;params:
							;eax - destination: PLStr
							;edx - source: LStr

exeAddr 403D15h
l403D15:    nop
exeAddr 403D30h
l403D30:    nop
exeAddr 403D39h
l403D39:    nop

exeAddr 403E70h
StringToLStr:	nop		;params:
							;eax - destination: PLStr
							;edx - source:		shortstring

exeAddr	403EA8h
LStrToString:	nop

exeAddr 403ED4h
LStrCat:    nop

exeAddr	403F18h
LStrCat3:	nop

exeAddr 403F8Ch
LStrCatN:	nop

exeAddr	403FDCh
LStrCmp:	nop

exeAddr	404080h
LStrAddRef:	nop

exeAddr 406D08h
patch128_begin:
GetTickCount:
	jmp	newGetTickCount
patch128_end:

exeAddr 406DC8h
SetFilePointer:     nop
exeAddr 406DE0h
Sleep:              nop
exeAddr 406E00h
WriteFile:          nop

exeAddr 407568h
CopyMemory:			nop

exeAddr	408A88h
IntToStr:	nop			;params:
							;eax - source: integer
							;edx - destination: PLStr

exeAddr	408B2Ch
StrToInt:	nop

exeAddr 410A04h
l410A04:    nop

exeAddr	410B14h
TList_Get:	nop

exeAddr	424894h
lstrpart_space	db	' ', 0

exeAddr	451F80h
TCustomWinSocket_SendText:	nop

IFDEF _DEDIK
exeAddr 45304Fh
patch30_begin:
call    patch29_begin
patch30_end:
ENDIF

exeAddr	46968Ch
patch103_begin:
newTAGFImage_LoadFromFileStrip	proc
	push	16
	pop		edx
	mov		[eax + 4], edx
	mov		[eax + 8], edx
	mov		[eax + 0Ch], edx
	mov		[eax + 10h], edx
	push	1
	pop		edx
	mov		[eax + 14h], edx
	mov		[eax + 18h], edx
	mov		[eax + 1Ch], edx
	mov		[eax + 20h], edx
	xor		eax, eax
	retn	14h
newTAGFImage_LoadFromFileStrip	endp
patch103_end:

exeAddr	469B14h
patch106_begin:
newTAGFImage_LoadFromFileAuto	proc
	push	16
	pop		edx
	mov		[eax + 4], edx
	mov		[eax + 8], edx
	mov		[eax + 0Ch], edx
	mov		[eax + 10h], edx
	push	1
	pop		edx
	mov		[eax + 14h], edx
	mov		[eax + 18h], edx
	mov		[eax + 1Ch], edx
	mov		[eax + 20h], edx
	xor		eax, eax
	retn	4
newTAGFImage_LoadFromFileAuto	endp
patch106_end:

exeAddr	469FC4h
patch104_begin:
newTAGFImage_LoadFromStream_0	proc
	push	16
	pop		edx
	mov		[eax + 4], edx
	mov		[eax + 8], edx
	mov		[eax + 0Ch], edx
	mov		[eax + 10h], edx
	push	1
	pop		edx
	mov		[eax + 14h], edx
	mov		[eax + 18h], edx
	mov		[eax + 1Ch], edx
	mov		[eax + 20h], edx
	xor		eax, eax
	retn	14h
newTAGFImage_LoadFromStream_0	endp
patch104_end:

exeAddr	46A43Ch
patch105_begin:
newTAGFImage_LoadFromVTDb	proc
	push	16
	pop		edx
	mov		[eax + 4], edx
	mov		[eax + 8], edx
	mov		[eax + 0Ch], edx
	mov		[eax + 10h], edx
	push	1
	pop		edx
	mov		[eax + 14h], edx
	mov		[eax + 18h], edx
	mov		[eax + 1Ch], edx
	mov		[eax + 20h], edx
	xor		eax, eax
	retn	8
newTAGFImage_LoadFromVTDb	endp
patch105_end:

exeAddr	46B06Ch
patch107_begin:
newTPowerGraph_Initialize	proc
	xor		eax, eax
	retn
newTPowerGraph_Initialize	endp
patch107_end:

exeAddr	46B518h
patch108_begin:
newTPowerGraph_Finalize	proc
	xor		eax, eax
	retn
newTPowerGraph_Finalize	endp
patch108_end:

exeAddr	46B594h
patch109_begin:
newTPowerGraph_Reset	proc
	xor		eax, eax
	retn
newTPowerGraph_Reset	endp
patch109_end:

exeAddr 46B5C4h
patch81_begin:
newTPowerGraph_SetAntialias	proc
	mov		eax, 1
	retn
newTPowerGraph_SetAntialias	endp
patch81_end:

exeAddr	46B8F8h
patch98_begin:
newTPowerGraph_SetClipRect	proc
	mov		eax, 1
	retn
newTPowerGraph_SetClipRect	endp
patch98_end:

exeAddr	46B978h
patch97_begin:
newTPowerGraph_ResetRect	proc
	mov		eax, 1
	retn
newTPowerGraph_ResetRect	endp
patch97_end:

exeAddr	46B9A8h
patch102_begin:
newTPowerGraph_BeginScene	proc
	mov		eax, 1
	retn
newTPowerGraph_BeginScene	endp
patch102_end:

exeAddr	46B9DCh
patch99_begin:
newTPowerGraph_EndScene	proc
	mov		eax, 1
	retn
newTPowerGraph_EndScene	endp
patch99_end:

exeAddr	46BA10h
patch100_begin:
newTPowerGraph_Present	proc
	mov		eax, 1
	retn
newTPowerGraph_Present	endp
patch100_end:

exeAddr	46BA70h
patch101_begin:
newTPowerGraph_Clear	proc
	mov		eax, 1
	retn
newTPowerGraph_Clear	endp
patch101_end:

exeAddr	46C080h
patch77_begin:
newTPowerGraph_FillRectMap	proc
	mov		eax, 1
	retn	20h
newTPowerGraph_FillRectMap	endp
patch77_end:

exeAddr	46C17Ch
patch78_begin:
newTPowerGraph_FillRectMap_0	proc
	mov		eax, 1
	retn	2Ch
newTPowerGraph_FillRectMap_0	endp
patch78_end:

exeAddr	46C2D0h
patch76_begin:
newTPowerGraph_FillRect	proc
	mov		eax, 1
	retn	10h
newTPowerGraph_FillRect endp
patch76_end:

exeAddr	46C310h
patch96_begin:
newTPowerGraph_FrameRect	proc
	mov		eax, 1
	retn	4
newTPowerGraph_FrameRect	endp
patch96_end:

exeAddr	46C3E0h
patch79_begin:
newTPowerGraph_Rectangle	proc
	mov		eax, 1
	retn	14h
newTPowerGraph_Rectangle	endp
patch79_end:

exeAddr	46C454h
patch80_begin:
newTPowerGraph_Line	proc
	mov		eax, 1
	retn	10h
newTPowerGraph_Line	endp
patch80_end:

exeAddr	46C648h
patch84_begin:
newTPowerGraph_SmoothLine	proc
	mov		eax, 1
	retn	0Ch
newTPowerGraph_SmoothLine	endp
patch84_end:

exeAddr	46CCE8h
patch94_begin:
newTPowerGraph_TextureMap	proc
	mov		eax, 1
	retn	24h
newTPowerGraph_TextureMap	endp
patch94_end:

exeAddr	46CE24h
patch93_begin:
newTPowerGraph_TextureMapRect_0	proc
	mov		eax, 1
	retn	14h
newTPowerGraph_TextureMapRect_0	endp
patch93_end:

exeAddr	46CF90h
patch92_begin:
newTPowerGraph_TextureMapRect	proc
	mov		eax, 1
	retn	18h
newTPowerGraph_TextureMapRect	endp
patch92_end:

exeAddr	46D0F8h
patch95_begin:
newTPowerGraph_TextureCol	proc
	mov		eax, 1
	retn	28h
newTPowerGraph_TextureCol	endp
patch95_end:

exeAddr	46D370h
patch88_begin:
newTPowerGraph_RenderEffect_0	proc
	mov		eax, 1
	retn 	0Ch
newTPowerGraph_RenderEffect_0	endp
patch88_end:

exeAddr	46D3ACh
patch87_begin:
newTPowerGraph_RenderEffect	proc
	mov		eax, 1
	retn	10h
newTPowerGraph_RenderEffect	endp
patch87_end:

exeAddr	46D410h
patch85_begin:
newTPowerGraph_RenderEffectCol	proc
	mov		eax, 1
	retn	10h
newTPowerGraph_RenderEffectCol	endp
patch85_end:

exeAddr	46D450h
patch91_begin:
newTPowerGraph_RenderEffectCol_0	proc
	mov		eax, 1
	retn	14h
newTPowerGraph_RenderEffectCol_0	endp
patch91_end:

exeAddr	46D4B8h
patch86_begin:
newTPowerGraph_RenderEffectCol2	proc
	mov		eax, 1
	retn	20h
newTPowerGraph_RenderEffectCol2	endp
patch86_end:

exeAddr	46D57Ch
patch90_begin:
newTPowerGraph_RotateEffectFix_0	proc
	mov		eax, 1
	retn	14h
newTPowerGraph_RotateEffectFix_0	endp
patch90_end:

exeAddr	46D790h
patch83_begin:
newTPowerGraph_TexturedLine2	proc
	mov		eax, 1
	retn	2Ch
newTPowerGraph_TexturedLine2	endp
patch83_end:

exeAddr	46D888h
patch82_begin:
newTPowerGraph_RotateEffect	proc
	mov		eax, 1
	retn	18h
newTPowerGraph_RotateEffect	endp
patch82_end:

exeAddr	46DA9Ch
patch89_begin:
newTPowerGraph_RotateEffectFix	proc
	mov		eax, 1
	retn	14h
newTPowerGraph_RotateEffectFix	endp
patch89_end:

exeAddr 47DF2Eh
patch26_begin:
call    patch25_begin
patch26_end:

exeAddr 47E47Fh
patch24_begin:
call    patch23_begin
patch24_end:

exeAddr 47E7CDh
patch20_begin:
call    patch19_begin
nop
nop
nop
nop
patch20_end:

IFDEF	_PINGER
exeAddr 47EAD4h
patch35_begin:
newTPlayerSize	dd	370h
patch35_end:
ENDIF

exeAddr 47F794h
ismultip:   nop

exeAddr	47FAACh
NFKPlanet_GetTok2:	nop

exeAddr	484BC4h
BNETSendData2IP_:	nop

exeAddr 484D08h
BNETSendData2HOST:  nop

exeAddr 486E74h
SpawnBubble:        nop

exeAddr	48C961h
patch114_begin:
	call	newApplyDamage_selfSplashDamage
patch114_end:

exeAddr 49CB38h
IsWaterContentHEAD: nop

exeAddr	4AB800h
DOM_Think:	nop

exeAddr 4B2014h
playsound:  nop

exeAddr	4B516Ah
patch43_begin:
	jmp		SpawnServer_PostInit_NFKPlanetPortOk
patch43_end:

exeAddr	4B51F6h
SpawnServer_PostInit_NFKPlanetPortOk:	nop

exeAddr	4B52ACh
SpawnServer:	nop

exeAddr	4B74E8h
patch115_begin:
	mov		edx, offset LNFK_VERSION
patch115_end:

NFKPlanet_PingLastServer	proc
; part of PingLastServer that sends ping
exeAddr	4B9C12h
patch49_begin::
	lea		ecx, [ebp - 2ch]
	movzx	edx, byte ptr [ebp - 2]		; i
	mov		eax, NFKPlanet_ServersList
	mov		ebx, [eax]
	call	dword ptr [ebx + 0Ch]		; TStringList.Get
	mov		eax, [ebp - 2ch]
	lea		ecx, [ebp - 28h]
	mov		dx, 7
	call	NFKPlanet_GetTok2
	cmp		dword ptr [ebp - 28h], 0	; If theres no 7th token
	jnz		exit
	mov		byte ptr [ebp - 3], 72		; put MMP_LOBBY_PING in message.data
	lea		eax, [ebp - 3]
	push	eax
	push	1
	push	0
	mov		eax, [ebp - 2ch]
	lea		ecx, [ebp - 130h]
	mov		dx, 5
	call	NFKPlanet_GetTok2			; get IP from 5th token
	mov		edx, [ebp - 130h]
	lea		eax, [ebp - 12Ch]
	mov		ecx, 0FFh
	call	LStrToString				; convert it into ShortString
	mov		eax, [ebp - 2ch]
	lea		ecx, [ebp - 130h]
	mov		dx, 6
	call	NFKPlanet_GetTok2			; get Port from 6th token
	mov		eax, [ebp - 130h]
	call	StrToInt
	mov		cx, ax
	lea		edx, [ebp - 12Ch]
	mov		eax, mainform
	call	BNETSendData2IP_
	jmp		afterPing
patch49_end::
	
exeAddr	4B9D0Bh
afterPing:	nop
	
exeAddr	4B9D68h
exit:	nop
NFKPlanet_PingLastServer	endp

exeAddr	4B9DC4h
patch50_begin:
NFKPlanet_UpdateServerPing	proc
									; eax - IP: ShortString
									; edx - Port: integer
;------- locals --------------------
IP				EQU		<[ebp - 4]>		; PShortString, size = 4
Port			EQU		<[ebp - 8]>		; Integer, size = 4
i				EQU		<[ebp - 0Ch]>	; Integer, size = 4
serversCount	EQU		<[ebp - 10h]>	; Integer, size = 4
ping			EQU		<[ebp - 14h]>	; Integer, size = 4
serverIP		EQU		<[ebp - 18h]>	; LStr, size = 4
serverData		EQU		<[ebp - 1Ch]>	; LStr, size = 4
tempStr			EQU		<[ebp - 20h]>	; LStr, size = 4
;------- codes ---------------------
	push	ebp
	mov		ebp, esp
	push	eax						; initialize IP
	push	edx						; initialize Port
	mov		ecx, 3
@@:	push	0						; allocate 24 more bytes for the rest of locals
	push	0
	dec		ecx
	jnz		@B
	push	ebx						; we will use ebx to access TStringList vtable
; enter try-finally block
	xor		eax, eax
	push	ebp
	push	offset exceptionHandler
	push	dword ptr fs:[eax]
	mov		fs:[eax], esp
	
	mov		eax, NFKPlanet_ServersList
	mov		ebx, [eax]
	call	dword ptr [ebx + 14h]	; TStringList.GetCount
	test	eax, eax
	jz		exit
	mov		serversCount, eax
	mov		eax, mainform
	mov		eax, [eax + 304h]		; eax = MainForm.Lobby
	cmp		byte ptr [eax + 24h], 0	; cmp MainForm.Lobby.Active, 0
	jne		nextServer
	cmp		MP_STEP, 4
	jne		exit
nextServer:	
	lea		ecx, serverData
	mov		eax, NFKPlanet_ServersList
	mov		edx, i
	call	dword ptr [ebx + 0Ch]	; NFKPlanet_ServersList.Get(i);
	lea		ecx, serverIP
	mov		eax, serverData
	mov		dx, 5
	call	NFKPlanet_GetTok2		; extract IP address of the server
	lea		eax, tempStr
	mov		edx, IP
	call	StringToLStr			; convert IP from parameters to LStr
	mov		eax, tempStr
	mov		edx, serverIP
	call	LStrCmp					; compare both
	jnz		continue
	lea		ecx, tempStr
	mov		eax, serverData
	mov		dx, 6
	call	NFKPlanet_GetTok2		; extract port number of the server
	mov		eax, tempStr
	call	StrToInt
	cmp		eax, Port				; compare with Port number from parameters
	jnz		continue
	lea		ecx, tempStr
	mov		eax, serverData
	mov		dx, 7
	call	NFKPlanet_GetTok2		; extract timestamp
	mov		eax, tempStr
	test	eax, eax
	jz		exit					; exit if there were no timestamp - this may happen and ruin all the shit
	call	StrToInt
	push	eax
	call	GetTickCount
	pop		edx
	sub		eax, edx
	js		exit					; exit if timestamp is bigger than GetTickCount - this must [almost] never happen
	sar		eax, 1
	cmp		eax, 999
	jbe		@F
	mov		eax, 999
@@:	
	mov		ping, eax
	lea		ecx, tempStr
	mov		eax, serverData
	mov		dx, 8
	call	NFKPlanet_GetTok2
	mov		eax, tempStr
	test	eax, eax
	jnz		exit					; exit if there already is a computed ping. This is plain wrong but meh...
	push	serverData				; prepare to LStrCatN
	push	offset nullStr
	lea		edx, tempStr
	mov		eax, ping
	call	IntToStr
	push	tempStr
	lea		eax, tempStr
	mov		edx, 3
	call	LStrCatN
	mov		eax, NFKPlanet_ServersList
	mov		edx, i
	mov		ecx, tempStr
	call	dword ptr [ebx + 20h]	; TStringList.Put
	jmp		exit	
continue:	
	inc		dword ptr i
	dec		dword ptr serversCount
	jnz		nextServer
exit:
	; exit try-finally block
	xor		eax, eax
	pop		edx
	pop		ecx
	pop		ecx
	mov		fs:[eax], edx
	push	offset realExit
cleanup:	
	lea		eax, tempStr
	mov		edx, 3
	call	LStrArrayClr
	retn
	
exceptionHandler:
	jmp		HandleFinally
	jmp		cleanup
	
realExit:
	pop		ebx
	mov		esp, ebp
	pop		ebp
	retn

;------- datas ---------------------
align 4
			dd		0FFFFFFFFh
			dd		1
nullStr		db		0
NFKPlanet_UpdateServerPing	endp
patch50_end:

exeAddr	4BA60Eh
patch56_begin:
	cmp		byte ptr [ebp - 1], 8
patch56_end:

exeAddr	4BA828h
patch58_begin:
	jmp		NFKPlanet_SortServerList_appendPort
patch58_end:
exeAddr	4BA82Dh
NFKPlanet_SortServerList_afterAppendPort:	nop

exeAddr	4BA844h
patch59_begin:
	mov		dx, 7
patch59_end:

exeAddr	4BA86Dh
patch60_begin:
	mov		dx, 7
patch60_end:

exeAddr	4BA8A2h
patch61_begin:
	mov		dx, 8
patch61_end:

exeAddr	4BA8CBh
patch62_begin:
	mov		dx, 8
patch62_end:

exeAddr	4BA98Ch
NFKPlanet_SortServerList_nullStr	dd	0

exeAddr	4BAA84h
BNET_DirectConnect:		nop

exeAddr 4C05D6h
patch3_begin:
IFDEF _DEDIC
jmp     l4C05E1
nop
nop
nop
nop
nop
nop
nop
nop
nop
ENDIF
patch3_end:
l4C05E1:    nop

exeAddr	4C2AA3h
patch55_begin:
	mov		al, 8
patch55_end:

exeAddr	4C3140h
patch63_begin:
	mov		dx, 8
patch63_end:

exeAddr 4C3360h
patch4_begin:
IFDEF _DEDIC
jmp     l4C336B
nop
nop
nop
nop
nop
nop
nop
nop
nop
ENDIF
patch4_end:
l4C336B:    nop

exeAddr	4C34D8h
patch66_begin:
	jmp		DrawMenu_newOnConnect
patch66_end:

exeAddr	4C34F3h
DrawMenu_onConnect_afterConcat:	nop

exeAddr	4C3533h
patch64_begin:
	mov		dx, 8
patch64_end:

exeAddr	4C3578h
patch72_begin:
	call 	DrawMenu_newAskForInvite
patch72_end:

exeAddr	4CA638h
patch123_begin:
	dd	0FFFFFFFFh
	dd	48h
	db	'Need For Kill (c) 2001-2011. Created by 3d[Power]. All rights preserved.', 0, 0, 0, 0
	dd	0FFFFFFFFh
	dd	40h
	db	'http://pff.clan.su                   e-mail: the.boobl@gmail.com', 0
patch123_end:

exeAddr	4CAD84h
patch124_begin:
	dd	0FFFFFFFFh
	dd	49
	db	'    visit the official NFK web site (pff.clan.su)', 0
patch124_end:

exeAddr	4CB534h
DrawMenu_onConnect_connectStr	dd	0

exeAddr 4E5735h
patch5_begin:
jmp     l4E5751
patch5_end:


exeAddr 4E5751h
l4E5751:    nop

exeAddr	4E9164h
patch132_begin:
	nop
	nop
	nop
	nop
	nop
	nop
patch132_end:


exeAddr 4E9390h
l4E9390:    nop

exeAddr	4E9725h
patch126_begin:
	jmp	DXTimerTimer_isInConsole
patch126_end:

exeAddr	4E9787h
DXTimerTimer_isInConsole:	nop


exeAddr 4EEFB3h
patch18_begin:
cmp     gametic, 31h
patch18_end:

;new realization of part of DXTimerTimer code
exeAddr 4EF281h
patch31_begin:
secondTick	proc
	call	ismultip
	cmp		al, 2
	jnz		new_notClient
	mov		eax, STIME
	mov		starttime, eax
l4EF298:
    push    esi
    push    edi
    xor     eax, eax
    mov     [ebp-0Ch], eax
powerupsLoop:                   ;old address = 4ef29d
    mov     edi, g_players
    mov     eax, [ebp-0Ch]
    cmp     dword ptr [edi+eax*4], 0
    jz      powerupsLoopCont
    mov     edi, [edi+eax*4]
    cmp     byte ptr [edi+4], 0
    jnz     powerupsLoopCont
    ;4ef2e3
    lea     esi, [edi+270h]
    cmp     byte ptr [esi+6], 0
    jz      @F
    cmp     dword ptr [edi+50h], 200
    jae     @F
    push    dword ptr [esi+24h]
    push    dword ptr [esi+20h]
    push    dword ptr [esi+2Ch]
    push    dword ptr [esi+28h]
    mov     eax, 30h
    call    playsound
    mov     byte ptr [esi+0Dh], 0Fh
@@:
    ;4ef378
    xor     ecx, ecx
    cmp     [esi+5], ch
    setnz   cl
    sub     [esi+5], cl
    ;4ef3cb
    cmp     byte ptr [esi+5], 3
    jnz     @F
    push    dword ptr [esi+24h]
    push    dword ptr [esi+20h]
    push    dword ptr [esi+2Ch]
    push    dword ptr [esi+28h]
    mov     ax, 8
    call    playsound
@@:       
    ;4ef41d
    movzx   eax, byte ptr [esi+8]
    cmp     al, 4
    ja      @F
    cmp     al, 1
    jbe     @F
    push    dword ptr [esi+24h]
    push    dword ptr [esi+20h]
    push    dword ptr [esi+2Ch]
    push    dword ptr [esi+28h]
    mov     ax, 3Ah
    call    playsound
@@:
    ;4ef4a0
    movzx   eax, byte ptr [esi+7]
    cmp     al, 4
    ja      @F
    cmp     al, 1
    jbe     @F
    push    dword ptr [esi+24h]
    push    dword ptr [esi+20h]
    push    dword ptr [esi+2Ch]
    push    dword ptr [esi+28h]
    mov     ax, 3Ah
    call    playsound
@@:
    ;4ef530
    movzx   eax, byte ptr [esi+9]
    cmp     al, 4
    ja      @F
    cmp     al, 1
    jbe     @F
    push    dword ptr [esi+24h]
    push    dword ptr [esi+20h]
    push    dword ptr [esi+2Ch]
    push    dword ptr [esi+28h]
    mov     ax, 3Ah
    call    playsound
@@: 
    ;4ef5b3
    xor     ecx, ecx
    cmp     [esi+6], ch
    setnz   cl
    sub     [esi+6], cl
    ;4ef5f2
    cmp     [esi+8], ch
    setnz   cl
    sub     [esi+8], cl
    ;4ef631
    cmp     [esi+0Ah], ch
    setnz   cl
    sub     [esi+0Ah], cl
    ;4ef670
    cmp     [esi+7], ch
    setnz   cl
    sub     [esi+7], cl
    ;4ef6af
    cmp     [esi+9], ch
    setnz   cl
    sub     [esi+9], cl
    ;4ef6ee
    mov     eax, edi
    call    IsWaterContentHEAD
    test    al, al
    jz      powerupsLoopCont
    cmp     byte ptr [edi+12h], 0
    jnz     powerupsLoopCont
    mov     eax, edi
    call    SpawnBubble
powerupsLoopCont:    
    add     byte ptr [ebp-0Ch], 1
    cmp     byte ptr [ebp-0Ch], 8
    jnz     powerupsLoop
;---------------- Pingers ---------------------
	xor		eax, eax
	mov		al, OPT_NETSPECTATOR
	test	eax, eax
	jnz		isSpectator
    mov     [ebp-0Ch], eax
pingLoop:
    mov     edi, g_players
    mov     eax, [ebp-0Ch]
    cmp     dword ptr [edi+eax*4], 0
    je      pingLoopCont
    mov     edi, [edi+eax*4]
    cmp     byte ptr [edi+274h], 0		;TPlayer.netobject
    jnz     pingLoopCont
    ;sending ping
    ;ping packet:
    ;
    ;0      1      3      5          9          0Bh
    ;--------------------------------------------
    ;| data | ping | dxid | checksum | gametime |  Size == 11
    ;--------------------------------------------
    ;
    sub     esp, 0Ch
    mov     byte ptr [esp], MMP_PING    ;data
    movzx   eax, word ptr [edi+356h]
    mov     [esp+1], ax                 ;ping
    movzx   eax, word ptr [edi+28Ch]
    mov     [esp+3], ax                 ;dxid    
    movzx   eax, byte ptr checksumDelay
    test    eax, eax
    jnz     @F
    mov     eax, 401000h
    mov     edx, 147200h
    call    getChecksum
    mov     checksum, eax
    mov     checksumDelay, 5
@@:    
    dec     checksumDelay
    mov     eax, checksum
    mov     [esp+5], eax
    mov     eax, gametime
    mov     [esp+9], ax
    mov     eax, STIME
    mov     pingsend_tick, eax
    mov     edx, esp
    xor     ecx, ecx
    mov     cl, 0Bh
    mov     eax, mainform
    push    0
    call    BNETSendData2HOST
    add     esp, 0Ch
    jmp     afterPing
pingLoopCont:
    add     byte ptr [ebp-0Ch], 1
    cmp     byte ptr [ebp-0Ch], 8
    jnz     pingLoop
	jmp		afterPing
isSpectator:
	sub		esp, 0Ch		; getting space for MMP_PING message buffer
	mov		byte ptr [esp], MMP_PING
	xor		eax, eax
	dec		eax
	mov		[esp + 1], eax	; set ping and dxid to 0FFFFh
	mov		[esp + 5], eax	; set checksum to 0FFFFFFFFh
	mov		[esp + 9], ax	; set gametime to 0FFFFh
	mov		edx, esp		; set pointer to message buffer
	xor		ecx, ecx
	mov		cl, 0Bh			; size of message
	mov		eax, mainform
	push	0				; not guaranteed (?)
	call	BNETSendData2HOST
	add		esp, 0Ch		; free message buffer
afterPing:
    pop     edi
    pop     esi
    jmp     endOfSecondEvent
new_notClient:
	jmp		secondTickNotClient
secondTick	endp 

align 8
getChecksum proc
    push    ebx
    push    esi
    push    edi
    mov     esi, 0FFFFh
    mov     edi, esi
bigloop:    
    mov     ecx, 168h
    cmp     edx, ecx
    cmovb   ecx, edx
    sub     edx, ecx
@@:    
    movzx   ebx, byte ptr [eax]
    add     esi, ebx
    inc     eax
    add     edi, esi
    dec     ecx
    jne     @B
    movzx   ecx, si
    movzx   ebx, di
    shr     esi, 10h
    shr     edi, 10h
    add     esi, ecx
    add     edi, ebx
    test    edx, edx
    jne     bigloop
    mov     eax, edi
    movzx   edx, si  
    shr     edi, 10h
    shr     esi, 10h
    add     eax, edi
    add     edx, esi
    pop     edi
    shl     eax, 10h
    pop     esi
    add     eax, edx
    pop     ebx    
    retn
getChecksum endp
patch31_end:

exeAddr	4EF7F7h
secondTickNotClient:
patch144_begin:
	call	ismultip
	cmp		al, 1
	jnz		secondTickNotServer
	jmp		new_secondTickServer
patch144_end:
	
exeAddr	4EF812h
secondTickTimeoutPlayers:	nop
	
exeAddr	4F094Bh
secondTickNotServer:	nop

exeAddr 4F0FD9h
endOfSecondEvent:   nop

exeAddr	4F3080h
patch125_begin:
	dd	0FFFFFFFFh
	dd	23
	db	'messages at pff.clan.su', 0
patch125_end:

exeAddr	4F38E4h
AddMessage:		nop

exeAddr 4F8908h
patch32_begin:
	retn
patch32_end:

exeAddr	4FEFB3h
patch117_begin:	
	call	newPrintNFKEngineVersion
patch117_end:

exeAddr	4FEFD4h
patch130_begin:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
patch130_end:

exeAddr	500697h
patch131_begin:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
patch131_end:

exeAddr	508B54h
patch140_begin:	; ending of TestIP function
	jmp		add_TestIP
patch140_end:

exeAddr	509174h
BNET_NFK_ReceiveData:	nop		; eax - mainform	TMainForm
								; edx - data		Pointer
								; ecx - address		ShortString
								; push- port		Integer
								; push- dataSize	Integer

exeAddr	50926Bh
patch134_begin:
	jmp		BNET_NFK_ReceiveData_PacketFilter
patch134_end:

exeAddr	509272h
BNET_NFK_ReceiveData_afterPacketFilter:	nop



exeAddr	509612h
patch75_begin:
	call	BNET_NFK_ReceiveData_on_MMP_INVITE_connectEx
patch75_end:

exeAddr	50984Ah
patch54_begin:
	jmp		BNET_NFK_ReceiveData_new_on_MMP_LOBBY_GAMESTATE_RESULT_beforeConcat
patch54_end:

exeAddr	509860h
BNET_NFK_ReceiveData_on_MMP_LOBBY_GAMESTATE_RESULT_afterConcat:	nop

exeAddr 509927h
patch52_begin:
BNET_NFK_ReceiveData_on_MMP_LOBBY_ANSWERPING:
	jmp		BNET_NFK_ReceiveData_new_on_MMP_LOBBY_ANSWERPING
patch52_end:

exeAddr 509B49h
patch39_begin:
NFK_VERSION db 03,'076'
patch39_end:

exeAddr	509FF2h
patch41_begin:
	mov		edx, offset NFK_VERSION
patch41_end:	

exeAddr	50A3E4h
patch70_begin:
	mov		eax, offset BNET_OLDGAMEIP
	mov		edx, offset BNET_GAMEIP
	call	PStrCpy
	mov		eax, [ebp + 0Ch]		; Port
	mov		BNET_SERVERPORT, ax
	call	SpawnServer
	jmp		BNET_ReceiveData_on_MMP_GAMESTATEANSWER_afterSpawnServer
patch70_end:

exeAddr	50A40Dh
BNET_ReceiveData_on_MMP_GAMESTATEANSWER_afterSpawnServer: nop

exeAddr	50B3A4h
patch129_begin:
	jmp		BNET_NFK_ReceiveData_on_MMP_REGISTERPLAYER_dontShowWindow
patch129_end:

exeAddr	50B3BDh
BNET_NFK_ReceiveData_on_MMP_REGISTERPLAYER_dontShowWindow: nop

exeAddr 50CA9Eh
patch14_begin:
jmp     l50CAA7
nop
nop
nop
nop
nop
nop
nop
patch14_end:
l50CAA7:    nop

exeAddr 50CAFDh
patch15_begin:
jmp     l50CB06
nop
nop
nop
nop
nop
nop
nop
patch15_end:
l50CB06:    nop

exeAddr 513B8Bh
patch142_begin:
    jmp		on_MMP_PING_distribute
patch142_end:
	
exeAddr	513B99h
patch33_begin:
on_MMP_PING_do_distribute:
	lea		eax, [ebp - 2FFh]	;buf
	mov		ecx, [ebp + 8]		;DataSize
	mov		edx, [ebp - 8]
	call	CopyMemory
	lea		eax, [ebp - 2FFh]	;buf
	push	eax
	push	[ebp + 8]
	push	0
	mov		ecx, [ebp + 0Ch]	;Port
patch33_end:

exeAddr	513BC9h
on_MMP_PING_no_distribute:	nop

IFDEF _PINGER
exeAddr 513BCEh
onMMP_PING2	proc
patch34_begin::
	mov		edi, [ebp - 8]
	xor		ecx, ecx
playerloop:
	mov		esi, [g_players + ecx * 4]
	test	esi, esi
	jz		playerloop_cont
	mov		ax, [esi + 28Ch]	;TPlayer.dxid
	cmp		ax, [edi + 3]		;TPingPacket.dxid
	jnz		playerloop_cont
	add		esi, 356h
	mov		ax, [edi + 1]		;TPingPacket.ping
	mov		[esi], ax			;TPlayer.ping
	cmp		byte ptr [ebp + 8], 0Bh
	jnz		playerloop_break
	mov		eax, [edi + 5]		;TPingPacket.crc
	cmp		eax, [esi + 12h]
	je		@F
	mov		[esi + 12h], eax	;TPlayer.crc
	call	crcChanged
@@:	
	xor		eax, eax
	mov		ax, [edi + 9]		;TPingPacker.gametime
	sub		eax, gametime
	cmp		eax, [esi + 16h]	;TPlayer.time_delta
	je		playerloop_break
	mov		[esi + 16h], eax
	call	deltaChanged
	jmp		playerloop_break
	
exeAddr	513C30h	
playerloop_cont:
	inc		ecx
	cmp		cl, 8
	jnz		playerloop
patch34_end::
playerloop_break:
onMMP_PING2	endp
ENDIF

exeAddr	516895h
BNET_NFK_ReceiveData_default:	nop

exeAddr	516B48h
BNET_NFK_ReceiveData_nullStr	dd	0

exeAddr	516DECh
str_droppedByTimeout	db	0	; shortstring ' ^7^ndropped by timeout.'

exeAddr	516E54h
str_Spectator	db	0	; shortstring 'Spectator '

exeAddr	517609h
patch67_begin:
	jmp		SPAWNCLIENT_portsEqual
patch67_end:

exeAddr	517625h
SPAWNCLIENT_portsEqual:		nop

exeAddr	517647h
patch68_begin:
	jmp		SPAWNCLIENT_portsEqual2
patch68_end:

exeAddr	51766Ah
SPAWNCLIENT_portsEqual2:	nop

exeAddr	517688h
patch69_begin:
	jmp		SPAWNCLIENT_portsEqual3
patch69_end:

exeAddr	5176A7h
SPAWNCLIENT_portsEqual3:	nop

exeAddr	51A773h
patch147_begin:
	call	SaveCFG_ext
patch147_end:

exeAddr	51D46Ch
ALIAS_SaveAlias:	nop

exeAddr	51E8A0h
patch112_begin:
	call	newApplyCommand_on_reconnect
patch112_end:	

exeAddr	51EC19h
patch110_begin:
	jmp		applyCommand_notWireframe
patch110_end:

exeAddr	51EC76h
applyCommand_notWireframe:	nop

exeAddr	51ED33h
patch118_begin:
	call	newPrintNFKEngineVersion
patch118_end:

exeAddr	53A359h
patch145_begin:
	jmp		applyCommand_ext
patch145_end:
applyCommand_after_ext:	nop

exeAddr	53A41Ch
applyCommand_exit:	nop

exeAddr	53CC9Ch
lstrpart_doublequote	db '"', 0

exeAddr	53D4ACh
lstrpart_invalid_value_dq	db 'invalid value "', 0

exeAddr	53D6C4h
lstrpart_dq_is_dq		db '" is "', 0

exeAddr	53E1B8h
lstrpart_dq_is_set_to_dq	db '" is set to "', 0

exeAddr	543F30h
patch120_begin:
	call	newGetSystemVariable_getNfkversion
	nop
patch120_end:

exeAddr	5446C4h
NFKPlanet_GetTok:	nop	

;------- NFKPlanet_ParseServerData fixes ---
exeAddr	5447EFh
; allocating buffer for server port
patch47_begin:
	mov		ecx, 5
patch47_end:

; jump to procedure of extracting port from planet data (ext)
exeAddr	5448B2h
patch45_begin:
	jmp		NFKPlanet_ParseServerData_ext
patch45_end:

; return address from ext procedure
exeAddr	5448BAh
NFKPlanet_ParseServerData_StartStrcat:	nop

; concatenating 13 strings instead of 11
exeAddr	5448BDh
patch46_begin:
	mov		edx, 0Dh
patch46_end:

; clean up buffer for server port
exeAddr	5448E8h
patch48_begin:
	lea		eax, [ebp - 28h]
	mov		edx, 0Ah
patch48_end:

exeAddr	544918h
NFKPlanet_ParseServerData_emptyStr	dd	0
;-------------------------------------------

exeAddr	5449C7h
patch40_begin:
	jmp		NFKPlanet_ParseResponse_versionNotOK
patch40_end:

exeAddr	544A10h
patch122_begin:
NFKPlanet_ParseResponse_versionNotOK:
	mov		ecx, offset aNFKPlanetTooOld
	nop
	nop
	nop
	nop
patch122_end:

exeAddr	544C04h
patch73_begin:
	dd		0FFFFFFFFh
	dd		3
LNFK_VERSION	db	'076',0	
patch73_end:
	
patch121_begin:
exeAddr	544C10h
aNFKPlanetTooOld	db		42, 'visit official website for new NFK update.', 0
exeAddr 544C50h
	db		42, 'This NFK Planet version is too old. Please', 0
exeAddr	544C7Ch
	db		22, 'NFK Planet is too old.', 0
patch121_end:

exeAddr	544E74h
patch38_begin:
oldNFKPlanet_SendHello:
	jmp		newNFKPlanet_SendHello
patch38_end:

exeAddr	544F80h
patch42_begin:
NFKPlanet_RegisterServer	proc	; eax = hostname: LStr
                                    ; edx = mapname: LStr
                                    ; ecx = current players: Byte
                                    ; arg_4 = max players: Byte = [ebp + 0Ch]
                                    ; arg_0 = game type: Byte = [ebp + 8]
;----------- local variables -------									
hostname	EQU	<[ebp - 4]>
mapname		EQU	<[ebp - 8]>
curPlayers	EQU	<[ebp - 0Ch]>
maxPlayers	EQU	<[ebp + 0Ch]>
gameType	EQU	<[ebp + 8]>
tempStr		EQU	<[ebp - 10h]>
;----------- codes -----------------
	push	ebp
	mov		ebp, esp
	push	eax						; init hostname
	push	edx						; init mapname
	push	ecx						; init curPlayers
	push	0						; init tempStr
	call	LStrAddRef				; add ref to hostname
	mov		eax, mapname
	call	LStrAddRef				; add ref to mapname
	push	esi						; esi will be an alias for MainForm.lobby.Socket so preserve it in teh stack
	; enter try
	xor		eax, eax
	push	ebp
	push	offset exceptHandler
	push	dword ptr fs:[eax]
	mov		fs:[eax], esp
	mov		esi, dword ptr mainform
	mov		esi, [esi + 304h]		; 304h - offset to `lobby' object in TMainForm
	cmp		byte ptr [esi + 24h], 0	; dunno what is `+ 24h', might be something like 'isConnected'
	je		notConnected
	mov		esi, [esi + 80h]		; 80h - offset to Socket object in `lobby'
	
	; sending greetings
	push	offset aGreeting		; put '?R' in the stack
	mov		eax, UDPDemon
	mov		eax, [eax + 834h]		; get UDPDemon.port value
	lea		edx, tempStr
	call	IntToStr
	push	tempStr					; put port number in the stack
	push	offset aCrLf			; put '\r\n' in the stack
	lea		eax, tempStr
	mov		edx, 3
	call	LStrCatN				; contatenate 3 strings from the stack and put it in tempStr
	mov		edx, tempStr
	mov		eax, esi
	call	TCustomWinSocket_SendText
	
	; sending hostname
	push	offset aHostname
	push	hostname
	push	offset aCrLf
	lea		eax, tempStr
	mov		edx, 3
	call	LStrCatN
	mov		edx, tempStr
	mov		eax, esi
	call	TCustomWinSocket_SendText
	
	; sending mapname
	push	offset aMapname
	push	mapname
	push	offset aCrLf
	lea		eax, tempStr
	mov		edx, 3
	call	LStrCatN
	mov		edx, tempStr
	mov		eax, esi
	call	TCustomWinSocket_SendText
	
	; sending current players
	push	offset aCurPlayers
	xor		eax, eax
	mov		al, curPlayers
	lea		edx, tempStr
	call	IntToStr
	push	tempStr
	push	offset aCrLf
	lea		eax, tempStr
	mov		edx, 3
	call	LStrCatN
	mov		edx, tempStr
	mov		eax, esi
	call	TCustomWinSocket_SendText
	
	; sending max players
	push	offset aMaxPlayers
	xor		eax, eax
	mov		al, maxPlayers
	lea		edx, tempStr
	call	IntToStr
	push	tempStr
	push	offset aCrLf
	lea		eax, tempStr
	mov		edx, 3
	call	LStrCatN
	mov		edx, tempStr
	mov		eax, esi
	call	TCustomWinSocket_SendText
	
	; sending game type
	push	offset aGameType
	xor		eax, eax
	mov		al, gameType
	lea		edx, tempStr
	call	IntToStr
	push	tempStr
	push	offset aCrLf
	lea		eax, tempStr
	mov		edx, 3
	call	LStrCatN
	mov		edx, tempStr
	mov		eax, esi
	call	TCustomWinSocket_SendText
	
notConnected:
	; leave try block
	xor		eax, eax
	pop		edx
	pop		ecx
	pop		ecx
	mov		fs:[eax], edx
	push	offset gracefulExit		; dirty Delphian hacks
cleanup:
	lea		eax, tempStr
	call	LStrClr					; delete tempStr
	lea		eax, mapname
	call	LStrClr					; remove ref from mapname
	lea		eax, hostname
	call	LStrClr					; remove ref from hostname
	retn
	
exceptHandler:
	jmp		HandleFinally
	jmp		cleanup

gracefulExit:
	pop		esi						; restore esi
	mov		esp, ebp				; cleanup locals
	pop		ebp
	retn	8
;----------- datas -----------------
			dd		0FFFFFFFFh
			dd		02
aGreeting	db		'?R', 0
align 4
			dd		0FFFFFFFFh
			dd		02
aHostname	db		'?N', 0
align 4
			dd		0FFFFFFFFh
			dd		02
aMapname	db		'?m', 0
align 4
			dd		0FFFFFFFFh
			dd		02
aCurPlayers	db		'?C', 0
align 4
			dd		0FFFFFFFFh
			dd		02
aMaxPlayers	db		'?M', 0
align 4
			dd		0FFFFFFFFh
			dd		02
aGameType	db		'?P', 0
align 4
			dd		0FFFFFFFFh
			dd		02
aCrLf		db		0Dh, 0Ah, 0			
NFKPlanet_RegisterServer	endp
patch42_end:

exeAddr	545594h
NFKPlanet_AskForInvite:		nop

exeAddr 5459E4h
patch28_begin:
call    patch27_begin
patch28_end:

exeAddr 546800h
patch22_begin:
call    patch21_begin
patch22_end:

exeAddr	546EAAh
; setting new BNET_OnDataReceived
patch138_begin:
dd		new_BNET_OnDataReceived
patch138_end:

exeAddr	547054h
old_BNET_OnDataReceived:	nop

exeAddr	5480A4h
patch135_begin:
	jmp		new_entryPoint
patch135_end:

exeAddr 5480AAh
old_entryPointCont:    nop

exeAddr 54901Ch
l54901C     dd  0
l549020     dd  0

exeAddr	54BCDCh
BNET_SERVERPORT	dw	0
exeAddr	54BCE0h
BNET_REALSERVERPORT	dw	0
exeAddr	54BCE4h
BNET_GAMEIP		dd	0	;ShortString
exeAddr	54BDE4h
BNET_OLDGAMEIP	dd	0

exeAddr	54BEF8h
ENABLE_PROTECT	db	0

exeAddr	54BF3Ch
SPECTATOR_TIMEOUT	dw	7000

exeAddr 54C274h
pingsend_tick   dd  0

exeAddr 54C7C4h
SYS_MAXAIR  db  0

exeAddr	54CB68h
OPT_NETSPECTATOR	db	0

exeAddr	54CCB0h
MATCH_GAMETYPE		db	0

exeAddr 54CDA0h
STIME   dd  0

exeAddr	552B60h
UDPDemon	dd	0

exeAddr	552B6Ch
NFKPlanet_state	db	0

exeAddr	552B80h
NFKPlanet_ServersList	dd	0

exeAddr	552B8Dh
MP_STEP	db	0

exeAddr 554CD4h
mainform    dd  0

exeAddr	555B00h
starttime	dd	0

exeAddr 757BC8h
gametime    dd  0
gametic     dd  0

exeAddr	75CC98h
SpectatorList	dd	0

exeAddr 75D380h
checksum    dd  0
checksumDelay   db  0 
OPT_CL_ALLOWDOWNLOAD	db	0
OPT_SV_ALLOWDOWNLOAD	db	0
align 4
sleepDelay	dd	0

exeAddr	75E2F0h
imp_GetTickCount	dd	0

exeAddr 784000h
patch19_begin:
call    FreeMem
mov     edx, ebp
mov     eax, [edi]
call    l410A04
retn
patch19_end:

exeAddr 784010h
patch21_begin:
call    FreeMem
mov     edx, ebp
mov     eax, [esi + 4]
retn
patch21_end:

exeAddr 784020h
patch23_begin:
push    eax
lea     eax, [eax + 0Ch]
call    LStrClr
pop     eax
call    FreeMem
movzx   edx, bx
mov     eax, [edi]
retn
patch23_end:

exeAddr 784038h
patch25_begin:
call    FreeMem
mov     edx, edi
mov     eax, [ebp + 0]
retn
patch25_end:

exeAddr 784048h
patch27_begin:
call    FreeMem
mov     edx, ebp
mov     eax, [esi + 8]
retn
patch27_end:

IFDEF	_DEDIK
align 16
patch29_begin:
mov		eax, sleepDelay
inc		eax
and		eax, 07Fh
mov		sleepDelay, eax
jnz		@F
push    1
call    Sleep
@@:
call	TRUNC
retn
patch29_end:
ENDIF

IFDEF _PINGER
align 16
patch36_begin:
dwordToHex  proc    ;eax - pointer to buffer, edx - dword
    push    edi
    mov     edi, eax
    mov     ecx, 8
hexloop:    
    rol     edx, 4
    mov     al, dl
    and     al,0Fh
    cmp     al, 9
    jbe     digit
    add     al, 7
digit:
    add     al, '0'
    stosb
    dec     ecx
    jnz     hexloop
    pop     edi
    retn
dwordToHex  endp

align 16
;eax = new CRC, ecx = player index
;must preserve ecx
crcChanged	proc
	push	ebp
	mov		ebp, esp
	push	eax		;[ebp - 4] = new CRC
	push	ecx		;[ebp - 8] = player index
	sub		esp, 50h
	mov		eax, esp
	mov		edx, offset crcWarning
	call	PStrCpy
	mov		eax, [ebp - 8]
	mov		eax, [g_players + eax * 4]
	lea		edx, [eax + 7Bh]
	mov		eax, esp
	mov		cl, 50h
	call	PStrNCat
	mov		eax, esp
	mov		edx, offset crcWarningCont
	mov		cl, 50h
	call	PStrNCat
	mov		eax, esp
	movzx	ecx, byte ptr [eax]
	add		eax, ecx
	inc		eax
	lea		ecx, [eax + 8]
	mov		byte ptr [ecx], 0
	mov		edx, [ebp - 4]
	call	dwordToHex
	mov		edx, esp
	add		byte ptr [edx], 10
	push	0
	mov		eax, esp
	call	StringToLStr
	mov		eax, [esp]
	call	AddMessage
	mov		eax, esp
	call	LStrClr
	mov		ecx, [ebp - 8]		;restore ecx
	mov		esp, ebp
	pop		ebp
	retn
crcChanged	endp
align 16
crcWarning	db	31,'^1Checksum was changed for ^7^n',0
crcWarningCont	db	6,'^7^n: ',0

dwordToDec	proc	;eax - pointer to buffer, edx - dword
	push	edi
	mov		edi, eax
	test	edx, edx
	jns		nosign
	mov		al, '-'
	stosb
	neg		edx
nosign:
	push	edi
	sub		esp, 10h
	mov		edi, esp
	push	0Ah
	pop		ecx
	mov		eax, edx
@@:	
	xor		edx, edx
	div		ecx
	add		dl, '0'
	mov		[edi], dl
	inc		edi
	test	eax, eax
	jnz		@B
	mov		ecx, edi
	mov		edx, edi
	sub		ecx, esp
	add		esp, 10h
	dec		edx
	pop		edi
@@:	mov		al, [edx]
	stosb
	dec		edx
	loopd	@B
	mov		eax, edi
	pop		edi
	retn
dwordToDec	endp

align 16
;eax = new Time-Delta, ecx = player index
deltaChanged	proc
	push	ebp
	mov		ebp, esp
	push	eax		;[ebp - 4] = new Time-Delta
	push	ecx		;[ebp - 8] = player index
	sub		esp, 50h
	mov		eax, esp
	mov		edx, offset timedeltaWarning
	call	PStrCpy
	mov		eax, [ebp - 8]
	mov		eax, [g_players + eax * 4]
	lea		edx, [eax + 7Bh]
	mov		eax, esp
	mov		cl, 50h
	call	PStrNCat
	mov		eax, esp
	mov		edx, offset crcWarningCont
	mov		cl, 50h
	call	PStrNCat
	mov		eax, esp
	movzx	ecx, byte ptr [eax]
	add		eax, ecx
	inc		eax
	mov		edx, [ebp - 4]
	call	dwordToDec
	mov		byte ptr [eax], 0
	mov		edx, esp
	sub		eax, esp
	dec		eax
	mov		byte ptr [edx], al
	push	0
	mov		eax, esp
	call	StringToLStr
	mov		eax, [esp]
	call	AddMessage
	mov		eax, esp
	call	LStrClr
	mov		esp, ebp
	pop		ebp
	retn
deltaChanged	endp
align 4
timedeltaWarning	db	33,'^1Time-Delta was changed for ^7^n',0
patch36_end:
ENDIF

align 16
patch37_begin:
newNFKPlanet_SendHello	proc
	mov		eax, mainform
	mov		eax, [eax + 304h]
	cmp		byte ptr [eax + 24h], 0
	je		finish
	mov		NFKPlanet_state, 0
	mov		ebx, [eax + 80h]
	sub		esp, 12
	mov		eax, esp
	mov		edx, offset aV
	call	PStrCpy
	mov		eax, esp
	mov		edx, offset NFK_VERSION
	mov		cl, 12
	call	PStrNCat
	mov		eax, esp
	mov		edx, offset endl
	mov		cl, 12
	call	PStrNCat
	mov		edx, esp
	push	0
	mov		eax, esp
	call	StringToLStr
	mov		edx, [esp]
	mov		eax, ebx
	call	TCustomWinSocket_SendText
	add		esp, 16
finish:
	retn

align 4
aV		db		2,'?V',0
endl	db		2,13,10,0
newNFKPlanet_SendHello	endp
patch37_end:

align 16
patch44_begin:
NFKPlanet_ParseServerData_ext:
	call	NFKPlanet_GetTok
	push	[ebp - 24h]
	push	offset NFKPlanet_ParseServerData_emptyStr
	lea		ecx, [ebp - 28h]
	mov		dx, 6
	mov		eax, [ebp - 4]
	call	NFKPlanet_GetTok
	push	[ebp - 28h]
	jmp		NFKPlanet_ParseServerData_StartStrcat
patch44_end:

align 16
patch51_begin:
BNET_NFK_ReceiveData_new_on_MMP_LOBBY_ANSWERPING:
	lea		eax, [ebp - 14Ah]	; FromIP
	mov		edx, [ebp + 0Ch]	; FromPort
	call	NFKPlanet_UpdateServerPing
	jmp		BNET_NFK_ReceiveData_default
patch51_end:

align 16
patch53_begin:
BNET_NFK_ReceiveData_new_on_MMP_LOBBY_GAMESTATE_RESULT_beforeConcat:
	push	[ebp - 3F8h]
	push	offset BNET_NFK_ReceiveData_nullStr
	lea		edx, [ebp - 344h]
	mov		eax, [ebp + 0Ch]	; FromPort
	call	IntToStr
	push	[ebp - 344h]
	lea		eax, [ebp - 344h]
	mov		edx, 0Ah
	call	LStrCatN
	jmp		BNET_NFK_ReceiveData_on_MMP_LOBBY_GAMESTATE_RESULT_afterConcat
patch53_end:

align 16
patch57_begin:
NFKPlanet_SortServerList_appendPort:
	call	LStrCatN
	push	[ebp - 14h]
	mov		eax, [ebp - 5Ch]
	lea		ecx, [ebp - 58h]
	mov		dx, 6
	call	NFKPlanet_GetTok2
	push	[ebp - 58h]
	push	offset NFKPlanet_SortServerList_nullStr
	lea		eax, [ebp - 14h]
	mov		edx, 3
	call	LStrCatN
	jmp		NFKPlanet_SortServerList_afterAppendPort
patch57_end:

align 16
patch65_begin:
DrawMenu_newOnConnect	proc
	call	NFKPlanet_GetTok2
	push	0
	mov		ecx, esp
	mov		eax, [ebp - 310h]
	mov		dx, 6
	call	NFKPlanet_GetTok2
	mov		eax, [esp]
	push	offset DrawMenu_onConnect_connectStr
	push	[ebp - 30Ch]
	push	offset addrSep
	push	eax
	lea		eax, [ebp - 308h]
	mov		edx, 4
	call	LStrCatN
	mov		eax, esp
	call	LStrClr
	pop		eax
	jmp		DrawMenu_onConnect_afterConcat
	
align 4
			dd	0FFFFFFFFh
			dd	1
addrSep		db	':', 0	
DrawMenu_newOnConnect	endp	
patch65_end:

align 16
patch71_begin:
DrawMenu_newAskForInvite	proc
	push	0
	mov		ecx, esp
	mov		eax, [ebp - 320h]
	mov		dx, 6
	call	NFKPlanet_GetTok2
	mov		eax, [ebp - 31Ch]
	mov		edx, [esp]
	push	eax
	push	offset addrSep2
	push	edx
	lea		eax, [ebp - 31Ch]
	mov		edx, 3
	call	LStrCatN
	mov		eax, esp
	call	LStrClr
	pop		eax
	mov		eax, [ebp - 31Ch]
	call	NFKPlanet_AskForInvite
	retn	
align 4
			dd	0FFFFFFFFh
			dd	1
addrSep2	db	':', 0	
DrawMenu_newAskForInvite	endp	
patch71_end:

align 16
patch74_begin:
BNET_NFK_ReceiveData_on_MMP_INVITE_connectEx	proc
	push	0
	mov		edx, esp
	mov		eax, [ebp + 0Ch]
	call	IntToStr
	mov		eax, [ebp - 32Ch]
	mov		edx, [esp]
	push	eax
	push	offset addrSep3
	push	edx
	lea		eax, [ebp - 32Ch]
	mov		edx, 3
	call	LStrCatN
	mov		eax, esp
	call	LStrClr
	pop		eax
	mov		eax, [ebp - 32Ch]
	call	BNET_DirectConnect
	retn	
align 4
			dd	0FFFFFFFFh
			dd	1
addrSep3	db	':', 0	
BNET_NFK_ReceiveData_on_MMP_INVITE_connectEx	endp	
patch74_end:

align 16
patch111_begin:
newApplyCommand_on_reconnect	proc
	push	0
	mov		edx, esp
	movzx	eax, BNET_REALSERVERPORT
	call	IntToStr
	mov		eax, [ebp - 8ECh]
	mov		edx, [esp]
	push	eax
	push	offset addrSep4
	push	edx
	lea		eax, [ebp - 8ECh]
	mov		edx, 3
	call	LStrCatN
	mov		eax, esp
	call	LStrClr
	pop		eax
	mov		eax, [ebp - 8ECh]
	call	BNET_DirectConnect
	retn
	
align 4
			dd	0FFFFFFFFh
			dd	1
addrSep4	db	':', 0
newApplyCommand_on_reconnect	endp
patch111_end:

align 16
patch113_begin:
; returns 0 in eax if player has battlesuit
newApplyDamage_selfSplashDamage	proc
	push	eax
	mov		eax, [ebp - 4]		; player
	cmp		byte ptr [eax + 277h], 0
	pop		eax
	jbe		noBattle
	xor		eax, eax			; dmg
noBattle:
	retn
newApplyDamage_selfSplashDamage	endp
patch113_end:

align 16
patch116_begin:
newPrintNFKEngineVersion	proc
; make string 'NFK Engine ver <version>.       <url>'
	push	0
	mov		eax, esp
	push	offset aNFKEngineVer1
	push	offset LNFK_VERSION
	push	offset aNFKEngineVer2
	push	offset NFK_URL
	mov		edx, 4
	call	LStrCatN
	mov		eax, [esp]
	call	AddMessage
	pop		eax
	retn
	
align 4
				dd		0FFFFFFFFh
				dd		15
aNFKEngineVer1	db		'NFK Engine ver ', 0, 0, 0
				dd		0FFFFFFFFh
				dd		9
aNFKEngineVer2	db		'.        ', 0
newPrintNFKEngineVersion	endp

align 4
			dd	0FFFFFFFFh
			dd	18
NFK_URL		db	'http://pff.clan.su', 0
patch116_end:

align 16
patch119_begin:
newGetSystemVariable_getNfkversion	proc
	mov		ecx, dword ptr NFK_VERSION
	mov		[eax], ecx
	retn
newGetSystemVariable_getNfkversion	endp
patch119_end:

align 16
patch127_begin:
newGetTickCount	proc
	call	[imp_GetTickCount]
	and		eax, 7FFFFFFFh
	retn
newGetTickCount	endp
patch127_end:

align 16
patch133_begin:
BNET_NFK_ReceiveData_PacketFilter	proc
;----------- local variables -------									
	FromIP		EQU	<[ebp - 14Ah]>	; ShortString
	data		EQU	<[ebp - 8]>		; PPChar
	Port		EQU	<[ebp + 0Ch]>	; Dword
;-----------------------------------
	call	ismultip
	cmp		eax, 2
	jnz		exit_ok
	mov		eax, data
	mov		al, [eax]
	; checking allowed set of packets
	cmp		al, MMP_INVITE
	jz		exit_ok
	cmp		al, MMP_LOBBY_ANSWERPING
	jz		exit_ok
	cmp		al, MMP_LOBBY_GAMESTATE_RESULT
	jz		exit_ok
	; now checking IP and Port of the sender
	lea		eax, dword ptr FromIP
	lea		edx, BNET_GAMEIP
	call	PStrCmp
	jnz		exit_notOk
	movzx	eax, word ptr BNET_REALSERVERPORT
	cmp		eax, Port
	jnz		exit_notOk
exit_ok:
	cmp		ENABLE_PROTECT, 0		; overwritten code
	jmp		BNET_NFK_ReceiveData_afterPacketFilter
exit_notOk:
	jmp		BNET_NFK_ReceiveData_default
BNET_NFK_ReceiveData_PacketFilter	endp	
patch133_end:

align 16
patch136_begin:
new_entryPoint:
	push	offset new_entryPointLibName
	call	GetModuleHandleA
	test	eax, eax
	jz		@F
	push	offset new_entryPointProcName1
	mov		edi, eax
	push	eax
	call	GetProcAddress
	test	eax, eax
	jz		@F
	mov		esi, eax
	push	offset new_entryPointProcName2
	push	edi
	call	GetProcAddress
	test	eax, eax
	jz		@F
	call	eax
	push	1
	push	eax
	call	esi
@@:	
	;--- init new console variables
	; cl_allowdownload and sv_allowdownload are 1 by default
	mov		OPT_CL_ALLOWDOWNLOAD, 1
	mov		OPT_SV_ALLOWDOWNLOAD, 1
	;--- old entry point code
	push    ebp
    mov     ebp, esp
    add     esp, 0FFFFFFF4h
    jmp     old_entryPointCont 
;----------- datas ------------
align 4
new_entryPointLibName	db	'kernel32.dll', 0
align 4
new_entryPointProcName1	db	'SetProcessAffinityMask', 0
align 4
new_entryPointProcName2	db	'GetCurrentProcess', 0
patch136_end:

align 16
patch137_begin:
new_BNET_OnDataReceived	proc
;----------- params ----------------
	port	EQU	<[ebp + 8]>	; integer
	address	EQU	<[ebp + 0Ch]>	; LStr
	; eax = edx = this (TNMUDP)
	; ecx = result of recvfrom
;----------- local variables -------									
	i		EQU	<[ebp - 4]>	; integer
	data	EQU	<[ebp - 24h]>	; char[32]
	count	EQU	<[ebp - 28h]>	; integer
	shortAddress	EQU	<[ebp - 38h]>	; shortstring[15]
;-----------------------------------
	cmp		ecx, 0FFFFFFFFh
	je		isError
	jmp		old_BNET_OnDataReceived
isError:
	push	ebp
	mov		ebp, esp
	sub		esp, 38h
	; preserve esi
	push	esi
	; apply fix only to servers
	call	ismultip
	cmp		eax, 1
	jnz		exit
	; make a short version of address
	lea		eax, shortAddress
	mov		edx, address
	mov		ecx, 0Fh
	call	LStrToString
	
	; check spectators
	mov		eax, SpectatorList
	mov		eax, [eax + 8]	; TList.Count
	cmp		eax, 0
	jle		noSpectators
	mov		count, eax
	xor		edx, edx
	mov		i, edx
spectatorsLoop:
	mov		eax, SpectatorList
	call	TList_Get
	mov		esi, eax
	lea		eax, shortAddress
	lea		edx, [esi + 01Fh]	;TSpectator.address
	call	PStrCmp
	jnz		nextSpectator
	mov		ax, [esi + 30h]
	cmp		ax, port
	jnz		nextSpectator
	; spectator is found
	mov		byte ptr data, MMP_SPECTATORDISCONNECT
	lea		eax, data + 1		;TMMP_SpectatorDisconnect.netname
	mov		edx, esi
	mov		ecx, 1Eh
	call	PStrNCpy
	mov		eax, port
	push	eax
	push	20h					; sizeof TMMP_SpectatorDisconnect
	mov		eax, mainform
	lea		edx, data
	lea		ecx, shortAddress
	call	BNET_NFK_ReceiveData
	jmp		exit
nextSpectator:
	mov		edx, i
	inc		edx
	mov		i, edx
	cmp		edx, count
	jl		spectatorsLoop
noSpectators:	
	
exit:
	pop		esi
	mov		esp, ebp
	pop		ebp
	retn	8
new_BNET_OnDataReceived	endp
patch137_end:

patch139_begin:
add_TestIP	proc	; function continuation (no prolog)
					; must restore edi, esi (in that order), does not purge stack params
;----------- local variables -------
	Result	EQU		<[ebp - 1]>		; byte
	i		EQU		<[ebp - 2]>		; byte
	address	EQU		<[ebp - 102h]>	; shortstring
					;[ebp - 104h] - unallocated word
					;[ebp - 108h] - old esi
					;[ebp - 10Ch] - old edi
	count	EQU		<[ebp - 110h]>	; integer
;-----------------------------------
	movzx	eax, byte ptr Result
	test	eax, eax
	jz		checkSpectators
	pop		edi
	pop		esi
	mov		esp, ebp
	pop		ebp
	retn
checkSpectators:
	push	ecx				; allocate count
	mov		edi, SpectatorList
	mov		edx, [edi + 8]	; TList.Count
	cmp		edx, 0
	jle		exit
	mov		count, edx
	mov		i, al
	mov		edx, eax
spectatorsLoop:	; here, edx must contain i
	mov		eax, edi
	call	TList_Get
	lea		edx, [eax + 01Fh]	;TSpectator.address
	lea		eax, address
	call	PStrCmp
	jnz		nextSpectator
	; found spectator
	push	1
	pop		eax
	jmp		exit
nextSpectator:
	movzx	edx, byte ptr i
	inc		edx
	mov		i, dl
	cmp		edx, count
	jl		spectatorsLoop
exit:
	pop		ecx				; free count
	pop		edi
	pop		esi
	mov		esp, ebp
	pop		ebp
	retn
add_TestIP	endp
patch139_end:

patch141_begin:
on_MMP_PING_distribute	proc	; jump on on_MMP_PING_do_distribute if ping distribution is needed (not spectators)
								; jump on on_MMP_PING_no_distribute otherwise
								; can use edi
;----------- local variables -------
	data	EQU		<[ebp - 8]>		; PChar
	i		EQU		<[ebp - 34h]>	; integer
	FromIP	EQU		<[ebp - 14Ah]>	; shortstring
	Port	EQU		<[ebp + 0Ch]>	; integer
;-----------------------------------
	mov		edi, data
	mov		eax, [edi + 1]
	cmp		eax, 0FFFFFFFFh
	; if no spectator, distribute
	jnz		on_MMP_PING_do_distribute
	; if spectator, find out which one was that
	mov		eax, SpectatorList
	mov		eax, [eax + 8]		;TList.Count
	cmp		eax, 0
	jle		exit
	push	eax					; [esp] now contains the length of spectators array
								; do not forget to pop it out!
	xor		edx, edx
	mov		i, edx
spectatorsLoop:	; edx has to have index at this point
	mov		eax, SpectatorList
	call	TList_Get
	mov		edi, eax
	lea		eax, [eax + 1Fh]		;TSpectator.address
	lea		edx, FromIP
	call	PStrCmp
	jnz		nextSpectator
	movzx	edx, word ptr [edi + 30h]	;TSpectator.port
	cmp		edx, Port
	jnz		nextSpectator
	call	GetTickCount
	mov		[edi + 34h], eax		;TSpectator.lastPingTime
	jmp		exit
nextSpectator:
	inc		dword ptr i
	mov		edx, i
	cmp		edx, [esp]
	jl		spectatorsLoop
exit:
	pop		eax					; remove spectators count
	jmp		on_MMP_PING_no_distribute	
on_MMP_PING_distribute	endp
patch141_end:

patch143_begin:
new_secondTickServer	proc	; function insertion, no prolog or epilog
								; can use ebx
;----------- local variables -------
	i	EQU		<[ebp - 0Ch]>	; integer
;-----------------------------------
	; old code
	cmp		MATCH_GAMETYPE, Gametype_DOM
	jnz		@F
	call	DOM_Think
@@:
	; timeout spectators
	mov		ebx, SpectatorList
	mov		eax, [ebx + 8]		;TList.Count
	cmp		eax, 0
	jle		noSpectators
	push	eax					; [esp] is now Count
	xor		edx, edx
	mov		i, edx
spectatorsLoop:					; edx must contain index at this point
	mov		eax, SpectatorList
	call	TList_Get
	mov		ebx, eax
	mov		edx, STIME
	sub		edx, [eax + 34h]	;TSpectator.lastPingTime
	cmp		dx, SPECTATOR_TIMEOUT
	jl		nextSpectator
	; spectator timeouted
	
	; say it
	; reserve buffer for shortstring[64] (68 bytes aligned) and LStr conversion buffer (4 bytes)
	; so we will have shortstring at [esp] and LString at [esp + 44h]
	push	0					; init LString with 0
	sub		esp, 44h
	; build string
	mov		eax, esp
	lea		edx, str_Spectator
	mov		cl, 44h
	call	PStrNCpy
	mov		eax, esp
	mov		edx, ebx			;TSpectator.netname
	mov		cl, 44h
	call	PStrNCat
	mov		eax, esp
	lea		edx, str_droppedByTimeout
	mov		cl, 44h
	call	PStrNCat
	lea		eax, [esp + 44h]
	mov		edx, esp
	call	StringToLStr
	mov		eax, [esp + 44h]
	call	AddMessage
	; cleanup
	lea		eax, [esp + 44h]
	call	LStrClr
	
	; Send MMP_SPECTATORDISCONNECT
	; we will reuse allocated 48h bytes for MMP_SPECTATORDISCONNECT message
	mov		byte ptr [esp], MMP_SPECTATORDISCONNECT
	lea		eax, [esp + 1]		;TMMP_SpectatorDisconnect.netname
	mov		edx, ebx			;TSpectator.netname
	mov		ecx, 1Eh
	call	PStrNCpy
	movzx	eax, word ptr [ebx + 30h]	;TSpectator.port
	mov		edx, esp
	push	eax
	push	20h					; sizeof TMMP_SpectatorDisconnect
	mov		eax, mainform
	lea		ecx, [ebx + 1Fh]	;TSpectator.address
	call	BNET_NFK_ReceiveData
	; free allocated buffer
	add		esp, 48h
	; decrease i and Count
	dec		dword ptr i
	dec		dword ptr [esp]
nextSpectator:
	mov		edx, i
	inc		edx
	mov		i, edx
	cmp		edx, [esp]
	jnz		spectatorsLoop
	pop		ecx					; remove Count from stack
noSpectators:	
	jmp		secondTickTimeoutPlayers
new_secondTickServer	endp
patch143_end:

patch146_begin:
align 16
; process input of boolean-type (0 or 1) parameter
; eax - LStr: name of parameter
; edx - PChar: pointer to the parameter value
; ecx - LStr: input value
; stack parameter 1 - Char: default value
applyCommand_process_boolean	proc	
;----------- local variables -------
	defaultValue	EQU		<[ebp + 8]>		; Char
	_name			EQU		<[ebp - 4]>		; LStr
	paramValue		EQU		<[ebp - 8]>		; PChar
	temp1			EQU		<[ebp - 0Ch]>	; LStr
;-----------------------------------
	push	ebp
	mov		ebp, esp
	; init stack variables
	push	eax
	push	edx
	push	0
	; check the presense of actual input
	test	ecx, ecx
	jnz		handle_input
	
	; there were none, show current value then
	lea		eax, temp1
	mov		edx, offset applyCommand_boolean_show
	call	LStrAsg
	; put current value to "show" string
	mov		eax, temp1
	mov		edx, paramValue
	mov		dl, [edx]
	add		[eax + 6], dl
	; put default value to "show" string
	mov		dl, defaultValue
	add		[eax + 22], dl
	
	; build a string '"<name>" is "<current value>". Default is "<default value>". Possible range 0-1.'
	push	offset lstrpart_doublequote
	mov		edx, _name
	push	edx
	lea		eax, temp1
	push	dword ptr [eax]
	mov		edx, 3
	call	LStrCatN
	; add message to the console
	mov		eax, temp1
	call	AddMessage
	jmp		exit
	
handle_input:
	; check input length - must be 1
	mov		eax, [ecx - 4]
	dec		eax
	jnz		bad_input
	; check input value - must be "0" or "1"
	mov		al, [ecx]
	sub		al, '0'
	cmp		al, 1
	ja		bad_input
	; set the value
	mov		[edx], al
	; announce changes
	; build a string '"<name>" is set to "<input value>"'
	push	offset lstrpart_doublequote
	mov		eax, _name
	push	eax
	push	offset lstrpart_dq_is_set_to_dq
	push	ecx
	push	offset lstrpart_doublequote
	lea		eax, temp1
	mov		edx, 5
	call	LStrCatN
	; add message to the console
	mov		eax, temp1
	call	AddMessage
	jmp		exit
	
bad_input:
	; build a string 'invalid value "<input value>"'
	lea		eax, temp1
	push	offset lstrpart_invalid_value_dq
	push	ecx
	push	offset lstrpart_doublequote
	mov		edx, 3
	call	LStrCatN
	mov		eax, temp1
	call	AddMessage
exit:
	lea		eax, temp1
	call	LStrClr
	mov		esp, ebp
	pop		ebp
	retn	4
;----------- datas -----------------
dd	0FFFFFFFFh
dd	45
; current and default values here are to be fixed in runtime
; current value offset = 6, default value offset = 22
applyCommand_boolean_show		db	'" is "0". Default is "0". Possible range 0-1.', 0

applyCommand_process_boolean	endp

align 16

applyCommand_ext	proc
;----------- local variables -------
	s			EQU		<[ebp - 4]>
	par0		EQU		<[ebp - 4Ch]>
	par1		EQU		<[ebp - 50h]>
;-----------------------------------
	; check cl_allowdownload
	mov		eax, par0
	mov		edx, offset lstr_cl_allowdownload
	call	LStrCmp
	jnz		check_sv_allowdownload
	push	1
	mov		eax, offset lstr_cl_allowdownload
	mov		edx, offset OPT_CL_ALLOWDOWNLOAD
	mov		ecx, par1
	call	applyCommand_process_boolean
	jmp		applyCommand_exit
	
check_sv_allowdownload:
	; check sv_allowdownload
	mov		eax, par0
	mov		edx, offset lstr_sv_allowdownload
	call	LStrCmp
	jnz		next
	push	1
	mov		eax, offset lstr_sv_allowdownload
	mov		edx, offset OPT_SV_ALLOWDOWNLOAD
	mov		ecx, par1
	call	applyCommand_process_boolean
	jmp		applyCommand_exit
next:
	call	ismultip
	jmp		applyCommand_after_ext
;----------- datas -----------------
align 4
dd	0FFFFFFFFh
dd  16
lstr_cl_allowdownload	db 'cl_allowdownload', 0

align 4
dd	0FFFFFFFFh
dd  16
lstr_sv_allowdownload	db 'sv_allowdownload', 0

applyCommand_ext	endp
patch146_end:

patch148_begin:
align 16
; save a numeric parameter in cfg
; eax - integer: number
; edx - LStr: name of parameter
; ecx - TStringList: cfg String List
SaveCFG_save_number	proc
	; reserve space for temporary LStr
	push	0
	; save ecx and edx
	push	ecx
	push	edx
	lea		edx, [esp + 8]
	call	IntToStr
	push	offset lstrpart_space
	lea		eax, [esp + 0Ch]
	push	dword ptr [eax]
	mov		edx, 3
	call	LStrCatN
	pop		eax
	mov		ecx, [eax]
	mov		edx, [esp]
	call	dword ptr [ecx + 34h]	;TStringList.Add
	mov		eax, esp
	call	LStrClr
	pop		ecx
	retn	
SaveCFG_save_number	endp

align 16
SaveCFG_ext	proc
;----------- local variables -------
	ts			EQU		<[ebp - 8]>
;-----------------------------------
	call	ALIAS_SaveAlias
	movzx	eax, byte ptr OPT_CL_ALLOWDOWNLOAD
	mov		edx, offset lstr_cl_allowdownload
	mov		ecx, ts
	call	SaveCFG_save_number
	movzx	eax, byte ptr OPT_SV_ALLOWDOWNLOAD
	mov		edx, offset lstr_sv_allowdownload
	mov		ecx, ts
	call	SaveCFG_save_number
	retn	
;----------- datas -----------------
dd	0FFFFFFFFh
dd	18
;lstr_cl_allowdownload	db	'cl_allowdownload 0', 0
SaveCFG_ext	endp
patch148_end:

IFDEF _MEMDEBUG

exeAddr 785000h

    jmp     newGetMem           ;jump from .004026E0 (5 nops ahead)
exeAddr 785008h
    jmp     newFreeMem          ;jump from .004026F8 (5 nops ahead)
exeAddr 785010h
    jmp     init                ;jump from .005480A4 (1 nop ahead)
exeAddr 785018h
    jmp     newReallocMem       ;jump from .00402710 (1 nop ahead)
exeAddr 785020h
    jmp     newHalt             ;call from .00548138 (0 nops ahead)
exeAddr 785028h
    jmp     onTimer             ;jump from .004E9388 (3 nops ahead)
exeAddr 785030h
    jmp     newNewAnsiString    ;jump from .00403D10 (0 nops ahead)
exeAddr 785038h
    jmp     newLStrFromPCharLen ;jump from .00403D34 (0 nops ahead)
    
align   10h
newGetMem   proc
    push    eax     ;save requested amount of memory
    add     eax, 8
    call    oldGetMem

    push    eax
    push    offset chainCriticalSection
    call    EnterCriticalSection
    pop     eax

    mov     ecx, nestingCount
    test    ecx, ecx
    jnz     @F
    mov     edx, dword ptr [esp+4]
    mov     retAddr, edx
@@:
    inc     ecx
    mov     nestingCount, ecx
    mov     ecx, retAddr

    mov     dword ptr [eax], ecx            ;caller
    mov     edx, dword ptr [esp]            ;size
    mov     dword ptr [eax+4], edx
    add     eax, 8
    push    eax
    call    addMemRecord

    mov     ecx, nestingCount
    dec     ecx
    jnz     @F
    mov     retAddr, ecx
@@:
    mov     nestingCount, ecx    

    push    offset chainCriticalSection
    call    LeaveCriticalSection
    
    pop     eax
    add     esp, 4
    retn    
newGetMem   endp

oldGetMem   proc
    test    eax, eax
    jz      l4026EE
    call    l54901C
    jmp     l4026EA
oldGetMem   endp

align   10h
newFreeMem  proc
    test    eax, eax
    jz      oldFreeMem
    sub     eax, 8
    push    edx
    push    eax
    mov     edx, dword ptr [eax+4]
    mov     eax, dword ptr [eax]
    call    deleteMemRecord
    pop     eax
    pop     edx
    call    oldFreeMem
    retn
newFreeMem  endp    

oldFreeMem  proc
    test    eax, eax
    jz      l402706
    call    l549020
    jmp     l402702
oldFreeMem  endp

newReallocMem   proc
    push    eax
    push    edx
    mov     ecx, dword ptr [eax]
    test    ecx, ecx
    jz      nofree
    sub     ecx, 8
    mov     dword ptr [eax], ecx
    mov     eax, dword ptr [ecx]
    mov     edx, dword ptr [ecx+4]
    call    deleteMemRecord
    mov     eax, dword ptr [esp+4]
    mov     edx, dword ptr [esp]
nofree:    
    test    edx, edx
    jz      @F
    add     edx, 8
@@:    
    call    oldReallocMem
    pop     edx
    pop     ecx
    test    edx, edx
    jz      noalloc

    add     eax, 8
    push    eax
    push    ecx
    push    edx
    push    offset chainCriticalSection
    call    EnterCriticalSection    
    pop     edx
    pop     ecx

    mov     eax, dword ptr [ecx]
    add     dword ptr [ecx], 8

    mov     ecx, nestingCount
    test    ecx, ecx
    jnz     @F
    mov     ecx, dword ptr [esp+4]
    mov     retAddr, ecx
@@:    
    inc     nestingCount

    mov     ecx, retAddr
    mov     dword ptr [eax], ecx
    mov     dword ptr [eax+4], edx
    call    addMemRecord

    mov     ecx, nestingCount
    dec     ecx
    jnz     @F
    mov     retAddr, ecx
@@: 
    mov     nestingCount, ecx

    push    offset chainCriticalSection
    call    LeaveCriticalSection

    pop     eax
noalloc:
    retn    
newReallocMem   endp

   
oldReallocMem   proc    ;eax - pointer to a memory, edx - new requested size
    mov     ecx, dword ptr [eax]
    test    ecx, ecx
    jz      l402748
    jmp     l402716    
oldReallocMem   endp

init    proc
    pusha
    push    offset chainCriticalSection
    call    InitializeCriticalSection
    call    GetTickCount
    mov     starttime, eax
    mov     timestamp, eax
    popa
;old init stuff
    push    ebp
    mov     ebp, esp
    add     esp, 0FFFFFFF4h
    jmp     l5480AA    
init    endp

newHalt proc
    call    GetTickCount
    mov     timestamp, eax
    call    saveToDisk
    call    l403B14h
    retn
newHalt endp

onTimer proc
    push    eax
    push    edx
    call    GetTickCount
    mov     edx, timestamp
    sub     eax, edx
    cmp     eax, 60000
    jb      exit
    add     edx, eax
    mov     timestamp, edx
    call    saveToDisk
    call    cleanChain
exit:    
    pop     edx
    pop     eax
    push    ebp
    mov     ebp, esp
    mov     ecx, 4Fh
    jmp     l4E9390
onTimer endp

newNewAnsiString proc
    push    eax
    push    offset chainCriticalSection
    call    EnterCriticalSection

    mov     eax, nestingCount
    test    eax, eax
    jnz     @F
    mov     ecx, dword ptr [esp+4]
    mov     retAddr, ecx
@@:    
    inc     eax
    mov     nestingCount, eax
    
    pop     eax
    call    oldNewAnsiString
    push    eax

    mov     eax, nestingCount
    dec     eax
    jnz     @F
    mov     retAddr, eax
@@:    
    mov     nestingCount, eax
    
    push    offset chainCriticalSection
    call    LeaveCriticalSection
    pop     eax
    retn
newNewAnsiString endp

oldNewAnsiString proc
    test    eax, eax
    jle     l403D30
    push    eax
    jmp     l403D15
oldNewAnsiString endp

newLStrFromPCharLen proc
    push    eax
    push    edx
    push    ecx
    push    offset chainCriticalSection
    call    EnterCriticalSection

    mov     eax, nestingCount
    test    eax, eax
    jnz     @F
    mov     ecx, dword ptr [esp+0Ch]
    mov     retAddr, ecx
@@:    
    inc     eax
    mov     nestingCount, eax

    pop     ecx
    pop     edx
    pop     eax
    call    oldLStrFromPCharLen
    push    eax

    mov     eax, nestingCount
    dec     eax
    jnz     @F
    mov     retAddr, eax
@@:    
    mov     nestingCount, eax
    
    push    offset chainCriticalSection
    call    LeaveCriticalSection
    pop     eax
    retn
newLStrFromPCharLen endp

oldLStrFromPCharLen proc
    push    ebx
    push    esi
    push    edi
    mov     ebx, eax
    jmp     l403D39
oldLStrFromPCharLen endp

allocBlock  proc
    push    edi
    mov     eax, 4000h      ;16k blocks
    call    oldGetMem
    push    eax
    mov     edi, eax
    xor     eax, eax
    mov     ecx, 1000h
    rep     stosd
    pop     eax
    pop     edi
    retn
allocBlock  endp    

addMemRecord    proc    ;edx - size
    push    esi
    push    edi

    mov     esi, retAddr
    mov     edi, edx

    mov     edx, offset allocChain
moveToNewBlock:     
    mov     eax, dword ptr [edx]
    test    eax, eax
    jnz     @F
    push    edx
    call    allocBlock
    pop     edx
    mov     dword ptr [edx], eax
@@:
    mov     edx, eax
    mov     ecx, 3FFh
blockLoop:
    mov     eax, dword ptr [edx]
    cmp     eax, esi
    jz      found
    test    eax, eax
    jz      notfound    
    add     edx, 10h
    dec     ecx
    jnz     blockLoop
    jmp     moveToNewBlock    
notfound:
    mov     dword ptr [edx], esi    
found:  
;found a free place in chain, edx points there  
    add     dword ptr [edx+4], edi
    inc     dword ptr [edx+8]
    add     dword ptr [edx+0Ch], edi

    pop     edi
    pop     esi
    retn
addMemRecord    endp

deleteMemRecord proc    ;eax - caller address, edx - size
    push    esi
    push    edi
    mov     esi, eax
    mov     edi, edx
    
    push    offset chainCriticalSection
    call    EnterCriticalSection
    
    mov     edx, offset allocChain
moveToNewBlock:
    mov     edx, dword ptr [edx]
    test    edx, edx
    jz      err      
    mov     ecx, 3FFh
blockLoop: 
    mov     eax, dword ptr [edx]
    cmp     eax, esi
    jz      found
    cmp     eax, 0
    jz      err
    add     edx, 10h
    dec     ecx
    jnz     blockLoop
    jmp     moveToNewBlock
found:
    dec     dword ptr [edx+8]
    sub     dword ptr [edx+4], edi
    sub     dword ptr [edx+0Ch], edi

    push    offset chainCriticalSection
    call    LeaveCriticalSection

    pop     edi
    pop     esi
    retn
err:
    int     3    
deleteMemRecord endp

cleanChain  proc
    push    offset chainCriticalSection
    call    EnterCriticalSection
    
    mov     edx, offset allocChain
moveToNewBlock:
    mov     edx, dword ptr [edx]
    test    edx, edx
    jz      exit
    mov     ecx, 3FFh
blockLoop:    
    mov     eax, dword ptr [edx]
    test    eax, eax
    jz      exit
    mov     dword ptr [edx+4], 0    
    mov     dword ptr [edx+8], 0 
    lea     edx, [edx+10h]
    dec     ecx
    jz      moveToNewBlock
    jmp     blockLoop
exit:

    push    offset chainCriticalSection
    call    LeaveCriticalSection
    retn    
cleanChain  endp

dwordToHex  proc    ;eax - pointer to buffer, edx - dword
    push    edi
    mov     edi, eax
    test    edx, edx
    jns     nosign
    mov     al, '-'
    dec     edi
    stosb
    neg     edx
nosign:    
    mov     ecx, 8
hexloop:    
    rol     edx, 4
    mov     al, dl
    and     al,0Fh
    cmp     al, 9
    jbe     digit
    add     al, 7
digit:
    add     al, '0'
    stosb
    dec     ecx
    jnz     hexloop
    pop     edi
    retn
dwordToHex  endp

dwordToDec  proc    ;eax - dword, edx - pointer to buffer
    test    eax, eax
    jnz     nozero
    mov     byte ptr [edx], '0'
    lea     eax, [edx+1]
    retn
nozero:    
    push    esi
    push    edi
    mov     edi, edx
    jns     nosign
    mov     byte ptr [edi], '-'
    inc     edi
    neg     eax
nosign:    
    mov     ecx, 0Ah
    mov     esi, edi
@@:    
    test    eax, eax
    jz      exit
    xor     edx, edx    
    div     ecx
    add     dl, '0'
    mov     byte ptr [edi], dl
    inc     edi
    jmp     @B
exit:
    mov     eax, edi
@@:
    dec     edi
    mov     cl, byte ptr [edi]
    mov     ch, byte ptr [esi]
    mov     byte ptr [edi], ch
    mov     byte ptr [esi], cl
    inc     esi
    cmp     esi, edi
    jb      @B    

    pop     edi
    pop     esi
    retn
dwordToDec  endp

saveToDisk  proc
    push    ebx
    push    esi
    push    edi
    push    0
    push    0
    push    OPEN_ALWAYS
    push    0
    push    0
    push    GENERIC_WRITE
    push    offset aMemReport
    call    CreateFileA
    cmp     eax, 0FFFFFFFFh
    jz      exit
    mov     ebx, eax
    push    FILE_END
    push    0
    push    0
    push    eax
    call    SetFilePointer
    sub     esp, 3Ch
    mov     edi, esp
    mov     ecx, 0Eh
    mov     eax, "----"
    rep     stosd
    mov     eax, 20202D2Dh
    stosd
    mov     eax, " :st"
    mov     edi,esp
    stosd
    mov     eax, edi
    mov     edx, timestamp
    sub     edx, starttime
    call    dwordToHex
    call    write
;writing alloc chain
    call    klear
    mov     edi, esp
    mov     esi, offset aAllocChain
    mov     ecx, LENGTHOF aAllocChain
    rep     movsb
    call    write
    call    klear

    push    offset chainCriticalSection
    call    EnterCriticalSection

    mov     edi, offset allocChain
moveToNewAllocBlock:
    mov     edi, dword ptr [edi]
    test    edi, edi
    jz      finishAllocBlock
    mov     esi, 3FFh
@@:
    mov     edx, dword ptr [edi]
    test    edx, edx
    jz      finishAllocBlock
    call    klear
    sub     edx, 5
    lea     eax, [esp]
    call    dwordToHex
    lea     edx, [esp+8]
    mov     byte ptr [edx], 9
    mov     eax, dword ptr [edi+4]
    inc     edx
    call    dwordToDec
    mov     byte ptr [eax], 9
    lea     edx, [eax+1]
    mov     eax, dword ptr [edi+8]
    call    dwordToDec
    mov     byte ptr [eax], 9
    lea     edx, [eax+1]
    mov     eax, dword ptr [edi+0Ch]
    call    dwordToDec
    call    write
    lea     edi, [edi+10h]
    dec     esi
    jz      moveToNewAllocBlock
    jmp     @B
finishAllocBlock:        

    push    offset chainCriticalSection
    call    LeaveCriticalSection

    push    ebx
    call    CloseHandle
exit:
    add     esp, 3Ch
    pop     edi
    pop     esi
    pop     ebx
    retn    
saveToDisk  endp

klear   proc
    push    edi
    mov     al, ' '
    mov     ecx, 3Ch
    lea     edi, [esp+8]
    rep     stosb
    pop     edi
    retn
klear   endp

write   proc
    lea     eax, [esp+4]
    lea     ecx, [eax+3Ch]
@@:
    dec     ecx
    cmp     byte ptr [ecx], ' '
    jz      @B
    inc     ecx
    mov     word ptr [ecx], 0A0Dh
    lea     ecx, [ecx+2]
    sub     ecx, eax
    
    add     esp, -4
    mov     edx, esp
    push    0
    push    edx
    push    ecx
    push    eax
    push    ebx
    call    WriteFile
    add     esp, 4
    retn
write   endp

align   10h
;data goes here
allocChain  dd  0
allocLastFreeBlock  dd  0
chainCriticalSection    dd 0,0,0,0,0,0
starttime   dd 0
timestamp   dd 0
aMemReport  db  "memreport.txt",0
aAllocChain db  "Alloc chain:"
retAddr     dd  0
nestingCount    dd  0

ENDIF
align   4
patchCount      dd      (patchSize_end - patchSize_begin) / 8
patchSize_begin dd      patch5_begin				; 6 players fix
                dd      patch5_end - patch5_begin
IFDEF _DEDIC
				dd      patch3_begin				; dedik server autocreate
                dd      patch3_end - patch3_begin			
                dd      patch4_begin				; dedik server autocreate
                dd      patch4_end - patch4_begin
ENDIF				
                dd      patch14_begin				; 6 players fix
                dd      patch14_end - patch14_begin
                dd      patch15_begin				; 6 players fix
                dd      patch15_end - patch15_begin
                dd      patch18_begin				; timer fix
                dd      patch18_end - patch18_begin
                dd      patch19_begin				; memory leak fix
                dd      patch19_end - patch19_begin
                dd      patch20_begin				; memory leak fix
                dd      patch20_end - patch20_begin
                dd      patch21_begin				; memory leak fix
                dd      patch21_end - patch21_begin
                dd      patch22_begin				; memory leak fix
                dd      patch22_end - patch22_begin
                dd      patch23_begin				; memory leak fix
                dd      patch23_end - patch23_begin
                dd      patch24_begin				; memory leak fix
                dd      patch24_end - patch24_begin
                dd      patch25_begin				; memory leak fix
                dd      patch25_end - patch25_begin
                dd      patch26_begin				; memory leak fix
                dd      patch26_end - patch26_begin
                dd      patch27_begin				; memory leak fix
                dd      patch27_end - patch27_begin
                dd      patch28_begin				; memory leak fix
                dd      patch28_end - patch28_begin
IFDEF	_DEDIK
                dd      patch29_begin				; sleeping pill
                dd      patch29_end - patch29_begin
                dd      patch30_begin				; sleeping pill
                dd      patch30_end - patch30_begin
ENDIF				
				dd		patch31_begin				; new pinger
				dd		patch31_end - patch31_begin
				dd		patch32_begin				; alt-tab fix
				dd		patch32_end - patch32_begin
				dd		patch33_begin				; new pinger
				dd		patch33_end - patch33_begin
IFDEF	_PINGER				
				dd		patch34_begin				; new pinger
				dd		patch34_end - patch34_begin			
				dd		patch35_begin				; new pinger
				dd		patch35_end - patch35_begin
				dd		patch36_begin				; new pinger
				dd		patch36_end - patch36_begin
ENDIF					
				dd		patch37_begin				; new planet adaptation
				dd		patch37_end - patch37_begin
				dd		patch38_begin				; new planer adaptation
				dd		patch38_end - patch38_begin
				dd		patch39_begin				; new Short Version
				dd		patch39_end - patch39_begin
				dd		patch40_begin				; new planet adaptation
				dd		patch40_end - patch40_begin
				dd		patch41_begin				; new planet adaptation
				dd		patch41_end - patch41_begin
				dd		patch42_begin				; new planet adaptation
				dd		patch42_end - patch42_begin
				dd		patch43_begin				; new planet adaptation
				dd		patch43_end - patch43_begin
				dd		patch44_begin				; new planet adaptation
				dd		patch44_end - patch44_begin
				dd		patch45_begin				; new planet adaptation
				dd		patch45_end - patch45_begin
				dd		patch46_begin				; new planet adaptation
				dd		patch46_end - patch46_begin
				dd		patch47_begin				; new planet adaptation
				dd		patch47_end - patch47_begin
				dd		patch48_begin				; new planet adaptation
				dd		patch48_end - patch48_begin
				dd		patch49_begin				; new planet adaptation
				dd		patch49_end - patch49_begin
				dd		patch50_begin				; new planet adaptation
				dd		patch50_end - patch50_begin
				dd		patch51_begin				; new planet adaptation
				dd		patch51_end - patch51_begin
				dd		patch52_begin				; new planet adaptation
				dd		patch52_end - patch52_begin
				dd		patch53_begin				; new planet adaptation
				dd		patch53_end - patch53_begin
				dd		patch54_begin				; new planet adaptation
				dd		patch54_end - patch54_begin
				dd		patch55_begin				; new planet adaptation
				dd		patch55_end - patch55_begin
				dd		patch56_begin				; new planet adaptation
				dd		patch56_end - patch56_begin
				dd		patch57_begin				; new planet adaptation
				dd		patch57_end - patch57_begin
				dd		patch58_begin				; new planet adaptation
				dd		patch58_end - patch58_begin
				dd		patch59_begin				; new planet adaptation
				dd		patch59_end - patch59_begin
				dd		patch60_begin				; new planet adaptation
				dd		patch60_end - patch60_begin
				dd		patch61_begin				; new planet adaptation
				dd		patch61_end - patch61_begin
				dd		patch62_begin				; new planet adaptation
				dd		patch62_end - patch62_begin
				dd		patch63_begin				; new planet adaptation
				dd		patch63_end - patch63_begin
				dd		patch64_begin				; new planet adaptation
				dd		patch64_end - patch64_begin
				dd		patch65_begin				; new planet adaptation
				dd		patch65_end - patch65_begin
				dd		patch66_begin				; new planet adaptation
				dd		patch66_end - patch66_begin
				dd		patch67_begin				; new planet adaptation
				dd		patch67_end - patch67_begin
				dd		patch68_begin				; new planet adaptation
				dd		patch68_end - patch68_begin
				dd		patch69_begin				; new planet adaptation
				dd		patch69_end - patch69_begin
				dd		patch70_begin				; new planet adaptation
				dd		patch70_end - patch70_begin
				dd		patch71_begin				; new planet adaptation
				dd		patch71_end - patch71_begin
				dd		patch72_begin				; new planet adaptation
				dd		patch72_end - patch72_begin
				dd		patch73_begin				; new Long Version
				dd		patch73_end - patch73_begin
				dd		patch74_begin				; new planet adaptation
				dd		patch74_end - patch74_begin
				dd		patch75_begin				; new planet adaptation
				dd		patch75_end - patch75_begin
IFDEF _DEDIC
				dd		patch76_begin				; disable graphic for dedik
				dd		patch76_end - patch76_begin
				dd		patch77_begin				; disable graphic for dedik
				dd		patch77_end - patch77_begin
				dd		patch78_begin				; disable graphic for dedik
				dd		patch78_end - patch78_begin
				dd		patch79_begin				; disable graphic for dedik
				dd		patch79_end - patch79_begin
				dd		patch80_begin				; disable graphic for dedik
				dd		patch80_end - patch80_begin
				dd		patch81_begin				; disable graphic for dedik
				dd		patch81_end - patch81_begin
				dd		patch82_begin				; disable graphic for dedik
				dd		patch82_end - patch82_begin
				dd		patch83_begin				; disable graphic for dedik
				dd		patch83_end - patch83_begin
				dd		patch84_begin				; disable graphic for dedik
				dd		patch84_end - patch84_begin
				dd		patch85_begin				; disable graphic for dedik
				dd		patch85_end - patch85_begin
				dd		patch86_begin				; disable graphic for dedik
				dd		patch86_end - patch86_begin
				dd		patch87_begin				; disable graphic for dedik
				dd		patch87_end - patch87_begin
				dd		patch88_begin				; disable graphic for dedik
				dd		patch88_end - patch88_begin
				dd		patch89_begin				; disable graphic for dedik
				dd		patch89_end - patch89_begin
				dd		patch90_begin				; disable graphic for dedik
				dd		patch90_end - patch90_begin
				dd		patch91_begin				; disable graphic for dedik
				dd		patch91_end - patch91_begin
				dd		patch92_begin				; disable graphic for dedik
				dd		patch92_end - patch92_begin
				dd		patch93_begin				; disable graphic for dedik
				dd		patch93_end - patch93_begin
				dd		patch94_begin				; disable graphic for dedik
				dd		patch94_end - patch94_begin
				dd		patch95_begin				; disable graphic for dedik
				dd		patch95_end - patch95_begin
				dd		patch96_begin				; disable graphic for dedik
				dd		patch96_end - patch96_begin
				dd		patch97_begin				; disable graphic for dedik
				dd		patch97_end - patch97_begin
				dd		patch98_begin				; disable graphic for dedik
				dd		patch98_end - patch98_begin
				dd		patch99_begin				; disable graphic for dedik
				dd		patch99_end - patch99_begin
				dd		patch100_begin				; disable graphic for dedik
				dd		patch100_end - patch100_begin
				dd		patch101_begin				; disable graphic for dedik
				dd		patch101_end - patch101_begin
				dd		patch102_begin				; disable graphic for dedik
				dd		patch102_end - patch102_begin
				dd		patch103_begin				; disable graphic for dedik
				dd		patch103_end - patch103_begin
				dd		patch104_begin				; disable graphic for dedik
				dd		patch104_end - patch104_begin
				dd		patch105_begin				; disable graphic for dedik
				dd		patch105_end - patch105_begin
				dd		patch106_begin				; disable graphic for dedik
				dd		patch106_end - patch106_begin
				dd		patch107_begin				; disable graphic for dedik
				dd		patch107_end - patch107_begin
				dd		patch108_begin				; disable graphic for dedik
				dd		patch108_end - patch108_begin
				dd		patch109_begin				; disable graphic for dedik
				dd		patch109_end - patch109_begin
				dd		patch110_begin				; disable graphic for dedik
				dd		patch110_end - patch110_begin
ENDIF				
				dd		patch111_begin				; new planet adaptation
				dd		patch111_end - patch111_begin
				dd		patch112_begin				; new planet adaptation
				dd		patch112_end - patch112_begin
				dd		patch113_begin				; no splash damage in BattleSuit
				dd		patch113_end - patch113_begin
				dd		patch114_begin				; no splash damage in BattleSuit
				dd		patch114_end - patch114_begin
				dd		patch115_begin				; new version in console
				dd		patch115_end - patch115_begin
				dd		patch116_begin				; new engine version in console
				dd		patch116_end - patch116_begin
				dd		patch117_begin				; new engine version in console
				dd		patch117_end - patch117_begin
				dd		patch118_begin				; new engine version in console
				dd		patch118_end - patch118_begin
				dd		patch119_begin				; new version in GetSystemVariable
				dd		patch119_end - patch119_begin
				dd		patch120_begin				; new version in GetSystemVariable
				dd		patch120_end - patch120_begin
				dd		patch121_begin				; new planet adaptation
				dd		patch121_end - patch121_begin
				dd		patch122_begin				; new planet adaptation
				dd		patch122_end - patch122_begin
				dd		patch123_begin				; new version at the bottom of main screen
				dd		patch123_end - patch123_begin 
				dd		patch124_begin				; new official website
				dd		patch124_end - patch124_begin
				dd		patch125_begin				; new birthday website
				dd		patch125_end - patch125_begin
IFDEF _DEDIC
				dd		patch126_begin				; dedik cursor centering fix
				dd		patch126_end - patch126_begin
ENDIF
				dd		patch127_begin				; GetTickCount fix
				dd		patch127_end - patch127_begin
				dd		patch128_begin				; GetTickCount fix
				dd		patch128_end - patch128_begin
IFDEF _DEDIC
				dd		patch129_begin				; no dedik window popup on player join
				dd		patch129_end - patch129_begin
				dd		patch130_begin				; dedik cursor visibility fix
				dd		patch130_end - patch130_begin
				dd		patch131_begin				; dedik cursor visibility fix
				dd		patch131_end - patch131_begin
				dd		patch132_begin				; dedik cursor visibility fix
				dd		patch132_end - patch132_begin
ENDIF				
				dd		patch133_begin				; new packet filter
				dd		patch133_end - patch133_begin
				dd		patch134_begin				; new packet filter
				dd		patch134_end - patch134_begin
				dd		patch135_begin				; multiprocessor timer issues fix
				dd		patch135_end - patch135_begin
				dd		patch136_begin				; multiprocessor timer issues fix
				dd		patch136_end - patch136_begin
				dd		patch137_begin				; network error handler
				dd		patch137_end - patch137_begin
				dd		patch138_begin				; network error handler
				dd		patch138_end - patch138_begin
				dd		patch139_begin				; added Spectators checking loop to TestIP function
				dd		patch139_end - patch139_begin
				dd		patch140_begin				; added Spectators checking loop to TestIP function
				dd		patch140_end - patch140_begin
				dd		patch141_begin				; update Spectator last ping time
				dd		patch141_end - patch141_begin
				dd		patch142_begin				; update Spectator last ping time
				dd		patch142_end - patch142_begin
				dd		patch143_begin				; ping timeout Spectators
				dd		patch143_end - patch143_begin
				dd		patch144_begin				; ping timeout Spectators
				dd		patch144_end - patch144_begin
				dd		patch145_begin				; applyCommand extension
				dd		patch145_end - patch145_begin
				dd		patch146_begin				; applyCommand extension
				dd		patch146_end - patch146_begin
				dd		patch147_begin				; SaveCFG extension
				dd		patch147_end - patch147_begin
				dd		patch148_begin				; SaveCFG extension
				dd		patch148_end - patch148_begin
				
patchSize_end:

end start