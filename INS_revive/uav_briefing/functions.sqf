BRF_FNC_SET_UNIT_MARKER = {
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

BRF_FNC_IS_DISPLAY_MARKER = {
	private ["_unit","_result"];
	
	_unit = _this select 0;
	_result = false;
	
	if ((_unit == driver vehicle _unit) || ({_x in vehicle _unit} count allUnits == 1)) then {
		_result = true;
	};
	
	_result
};