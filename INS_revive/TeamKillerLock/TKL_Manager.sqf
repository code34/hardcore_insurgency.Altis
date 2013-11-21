
// Add to the black list the gameID from TK: ["GameID_1","GameID_2",...]
_Black_List = [];

// TEAM KILLER LOCK LIMIT -> null = [TKL_Limit] ExecVM "INS_revive\TeamKillerLock\TKL_Manager.sqf";
TKL_Limit = _This Select 0;

_TKL_Remover_Delay = _This Select 1;

_TKL_Remover_Timer = Time + _TKL_Remover_Delay;

FN_GET_TKL_UnitSide = Compile preprocessFile "INS_revive\TeamKillerLock\FN_GET_TKL_UnitSide.sqf";
TKL_Punishment = Compile preprocessFile "INS_revive\TeamKillerLock\TKL_Punishment.sqf";

If (IsServer) Then
	{
	null = createMarker ["TKL_Log", [0,0]];
	"TKL_Log" setMarkerType "empty";
	}
	Else
	{
	WaitUntil {Player == Player};
	};

Sleep 1;

((GetPlayerUID Player)+"_Side") SetMarkerPos [(GetMarkerPos ((GetPlayerUID Player)+"_Side") Select 0)+1,0];

Sleep 1;

If ((MarkerPos ((GetPlayerUID Player)+"_Side") Select 0) == 0) Then
	{
	null = createMarker [(GetPlayerUID Player)+"_Side", [0,0]];
	(GetPlayerUID Player)+"_Side" setMarkerType "empty";
	Player CommandChat "TEAM KILLER LOCK SYSTEM: CREATING A NEW RECORD.";
	}
	Else
	{
	((GetPlayerUID Player)+"_Side") SetMarkerPos [(GetMarkerPos ((GetPlayerUID Player)+"_Side") Select 0)-1,0];
	Player CommandChat "TEAM KILLER LOCK SYSTEM: RECORD ALREADY EXIST.";
	};

If ((GetPlayerUID Player) In _Black_List) Then {(GetPlayerUID Player)+"_Side" setMarkerText "BANNED";};

Sleep 1;

If (MarkerText ((GetPlayerUID Player)+"_Side") != "BANNED") Then
	{
	Player CommandChat "TKL list updated every 5min (CTRL+V to paste)";
	(GetPlayerUID Player)+"_Side" setMarkerText ([Player] Call FN_GET_TKL_UnitSide);
	Player CommandChat Format ["TEAM KILLER LOCK SYSTEM: %1/%2",(GetMarkerPos ((GetPlayerUID Player)+"_Side") Select 0),TKL_Limit];
	_n = (GetMarkerPos ((GetPlayerUID Player)+"_Side") Select 0);
	_TKL_Log_Timer = Time;
	While {(GetMarkerPos ((GetPlayerUID Player)+"_Side") Select 0) < TKL_Limit} Do
		{
		If ((GetMarkerPos ((GetPlayerUID Player)+"_Side") Select 0) > _n) Then {_n = (GetMarkerPos ((GetPlayerUID Player)+"_Side") Select 0); null = [] Spawn TKL_Punishment;};
		Sleep 1;
		// TK list will be copied every 5min
		If (Time > _TKL_Log_Timer) Then {_TKL_Log_Timer = _TKL_Log_Timer + 300; CopyToClipboard ("TKL_Log: "+MarkerText "TKL_Log");};
		If (Time > _TKL_Remover_Timer) Then
			{
			_TKL_Remover_Timer = _TKL_Remover_Timer + _TKL_Remover_Delay;
			If ((GetMarkerPos ((GetPlayerUID Player)+"_Side") Select 0) > 0) Then {((GetPlayerUID Player)+"_Side") SetMarkerPos [(GetMarkerPos ((GetPlayerUID Player)+"_Side") Select 0)-1,0]; _n = _n - 1;};
			};
		};
	"TKL_Log" setMarkerText (MarkerText "TKL_Log")+Name Player+"="+(GetPlayerUID Player)+",";
	(GetPlayerUID Player)+"_Side" setMarkerText "BANNED";
	}
	Else
	{
	Player CommandChat "TEAM KILLER LOCK SYSTEM: BANNED!";
	};

While {True} Do
	{
	DisableUserInput True;
	TitleText ["NO TEAM KILLERS!\nYOUR GAME IS LOCKED!\n(YOU CAN NOT JOIN UNTIL SERVER RESTARTS)\n[ALT]+[F4] => EXIT","BLACK FADED"];
	Sleep 1;
	};
