	// -----------------------------------------------
	// Author: team  code34 nicolas_boiteux@yahoo.fr
	// warcontext - Description: Do random weather 
	// locality: server side
	// -----------------------------------------------
	if (!isServer) exitWith{};

	private [
		"_rain",
		"_fog",
		"_overcast",
		"_wind"
	];

	_rain = 0;
	_overcast = 0;
	_databasename = "HI";

	if(wcinidb) then {
		wcweather = [_databasename, "GLOBAL", "weather", "ARRAY"] call iniDB_read;
		if (count wcweather > 0) then {
			60 setRain (wcweather select 0);
			60 setfog (wcweather select 1);
			60 setOvercast (wcweather select 2);
			setwind (wcweather select 3);
			setdate (wcweather select 4);
			publicvariable "wcweather";
			sleep 600;
		};
	};
	
	while {true} do {
		_rain = random 1;
		if(_rain < 0.4) then {
			_overcast = random 1;
		} else {
			_overcast = 0.5 + (random 0.5);
		};
		if((date select 3 > 2) and (date select 3 <6)) then {
			_fog = 0.4 + (random 0.6);
		} else {
			_fog = 0;			
		};
		if(random 1 > 0.95) then {
			_wind = [random 7, random 7, true];
		} else {
			_wind = [random 3, random 3, true];
		};
		wcweather = [_rain, _fog, _overcast, _wind, date];
		publicvariable "wcweather";
		if(wcinidb) then {
			_ret = [_databasename, "GLOBAL", "weather", wcweather] call iniDB_write;
		};
		60 setRain (wcweather select 0);
		60 setfog (wcweather select 1);
		60 setOvercast (wcweather select 2);
		setwind (wcweather select 3);
		sleep 600;
	};