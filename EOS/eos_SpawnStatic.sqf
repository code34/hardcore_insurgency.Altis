	// -----------------------------------------------
	// Author : ?
	// fix code34 nicolas_boiteux@yahoo.fr
	// -----------------------------------------------
	//if (!isServer) exitwith {};

	private [
			"_staticPool",
			"_currentEOSVeh",
			"_vehicle",
			"_group",
			"_enemyFactionVehicle",
			"_eosGroupSize",
			"_eosMarkerSizeB",
			"_currentPOS",
			"_spwnposNew",
			"_loop",
			"_active",
			"_spotFriendlies",
			"_currentMKR",
			"_enemyFactionType",
			"_enemyFaction",
			"_restart"
		];

	_currentMKR		= (_this select 0);
	_currentPOS		= markerpos _currentMKR;
	_eosMarkerSizeB		= (getMarkerSize _currentmkr) select 1;
	_enemyFactionType	= (_this select 1);
	_spotFriendlies		= (_this select 2);

	switch (_enemyFactionType) do{
		case 0:{
			_staticPool=["O_GMG_01_F","O_GMG_01_high_F","O_HMG_01_high_F", "O_HMG_01_F", "O_Mortar_01_F", "O_static_AA_F", "O_static_AT_F"];
			_enemyFactionVehicle = East;
		};

		case 1:{
			_staticPool =["B_Mortar_01_F"];
			_enemyFactionVehicle = West;
		};

		case 2:{
			_staticPool =["I_Mortar_01_F"];
			_enemyFactionVehicle =INDEPENDENT;
		};
	};

	_spwnposNew = [_currentPOS, random (_eosMarkerSizeB -15), random 359] call BIS_fnc_relPos;
	_spwnposNew = [_spwnposNew,0,50,10,0,2000,0] call BIS_fnc_findSafePos;

	_currentEOSVeh = _staticPool select (floor(random(count _staticPool)));	
	_sideEOSVeh = [_spwnposNew, random 359, _currentEOSVeh,_enemyFactionVehicle] call bis_fnc_spawnvehicle;
	_vehicle = _sideEOSVeh select 0;
	_group = _sideEOSVeh select 2;

	[_group,_currentPOS] call bis_fnc_taskDefend;
	
	_loop=true;
	while {_loop} do {
		sleep 1;
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
		};
		if((!_restart) and (!_active)) then {
			_loop=false;
		};
	};

	_callNumber=_spotFriendlies getvariable "totalCalls";
	_callNumber=_callNumber + 1;
	_spotFriendlies setvariable ["totalCalls",_callNumber];