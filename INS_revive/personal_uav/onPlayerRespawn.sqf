_unit = _this select 0;
_corpse = _this select 1;

if (local _unit) then {
	_corpse removeAction uav_recon_action;
	
	uav_recon_action = _unit addAction [
		("<t color='#8edbff'>" + "UAV Reconnaissance" + "</t>"), 
		"INS_revive\personal_uav\uavView.sqf", [], -10, false
	];
};