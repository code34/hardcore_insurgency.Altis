
// Check for arma 3
if (GVAR_is_arma3) then {
	call compile preProcessFileLineNumbers "INS_revive\S_NVG\functions_a3.sqf";
} else {
	FNC_has_nvg = {
		private ["_unit","_result"];
		
		// Set variable
		_unit = _this select 0;
		
		// Check has NVG
		_result = _unit hasWeapon "NVGoggles";
		
		// Return value
		_result
	};
};

S_NVG_offbutton = {
	setAperture -1;
	S_NVG_on = false;
};

S_NVG_keypressed = {
	if ([player] call FNC_has_nvg) then
	{
		// if pressed key is "N" then either turn NVG on or off
		if ((_this select 1)in (actionKeys "nightVision")) exitWith
		{
			if (S_NVG_on) then {
				// disable
				_this call S_NVG_offbutton;
			} else {
				// enable
				S_NVG_on = true;
				if (S_NVG_settingon) then {
					setAperture (S_NVG_sensitivity);
				};

			};
		};
		
		if (S_NVG_settingon && S_NVG_on) then {
			// What to do on PAGEUP = 201
			if ((_this select 1) == S_NVG_sensitivity_up) exitWith {
				S_NVG_sensitivity = S_NVG_sensitivity - ((S_NVG_sensitivity)/10);
				S_NVG_sensitivity = ((round(S_NVG_sensitivity * 10)) /10);
				S_NVG_sensitivity = S_NVG_sensitivity max 0.1;
				hint format ["NV Aperture: %1",(S_NVG_sensitivity)];
				setAperture (S_NVG_sensitivity);
			};
			
			// What to do on PAGEDOWN = 209
			if ((_this select 1) == S_NVG_sensitivity_down) exitWith {
				S_NVG_sensitivity = S_NVG_sensitivity + ((S_NVG_sensitivity)/10);
				S_NVG_sensitivity = ((round(S_NVG_sensitivity * 10)) /10);
				S_NVG_sensitivity = S_NVG_sensitivity min 1000;
				hint format ["NV Aperture: %1",(S_NVG_sensitivity)];
				setAperture (S_NVG_sensitivity);
			};
		};
	};
};