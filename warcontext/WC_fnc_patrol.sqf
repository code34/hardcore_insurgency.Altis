	// -----------------------------------------------
	// Author:  code34 nicolas_boiteux@yahoo.fr
	// WARCONTEXT - Simple Seek & destroy patrol script

	private [
		"_areasize",
		"_alert",
		"_cible", 
		"_cibles", 
		"_counter",
		"_formationtype",
		"_group", 
		"_list",
		"_move",
		"_newposition",
		"_newx",
		"_newy",
		"_position",
		"_originalsize",
		"_enemyside",
		"_wp",
		"_wptype"
	];

	_group = _this select 0;
	_position = _this select 1;
	_areasize = _this select 2;

	_newposition = [];
	_newx = 0;
	_newy = 0;

	if (isnil "_areasize") exitwith {
		hintc "WARCONTEXT: patrolscript: areasize parameter is not set";
	};

	if(side (leader _group) == west) then {
		_enemyside = [east];
	};
	if(side (leader _group) == east) then {
		_enemyside = [west];
	};
	if(side (leader _group) == resistance) then {
		_enemyside = [west];
	};

	_alert = true;

	while { (count (units _group) > 0) } do {
		_list = _position nearEntities [["Man"], _areasize];
		if(count _list > 0) then {
			_cibles = [];
			{
				if(side _x in _enemyside) then {
					_cibles = _cibles + [_x];
				} else {
					_list = _list - [_x];
				};
				sleep 0.1;
			}foreach _list;
			if(count _cibles > 0) then {
				_alert = true;
			} else {
				_alert = false;
			};
		};

		if(_alert) then {
			_group setBehaviour "AWARE";
			_group setCombatMode "RED";

			_newposition = position (_cibles call BIS_fnc_selectRandom);
			_wp = _group addWaypoint [_newposition, 25];
			_wp setWaypointPosition [_newposition, 25];
			_wp setWaypointType "DESTROY";
			_wp setWaypointVisible true;
			_wp setWaypointSpeed "LIMITED";
			_group setCurrentWaypoint _wp;
			sleep 30;
			deletewaypoint _wp;
		} else {
			_wptype = "DESTROY";
			_group setBehaviour "SAFE";
			_group setCombatMode "GREEN";

			_formationtype = ["COLUMN", "STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","FILE","DIAMOND"] call BIS_fnc_selectRandom;
			_group setFormation _formationtype;

			if(random 1 > 0.5) then {
				_newx = (_position select 0) + ((random _areasize) * -1 );
				_newy = (_position select 1) + ((random _areasize) * -1 );
			} else {
				_newx = (_position select 0) + (random _areasize);
				_newy = (_position select 1) + (random _areasize);
			};

			_newposition = [_newx, _newy];
			_wp = _group addWaypoint [_newposition, 25];
			_wp setWaypointPosition [_newposition, 25];
			_wp setWaypointType (_wptype call BIS_fnc_selectRandom);
			_wp setWaypointVisible true;
			_wp setWaypointSpeed "LIMITED";
			_group setCurrentWaypoint _wp;

			_move = true;
			_originalsize = count (units _group);
			_counter = 0;

			while { _move } do {
				_counter = _counter + 1;
				if(_counter > 29) then {
					_move = false;
				};			
				if(count (units _group) < _originalsize) then {
					_move = false;
				};
				sleep 1;
			};
			deletewaypoint _wp;
		};
		sleep 0.1;
	};
	
	hint "yop";
