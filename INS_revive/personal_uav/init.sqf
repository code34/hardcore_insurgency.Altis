private ["_playerRespawn"];

[] Call Compile preprocessFileLineNumbers "INS_revive\personal_uav\functions.sqf";

uav_recon_action = player addAction [
	("<t color='#8edbff'>" + "UAV Reconnaissance" + "</t>"), 
	Compile preprocessFileLineNumbers "INS_revive\personal_uav\uavView.sqf", [], -10, false
];

_playerRespawn = player addEventHandler ["Respawn", {_this Call Compile preprocessFileLineNumbers "INS_revive\personal_uav\onPlayerRespawn.sqf";}]; 

UAV_GVAR_alt = INS_REV_CFG_uav_altitude;
UAV_GVAR_circle = INS_REV_CFG_uav_circle;
UAV_GVAR_position = 0;
UAV_GVAR_delayTime = INS_REV_CFG_uav_delay;