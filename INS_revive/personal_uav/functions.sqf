AW_fnc_establishingShot = {
	/*
		Author: Thomas Ryan
			Tweaked by Rarek [AW]
		
		Description:
		Play a fake UAV observational sequence which serves as an establishing shot.
		
		Parameters:
			_this select 0: OBJECT or ARRAY - Target position/object
			_this select 1: STRING - Text to display
			_this select 2 (Optional): NUMBER - Altitude (in meters)
			_this select 3 (Optional): NUMBER - Radius of the circular movement (in meters)
			_this select 4 (Optional): NUMBER - Viewing angle (in degrees)
			_this select 5 (Optional): NUMBER - Direction of camera movement (0: anti-clockwise, 1: clockwise, default: random)
			_this select 6 (Optional): ARRAY -	Objects/positions/groups to display icons over
								Syntax: [[icon, color, target, size X, size Y, angle, text, shadow]]
	*/

	enableSaving [false, false];

	BIS_missionStarted = nil;

	private ["_tgt", "_txt", "_alt", "_rad", "_ang", "_dir"];
	_tgt = [_this, 0, objNull, [objNull, []]] call BIS_fnc_param;
	_txt = [_this, 1, "", [""]] call BIS_fnc_param;
	_alt = [_this, 2, 500, [500]] call BIS_fnc_param;
	_rad = [_this, 3, 200, [200]] call BIS_fnc_param;
	_ang = [_this, 4, random 360, [0]] call BIS_fnc_param;
	_dir = [_this, 5, round random 1, [0]] call BIS_fnc_param;

	BIS_fnc_establishingShot_icons = [_this, 6, [], [[]]] call BIS_fnc_param;

	//0 fadeSound 0;
	titleCut ["", "BLACK FADED", 10e10];

	// Create fake UAV
	if (isNil "BIS_fnc_establishingShot_fakeUAV") then {
		BIS_fnc_establishingShot_fakeUAV = "Camera" camCreate [10,10,10];
	};

	BIS_fnc_establishingShot_fakeUAV cameraEffect ["INTERNAL", "BACK"];

	cameraEffectEnableHUD true;

	private ["_pos", "_coords"];
	_pos = if (typeName _tgt == typeName objNull) then {position _tgt} else {_tgt};
	_coords = [_pos, _rad, _ang] call BIS_fnc_relPos;
	_coords set [2, _alt];

	BIS_fnc_establishingShot_fakeUAV camPrepareTarget _tgt;
	BIS_fnc_establishingShot_fakeUAV camPreparePos _coords;
	BIS_fnc_establishingShot_fakeUAV camPrepareFOV 0.700;
	BIS_fnc_establishingShot_fakeUAV camCommitPrepared 0;

	// Timeout the preload after 3 seconds
	BIS_fnc_establishingShot_fakeUAV camPreload 3;

	// Apply post-process effects
	private ["_ppColor"];
	_ppColor = ppEffectCreate ["colorCorrections", 1999];
	_ppColor ppEffectEnable true;
	_ppColor ppEffectAdjust [1, 1, 0, [1, 1, 1, 0], [0.8, 0.8, 0.8, 0.65], [1, 1, 1, 1.0]];
	_ppColor ppEffectCommit 0;

	private ["_ppGrain"];
	_ppGrain = ppEffectCreate ["filmGrain", 2012];
	_ppGrain ppEffectEnable true;
	_ppGrain ppEffectAdjust [0.1, 1, 1, 0, 1];
	_ppGrain ppEffectCommit 0;

	// Disable stuff after simulation starts
	[] spawn {
		waitUntil {time > 0};
		showCinemaBorder false;
		enableEnvironment false;
	};

	// Compile SITREP text
	private ["_month", "_day", "_hour", "_minute"];
	_month = str (date select 1);
	_day = str (date select 2);
	_hour = str (date select 3);
	_minute = str (date select 4);

	if (date select 1 < 10) then {_month = format ["0%1", str (date select 1)]};
	if (date select 2 < 10) then {_day = format ["0%1", str (date select 2)]};
	if (date select 3 < 10) then {_hour = format ["0%1", str (date select 3)]};
	if (date select 4 < 10) then {_minute = format ["0%1", str (date select 4)]};

	private ["_time", "_date"];
	_time = format ["%1%2", _hour, _minute];
	_date = format ["%1/%2/%3", _day, _month, str (date select 0)];

	private ["_SITREP"];
	_SITREP = format ["<t align = 'left' shadow = '1'>PERSONAL UAV V1.71||%1 |%2 %3 HOURS</t>", _txt, _date, _time];
	
	//removed 'toUpper _txt' from _SITREP

	disableSerialization;

	waitUntil {!(isNull ([] call BIS_fnc_displayMission))};

	// Compile key
	private ["_key"];
	_key = format ["BIS_%1.%2_establishingShot", missionName, worldName];

	private ["_dispMis"];
	_dispMis = [] call BIS_fnc_displayMission;
	
	// Allow skipping
	/*
		if (_this select 1 == 57) then {
			0 fadeSound 1;
			playSound 'click';
			
			activateKey '%1';
			BIS_fnc_establishingShot_skip = true;
			
			true
		};
		
		if (_this select 1 == 79) then {
			false setCamUseTi 0;
			true
		};
	*/
		
	private ["_skipEH"];
	_skipEH = _dispMis displayAddEventHandler [
		"KeyDown",
		format [
			"
				switch (_this select 1) do
				{
					case 57:
					{
						0 fadeSound 1;
						playSound 'click';
						
						activateKey '%1';
						BIS_fnc_establishingShot_skip = true;
						
						true
					};
					
					case 79:
					{
						false setCamUseTi 0;
						playSound 'click';
						true
					};
					
					case 80:
					{
						true setCamUseTi 0;
						playSound 'click';
						true
					};
					
					case 81:
					{
						true setCamUseTi 1;
						playSound 'click';
						true
					};
					
					case 75:
					{
						true setCamUseTi 2;
						playSound 'click';
						true
					};
					
					case 76:
					{
						true setCamUseTi 3;
						playSound 'click';
						true
					};
					
					case 77:
					{
						true setCamUseTi 4;
						playSound 'click';
						true
					};
					
					case 71:
					{
						true setCamUseTi 5;
						playSound 'click';
						true
					};
					
					case 72:
					{
						true setCamUseTi 6;
						playSound 'click';
						true
					};
					
					case 73:
					{
						true setCamUseTi 7;
						playSound 'click';
						true
					};
				};
			",
			_key
		]
	];

	// Create vignette & tiles
	("BIS_layerEstShot" call BIS_fnc_rscLayer) cutRsc ["RscEstablishingShot", "PLAIN"];
	
	// Remove effects if video options opened
	optionsMenuOpened = {
		disableSerialization;
		{(_x call BIS_fnc_rscLayer) cutText ["", "PLAIN"]} forEach ["BIS_layerEstShot", "BIS_layerStatic", "BIS_layerInterlacing"];
	};

	// Add them back if closed
	optionsMenuClosed = {
		disableSerialization;
		("BIS_layerEstShot" call BIS_fnc_rscLayer) cutRsc ["RscEstablishingShot", "PLAIN"];
	};

	waitUntil {!(isNull (uiNamespace getVariable "RscEstablishingShot"))};

	// Wait for the camera to load
	waitUntil {camPreloaded BIS_fnc_establishingShot_fakeUAV || !(isNil "BIS_fnc_establishingShot_skip")};
	
	private ["_musicEH", "_drawEH"];

	if (isNil "BIS_fnc_establishingShot_skip") then {
		// Play ambience on repeat
		0 fadeMusic 0;
		2 fadeMusic 1;
		playMusic ["RadioAmbient1", random 60];
		_musicEH = addMusicEventHandler ["MusicStop", {playMusic "RadioAmbient1"}];
		
		// Move camera in a circle
		[_pos, _alt, _rad, _ang, _dir] spawn {
			scriptName "BIS_fnc_establishingShot: camera control";
			
			private ["_pos", "_alt", "_rad", "_ang", "_dir"];
			_pos = _this select 0;
			_alt = _this select 1;
			_rad = _this select 2;
			_ang = _this select 3;
			_dir = _this select 4;
			
			while {isNil "BIS_missionStarted"} do {
				_ang = _ang - 0.5;
				
				private ["_coords"];
				_coords = [_pos, _rad, if (_dir == 0) then {_ang} else {_ang * -1}] call BIS_fnc_relPos;
				_coords set [2, _alt];
				
				BIS_fnc_establishingShot_fakeUAV camPreparePos _coords;
				BIS_fnc_establishingShot_fakeUAV camCommitPrepared 0.5;
				
				waitUntil {camCommitted BIS_fnc_establishingShot_fakeUAV || !(isNil "BIS_missionStarted")};
				
				BIS_fnc_establishingShot_fakeUAV camPreparePos _coords;
				BIS_fnc_establishingShot_fakeUAV camCommitPrepared 0;
			};
		};
		
		sleep 1;
		
		if (isNil "BIS_fnc_establishingShot_skip") then {
			// Static fade-in
			("BIS_layerStatic" call BIS_fnc_rscLayer) cutRsc ["RscStatic", "PLAIN"];
			waitUntil {!(isNull (uiNamespace getVariable "RscStatic_display")) || !(isNil "BIS_fnc_establishingShot_skip")};
			waitUntil {isNull (uiNamespace getVariable "RscStatic_display")  || !(isNil "BIS_fnc_establishingShot_skip")};
			
			if (isNil "BIS_fnc_establishingShot_skip") then {
				// Show interlacing
				("BIS_layerInterlacing" call BIS_fnc_rscLayer) cutRsc ["RscInterlacing", "PLAIN"];
				
				// Show screen
				titleCut ["", "PLAIN"];
				
				// Add interlacing to optionsMenuClosed
				optionsMenuClosed = {
					("BIS_layerEstShot" call BIS_fnc_rscLayer) cutRsc ["RscEstablishingShot", "PLAIN"];
					("BIS_layerInterlacing" call BIS_fnc_rscLayer) cutRsc ["RscInterlacing", "PLAIN"];
				};
				
				// Show icons
				if (count BIS_fnc_establishingShot_icons > 0) then {
					_drawEH = addMissionEventHandler [
						"Draw3D",
						{
							{
								private ["_icon", "_color", "_target", "_sizeX", "_sizeY", "_angle", "_text", "_shadow"];
								_icon = [_x, 0, "", [""]] call BIS_fnc_param;
								_color = [_x, 1, [], [[]]] call BIS_fnc_param;
								_target = [_x, 2, [], [[], objNull, grpNull]] call BIS_fnc_param;
								_sizeX = [_x, 3, 1, [1]] call BIS_fnc_param;
								_sizeY = [_x, 4, 1, [1]] call BIS_fnc_param;
								_angle = [_x, 5, random 360, [0]] call BIS_fnc_param;
								_text = [_x, 6, "", [""]] call BIS_fnc_param;
								_shadow = [_x, 7, 0, [0]] call BIS_fnc_param;
								
								// Determine condition and position
								private ["_condition", "_position"];
								_condition = true;
								_position = _target;
								
								switch (typeName _target) do {
									// Object
									case typeName objNull: {
										_condition = alive _target;
										_position = getPosATL _target;
									};
									
									// Group
									case typeName grpNull: {
										_condition = {alive _x} count units _target > 0;
										_position = getPosATL leader _target;
									};
								};
								
								// Draw icon
								if (_condition) then {
									drawIcon3D [_icon, _color, _position, _sizeX, _sizeY, _angle, _text, _shadow];
								};
							} forEach BIS_fnc_establishingShot_icons;
						}
					];
				};
				
				// Spawn instructions separately to allow for no delay in skipping
				_key spawn {
					scriptName "BIS_fnc_establishingShot: instructions control";
					
					disableSerialization;
					
					private ["_key"];
					_key = _this;
					
					if (!(isKeyActive _key) && isNil "BIS_fnc_establishingShot_skip") then {
						// Display instructions
						private ["_layerTitlecard"];
						_layerTitlecard = "BIS_layerTitlecard" call BIS_fnc_rscLayer;
						_layerTitlecard cutRsc ["RscDynamicText", "PLAIN"];
						
						private ["_dispText", "_ctrlText"];
						_dispText = uiNamespace getVariable "BIS_dynamicText";
						_ctrlText = _dispText displayCtrl 9999;
						
						_ctrlText ctrlSetPosition [
							0 * safeZoneW + safeZoneX,
							0.8 * safeZoneH + safeZoneY,
							safeZoneW,
							safeZoneH
						];
						
						// Determine appropriate key highlight
						private ["_keyColor"];
						_keyColor = format [
							"<t color = '%1'>",
							(["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet) call BIS_fnc_colorRGBtoHTML
						];
						
						private ["_skipText"];
						_skipText = format [
							"%1PRESS %2[SPACE]%3 TO ADVANCE%4",	// Todo: localize
							"<t size = '0.75'>",
							_keyColor,
							"</t>",
							"</t>"
						];
						
						_ctrlText ctrlSetStructuredText parseText _skipText;
						_ctrlText ctrlSetFade 1;
						_ctrlText ctrlCommit 0;
						
						_ctrlText ctrlSetFade 0;
						_ctrlText ctrlCommit 1;
						
						// Wait for video to finish
						waitUntil {{!(isNil _x)} count ["BIS_fnc_establishingShot_skip", "BIS_fnc_establishingShot_UAVDone"] > 0};
						
						// Remove instructions
						_ctrlText ctrlSetFade 1;
						_ctrlText ctrlCommit 0;
					};
				};
				
				sleep 1;
				
				if (isNil "BIS_fnc_establishingShot_skip") then {
					((uiNamespace getVariable "RscEstablishingShot") displayCtrl 2500) ctrlSetPosition [
						(((safeZoneW / safeZoneH) min 1.2) / 40) + safeZoneX,
						((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) + safeZoneY,
						safeZoneW,
						safeZoneH
					];
					
					((uiNamespace getVariable "RscEstablishingShot") displayCtrl 2500) ctrlCommit 0;
					
					// Split text to individual characters
					private ["_SITREPArray"];
					_SITREPArray = toArray _SITREP;
					{_SITREPArray set [_forEachIndex, toString [_x]]} forEach _SITREPArray;
					
					private ["_scrollIn"];
					_scrollIn = _SITREPArray spawn {
						disableSerialization;
						
						private ["_SITREPArray"];
						_SITREPArray = _this;
						
						private ["_SITREPCompile"];
						_SITREPCompile = "";
						
						// Make text scroll in
						for "_i" from 0 to (count _SITREPArray - 1) do {
							private ["_character", "_delay"];
							_character = _SITREPArray select _i;
							_delay = if (_character == "|") then {_character = "<br/>"; 1} else {0.01};
							
							_SITREPCompile = _SITREPCompile + _character;
							
							if (!(isNull (uiNamespace getVariable "RscEstablishingShot"))) then {
								((uiNamespace getVariable "RscEstablishingShot") displayCtrl 2500) ctrlSetStructuredText parseText (_SITREPCompile + "_");
								((uiNamespace getVariable "RscEstablishingShot") displayCtrl 2500) ctrlCommit 0;
							};
							
							sleep _delay;
						};
						
						if (!(isNull (uiNamespace getVariable "RscEstablishingShot"))) then {
							((uiNamespace getVariable "RscEstablishingShot") displayCtrl 2500) ctrlSetStructuredText parseText _SITREPCompile;
						};
						
						sleep 8;
					};
					
					waitUntil {!(isNil "BIS_fnc_establishingShot_skip")};
					
					if (isNil "BIS_fnc_establishingShot_skip") then {
						// Register the UAV finished
						BIS_fnc_establishingShot_UAVDone = true;
					};
				};
			};
		};
	};

	waitUntil {{!(isNil _x)} count ["BIS_fnc_establishingShot_skip", "BIS_fnc_establishingShot_UAVDone"] > 0};

	// Remove skipping eventhandler
	_dispMis displayRemoveEventHandler ["KeyDown", _skipEH];

	// Static fade-out
	("BIS_layerStatic" call BIS_fnc_rscLayer) cutRsc ["RscStatic", "PLAIN"];
	waitUntil {!(isNull (uiNamespace getVariable "RscStatic_display"))};
	waitUntil {isNull (uiNamespace getVariable "RscStatic_display")};

	// Remove HUD
	optionsMenuOpened = nil;
	optionsMenuClosed = nil;

	if (!(isNil "_drawEH")) then {
		removeMissionEventHandler ["Draw3D", _drawEH];
	};

	if (!(isNull (uiNamespace getVariable "RscEstablishingShot"))) then {
		((uiNamespace getVariable "RscEstablishingShot") displayCtrl 2500) ctrlSetFade 1;
		((uiNamespace getVariable "RscEstablishingShot") displayCtrl 2500) ctrlCommit 0;
	};

	{
		private ["_layer"];
		_layer = _x call BIS_fnc_rscLayer;
		_layer cutText ["", "PLAIN"];
	} forEach ["BIS_layerEstShot", "BIS_layerStatic", "BIS_layerInterlacing"];

	// Stop ambience
	if (!(isNil "_musicEH")) then {
		0 fadeMusic 0;
		removeMusicEventHandler ["MusicStop", _musicEH];
	};

	titleCut ["", "BLACK FADED", 10e10];

	sleep 1;

	//enableSaving [true, true];
	enableSaving [false, false];

	BIS_fnc_establishingShot_fakeUAV cameraEffect ["TERMINATE", "BACK"];

	ppEffectDestroy _ppColor;
	ppEffectDestroy _ppGrain;

	3 fadeSound 1;
	enableEnvironment true;
	titleCut ["", "BLACK IN", 3];

	// Clear existing global variables
	BIS_fnc_establishingShot_icons = nil;
	BIS_fnc_establishingShot_skip = nil;
	BIS_fnc_establishingShot_UAVDone = nil;

	// Start mission
	BIS_missionStarted = true;

	true
};

FNC_SET_UNIT_MARKER = {
	private ["_unit","_vehicle","_vehicleType","_icon","_medic","_repair","_support","_recon","_motor","_mech","_heli","_arty"];
	
	_unit = _this select 0;
	_vehicle = vehicle _unit;
	_vehicleType =  typeOf _vehicle;
	_icon = "a3\ui_f\data\map\markers\nato\b_inf.paa";
	
	_medic = ["B_medic_F","O_medic_F"];
	_repair = ["B_soldier_repair_F","O_soldier_repair_F"];
	_support = ["B_soldier_AR_F","O_soldier_AR_F"];
	_recon = ["B_soldier_M_F","O_soldier_M_F"];
	_motor = ["c_offroad","B_Quadbike_F","O_Quadbike_F","O_Galkin_F","B_Hunter_F"];
	_mech = ["B_Hunter_HMG_F","B_Hunter_RCWS_F","O_Galkin_MG_F","O_Galkin_GMG_F"];
	_heli = ["B_MH9_F","B_AH9_F","O_Ka60_F","O_Ka60_Unarmed_F"];
	_arty = ["B_Mk6","O_Mk6"];
	
	if (_unit != vehicle _unit) then {
		switch true do {
			case (_vehicleType in _motor):
				{_icon = "a3\ui_f\data\map\markers\nato\b_motor_inf.paa";};
			case (_vehicleType in _mech):
				{_icon = "a3\ui_f\data\map\markers\nato\b_mech_inf.paa";};
			case (_vehicleType in _heli):
				{_icon = "a3\ui_f\data\map\markers\nato\b_air.paa"};
			case (_vehicleType in _arty):
				{_icon = "a3\ui_f\data\map\markers\nato\b_mortar.paa"};
		};
	} else {
		switch true do {
			case (_vehicleType in _medic):
				{_icon = "a3\ui_f\data\map\markers\nato\b_med.paa";};
			case (_vehicleType in _repair):
				{_icon = "a3\ui_f\data\map\markers\nato\b_maint.paa";};
			case (_vehicleType in _support):
				{_icon = "a3\ui_f\data\map\markers\nato\b_support.paa"};
			case (_vehicleType in _recon):
				{_icon = "a3\ui_f\data\map\markers\nato\b_recon.paa"};
		};
	};
	
	_icon
};

FNC_IS_DISPLAY_MARKER = {
	private ["_unit","_result","_Units"];
	
	_unit = _this select 0;
	_result = false;
	
	if ((side _unit == side player) || (INS_REV_CFG_uav_enemy_marker)) then {
		if ((_unit == driver vehicle _unit) || ({_x in vehicle _unit} count allUnits == 1)) then {
			_result = true;
		};
	};
	
	_result
};

FNC_alt_onsliderchange = {
	private["_dialog","_text","_value"];
	disableSerialization;
	
	_dialog = findDisplay 2800;
	_text = _dialog displayCtrl 1004;
	_value = _this select 0;
	
	_text ctrlSetText format["%1", round(_value)];
};

FNC_circle_onsliderchange = {
	private["_dialog","_text","_value"];
	disableSerialization;
	
	_dialog = findDisplay 2800;
	_text = _dialog displayCtrl 1005;
	_value = _this select 0;
	
	_text ctrlSetText format["%1", round(_value)];
};

FNC_apply_settings = {
	UAV_GVAR_alt = sliderPosition 1900;
	UAV_GVAR_circle = sliderPosition 1901;
	
	if (!INS_REV_CFG_uav_allow_map_click) then {
		if (lbCurSel 2100 == 1) then {
			player globalChat "Map click is not available."
		};
	} else {
		UAV_GVAR_position = lbCurSel 2100;
	};
};

FNC_position_oncombochange = {
	private["_dialog","_combo","_value"];
	disableSerialization;
	
	_dialog = findDisplay 2800;
	_combo = _dialog displayCtrl 2100;
	_value = _this select 0;
	
	player sidechat format["Debug : %1", _value];
	
	if (!INS_REV_CFG_uav_allow_map_click) then {
		if (_value == 1) then {
			lbSetCurSel [2100, 0];
			player globalChat "UAV map click position is not available."
		};
	}
};