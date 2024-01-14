const int TwitchIntegration_PROC_cInitIntegration     = 0;
const int TwitchIntegration_PROC_cShutdownIntegration = 0;
const int TwitchIntegration_PROC_cHandleEvents        = 0;

const string TwitchIntegration_User = "";
const string TwitchIntegration_Command   = "";
const string TwitchIntegration_Arguments = "";
const int TwitchIntegration_Sound_Enabled = 1;
const int TwitchIntegration_Print_Redemptions = 1;

const int Ninja_TwitchIntegration_MAX_DEFERRED = 40;
const string Ninja_TwitchIntegration_Deferred[Ninja_TwitchIntegration_MAX_DEFERRED] = {
	"", "", "", "", "", "", "", "", "", "",
	"", "", "", "", "", "", "", "", "", "",
	"", "", "", "", "", "", "", "", "", "",
	"", "", "", "", "", "", "", "", "", ""
};

const int Ninja_TwitchIntegration_Num_Deferred = 0;

func int Ninja_TwitchIntegration_DeferEvent(var string event) {
	const string numItemsQueued = "";

	if (Ninja_TwitchIntegration_Num_Deferred >= Ninja_TwitchIntegration_MAX_DEFERRED) {
		numItemsQueued = IntToString(+Ninja_TwitchIntegration_Num_Deferred);
		MEM_Info(ConcatStrings("TwitchIntegration: Number of Queued events: ", numItemsQueued));
		return 0;
	};
	MEM_WriteStatStringArr(Ninja_TwitchIntegration_Deferred, Ninja_TwitchIntegration_Num_Deferred, event);
	Ninja_TwitchIntegration_Num_Deferred += 1;

	numItemsQueued = IntToString(+Ninja_TwitchIntegration_Num_Deferred);
	MEM_Info(ConcatStrings("TwitchIntegration: Number of Queued events: ", numItemsQueued));
	return 1;
};

