	private ["_canDeleteGroup","_group","_groups","_units", "_sanity"];
	while {true} do {
		sleep 30;
		{
			if(!isplayer _x) then {
				_sanity = _x getvariable "sanity";
				if(isnil ("_sanity")) then {
					_sanity = 0;
				};
				if(_sanity > 10) then {
					deleteVehicle _x;
				} else {
					_x setvariable ["sanity", (_sanity + 1), false];
				};
			};
			sleep 0.1;
		} foreach allDead;


		{
			if((damage _x > 0.8) and !((side _x) in [west,civilian]) and (count(crew _x) ==0)) then {
				_sanity = _x getvariable "sanity";
				if(isnil ("_sanity")) then {
					_sanity = 0;
				};
				if(_sanity > 10) then {
					deleteVehicle _x;
				} else {
					_x setvariable ["sanity", (_sanity + 1), false];
				};
			};
			sleep 0.1;
		} foreach vehicles;
		
		_groups = allGroups;
	
		for "_c" from 0 to ((count _groups) - 1) do
		{
			_canDeleteGroup = true;
			_group = (_groups select _c);
			if (!isNull _group) then
			{
				_units = (units _group);
				{
					if (alive _x) then { _canDeleteGroup = false; };
					sleep 0.1;
				} forEach _units;
			};
			if (_canDeleteGroup && !isNull _group) then { deleteGroup _group; };
			sleep 0.1;
		};
	};