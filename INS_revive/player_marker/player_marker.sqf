	// @author unknown
	// @code34 fix - nicolas_boiteux@yahoo.fr
	// Draw Player Marker

	private ["_markers"];

	_markers = [];

	while {true} do {
		// Check method serverside or clientside
		if (INS_REV_CFG_player_marker_serverSide) then {
			_markers = [_markers] call FNC_SET_PLAYER_MARKER_SERVER_SIDE;
		} else {
			_markers = [_markers] call FNC_SET_PLAYER_MARKER;
		};
		sleep 0.5;
	};