const int _TwitchIntegration_Print_Count_Limit_Current = 0;
const int _TwitchIntegration_Print_Duration = 8000;
const int _TwitchIntegration_Print_Y = 1500;
const int _TwitchIntegration_Print_X = 5500;
const int _TwitchIntegration_Print_TextHeight = 150;
const int _TwitchIntegration_Print_Count_Max = 30;
const int _TwitchIntegration_Print_Count = 0;
const int _TwitchIntegration_Print_Timer = 0;

const string TwitchIntegration_Print_Font = "FONT_OLD_10_WHITE.TGA";

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
func void Ninja_TwitchIntegration_FFTimer() {
	_TwitchIntegration_Print_Timer += MEM_Timer.frameTime;
	// Reset the Print-Counter if not printed for X milliseconds
	if (_TwitchIntegration_Print_Timer > _TwitchIntegration_Print_Duration) {
		_TwitchIntegration_Print_Count_Limit_Current = 0;
		_TwitchIntegration_Print_Count = 0;
		_TwitchIntegration_Print_Timer = 0;
	};
};