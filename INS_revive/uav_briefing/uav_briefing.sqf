//** UAV Intro Briefing */
private ["_sitrep"];

[] Call Compile preprocessFileLineNumbers  "INS_revive\uav_briefing\functions.sqf";

// Loading Screen
//waituntil {!IsNull (findDisplay 46)};
/*
if (!isJIP) then {
	for "_i" from 1 to 99 do {
		titleText [format["MIssion is loading [ %1 %2 ]", _i, "%"],"BLACK FADED"];
		sleep 0.16;
	};
	titleText [format["MIssion is loading [ %1 %2 ]", 100, "%"],"PLAIN"];
};
*/

// Get Mission Description
_sitrep = getText (missionConfigFile >> "onLoadMission");
If (_sitrep == "") then { _sitrep = missionName; };

private ["_colorWest","_colorEast","_colorGuer","_colorCiv","_markerArray","_icon","_markerColor","_size","_unitName"];

// set side colors
_colorWest = WEST call BIS_fnc_sideColor;
_colorEast = EAST call BIS_fnc_sideColor;
_colorGuer = [0.22,0.69,0.06,1];
_colorCiv = [0.52,0.06,0.69,1];

// set transparency for colors
{_x set [3, 0.4]} forEach [_colorWest, _colorEast, _colorGuer, _colorCiv];

_markerArray = [
	//["a3\ui_f\data\map\groupIcons\selector_selectedFriendly_ca.paa", _colorWest, player, 2, 2, 0, "", 0]
	//["\a3\ui_f\data\map\markers\nato\b_inf.paa", _colorWest, player, 1, 1, 0, name player, 0]
];

{
	if (alive _x) then {
		if ([_x] call BRF_FNC_IS_DISPLAY_MARKER) then {
			_icon = [_x] call BRF_FNC_SET_UNIT_MARKER;
			
			switch (format["%1",side _x]) do {
				case "WEST": {
					_markerColor = _colorWest;
				};
				case "EAST": {
					_markerColor = _colorEast;
				};
				case "GUER": {
					_markerColor = _colorGuer;
				};
				case "CIV": {
					_markerColor = _colorCiv;
				};
			};
			
			_size = 0.5;
			if (rankId _x > 1 || _x != vehicle _x) then {
				_size = 1;
			};
			
			_unitName = "";
			if (isPlayer _x) then {
				_unitName = name _x;
			};
			
			_markerArray = _markerArray + [[_icon, _markerColor, _x, _size, _size, 0, _unitName, 1]];
		};
	};
} forEach allUnits;

[
    vehicle player, 			// Target position (replace MARKERNAME)
    _sitrep, // SITREP text
    400,                    // 400m altitude
    200,                    // 200m radius
    0,                      // 0 degrees viewing angle
    1,                      // Clockwise movement
    _markerArray			// Marker array
] spawn BIS_fnc_establishingShot;

//sleep 1;
//titleText ["","PLAIN"];


//waitUntil {{!(isNil _x)} count ["BIS_fnc_establishingShot_skip", "BIS_fnc_establishingShot_UAVDone"] > 0};

// Disable MP Mission Saving
//enableSaving [false, false];