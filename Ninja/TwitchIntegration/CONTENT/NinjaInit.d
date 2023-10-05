const int TwitchIntegration_PROC_cInitIntegration     = 0;
const int TwitchIntegration_PROC_cShutdownIntegration = 0;
const int TwitchIntegration_PROC_cHandleEvents        = 0;


const int _TwitchIntegration_Print_Count_Limit_Current = 0;
const int _TwitchIntegration_Print_Duration = 8000;
const int _TwitchIntegration_Print_Y = 2000;
const int _TwitchIntegration_Print_X = 5500;
const int _TwitchIntegration_Print_TextHeight = 150;
const int _TwitchIntegration_Print_Count_Max = 30;
const int _TwitchIntegration_Print_Count = 0;
const int _TwitchIntegration_Print_Timer = 0;

const string TwitchIntegration_Print_Font = "FONT_OLD_10_WHITE.TGA";

const string TwitchIntegration_User = "";
const string TwitchIntegration_Command   = "";
const string TwitchIntegration_Arguments = "";


func void _TwitchIntegration_PrintC(var string text, var int color) {
    const int _Print_Count_Limit = 30;

	if (_TwitchIntegration_Print_Count_Limit_Current > _Print_Count_Limit) { return; };
	// If we, for some reason, have no font.
	if (STR_Len(TwitchIntegration_Print_Font) == 0) { return; };

	if (_TwitchIntegration_Print_Count >= _TwitchIntegration_Print_Count_Max) { _TwitchIntegration_Print_Count = 0; };
	// restart from top if text would be out-of-bounds (Y-coords)
	if ((_TwitchIntegration_Print_Y + (_TwitchIntegration_Print_TextHeight * _TwitchIntegration_Print_Count) + _TwitchIntegration_Print_TextHeight) >= PS_VMax) {
		_TwitchIntegration_Print_Count = 0;
	};

	Print_Ext(_TwitchIntegration_Print_X, _TwitchIntegration_Print_Y + (_TwitchIntegration_Print_TextHeight * _TwitchIntegration_Print_Count), text, TwitchIntegration_Print_Font, color, _TwitchIntegration_Print_Duration);

	_TwitchIntegration_Print_Count += 1;
	_TwitchIntegration_Print_Timer = 0;
	_TwitchIntegration_Print_Count_Limit_Current +=1;
};

func void _TwitchIntegration_Print(var string text) {
    _TwitchIntegration_PrintC(text, COL_White);
};

//einfache Anwendung der obigen beiden Funktionen.
func int TwitchIntegration_FindDllFunction(var string name) {
    const int DLL = 0;
    if (!DLL) {
        DLL = LoadLibrary ("twitch-integration.dll");
    };
    
    return GetProcAddress(DLL, name);
};

func int TwitchIntegration_Init() {
	TwitchIntegration_PROC_cInitIntegration     = TwitchIntegration_FindDllFunction("cInitIntegration");
	TwitchIntegration_PROC_cShutdownIntegration = TwitchIntegration_FindDllFunction("cShutdownIntegration");
	TwitchIntegration_PROC_cHandleEvents        = TwitchIntegration_FindDllFunction("cHandleEvents");

	return 0;
};

func string TwitchIntegration_ReadString(var int lpstr) {
	if (lpstr == 0) {
		return "(null)";
	};
	const int oldSb = 0; oldSb = SB_Get();
	if (final()) { SB_Use(oldSb); };

	const int sb = 0;
	if(!sb) { sb = SB_New(); };

    SB_Use(sb);
    SB_Clear();
	const int offset = 0; offset = 0;
	while(MEM_ReadByte(lpstr+offset) != 0);
		SBc(MEM_ReadByte(lpstr+offset));
		offset += 1;
	end;

    const string ret = ""; ret = SB_ToString();
	return ret;
};

func int Ninja_TwitchIntegration_ReadOpt() {
};

const int Ninja_TwitchIntegration_InitComplete = 0;

func string Ninja_TwitchIntegration_Start() {
	const int lpstrRet = 0; lpstrRet = 0;
	
	const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PutRetValTo(_@(lpstrRet));
        CALL__cdecl(TwitchIntegration_PROC_cInitIntegration);
	
        call = CALL_End();
    };
    
    return TwitchIntegration_ReadString(lpstrRet);
};


func string Ninja_TwitchIntegration_CurrentEvent() {
	const int lpstrRet = 0; lpstrRet = 0;
	
    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PutRetValTo(_@(lpstrRet));
        CALL__cdecl(TwitchIntegration_PROC_cHandleEvents);
	
        call = CALL_End();
    };
    
    return TwitchIntegration_ReadString(lpstrRet);
};

func void Ninja_TwitchIntegration_Dummy() {
	_TwitchIntegration_Print("Twitch Integration");
};

func void Ninja_TwitchIntegration_HandleREWARD_ADD(var string user, var string fn) {
	const int fnIdx = -1;
	fnIdx = MEM_FindParserSymbol(fn);
	if (fnIdx != -1) {
		_TwitchIntegration_PrintC(ConcatStrings(user, ConcatStrings(" hat ", ConcatStrings(fn, " ausgeführt"))), COL_Lime);
		MEM_CallByID(fnIdx);
	} else {
		MEM_Info(ConcatStrings("Could not find function: ", fn));
	};
};

