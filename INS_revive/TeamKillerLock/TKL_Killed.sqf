
_Unit = _This Select 0;
_Killer = _This Select 1;

_Killer_Vehicle = ((Position _Unit) NearObjects ["landvehicle",10]) Select 0;

// modified by naong
if (isNil "_Killer_Vehicle") then {_Killer_Vehicle = objNull};

_Killer_Crew = Crew _Killer;
_Killer_Crew = _Killer_Crew - [AssignedDriver _Killer];
_Killer_Crew = _Killer_Crew - [AssignedCargo _Killer];

_Punish = False;
_Punish_No = 1;

//SPECIAL CASES -> INCREASES PUNISHMENT
//If ((TypeOf _Unit) In ["Doctor","PowGen_Big"]) Then {_Punish_No = TKL_Limit;};

If (Vehicle _Unit == Vehicle _Killer) Then
	{
	If ((!IsNull _Killer_Vehicle) And (IsPlayer (Driver _Killer_Vehicle))) Then
		{
		If ([_Unit] Call FN_GET_TKL_UnitSide == [Driver _Killer_Vehicle] Call FN_GET_TKL_UnitSide) Then
			{
			If ((Round(Speed _Unit) != 0) And (Speed _Killer_Vehicle > 0)) Then
				{
				null = [Driver _Killer_Vehicle,_Punish_No,_Unit in (Units Group Player)] ExecVM "INS_revive\TeamKillerLock\TKL_VoteAction.sqf";
				};
			};
		};
	_MEM_Killer_Side = MarkerText ((GetPlayerUID Player)+"_Side");
	(GetPlayerUID Player)+"_Side" setMarkerText (Name Player);
	Sleep 2;
	(GetPlayerUID Player)+"_Side" setMarkerText _MEM_Killer_Side;
	}
	Else
	{
	If ([_Unit] Call FN_GET_TKL_UnitSide == markerText ((GetPlayerUID _Killer)+"_Side")) Then {_Punish = True;};
	Sleep 1;
	If (markerText ((GetPlayerUID Leader _Unit)+"_Side") == markerText ((GetPlayerUID _Killer)+"_Side")) Then {_Punish = True;};
	If ((_Punish) And (IsPlayer _Killer)) Then
		{
		While {Count _Killer_Crew > 0} Do
			{
			null = [_Killer_Crew Select 0,_Punish_No,_Unit in (Units Group Player)] ExecVM "INS_revive\TeamKillerLock\TKL_VoteAction.sqf";
			_Killer_Crew = _Killer_Crew - [_Killer_Crew Select 0];
			};
		};
	};
