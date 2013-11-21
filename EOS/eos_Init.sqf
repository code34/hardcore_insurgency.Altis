	// -----------------------------------------------
	// Author : ?
	// fix code34 nicolas_boiteux@yahoo.fr
	// -----------------------------------------------
	//if (!isServer) exitwith {};

	private [
		"_eosCleared",
		"_airCraftSpawned",
		"_air",
		"_zoneRestart",
		"_callNumber",
		"_totalCalls",
		"_chance",
		"_dynamicBattlefield",
		"_statics",
		"_staticSpawned",
		"_APCs",
		"_APCSpawned",
		"_vehicles",
		"_lightVehSpawned",
		"_groups",
		"_groupsSpawned",
		"_houseGroupsspawned",
		"_houses",
		"_eosFactionsArray",
		"_eosTypeArray",
		"_spawnStatic",
		"_spawnAPC",
		"_spawnVehicle",
		"_zoneCleared",
		"_spotTaken",
		"_FactionVEHICLE",
		"_eosGroupSize",
		"_spawnPatrol",
		"_eosActive",
		"_debugHint",
		"_enemyFactionType",
		"_spawnHouse",
		"_mkrAlpha",
		"_currentMKR",
		"_currentPOS",
		"_eosMarkerSizeA",
		"_eosMarkerSizeB",
		"_enemyFaction",
		"_friendlySide",
		"_hideMarkers",
		"_SafeZone",
		"_spotEnemies",
		"_spotFriendlies",
		"_mkrAlphaHighlight",
		"_handle", 
		"_count", 
		"_countvehicle", 
		"_array", 
		"_eastc", 
		"_westc"
	];
	
	_currentMKR 		= (_this select 0);
	_currentPOS		= markerpos (_this select 0);
	_eosMarkerSizeA		= (getMarkerSize _currentmkr) select 0;
	_eosMarkerSizeB		= (getMarkerSize _currentmkr) select 1;
	
	_eosTypeArray		= (_this select 1);
	_houses			= _eosTypeArray select 0;
	_groups 		= _eosTypeArray select 1;
	_vehicles		= _eosTypeArray select 2;
	_APCs			= _eosTypeArray select 3;
	_statics		= _eosTypeArray select 4;
	_air			= _eosTypeArray select 5;
	
	_eosFactionsArray	= (_this select 2);
	_enemyFactionType	= _eosFactionsArray select 0;
	_SafeZone		= _eosFactionsArray select 1;
	_hideMarkers		= _eosFactionsArray select 2;
	
	_debugHint		= false;
	_dynamicBattlefield 	= if (count _this > 3) then {_this select 3} else {false};

	switch (_enemyFactionType) do{
		case 0:{
			_enemyFaction="east";
		};
		case 1:{
			_enemyFaction="west";
		};
		case 2:{
			_enemyFaction="GUER";
		};
		case 3:{
			_enemyFaction="civ";
		};
	};

	switch (_hideMarkers) do {
		case 0:{
			_mkrAlphaHighlight = 1;
			_mkrAlpha = 0.5;
		};
		case 1:{
			_mkrAlphaHighlight = 0;
			_mkrAlpha = 0;
		};
		case 2:{
			_mkrAlphaHighlight = 0.5;
			_mkrAlpha = 0.5;
		};
	};

	_currentMKR setmarkercolor "ColorRed";
	_currentMKR setmarkerAlpha 1;

	_count = 0;
	while { _count == 0 } do {
		sleep 10 + (random 5);
		if(wclockcount < wcmaxzone) then {
			{
				if((isplayer _x) and (side _x == west)) then {
					if(position _x distance _currentPOS < (_SafeZone+ _eosMarkerSizeA)) then {
						if((getposatl _x) select 2 < 10) then {
							_count = 1;
						};
					};
				};		
				sleep 0.1;
			}foreach playableUnits;
		};
	};
	wclockcount = wclockcount + 1;

	// ZONE ACTIVE. CREAT SUB-TRIGGERS
	opformarkers = opformarkers - [_currentMKR];
	battlemarkers = battlemarkers + [_currentMKR];
	_currentMKR setmarkercolor "ColorOrange";
	_currentMKR setmarkerAlpha 1;

	_spotFriendlies = createTrigger ["EmptyDetector",_currentPOS]; 
	_spotFriendlies setTriggerArea [(_SafeZone+ _eosMarkerSizeA),(_SafeZone+ _eosMarkerSizeB),0,true]; 
	_spotFriendlies setTriggerActivation ["West","PRESENT",true]; 
	_spotFriendlies setTriggerStatements ["","",""];

	waitUntil {triggeractivated _spotFriendlies};

	// SET CACHE VARIABLES				
	_spotFriendlies setvariable ["totalCalls",0];
	_spotFriendlies setvariable ["Active",true];
	_spotFriendlies setvariable ["restart", false];

	// SPAWN EOS UNITS
	_totalCalls=0;

	_count = west countside playableUnits;
	switch(PARAM_Redlevel) do {
		case 1: {
			_groups = _groups;
		};
		case 2: {
			_groups = _groups + round(random(_count/20));
		};
		case 3: {
			_groups = _groups + round(random(_count/15));
		};
	};

	_houseGroupsspawned=0;
	while {_houses > _houseGroupsspawned} do {
		sleep 1;
		_houseGroupsspawned=_houseGroupsspawned + 1;
		_totalCalls = _totalCalls + 1;
		_handle = [_currentMKR,_enemyFactionType,_spotFriendlies,true] execVM "eos\eos_SpawnInfantry.sqf";
	};
					
	_groupsSpawned=0;		
	while {_groups > _groupsSpawned} do {
		sleep 1;
		_groupsSpawned=_groupsSpawned + 1;
		_totalCalls = _totalCalls + 1;
		_handle = [_currentMKR,_enemyFactionType,_spotFriendlies,false] execVM "eos\eos_SpawnInfantry.sqf";
	};
						
	_lightVehSpawned=0;
	while {_lightVehSpawned < _vehicles} do {
		sleep 1;
		_lightVehSpawned=_lightVehSpawned + 1;
		_totalCalls = _totalCalls + 1;
		_handle = [_currentMKR,_enemyFactionType,_spotFriendlies,true] execVM "eos\eos_SpawnVehicle.sqf";
	};
						
	_APCSpawned=0;
	while {_APCSpawned < _APCs} do {
		sleep 1;
		_APCSpawned=_APCSpawned + 1;
		_totalCalls = _totalCalls + 1;					
		_handle = [_currentMKR,_enemyFactionType,_spotFriendlies,false] execVM "eos\eos_SpawnVehicle.sqf";
	};
	
	_staticSpawned=0;
	while {_staticSpawned < _statics} do {
		sleep 1;
		_staticSpawned=_staticSpawned + 1;
		_totalCalls = _totalCalls + 1;
		_handle = [_currentMKR,_enemyFactionType,_spotFriendlies,true] execVM "eos\eos_SpawnStatic.sqf";
	};

	_airCraftSpawned=0;
	while {_airCraftSpawned < _air} do {
		sleep 1;
		_airCraftSpawned=_airCraftSpawned + 1;
		_handle = [_currentMKR,_enemyFactionType,_spotFriendlies,true] execVM "eos\eos_SpawnAir.sqf";
	};
								
	_eosActive=true;
	_eosCleared=false;
	while {_eosActive} do {
		sleep 6;
		_westc = 0;
		_eastc = 0;
		_inzone = false;
		_array = nearestObjects [_currentPOS, ["Man", "Landvehicle"], (_SafeZone+ _eosMarkerSizeA)];
		sleep 4;
		{
			{
				if(alive _x) then {
					if((side _x) in [west,civilian]) then {
						_westc = _westc + 1;
						if(_x distance _currentPOS < ((getmarkersize _currentMKR) select 0)) then {
							_inzone = true;
						};
					};
					if(side _x in [east, resistance]) then {
						if(_x distance _currentPOS < ((getmarkersize _currentMKR) select 0)) then {
							_eastc = _eastc + 1;
						};
					};
				};
				sleep 0.01;
			}foreach (crew (vehicle _x));
			sleep 0.01;
		}foreach _array;

		//if (!triggeractivated _spotFriendlies) then {
		if(_westc == 0) then {
			_spotFriendlies setvariable ["Active",false];
			_spotFriendlies setvariable ["restart", true];
			if (!_eosCleared) then {
				_zoneRestart=True;
			};
			_eosActive = false;
		};
	
		if((_eastc == 0) and (_westc > 0) and (_inzone)) then {
			_spotFriendlies setvariable ["Active",false];
			if (_dynamicBattlefield) then {
				_eosActive = false;
			};
			_eosCleared=true;
			_currentMKR setmarkercolor "colorBlue";
			_currentMKR setmarkerAlpha 1;
			_zoneRestart=false;		
		};

		if((_eastc > 0) and (_inzone)) then {
			_currentMKR setmarkercolor "colorYellow";
			_currentMKR setmarkerAlpha 1;
		};
	};	

	// WAIT UNTIL ALL UNITS CACHED
	while {true} do {
		sleep (random 10);
		_callNumber = _spotFriendlies getvariable "totalCalls";
		if (_callNumber == _totalCalls) exitwith {};
	};
		
	// CACHING COMPLETE
	deletevehicle _spotFriendlies;

	if (_zoneRestart) then {
		opformarkers = opformarkers + [_currentMKR];
		battlemarkers = battlemarkers - [_currentMKR];
		_currentMKR setmarkercolor "ColorRed";
		_handle =[_currentMKR,[_houses,_groups,_vehicles,_APCs,_statics,0],_eosFactionsArray,_dynamicBattlefield] execVM "eos\eos_Init.sqf";
		wclockcount = wclockcount - 1;
	} else {
		blueformarkers = blueformarkers + [_currentMKR];
		battlemarkers = battlemarkers - [_currentMKR];
		wclockcount = wclockcount - 1;
	};