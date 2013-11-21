FNC_has_nvg = {
	private ["_unit","_result"];
	
	// Set variable
	_unit = _this select 0;
	
	// Check has NVG
	_result = _unit hasWeapon "NVGoggles" || "NVGoggles" in assignedItems _unit;
	
	// Return value
	_result
};
