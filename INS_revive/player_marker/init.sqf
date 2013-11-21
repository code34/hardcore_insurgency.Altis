	// @author unknown
	// @code34 enhanced & fixes - nicolas_boiteux@yahoo.fr

	private ["_markers", "_colors", "_color","_playerRespawn"];
	
	// Wait until INS_revive function is initialized
	waitUntil {!isNil "INS_REV_FNCT_init_completed"};
	
	// Compile Functions
	call compile preprocessFile "INS_revive\player_marker\functions.sqf";
	EXT_updateplayerlist 		= compile preprocessFile "INS_revive\player_marker\unitupdate.sqf";
	EXT_updateplayermarkers 	= compile preprocessFile "INS_revive\player_marker\player_marker.sqf";
	
	wcaliveplayers = [];
	
	// Server Side
	if (isServer && INS_REV_CFG_player_marker_serverSide) then {
		wcgarbage = [] spawn EXT_updateplayerlist;
		wcgarbage  = [] spawn EXT_updateplayermarkers;
	};
	
	// Client Side
	if (!isDedicated && !INS_REV_CFG_player_marker_serverSide) then {
		wcgarbage = [] spawn EXT_updateplayerlist;
		wcgarbage  = [] spawn EXT_updateplayermarkers;
	};