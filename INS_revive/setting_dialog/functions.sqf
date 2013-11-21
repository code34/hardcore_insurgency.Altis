FNC_check_display = {
	if (INS_REV_CFG_taw_view) then {
		if (GVAR_is_arma3) then {
			closeDialog 0;
			[] execVM 'INS_revive\taw_vd\open.sqf';
		} else {
			closeDialog 0;
			[] execVM "INS_revive\mission_settings\create.sqf";
		};
	} else {
		systemChat "Display Setting is not available.";
	};
};

FNC_check_squad = {
	if (INS_REV_CFG_squad_management) then {
		closeDialog 0;
		[] execVM 'INS_revive\DOM_squad\open_dialog.sqf';
	} else {
		systemChat "Squad Management is not available.";
	};
};

FNC_check_uav = {
	if (INS_REV_CFG_uav && INS_REV_CFG_uav_setting_dialog) then {
		if (GVAR_is_arma3) then {
			closeDialog 0;
			[] execVM 'INS_revive\personal_uav\open_settings.sqf';
		} else {
			systemChat "UAV Setting is not available.";
		};
	} else {
		systemChat "UAV Setting is not available.";
	};
};