func int Ninja_TwitchIntegration_TryPopDeferredEvent(var int stringPtr) {
	if (Ninja_TwitchIntegration_Num_Deferred <= 0) {
		return 0;
	};

	var string str;
	str = MEM_ReadStatStringArr(Ninja_TwitchIntegration_Deferred, Ninja_TwitchIntegration_Num_Deferred - 1);

	MEM_WriteString(stringPtr, str);
	Ninja_TwitchIntegration_Num_Deferred -= 1;
	MEM_WriteStatStringArr(Ninja_TwitchIntegration_Deferred, Ninja_TwitchIntegration_Num_Deferred, "");

	return 1;
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

func string Ninja_TwitchIntegration_ReadOptDefault(var string opt, var string defVal) {
	const string optCategory = "TwitchIntegration";
	var string opt;
	if (!MEM_GothOptExists(optCategory, opt)) {
		MEM_SetGothOpt(optCategory, opt, defVal);
		opt = defVal;
	} else {
		opt = MEM_GetGothOpt(optCategory, opt);
	};
	return opt;
};

func void Ninja_TwitchIntegration_ReadOpt() {
	var string opt;
	opt = Ninja_TwitchIntegration_ReadOptDefault("Sound_Enabled", IntToString(TwitchIntegration_Sound_Enabled));
	TwitchIntegration_Sound_Enabled = Hlp_StrCmp(opt, "1");

	opt = Ninja_TwitchIntegration_ReadOptDefault("Print_Redemptions", IntToString(TwitchIntegration_Print_Redemptions));
	TwitchIntegration_Print_Redemptions = Hlp_StrCmp(opt, "1");
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

func int _Ninja_TwitchIntegration_CallFnRetInt(var int fnIdx) {
	var zCPar_Symbol fncSymb; fncSymb = _^(MEM_GetSymbolByIndex(fnIdx));

	if (fncSymb.offset) && (MEM_Parser.datastack_sptr > 0) {
		if (fncSymb.offset == (zPAR_TYPE_INT >> 12)) {
			// Safety checks on stack integrity
			if (MEM_Parser.datastack_sptr >= 2) {
				var int sPtr; sPtr = MEM_Parser.datastack_sptr; // Stack pointer is constantly changing so copy it
				var int tok; tok = contentParserAddress + zCParser_datastack_stack_offset + (sPtr-1)*4;
				if (MEM_ReadInt(tok) == zPAR_TOK_PUSHINT) || (MEM_ReadInt(tok) == zPAR_TOK_PUSHVAR) {
					// There is indeed a valid return value
					return +MEM_PopIntResult();
				};
			};
		};
	};
	MEM_Info("TwitchIntegration: Function has no 'int' return value");
	return 1;
};

func int _Ninja_TwitchIntegration_CallFn(var string user, var string fn) {
	const int fnIdx = -1;
	fnIdx = MEM_FindParserSymbol(fn);
	const int fnWasExecuted = 0; fnWasExecuted = 0;
	if (fnIdx != -1) {
		MEM_CallByID(fnIdx);
		fnWasExecuted = +_Ninja_TwitchIntegration_CallFnRetInt(fnIdx);
	} else {
		MEM_Info(ConcatStrings("Could not find function: ", fn));
	};

	if (fnWasExecuted) {
		if (TwitchIntegration_Print_Redemptions) {
			_TwitchIntegration_PrintC(ConcatStrings(user, ConcatStrings(" hat ", ConcatStrings(fn, " ausgeführt"))), COL_Lime);
		};
	};

	return +fnWasExecuted;
};

func int Ninja_TwitchIntegration_HandleREWARD_ADD(var string user, var string fn) {
	return +_Ninja_TwitchIntegration_CallFn(user, fn);
};

func int Ninja_TwitchIntegration_HandleBITS_USED(var string user, var string fn) {
	return +_Ninja_TwitchIntegration_CallFn(user, fn);
};

func int Ninja_TwitchIntegration_HandleFOLLOW(var string user, var string fn) {
	return +_Ninja_TwitchIntegration_CallFn(user, fn);
};

func int Ninja_TwitchIntegration_HandleCHAT(var string user, var string fn) {
	return +_Ninja_TwitchIntegration_CallFn(user, fn);
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
	if (Npc_IsDead(hero)) { return; };

	const string event = "";
	event = Ninja_TwitchIntegration_CurrentEvent();
	MEM_Info(ConcatStrings("Twitch Integration: Current event: ", event));

	const string arg0 = "";
	const string arg1 = "";
	const string arg2 = "";

	if (STR_SplitCount(event, " ") <3) {
		if (Ninja_TwitchIntegration_TryPopDeferredEvent(_@s(event))) {
			MEM_Info(ConcatStrings("TwitchIntegration popped deferred event: ", event));
		} else {
			return;
		};
	};

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

	const int handled = 1; handled = 1;

	if STR_StartsWith(arg0, "REWARD_ADD") {
		MEM_Info(ConcatStrings("Event: ", event));
		handled = Ninja_TwitchIntegration_HandleREWARD_ADD(arg1, arg2);
	} else if STR_StartsWith(arg0, "FOLLOW") {
		MEM_Info(ConcatStrings("Event: ", event));
		handled = Ninja_TwitchIntegration_HandleFOLLOW(arg1, arg2);
	} else if STR_StartsWith(arg0, "CHAT") {
		MEM_Info(ConcatStrings("Event: ", event));
		handled = Ninja_TwitchIntegration_HandleCHAT(arg1, arg2);
	} else if STR_StartsWith(arg0, "BITS_USED") {
		MEM_Info(ConcatStrings("Event: ", event));
		handled = Ninja_TwitchIntegration_HandleBITS_USED(arg1, arg2);
	} else {
		// _TwitchIntegration_Print(event);
	};
	if (!handled) {
		if (!Ninja_TwitchIntegration_DeferEvent(event)){

		};
	};
};


/// Init-function called by Ninja
func void Ninja_TwitchIntegration_Init() {
	// Initialize Ikarus
	MEM_InitAll();
	// Initialize LeGo
	Lego_MergeFlags(LeGo_FrameFunctions | LeGo_PrintS);
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
