/*
 * Author:      Sinky
 * Date:        2nd February 2011
 * Last Edited: 2nd February 2011
 * Version:     1.0
 */
private ["_unit","_corpse"];

waitUntil {alive player};

hint "Respawned";

_unit = _this select 0;
//_corpse = _this select 1;
sleep 0.1;

//if (isPlayer _unit) then {
	//sleep 0.1;
	//_corpse removeAction GVAR_settings_action;
	
	sleep 0.1;
	GVAR_settings_action = player addAction [
		("<t color='#fffe80'>" + "Settings" + "</t>"), 
		"INS_revive\mission_settings\create.sqf", [], 0, false
	];

//};