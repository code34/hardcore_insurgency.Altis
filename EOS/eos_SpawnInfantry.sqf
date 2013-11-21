	// -----------------------------------------------
	// Author : ?
	// fix code34 nicolas_boiteux@yahoo.fr
	// -----------------------------------------------
	//if (!isServer) exitwith {};

	private [
			"_callNumber",
			"_spawnHouse",
			"_diverPool",
			"_InfantryPool",
			"_enemyFactionVehicle",
			"_debugHint",
			"_eosGroupSize",
			"_currentEOStype",
			"_typeGroup",
			"_enemyTeam",
			"_markersize",
			"_markerpos",
			"_group",
			"_spwnposNew",
			"_loop",
			"_active",
			"_spotFriendlies",
			"_marker",
			"_enemyFactionType",
			"_spawnType",
			"_enemyFaction",
			"_handle",
			"_restart"
		];

	_marker			= (_this select 0);
	_markerpos 		= getmarkerpos _marker;
	_markersize		= (getMarkerSize _marker) select 1;
	_enemyFactionType	= (_this select 1);
	_spotFriendlies		= (_this select 2);
	_spawnHouse		= (_this select 3);
	_debugHint		= false;

	switch (_enemyFactionType) do{
		case 0:{
			// EAST UNIT POOLS. REMOVE OR ADD SQUADS AS NEEDED
			_InfantryPool = ["OIA_InfSquad_Weapons","OIA_InfSquad", "OIA_InfTeam", "OIA_InfTeam_AA", "OIA_InfTeam_AT", "OI_SniperTeam", "OI_ReconTeam"];
			_diverPool = ["OI_diverTeam"];
			_enemyFaction = "East";
			_enemyFactionVehicle = East;
			_enemyTeam = "OPF_F";
		};
	
		case 1:{
			// WEST UNIT POOLS. REMOVE OR ADD SQUADS AS NEEDED
			_InfantryPool = ["BUS_InfSquad","BUS_InfSquad_Weapons"];
			_diverPool = ["BUS_DiverTeam"];
			_enemyFaction = "west";
			_enemyFactionVehicle = West;
			_enemyTeam = "BLU_F";
		};
	
		case 2:{
			// GUER UNIT POOLS. REMOVE OR ADD SQUADS AS NEEDED
			_InfantryPool = ["HAF_InfSquad_Weapons","HAF_InfSquad"];
			_diverPool = ["HAF_DiverTeam"];
			_enemyFaction = "Indep";
			_enemyFactionVehicle =INDEPENDENT;
			_enemyTeam = "IND_F";
		};
	};

	if (surfaceIsWater _markerpos) then {
		_currentEOStype = _diverPool select (floor(random(count _diverPool)));
		_typeGroup = "SpecOps";
	}else{
		_currentEOStype = _InfantryPool select (floor(random(count _InfantryPool)));
		_typeGroup = "infantry";
	};

	_spwnposNew = [_markerpos, random (_markersize -15), random 359] call BIS_fnc_relPos;
	_group = [_spwnposNew, _enemyFactionVehicle, (configfile >> "CfgGroups" >> _enemyFaction >> _enemyTeam >> _typeGroup >> _currentEOStype),[],[],[0.25,0.4],[],[EOSgroupSize,0]] call BIS_fnc_spawnGroup;

	{
		wcgarbage = [_x, _currentEOStype] spawn WC_fnc_skill;
	}foreach (units _group);

	_handle = [(leader _group),_marker,"showmarker"] execVM "scripts\ups.sqf";
				
	_loop=true;
	while {_loop} do {
		sleep 1;
		_active = _spotFriendlies getvariable "Active";
		_restart =_spotFriendlies getvariable "restart";
		if ((_restart) and (!_active)) then {
			{deleteVehicle _x; sleep 0.1;} forEach (units _group); 
			deleteGroup _group;
			_loop=false;
			terminate _handle;
		};
		if((!_restart) and (!_active)) then {
			_loop=false;
			terminate _handle;
		};
		//_markersize = (getMarkerSize _marker) select 1;
		//if((leader _group) distance _markerpos > (_markersize/2)) then {
		//	if((((leader _group) distance _markerpos) * 2) < 1000) then {
		//		_markersize = (((leader _group) distance _markerpos) * 2);
		//		_marker setmarkersize [_markersize, _markersize];
		//	};
		//};
	};

	_marker setmarkersize [50,50];
	_callNumber=_spotFriendlies getvariable "totalCalls";
	_callNumber=_callNumber + 1;
	_spotFriendlies setvariable ["totalCalls",_callNumber];