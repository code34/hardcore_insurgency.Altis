// Init functions
call Compile preprocessFileLineNumbers "INS_revive\DOM_squad\x_netinit.sqf";
if (!isDedicated) then {
	call Compile preprocessFileLineNumbers "INS_revive\DOM_squad\x_uifuncs.sqf";
	
	/*
	squad_mgmt_action = player addAction [
		("<t color='#04cc6b'>" + "Squad Management" + "</t>"), 
		Compile preprocessFileLineNumbers "INS_revive\DOM_squad\open_dialog.sqf", [], -80, false
	];

	private "_playerRespawn";
	_playerRespawn = player addEventHandler ["Respawn", {_this Call Compile preprocessFileLineNumbers "INS_revive\DOM_squad\onPlayerRespawn.sqf";}]; 
	*/
};
