	// -----------------------------------------------
	// Author: team  code34 nicolas_boiteux@yahoo.fr
	// Dynamic zone for EOS
	// -----------------------------------------------
	//if (!isServer) exitWith{};

	private [
		"_globalindex",
		"_marker", 
		"_index", 
		"_infhouse", 
		"_inf", 
		"_lightveh", 
		"_heavveh", 
		"_static", 
		"_air", 
		"_array", 
		"_housezone", 
		"_positions",
		"_zonetocreate"
	];

	EOSmarkers = [];
	EOSgroupSize= 5 + round(random (5));
	_databasename = "HI";

	wcopformarkers = 0;
	wcblueformarkers = 0;
	wcbattlemarkers = 0;
	wclockcount = 0;
	wcmaxzone = 100;

	_index = 0;
	_zonetocreate = [];

	if(wcinidb) then {
		if(PARAM_deleteinidb == 1) then {
			_databasename call iniDB_delete;
		};
		battlemarkers = [_databasename, "GLOBAL", "battlemarkers", "ARRAY"] call iniDB_read;
		blueformarkers = [_databasename, "GLOBAL", "blueformarkers", "ARRAY"] call iniDB_read;
		opformarkers = [_databasename, "GLOBAL", "opforformarkers", "ARRAY"] call iniDB_read;
		_globalindex = [_databasename, "GLOBAL", "wcglobalindex", "ARRAY"] call iniDB_read;
	} else {
		battlemarkers = [];
		blueformarkers = [];
		opformarkers = [];
		_globalindex = [];
	};

	// retrieve zone to build
	// full zone if new game
	// only backup zone if inidb
	_positions = [_globalindex] call WC_fnc_computezone;

	_index = 0;
	{
		_marker = createMarker [format["mrk%1", _index], _x];
		_marker setMarkerShape "RECTANGLE";
		_marker setmarkerbrush "Solid";
		_marker setmarkercolor "ColorRed";
		_marker setmarkersize [50,50];

		_marker2 = createMarker [format["mrktxt%1", _index], _x];
		_marker2 setMarkerType "mil_triangle";
		_marker2 setmarkerbrush "Solid";
		_marker2 setmarkercolor "ColorBlack";
		_marker2 setmarkersize [0.5,0.5];
		_marker2 setmarkertext format["id:%1", _index];

		if!(_marker in blueformarkers) then {
			_zonetocreate = _zonetocreate  + [_marker];
		};
		_index = _index + 1;
		sleep 0.0001;
	}foreach _positions;
	opformarkers = _zonetocreate;
	battlemarkers = [];

	{
		_x setmarkercolor "ColorBlue";
	}foreach blueformarkers;

	onplayerConnected {[] execVM "eos\eos_JIP.sqf";};

	{
		_marker = _x;
		_infhouse = 1;
		_inf = 0;
		_lightveh = round (random 1);
		_heavveh = round (random 1);
		_static = round (random 1);

		if(random 1 > 0.97) then {
			_air = 1;
		} else {
			_air = 0;
		};

		if(_infhouse + _inf + _lightveh + _heavveh + _static + _air == 0) then {
				_inf = 1;
		};

		if(_lightveh + _heavveh == 2) then {
			_lightveh = 0;
		};

		_array = [_infhouse, _inf, _lightveh, _heavveh, _static, _air];

		[[format ["%1",_marker]],_array,[0,800,0],true] execVM "eos\eos_GearBox.sqf";
		sleep 0.001;
	}foreach _zonetocreate;

	[] spawn {
		private ["_countE", "_countW", "_countB"];
		while { true } do {
			wcopformarkers = count opformarkers;
			wcblueformarkers = count blueformarkers;
			wcbattlemarkers = count battlemarkers;
			"opforzonetext" setMarkerText format["%1 Opfor zones", wcopformarkers];
			"blueforzonetext" setMarkerText format["%1 Bluefor zones", wcblueformarkers];
			"battlezonetext" setMarkerText format["%1 Battle zones", wcbattlemarkers];
			sleep 10;
		};
	};


	if(wcinidb) then {
		[] spawn {
			_databasename = "HI";
			// wait init is done - before begin backup
			sleep 60;
			while { true } do {
				_ret = [_databasename, "GLOBAL", "opformarkers", opformarkers] call iniDB_write;
				if!(_ret) then {
					diag_log "HARDCORE ISURGENCY: Game can not be save too much opfor zone";
				};
				_ret = [_databasename, "GLOBAL", "blueformarkers", blueformarkers] call iniDB_write;
				if!(_ret) then {
					diag_log "HARDCORE ISURGENCY: Game can not be save too much bluefor zone";
				};
				_ret = [_databasename, "GLOBAL", "battlemarkers", battlemarkers] call iniDB_write;
				if!(_ret) then {
					diag_log "HARDCORE ISURGENCY: Game can not be save too much battle zone";
				};
				sleep 60;
			};
		};
	};

	[] spawn {
		private ["_blank"];
		_blank = false;
		while { true } do {
			if(wcbattlemarkers > wcmaxzone ) then {
				if!(_blank) then {
					{		
						_x setmarkeralpha 0.1;
					}foreach opformarkers;
					_blank = true;
				};
			} else {
				if(_blank) then {
					{		
						_x setmarkeralpha 1;
					}foreach opformarkers;					
					_blank = false;
				};
			};
			sleep 10;
		};
	};