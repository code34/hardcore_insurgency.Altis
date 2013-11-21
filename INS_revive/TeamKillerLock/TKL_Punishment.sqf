
_TeamKill_n = (GetMarkerPos ((GetPlayerUID Player)+"_Side") Select 0);
_WaitingTime = 301;

If (_TeamKill_n == 1) Then {_WaitingTime = 11;};
If (_TeamKill_n == 2) Then {_WaitingTime = 91;};

_h = 0;
_min = 0;
_s = 0;
_min_Text = "";
_s_Text = "";

If ((Vehicle Player) == Player) Then {}	Else
	{
	If (Player != Driver (Vehicle Player)) Then {DisableUserInput True;};
	};

While {Floor _WaitingTime > 0} Do
	{
	If (Alive(Player)) Then {Player EnableSimulation False;} Else {Player EnableSimulation True;};
	_WaitingTime = _WaitingTime - 1;
	_h = Floor (_WaitingTime/3600);
	_min = Floor((_WaitingTime/3600 - Floor (_WaitingTime/3600))*60);
	_s = Floor((((_WaitingTime/3600 - Floor (_WaitingTime/3600))*60) - Floor((_WaitingTime/3600 - Floor (_WaitingTime/3600))*60))*60);

	If (_min < 10) Then {_min_Text = "0"+Str(_min);} Else {_min_Text = Str(_min);};
	If (_s < 10) Then {_s_Text = "0"+Str(_s);} Else {_s_Text = Str(_s);};

	TitleText [Format ["YOU KILLED A COLLEAGUE: %1/%2\n[LOCKED: %3]\n\n[ALT]+[F4] => EXIT",GetMarkerPos ((GetPlayerUID Player)+"_Side") Select 0,TKL_Limit,_min_Text + ":" + _s_Text],"BLACK FADED"];
	Sleep 1;
	};
HintSilent "";
Player EnableSimulation True;
Player PlayMove "AmovPercMstpSlowWrflDnon_Salute";
DisableUserInput False;
TitleText ["","BLACK IN"];
