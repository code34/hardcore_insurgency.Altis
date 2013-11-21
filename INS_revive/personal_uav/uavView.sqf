private ["_colorWest","_colorEast","_colorGuer","_colorCiv","_markerArray","_icon","_markerColor","_size","_unitName","_position"];

scopeName "main";

// Check leader
if (INS_REV_CFG_uav_squadleader_only) then {
	if (leader group player != player ) exitWith {
		systemChat "Only squad leader can use the UAV.";
		breakOut "main";
	};
};

// Check delay time
if (isNil "UAV_GVAR_time") then {UAV_GVAR_time = -UAV_GVAR_delayTime;};
if (UAV_GVAR_time + UAV_GVAR_delayTime > time) exitWith {
	systemChat format["UAV support will available in %1 minutes (%2 sec).", round((UAV_GVAR_time + UAV_GVAR_delayTime - time)/60), round(UAV_GVAR_time + UAV_GVAR_delayTime - time)];
};

// Check position config
if (UAV_GVAR_position == 0) then {
	_position = vehicle player;
} else {
	// Display hint
	hint "Designate target for UAV by clicking on the map";
	systemChat "Designate target for UAV";
	
	// Open map
	openMap true;
	
	// Set variable
	UAV_GVAR_mapclick = false;
	
	// Do map click
	onMapSingleClick "UAV_GVAR_clickpos = _pos; UAV_GVAR_mapclick = true; onMapSingleClick ''; true;";
	
	// Wait until player click on the map or close map
	waitUntil {UAV_GVAR_mapclick or !(visiblemap)};
	if (!visibleMap) exitwith {
		systemChat "UAV reconnaissance canceled.";
		breakOut "main";
	};
	
	_position = UAV_GVAR_clickpos;
};

// Update uav time
UAV_GVAR_time = time;

// set side colors
// Color Index : "ColorOrange","ColorYellow","ColorGreen","ColorPink","ColorBrown","ColorKhaki","ColorBlue","ColorRed","ColorBlack","ColorWhite"
_colorWest = WEST call BIS_fnc_sideColor;
_colorEast = EAST call BIS_fnc_sideColor;
_colorGuer = [0.22,0.69,0.06,1];
_colorCiv = [0.52,0.06,0.69,1];

// set transparency for colors
{_x set [3, 0.4]} forEach [_colorWest, _colorEast, _colorGUER, _colorCIV];

_markerArray = [
	["a3\ui_f\data\map\groupIcons\selector_selectedFriendly_ca.paa", _colorWest, player, 2, 2, 0, "", 0]
	//["\a3\ui_f\data\map\markers\nato\b_inf.paa", _colorWest, player, 1, 1, 0, name player, 0]
];

{
	if (alive _x) then {
		if ([_x] call FNC_IS_DISPLAY_MARKER) then {
			_icon = [_x] call FNC_SET_UNIT_MARKER;
			
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

// Start UAV view
[
	_position,
	format ["OPERATOR: %1||Press SPACE to EXIT|Press NUM 1 - 9 to switch viewing modes|", name player],
	UAV_GVAR_alt,
	UAV_GVAR_circle,
	180 - getDir vehicle player,
	1,
	_markerArray
] call AW_fnc_establishingShot;
