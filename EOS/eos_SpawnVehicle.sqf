	// -----------------------------------------------
	// Author : ?
	// fix code34 nicolas_boiteux@yahoo.fr
	// -----------------------------------------------
	//if (!isServer) exitwith {};

	private [
			"_currentEOSVeh",
			"_armorPool",
			"_motorPool",
			"_shipPool",
			"_vehicle",
			"_group",
			"_spawnLight",
			"_diverPool",
			"_InfantryPool",
			"_enemyFactionVehicle",
			"_currentEOStype",
			"_eosMarkerSizeB",
			"_markerpos",
			"_spwnposNew",
			"_loop",
			"_active",
			"_spotFriendlies",
			"_marker",
			"_markersize",
			"_enemyFactionType",
			"_enemyFaction",
			"_handle",
			"_restart"
		];

	_marker			= (_this select 0);
	_markerpos 		= getmarkerpos _marker;
	_markersize		= (getMarkerSize _marker) select 1;
	_enemyFactionType	= (_this select 1);
	_spotFriendlies		= (_this select 2);
	_spawnLight		= (_this select 3);

	_eosMarkerSizeB		= (getMarkerSize _marker) select 1;

	switch (_enemyFactionType) do{
		case 0:{
			_shipPool = ["O_Boat_Transport_01_F","O_Boat_Armed_01_hmg_F"];
			_motorPool = ["O_MRAP_02_F","O_MRAP_02_hmg_F","O_MRAP_02_gmg_F", "I_MRAP_03_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F"]; 
			_armorPool = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_MBT_02_arty_F","O_APC_Wheeled_02_rcws_F","I_APC_Wheeled_03_cannon_F"];
			_enemyFactionVehicle = East;
		};
		case 1:{
			_shipPool = ["B_Boat_Transport_01_F","B_Boat_Armed_01_minigun_F"];
			_motorPool = ["B_MRAP_01_F","B_MRAP_01_hmg_F","B_MRAP_01_gmg_F","B_Truck_01_covered_F"]; 
			_armorPool = ["B_APC_Wheeled_01_cannon_F","B_APC_Tracked_01_base_F","B_APC_Tracked_01_rcws_F"];
			_enemyFactionVehicle = West;
		};
		case 2:{
			_shipPool = ["I_Boat_Transport_01_F","I_Boat_Armed_01_minigun_F"];
			_motorPool = ["I_MRAP_03_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F","I_Truck_02_covered_F"]; 
			_armorPool = ["I_MRAP_03_hmg_F"];
			_enemyFactionVehicle =INDEPENDENT;
		};
	};

	_spwnposNew = [_markerpos, random (_eosMarkerSizeB -15), random 359] call BIS_fnc_relPos;

	if (surfaceIsWater _markerpos) then {
		_currentEOSVeh = _shipPool select (floor(random(count _shipPool)));
	}else{
		_spwnposNew=[_spwnposNew,0,50,10,0,2000,0] call BIS_fnc_findSafePos;
		if (_spawnLight) then {
			_currentEOSVeh = _motorPool select (floor(random(count _motorPool)));
		}else{
			_currentEOSVeh = _armorPool select (floor(random(count _armorPool)));
		};
	};

	_sideEOSVeh = [_spwnposNew, random 359, _currentEOSVeh,_enemyFactionVehicle] call bis_fnc_spawnvehicle;
	_vehicle = _sideEOSVeh select 0;
	_group = _sideEOSVeh select 2;

	_handle = [(leader _group),_marker,"showmarker"] execVM "scripts\ups.sqf";
	_vehicle setVehicleLock "LOCKED";

	{
		wcgarbage = [_x, ""] spawn WC_fnc_skill;
	}foreach (units _group);

	_loop=true;
	while {_loop} do {
		sleep 5;
		_active = _spotFriendlies getvariable "Active";
		_restart =_spotFriendlies getvariable "restart";
		if ((_restart) and (!_active)) then {
			{
				deleteVehicle _x; 
				sleep 0.1;
			} forEach (units _group); 
			deleteGroup _group;
			deletevehicle _vehicle;
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