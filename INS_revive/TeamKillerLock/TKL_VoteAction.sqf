
_Killer = _This Select 0;
_Punishment = _This Select 1;
_LinkedToPlayer = _This Select 2;
Punish_YES = False;
_n = 15;

If (_LinkedToPlayer) Then
	{
	WaitUntil {Alive(Player);};
	Sleep 1;
	_Act = (Vehicle Player) AddAction ['<t color="#00FF00">' + Format ["FORGIVE KILLER: %1",Name _Killer] + '</t>', "INS_revive\TeamKillerLock\TKL_VoteAction_Punish.sqf",[],25,false];
	While {!Punish_YES And (_n > 0)} Do	{
		TitleText [Format["\n\nFORGIVE KILLER '%2'?\n(If you want to forgive teamkiller, then press 'Y' key.)\n%1", _n, Name _Killer],"PLAIN"];
		
		Sleep 1;
		_n = _n - 1;
	};
	
	if (!Punish_YES And (_n > 0)) then {
		TitleText [format["'%1' have been forgived.",Name _Killer],"Plain"];
	} else {
		TitleText ["","Plain"];
	};
	(Vehicle Player) RemoveAction _Act;
	};

If (!Punish_YES) Then {((GetPlayerUID _Killer)+"_Side") SetMarkerPos [(GetMarkerPos ((GetPlayerUID _Killer)+"_Side") Select 0)+_Punishment,0];};


