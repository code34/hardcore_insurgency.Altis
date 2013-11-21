	// init warcontext function
	WC_fnc_weather 		= compile preprocessFile "warcontext\wc_weather\WC_fnc_weather.sqf";
	WC_fnc_skill	 	= compile preprocessFile "warcontext\wc_skill\WC_fnc_setskill.sqf";
	WC_fnc_computezone	= compile preprocessFile "EOS\eos_computezone.sqf";

	if (isClass(configFile >> "cfgPatches" >> "inidbi")) then {
		call compile preProcessFile "\inidbi\init.sqf";
		wcinidb = true;
	} else {
		wcinidb = false;
	};
	
	// JIP Check (This code should be placed first line of init.sqf file)
	if (!isServer && isNull player) then {isJIP=true;} else {isJIP=false;};
	
	// Wait until player is initialized
	if (!isDedicated) then {
		waitUntil {!isNull player && isPlayer player};
		if !(player hasWeapon "ItemGPS") then {
			player addWeapon "ItemGPS";
		};
	};
	
	// INS_revive initialize
	[] execVM "INS_revive\revive_init.sqf";
	
	// Wait for INS_revive initialized
	waitUntil {!isNil "INS_REV_FNCT_init_completed"};
	
	if (isServer) then {
		switch(PARAM_TimeOfDay) do {
			case 1: {
				setdate [2013, 09, 25, 04, 00];
			};
		
			case 2: {
				setdate [2013, 09, 25, 12, 00];
			};
		
			case 3: {
				setdate  [2013, 09, 25, 17, 00];
			};
		
			case 4: {
				setdate [2013, 09, 25, 22, 00];
			};
		};
		enableSaving [false, false];
		if(PARAM_headlessclient == 0) then {
			wcamountofredzones = 1 - (PARAM_Redzone/100);
			[] execVM "EOS\init.sqf";
		};
		if(PARAM_dynamicweather == 1) then {		
			wcgarbage = [] spawn WC_fnc_weather;
		};
	};

	if (local player) then {	
		// set meteo
		"wcweather" addPublicVariableEventHandler {
			wcweather = _this select 1;
			60 setRain (wcweather select 0);
			60 setfog (wcweather select 1);
			60 setOvercast (wcweather select 2);
			setwind (wcweather select 3);
			setdate (wcweather select 4);
		};

		// synch server & client
		"wcheadlessclientid" addPublicVariableEventHandler {
			wcheadlessclientid = (_this select 1);
			hint format["Headlessclient connected %1", wcheadlessclientid];
		};
	};

	// Headless client support AI
	if ( !hasInterface && !isServer ) then {
		if((PARAM_headlessclient == 1) and (name player == "HC")) then {
			wcamountofredzones = 1 - (PARAM_Redzone/100);
			[] execVM "EOS\init.sqf";

			[] spawn {
				while {true} do {
					diag_log format["HEADLESSCLIENT FPS: %1 TIME: %2 IDCLIENT: %3", diag_fps, time, owner player];
					sleep 60;
				};
			};
			sleep 60;
			wcheadlessclientid = owner player;
			publicvariable "wcheadlessclientid";
		};
	};

	// fast time server & client
	if(PARAM_fastime == 1) then {
		[] spawn {
			while {true} do {
				skiptime 0.01;
				sleep 10;
			};
		};
	};