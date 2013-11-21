	// -----------------------------------------------
	// Author : ?
	// fix code34 nicolas_boiteux@yahoo.fr
	// -----------------------------------------------
	//if (!isServer) exitwith {};

	private ["_chopperSpawn","_getToMarker","_sideEOSVeh","_EOSvehGrp","_crew","_vehicle","_callNumber","_spawnChopper","_planePool","_chopperPool","_enemyFactionVehicle","_debugHint","_eosGroupSize","_currentEOStype","_typeGroup","_enemyTeam","_eosMarkerSizeB","_eosMarkerSizeB","_currentPOS""_sideEOSInf","_spwnposNew","_loop","_active","_spotFriendlies","_currentMKR","_enemyFactionType","_spawnType","_enemyFaction"];

	_currentMKR=(_this select 0);
	_currentPOS=markerpos _currentMKR;
	_eosMarkerSizeB=getMarkerSize _currentmkr select 1;
	_enemyFactionType=(_this select 1);
	_spotFriendlies=(_this select 2);
	_spawnChopper=(_this select 3);
	_debugHint=false;
	
	switch (_enemyFactionType) do{
		case 0:{
			// EAST UNIT POOLS. REMOVE OR ADD SQUADS AS NEEDED
			_chopperPool = ["O_Heli_Attack_02_black_F","O_Heli_Attack_02_F"];
			_planePool = ["OI_diverTeam"];
			_enemyFaction = "East";
			_enemyFactionVehicle = East;
			_enemyTeam = "OPF_F";
		};

		case 1:{
			// WEST UNIT POOLS. REMOVE OR ADD SQUADS AS NEEDED
			_chopperPool = ["B_Heli_Attack_01_F","B_Heli_Light_01_armed_F"];
			_planePool = ["BUS_DiverTeam"];
			_enemyFaction = "west";
			_enemyFactionVehicle = West;
			_enemyTeam = "BLU_F";					
			};

		case 2:{
			// GUER UNIT POOLS. REMOVE OR ADD SQUADS AS NEEDED
			_chopperPool = ["I_Heli_Transport_02_F"];
			_planePool = ["HAF_DiverTeam"];
			_enemyFaction = "Indep";
			_enemyFactionVehicle =INDEPENDENT;
			_enemyTeam = "IND_F";
		};
	};

	_spwnposNew=[[0,0,0],0,50,10,1,2000,0] call BIS_fnc_findSafePos;
	if (_spawnChopper) then {
		_currentEOStype = _chopperPool select (floor(random(count _chopperPool)));
		_sideEOSVeh = [_spwnposNew, random 359, _currentEOStype,_enemyFactionVehicle] call bis_fnc_spawnvehicle;
		_vehicle = _sideEOSVeh select 0;
		_crew = _sideEOSVeh select 1;
		_EOSvehGrp = _sideEOSVeh select 2;
					
		_getToMarker = _EOSvehGrp addWaypoint [_currentPOS, 0];
		_getToMarker setWaypointType "DESTROY";
		_getToMarker setWaypointSpeed "FULL";
		_getToMarker setWaypointBehaviour "AWARE";
		_loiter = _EOSvehGrp addWaypoint [_currentPOS, 1];
		_loiter setWaypointType "LOITER";
		_loiter setWaypointLoiterType "CIRCLE"
	};

	{
		wcgarbage = [_x, ""] spawn WC_fnc_skill;
	}foreach (units _EOSvehGrp);