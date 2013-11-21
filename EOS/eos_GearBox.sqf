	// -----------------------------------------------
	// Author : ?
	// fix code34 nicolas_boiteux@yahoo.fr
	// -----------------------------------------------
	//if (!isServer) exitwith {};
	
	_eosMarkerArray=(_this select 0);
	_eosTypeArray=(_this select 1);
	_eosFactionsArray=(_this select 2);
	_dynamicBattlefield=if (count _this > 3) then {_this select 3} else {false};
	
	{
		EOSmarkers = EOSmarkers + [_x];
		[_x,_eosTypeArray,_eosFactionsArray,_dynamicBattlefield] execVM "eos\eos_Init.sqf";
	}foreach _eosMarkerArray;