func void Ninja_TwitchIntegration_HandleFOLLOW(var string user, var string fn) {
	const int fnIdx = -1;
	fnIdx = MEM_FindParserSymbol(fn);
	if (fnIdx != -1) {
		_TwitchIntegration_PrintC(ConcatStrings(user, ConcatStrings(" hat ", ConcatStrings(fn, " ausgeführt"))), COL_Lime);
		MEM_CallByID(fnIdx);
	} else {
		MEM_Info(ConcatStrings("Could not find function: ", fn));
	};
};
func void Ninja_TwitchIntegration_HandleCHAT(var string user, var string fn) {
	const int fnIdx = -1;
	fnIdx = MEM_FindParserSymbol(fn);
	if (fnIdx != -1) {
		_TwitchIntegration_PrintC(ConcatStrings(user, ConcatStrings(" hat ", ConcatStrings(fn, " ausgeführt"))), COL_Lime);
		MEM_CallByID(fnIdx);
	} else {
		MEM_Info(ConcatStrings("Could not find function: ", fn));
	};
};

func int Ninja_TWI_STR_IndexOf(var string str, var string tok, var int offset) {
    var zString zStr; zStr = _^(_@s(str));
    var zString zTok; zTok = _^(_@s(tok));
    
    if(zTok.len == 0) {
        return 0;
    };
    if (zStr.len == 0) {
        return -1;
    };
    
    var int startPos; startPos = zStr.ptr;
	var int startOff; startOff = 0;
    var int startMax; startMax = zStr.ptr + zStr.len - zTok.len;
    
    var int loopPos; loopPos = MEM_StackPos.position;
    if (startPos <= startMax) {
        if (MEM_CompareBytes(startPos, zTok.ptr, zTok.len)) {
			if (startOff == offset) {
            	return startPos - zStr.ptr;
			};
			startOff += 1;
        };
        startPos += 1;
        MEM_StackPos.position = loopPos;
    };
    return -1;
};

func void Ninja_TwitchIntegration_FFHandle() {
	if (!Ninja_TwitchIntegration_InitComplete) { return; };
	if (!MEM_Game.timeStep)    { return; };
	if (!Hlp_IsValidNpc(hero)) { return; };

	const string event = ""; event = Ninja_TwitchIntegration_CurrentEvent();
	// MEM_Info(ConcatStrings("Twitch Integration: Current event: ", event));

	const string arg0 = "";
	const string arg1 = "";
	const string arg2 = "";

	if (STR_SplitCount(event, " ") <3) {
		return;
	};
	arg0 = STR_Split(event, " ", 0); // type
	arg1 = STR_Split(event, " ", 1); // user
	arg2 = STR_Split(event, " ", 2); // function

	TwitchIntegration_User = arg1;
	TwitchIntegration_Command = arg2;
	
	var int idxRest; idxRest = Ninja_TWI_STR_IndexOf(event, " ", 2);
	if (idxRest != -1) {
		TwitchIntegration_Arguments	= STR_SubStr(event, idxRest+1, STR_Len(event) - idxRest - 1);
	} else {
		TwitchIntegration_Arguments	= "";
	};
	MEM_Info(ConcatStrings("TwitchIntegration_User: ", TwitchIntegration_User));
	MEM_Info(ConcatStrings("TwitchIntegration_Command: ", TwitchIntegration_Command));
	MEM_Info(ConcatStrings("TwitchIntegration_Arguments: ", TwitchIntegration_Arguments));

	if STR_StartsWith(arg0, "REWARD_ADD") {
		MEM_Info(ConcatStrings("Event: ", event));
		Ninja_TwitchIntegration_HandleREWARD_ADD(arg1, arg2);
	} else if STR_StartsWith(arg0, "FOLLOW") {
		MEM_Info(ConcatStrings("Event: ", event));
		Ninja_TwitchIntegration_HandleFOLLOW(arg1, arg2);
	} else if STR_StartsWith(arg0, "CHAT") {
		MEM_Info(ConcatStrings("Event: ", event));
		Ninja_TwitchIntegration_HandleCHAT(arg1, arg2);
	} else {
		// _TwitchIntegration_Print(event);
	};
};

func void Ninja_TwitchIntegration_FFTimer() {
	_TwitchIntegration_Print_Timer += MEM_Timer.frameTime;
	// Reset the Print-Counter if not printed for X milliseconds
	if (_TwitchIntegration_Print_Timer > _TwitchIntegration_Print_Duration) {
		_TwitchIntegration_Print_Count_Limit_Current = 0;
		_TwitchIntegration_Print_Count = 0;
		_TwitchIntegration_Print_Timer = 0;
	};
};


/// Init-function called by Ninja
func void Ninja_TwitchIntegration_Init() {
	// Initialize Ikarus
	MEM_InitAll();
	// Initialize LeGo
	// Lego_MergeFlags(LeGo_FrameFunctions);
	FF_ApplyOnceExtGT(Ninja_TwitchIntegration_FFHandle, 500, -1);
};

func void Ninja_TwitchIntegration_Menu(var int menuPtr) {
	// Initialize Ikarus
	MEM_InitAll();

	const int once = 0;
	if (!once) {
		TwitchIntegration_Init();
		Ninja_TwitchIntegration_ReadOpt();
		const string errText = ""; errText = Ninja_TwitchIntegration_Start();
		if (!Hlp_StrCmp(errText, "")) {
			MEM_Warn("Could not initialize Twitch Integration");
			MEM_Warn(errText);
			once = 1;
			return;
		};
		Ninja_TwitchIntegration_InitComplete = 1;
		once = 1;
	};

	// TODO: HOOK beim Beenden des Spiels: Twitch-Integration deaktivieren
};
