/*
 * Author:      Sinky
 * Date:        3rd February 2011
 * Last Edited: 3rd February 2011
 * Version:     1.0
 */
 
private ["_playerRespawn"];
	
// Add the action for the settings dialog
GVAR_settings_action = player addAction [
	("<t color='#fffe80'>" + "Settings" + "</t>"), 
	"INS_revive\mission_settings\create.sqf", [], 0, false
];

// Used to re-add the settings action after respawn
//player addMPEventHandler ["MPRespawn", {_this execVM "INS_revive\mission_settings\onPlayerRespawn.sqf"}];
//player addEventHandler ["Respawn", {_this execVM "INS_revive\mission_settings\onPlayerRespawn.sqf"}];
FNC_onRespawn = Compile preprocessFileLineNumbers "INS_revive\mission_settings\onPlayerRespawn.sqf";
//_playerRespawn = player addEventHandler ["Respawn", {_this spawn FNC_onRespawn;}];
_playerRespawn = player addEventHandler ["Killed", {_this spawn FNC_onRespawn;}];
