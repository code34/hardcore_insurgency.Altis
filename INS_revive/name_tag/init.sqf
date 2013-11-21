private ["_player","_textColor","_nearUnits","_index","_displayDistance"];
disableSerialization;

// Wait until INS_revive function is initialized
waitUntil {!isNil "INS_REV_FNCT_init_completed"};

// Compile Functions
Call Compile PreprocessFileLineNumbers "INS_revive\name_tag\functions.sqf";

// Define variable
_textColor = [0.5 , 1, 0.5];
_displayDistance = 20;
if (isNil "INS_REV_CFG_respawn_type") then {INS_REV_CFG_respawn_type = "SIDE"};

// Start loop
while {INS_REV_CFG_name_tag} do {
	_player = player;
	_nearUnits = [_player, _displayDistance] call FNC_get_near_units;
	
	// If there's player
	if (count _nearUnits > 0) then {
		1 cutRsc ["namehud","PLAIN"];
		_index = 0;
		{
			[_player, _x, _index, _textColor, _displayDistance] call FNC_set_name_tag;
		} forEach _nearUnits;
	};
	sleep 0.05;
};