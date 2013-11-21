// =========================================================================================================
//  Urban Patrol Script Lite
//  Author: code34 nicolas_boiteux@yahoo.fr
//  Original Author: Kronzky (www.kronzky.info / kronzky@gmail.com)
// ---------------------------------------------------------------------------------------------------------
//  Required parameters:
//    unit          = Unit to patrol area (1st argument)
//    markername    = Name of marker that covers the active area. (2nd argument)
//    (e.g. nul=[this,"town"] execVM "ups.sqf")
//
//  Optional parameters: 
//    random        = Place unit at random start position.
//    randomdn      = Only use random positions on ground level.
//    randomup      = Only use random positions at top building positions. 
//    nomove        = Unit will stay at start position until enemy is spotted.
//    nofollow      = Unit will only follow an enemy within the marker area.
//    delete:n      = Delete dead units after 'n' seconds.
//    nowait        = Do not wait at patrol end points.
//    noslow        = Keep default behaviour of unit (don't change to "safe" and "limited").
//    noai          = Don't use enhanced AI for evasive and flanking maneuvers.
//    showmarker    = Display the area marker.
//    empty:n       = Consider area empty, even if 'n' units are left.
//    track         = Display a position and destination marker for each unit.
//
// =========================================================================================================
	
// how far opfors should move away if they're under attack
// set this to 200-300, when using the script in open areas (rural surroundings)
#define SAFEDIST 50

// how close unit has to be to target to generate a new one 
#define CLOSEENOUGH 10

// how close units have to be to each other to share information
#define SHAREDIST 100

// how long AI units should be in alert mode after initially spotting an enemy
#define ALERTTIME 180

// ---------------------------------------------------------------------------------------------------------
//echo format["[K] %1",_this];

// convert argument list to uppercase
_UCthis = [];
for [{_i=0},{_i<count _this},{_i=_i+1}] do {_e=_this select _i; if (typeName _e=="STRING") then {_e=toUpper(_e)};_UCthis set [_i,_e]};

// ***************************************** SERVER INITIALIZATION *****************************************

	// global functions
	if (isNil("KRON_UPS_INIT")) then {
		KRON_UPS_INIT = 0;
		KRON_UPS_Debug = 0;
	
		// find a random position within a radius
		KRON_randomPos = {
			private["_cx","_centerposY","_rx","_ry","_cd","_sd","_ad","_tx","_ty","_xout","_yout"];
			_cx=_this select 0; 
			_centerposY=_this select 1; 
			_rx=_this select 2; 
			_ry=_this select 3; 
			_cd=_this select 4; 
			_sd=_this select 5; 
			_ad=_this select 6; 

			_tx=random (_rx*2)-_rx; 
			_ty=random (_ry*2)-_ry; 
			_xout= if (_ad!=0) then {_cx+ (_cd*_tx - _sd*_ty)} else {_cx+_tx}; 
			_yout= if (_ad!=0) then {_centerposY+ (_sd*_tx + _cd*_ty)} else {_centerposY+_ty}; 
			[_xout,_yout];
		};

		// find any building (and its possible building positions) near a position
		KRON_PosInfo = {
				private["_pos","_lst","_bld","_bldpos"];
				_pos = _this select 0; 
				_lst= nearestObjects [_pos,["House_F"], 50]; 
				if (count _lst == 0) then {
					_bld=0;
					_bldpos = 0
				} else {
					_bld=_lst select 0;
					_bldpos=[_bld] call KRON_BldPos;
				}; 
				[_bld,_bldpos];
		};

		/// find the highest building position	
		KRON_BldPos = {
			private ["_bld","_bi","_bldpos","_maxZ","_bp","_bz","_higher"];
			_bld=_this select 0;
			_maxZ=0;
			_bi=0;
			_bldpos=0;
			while {_bi>=0} do {
				_bp = _bld BuildingPos _bi;
				if ((_bp select 0)==0) then {
					_bi=-99
				} else {
					_bz=_bp select 2; 
					_higher = ((_bz>_maxZ) || ((abs(_bz-_maxZ)<.5) && (random 1>.5)));
					if ((_bz>4) && _higher) then {
						_maxZ=_bz;
						_bldpos=_bi;
					}
				};
				_bi=_bi+1;
			};
			_bldpos;
		};

		KRON_OnRoad = {
			private["_pos","_car","_tries","_lst"];
			_pos	= _this select 0;
			_car	= _this select 1;
			_tries	= _this select 2;
			_lst	= _pos nearRoads 4;
			if ((count _lst!=0) && (_car || !(surfaceIsWater _pos))) then {_tries=99};
			(_tries+1);
		};

		KRON_getDirPos = {
			private["_a","_b","_from","_to","_return"];
			_from = _this select 0;
			_to = _this select 1;
			_return = 0;

			_a = ((_to select 0) - (_from select 0));
			_b = ((_to select 1) - (_from select 1));

			if (_a != 0 || _b != 0) then {_return = _a atan2 _b;};
			if ( _return < 0 ) then { _return = _return + 360;};
			_return;
		};

		KRON_distancePosSqr = {(((_this select 0) select 0)-((_this select 1) select 0))^2 + (((_this select 0) select 1)-((_this select 1) select 1))^2};
		KRON_relPos = {private["_p","_d","_a","_x","_y","_xout","_yout"];_p=_this select 0; _x=_p select 0; _y=_p select 1; _d=_this select 1; _a=_this select 2; _xout=_x + sin(_a)*_d; _yout=_y + cos(_a)*_d;[_xout,_yout,0]};

		KRON_rotpoint = {
			private["_cp","_a","_tx","_ty","_cd","_sd","_cx","_centerposY","_xout","_yout"];
			_cp=_this select 0;
			_cx=_cp select 0;
			_centerposY=_cp select 1;
			_a=_this select 1;
			_cd=cos(_a*-1);
			_sd=sin(_a*-1);
			_tx=_this select 2;
			_ty=_this select 3;
			_xout =if (_a!=0) then {_cx+ (_cd*_tx - _sd*_ty)} else {_cx+_tx};
			_yout= if (_a!=0) then {_centerposY+ (_sd*_tx + _cd*_ty)} else {_centerposY+_ty};
			[_xout,_yout,0];
		};

		KRON_stayInside = {
			private["_targetpos","_targetposX","_targetposY","_centerpos","_centerposX","_centerposY","_rangeX","_rangeY","_areadir","_fx","_fy"];

			_targetpos	= _this select 0;	
			_targetposX	= _targetpos select 0;
			_targetposY	= _targetpos select 1;

			_centerpos	= _this select 1;
			_centerposX	= _centerpos select 0;
			_centerposY	= _centerpos select 1;

			_rangeX		=_this select 2;
			_rangeY		=_this select 3;

			_areadir	=_this select 4;

			_targetpos = [_centerpos, _areadir, (_targetposX - _centerposX), (_targetposY - _centerposY)] call KRON_rotpoint;

			_targetposX = _targetpos select 0;
			_targetposY = _targetpos select 1;
			_fx= _targetposX;
			_fy= _targetposY;

			if (_targetposX < (_centerposX - _rangeX)) then { _fx = _centerposX - _rangeX; };
			if (_targetposX > (_centerposX + _rangeX)) then { _fx = _centerposX + _rangeX; };
			if (_targetposY < (_centerposY - _rangeY)) then { _fy = _centerposY - _rangeY; };
			if (_targetposY > (_centerposY + _rangeY)) then { _fy = _centerposY + _rangeY; };

			if ((_fx != _targetposX) || (_fy != _targetposY)) then {
				_targetpos = [_centerpos, _areadir * -1, (_fx - _centerposX), (_fy - _centerposY)] call KRON_rotpoint;
			};
			_targetpos;
		};


		// Misc
		KRON_getArg = {private["_cmd","_arg","_list","_a","_v"]; _cmd=_this select 0; _arg=_this select 1; _list=_this select 2; _a=-1; {_a=_a+1; _v=format["%1",_list select _a]; if (_v==_cmd) then {_arg=(_list select _a+1)}} foreach _list; _arg};
		
		[] spawn {
			while { true } do {
				// find all units in mission
				KRON_AllWest = [];
				KRON_AllEast = [];
				KRON_AllRes = [];
				{
					_s = side _x;
					switch (_s) do {
						case west: 
							{ KRON_AllWest = KRON_AllWest + [_x]; };
						case east: 
							{ KRON_AllEast = KRON_AllEast + [_x]; };
						case resistance: 
							{ KRON_AllRes = KRON_AllRes + [_x]; };
					};
					sleep 0.01;
				}foreach allunits;
				sleep 30;
			};
		};
		KRON_UPS_Instances = 0;
		KRON_UPS_INIT = 1;
	};

	if ((count _this)<2) exitWith {
		if (format["%1",_this]!="INIT") then {hint "UPS: Unit and marker name have to be defined!"};
	};
	_exit = false;
	_onroof = false;
	
	// ---------------------------------------------------------------------------------------------------------
	waitUntil {KRON_UPS_INIT == 1};
	sleep (random 1);
	
	KRON_UPS_Instances =	KRON_UPS_Instances + 1;
	
	// get name of area marker 
	_areamarker = _this select 1;
	if (isNil ("_areamarker")) exitWith {
		hint "UPS: Area marker not defined.\n(Typo, or name not enclosed in quotation marks?)";
	};	
	
	_centerpos = [];
	_centerX = [];
	_centerY = [];
	_rangeX = 0;
	_rangeY = 0;
	_areadir = 0;
	_areaname = "";
	_showmarker = "HIDEMARKER";
	_getAreaInfo = {
		// remember center position of area marker
		_centerpos = getMarkerPos _areamarker;
		_centerX = abs(_centerpos select 0);
		_centerY = abs(_centerpos select 1);
		
		// X/Y range of target area
		_areasize = getMarkerSize _areamarker;
		_rangeX = _areasize select 0;
		_rangeY = _areasize select 1;

		// marker orientation (needed as negative value!)
		_areadir = (markerDir _areamarker) * -1;
		_areaname = _areamarker;
			
		// show area marker 
		_showmarker = if ("SHOWMARKER" in _UCthis) then {"SHOWMARKER"} else {"HIDEMARKER"};
		if (_showmarker=="HIDEMARKER") then {
			_areamarker setMarkerPos [-abs(_centerX),-abs(_centerY)];
		};
	};
	[] call _getAreaInfo;

	// unit that's moving
	_leader = (_this select 0);	

	// check type of leader
	if(_leader iskindof "MAN") then {
		_exit = false;
	} else {
		hint "UPS: parameter 0 is not a man)";
		_exit = true;
	};

	// give this group a unique index
	_grpidx = format["%1",KRON_UPS_Instances];

	// remember the original group members, so we can later find a new leader, in case he dies
	_group = group _leader;

	// what type of "vehicle" is unit ?
	_isman 	= _leader isKindOf "Man";
	_iscar 	= (vehicle _leader) isKindOf "LandVehicles";
	_isboat = (vehicle _leader) isKindOf "Ship";
	_isplane = (vehicle _leader) isKindOf "Air";

	// check to see whether group is an enemy of the player (for attack and avoidance maneuvers)
	// since countenemy doesn't count vehicles, and also only counts enemies if they're known, 
	// we just have to brute-force it for now, and declare *everyone* an enemy who isn't a civilian
	_issoldier = (side _leader != civilian);

	_sharedenemy=0;

	//TODO: FIND A WAY TO DETERMINE ASSOCIATION OF RESISTANCE UNITS
	if (_issoldier) then {
		switch (side _leader) do {
			case west:
				{ 
					_sharedenemy=0;
				};
			case east:
				{
					_sharedenemy=1;
				};
			case resistance:
				{
					_sharedenemy=2;
				};
		};
		{
			_x disableAI "autotarget";
			sleep 0.01;
		} forEach (units _group);
	};
	sleep 1;

	// global unit variable to externally influence script 
	_named = false;
	_npcname = str(side _leader);

	// create global variable for this group
	call compile format ["KRON_UPS_%1=1",_npcname];

	// store some trig calculations
	_cosdir=cos(_areadir);
	_sindir=sin(_areadir);

	// minimum distance of new target position
	if (_rangeX==0) exitWith {
		hint format["UPS: Cannot patrol Sector: %1\nArea Marker doesn't exist",_areaname]; 
	};
	_mindist=(_rangeX^2+_rangeY^2)/4;

	// remember the original mode & speed
	_orgMode = behaviour _leader;
	_orgSpeed = speedmode _leader;
	_speedmode = _orgSpeed;

	// set first target to current position (so we'll generate a new one right away)
	_currPos = getpos _leader;
	_orgPos = _currPos;
	_orgWatch=[_currPos,50,getDir _leader] call KRON_relPos; 
	_orgDir = getDir _leader;
	_avoidPos = [0,0];
	_flankPos = [0,0];
	_attackPos = [0,0];

	_dist = 0;
	_lastdist = 0;
	_lastmove1 = 0;
	_lastmove2 = 0;
	_maxmove=0;
	_moved=0;
	
	_damm=0;
	_dammchg=0;
	_lastdamm = 0;
	_timeontarget = 0;
	
	_fightmode = "walk";
	_fm=0;
	_gothit = false;
	_hitPos=[0,0,0];
	_react = 99;
	_lastdamage = 0;
	_lastknown = 0;
	_opfknowval = 0;
	
	_sin90=1; 
	_cos90=0;
	_sin270=-1; 
	_cos270=0;

	// set target tolerance high for choppers & planes
	_closeenough= CLOSEENOUGH*CLOSEENOUGH;
	if (_isplane) then {
		_closeenough=5000;
	};

	// wait at patrol end points
	_pause = if ("NOWAIT" in _UCthis) then {"NOWAIT"} else {"WAIT"};

	// don't move until an enemy is spotted
	_nomove  = if ("NOMOVE" in _UCthis) then {"NOMOVE"} else {"MOVE"};

	// don't follow outside of marker area
	_nofollow = "NOFOLLOW";

	// share enemy info 
	_shareinfo ="SHARE";

	// suppress fight behaviour
	if ("NOAI" in _UCthis) then {_issoldier=false};

	// adjust cycle delay 
	_centerposYcle = ["CYCLE:",5,_UCthis] call KRON_getArg;

	// drop units at random positions
	_initpos = "ORIGINAL";

	if ("RANDOM" in _UCthis) then {_initpos = "RANDOM"};
	if ("RANDOMUP" in _UCthis) then {_initpos = "RANDOMUP"}; 
	if ("RANDOMDN" in _UCthis) then {_initpos = "RANDOMDN"}; 

	// don't position groups or vehicles on rooftops
	if ((_initpos!="ORIGINAL") && ((!_isman) || (count (units _group))>1)) then {_initpos="RANDOMDN"};

	// set behaviour modes (or not)
	_noslow = if ("NOSLOW" in _UCthis) then {"NOSLOW"} else {"SLOW"};
	if (_noslow!="NOSLOW") then {
		_leader setbehaviour "safe"; 
		_leader setSpeedMode "limited";
		_speedmode = "limited";
	}; 

	// make start position random 
	if (_initpos!="ORIGINAL") then {
		// find a random position (try a max of 20 positions)
		_try=0;
		_bld=0;
		_bldpos=0;
		while {_try<20} do {
			_currPos=[_centerX,_centerY,_rangeX,_rangeY,_cosdir,_sindir,_areadir] call KRON_randomPos;
			if ((_initpos=="RANDOMUP") || ((_initpos=="RANDOM") && (random 1>.75))) then {
				_posinfo=[_currPos] call KRON_PosInfo;
				_bld=_posinfo select 0;
				_bldpos=_posinfo select 1;
			};
			if (_isplane || _isboat || !(surfaceiswater _currPos)) then {
				if (((_initpos=="RANDOM") || (_initpos=="RANDOMUP")) && (_bldpos>0)) then {_try=99};
				if (((_initpos=="RANDOM") || (_initpos=="RANDOMDN")) && (_bldpos==0)) then {_try=99};
			};
			_try=_try+1;
			sleep 0.1;
		};
		if (_bldpos==0) then {
			if (_isman) then {
				{
					_x setPos _currPos;
					sleep 0.1;
				} foreach (units _group); 
			} else {
				(vehicle _leader) setPos _currPos;
			};
		} else {
			// put the unit on top of a building
			_leader setPos (_bld buildingPos _bldpos); 
			_leader setUnitPos "up";
			_currPos = getPos _leader;
			_onroof = true;
			_exit=true; // don't patrol if on roof
		};
	};

	// units that can be left for area to be "cleared"
	_zoneempty = ["EMPTY:",0,_UCthis] call KRON_getArg;

	// init done
	_makenewtarget=true;
	_newpos=false;
	_targetPos = _currPos;
	_swimming = false;
	_waiting = if (_nomove=="NOMOVE") then {9999} else {0};

	// exit if something went wrong during initialization (or if unit is on roof)
	if (_exit) exitWith {
		if ((KRON_UPS_DEBUG>0) && !_onroof) then {hint "Initialization aborted"};
	};

// ***********************************************************************************************************
// ************************************************ MAIN LOOP ************************************************

_loop = true;
_currcycle = _centerposYcle;
_knownenemy = [objNull,objNull];

while {_loop} do {

	// keep track of how long we've been moving towards a destination
	_timeontarget = _timeontarget + _currcycle;
	_react = _react + _currcycle;
			
	// did anybody in the group got hit?
	_newdamage=0; 
	{
		if((damage _x) > 0.2) then {
			_newdamage =_newdamage + (damage _x); 
			// damage has increased since last round
			if (_newdamage>_lastdamage) then {
				_lastdamage = _newdamage; 
				_gothit = true;
			};
			_hitPos = getpos _x; 
		};
		sleep 0.1;
	} foreach (units _group);

	// nobody left alive, exit routine
	if (count (units _group) == 0) then {
		_exit=true;
	} else {
		// did the leader die?
		if (!alive _leader) then {
			_leader = leader _group; 
			if (isPlayer _leader) then {_exit=true};
		};
	};
	
	// current position
	_currPos = getpos _leader; 
	_currX = _currPos select 0; 
	_currY = _currPos select 1;
	
	// if the AI is a civilian we don't have to bother checking for enemy encounters
	if ((_issoldier) && ((count KRON_AllWest) > 0) && !(_exit)) then {

		// if the leader comes across another unit that's either injured or dead, go into combat mode as well. 
		// If the other person is still alive, share enemy information.
		if (_shareinfo=="SHARE") then {
			_others = KRON_AllEast - (units _group);
			{
				if (!(isNull _x) && (_leader distance _x < SHAREDIST)) then {
					_leader setBehaviour "aware"; 
					_gothit = true; 
					if ((_hitPos select 0) == 0) then { _hitPos = getPos _x};
					if (_leader knowsabout (vehicle _x) > 3) then {
						if (alive _x) then {
							_leader reveal (_knownenemy select _sharedenemy);
							(group _x) reveal (_knownenemy select _sharedenemy);
						}; 
					};
				};
				sleep 0.1;
			}forEach _others;
		};
			
		// did the group spot an enemy?
		_lastknown=_opfknowval;
		_opfknowval=0; 
		_maxknowledge=0;
		{
			_knows= _leader knowsabout (vehicle _x); 
			if ((alive _x) && (_knows > 0.2) && (_knows > _maxknowledge)) then {
				_knownenemy set [_sharedenemy,_x]; 
				_opfknowval=_opfknowval+_knows; 
				_maxknowledge=_knows;
			};
			if (!alive _x) then {KRON_AllWest = KRON_AllWest-[_x];};
			if (_maxknowledge==4) exitWith {};
			sleep 0.1;
		}foreach KRON_AllWest;
		
		_pursue=false;
		_accuracy=100;

		// opfor spotted an enemy or got shot, so start pursuit
		if (_opfknowval>_lastknown || _gothit) then {
			_leader setbehaviour "combat";
			_pursue=true;
			// make the exactness of the target dependent on the knowledge about the shooter
			_accuracy=21-(_maxknowledge*5);
		};

		_wcenemy = (_knownenemy select _sharedenemy);		
		if (isnil "_wcenemy") then {
			_pursue=false;
		} else {
			if(isnull _wcenemy) then {
				_pursue=false;
			};
		};

		// don't react to new fatalities if less than 60 seconds have passed since the last one
		if ((_react<60) && (_fightmode!="walk")) then {_pursue=false};

		if (_pursue) then	{
			// get position of spotted unit in player group, and watch that spot
			_offsx=_accuracy/2-random _accuracy; 
			_offsY=_accuracy/2-random _accuracy;
			_wcenemy = (_knownenemy select _sharedenemy);
			_targetPos = getpos _wcenemy;
			_targetPos = [(_targetPos select 0) + _offsX, (_targetPos select 1) + _offsY];
			_targetX = _targetPos select 0;
			_targetY = _targetPos select 1;
			{
				if(vehicle _x == _x) then {
					_x dowatch _targetPos;
				} else {
					_x dowatch (vehicle _wcenemy);
					_x dotarget (vehicle _wcenemy);
					_x dofire (vehicle _wcenemy);
				};
				sleep 0.1;
			} foreach (units _group);

			// also go into "combat mode"
			_leader setSpeedMode "full"; 
			_speedmode = "full";
			_leader setbehaviour "combat";
			_pause="NOWAIT";
			_waiting=0;
			
			// angle from unit to target
			_dir1 = [_currPos,_targetPos] call KRON_getDirPos;

			// angle from target to unit (reverse direction)
			_dir2 = (_dir1+180) mod 360;

			// angle from fatality to target
			_dir3 = if (_hitPos select 0!=0) then {[_hitPos,_targetPos] call KRON_getDirPos;} else {_dir1;};
			_dd = (_dir1-_dir3);
			
			// unit position offset straight towards target
			_relUX = sin(_dir1)*SAFEDIST; 
			_relUY = cos(_dir1)*SAFEDIST;

			// target position offset straight towards unit
			_relTX = sin(_dir2)*SAFEDIST; 
			_relTY = cos(_dir2)*SAFEDIST;

			// go either left or right (depending on location of fatality - or randomly if no fatality)
			_sinU=_sin90;
			_cosU=_cos90;
			_sinT=_sin270;
			_cosT=_cos270;

			if ((_dd<0) || (_dd==0 && (random 1)>0.5)) then {
				_sinU=_sin270;
				_cosU=_cos270;
				_sinT=_sin90;
				_cosT=_cos90;
			};

			// avoidance position (right or left of unit)
			_avoidX = _currX + _cosU*_relUX - _sinU*_relUY;
			_avoidY = _currY + _sinU*_relUX + _cosU*_relUY;
			_avoidPos = [_avoidX,_avoidY];
			
			// flanking position (right or left of target)
			_flankX = _targetx + _cosT*_relTX - _sinT*_relTY;
			_flankY = _targetY + _sinT*_relTX + _cosT*_relTY;
			_flankPos = [_flankX,_flankY];

			// final target position
			_attackPos = _targetPos;

			// for now we're stepping a bit to the side
			_targetPos = _avoidPos;

			if (_nofollow=="NOFOLLOW") then {
				_avoidPos = [_avoidPos,_centerpos,_rangeX,_rangeY,_areadir] call KRON_stayInside;
				_flankPos = [_flankPos,_centerpos,_rangeX,_rangeY,_areadir] call KRON_stayInside;
				_attackPos = [_attackPos,_centerpos,_rangeX,_rangeY,_areadir] call KRON_stayInside;
				_targetPos = [_targetPos,_centerpos,_rangeX,_rangeY,_areadir] call KRON_stayInside;
			};
			
			_react=0;
			_fightmode="fight";
			_timeontarget=0; 
			_fm=1;
			 if (KRON_UPS_Debug!=0) then {
				"dead" setmarkerpos _hitPos; "avoid" setmarkerpos _avoidPos; "flank" setmarkerpos _flankPos; "target" setmarkerpos _attackPos;
			};
			_newpos=true;
			// speed up the cycle duration after an incident
			if (_currcycle>=_centerposYcle) then {_currcycle=1};
		};
	}; 

	if !(_newpos) then {
		// calculate new distance
		// if we're waiting at a waypoint, no calculating necessary
		if (_waiting <= 0) then {
			// distance to target
			_dist = [_currPos,_targetPos] call KRON_distancePosSqr;
			if (_lastdist==0) then {_lastdist=_dist};
			_moved = abs(_dist-_lastdist);

			// adjust the target tolerance for fast moving vehicles
			if (_moved>_maxmove) then {
				_maxmove=_moved;
				if ((_maxmove/40) > _closeenough) then {
					_closeenough=_maxmove/40;
				}
			};

			// how much did we move in the last three cycles?
			_totmove=_moved+_lastmove1+_lastmove2;
			_damm = damage _leader;

			// is our damage changing (increasing)?
			_dammchg = abs(_damm - _lastdamm);
			
			// we're either close enough, seem to be stuck, or are getting damaged, so find a new target 
			if ((!_swimming) && ((_dist<=_closeenough) || (_totmove<.2) || (_dammchg>0.01) || (_timeontarget>ALERTTIME))) then {_makenewtarget=true;};

			// in 'attack (approach) mode', so follow the flanking path (don't make it too predictable though)
			if ((_fightmode!="walk") && (_dist<=_closeenough)) then {
				if (random 1 < 0.95) then {
					if (_flankPos select 0!=0) then {
						_targetPos=_flankPos; 
						_flankPos=[0,0]; 
						_makenewtarget=false; 
						_newpos=true;
						_fm=1;
					} else {
						if (_attackPos select 0!=0) then {
							_targetPos=_attackPos; 
							_attackPos=[0,0]; 
							_makenewtarget=false; 
							_newpos=true;
							_fm=2;
						};
					};
				};
			};

			// make new target
			if (_makenewtarget) then {
				if ((_nomove=="NOMOVE") && (_timeontarget>ALERTTIME)) then {
					if (([_currPos,_orgPos] call KRON_distancePosSqr)<_closeenough) then {
						_newpos = false;
					} else {
						_targetPos=_orgPos;
					};
				} else {
					// re-read marker position/size
					[] call _getAreaInfo;
					// find a new target that's not too close to the current position
					_targetPos=_currPos;
					_tries=0;
					while {((([_currPos,_targetPos] call KRON_distancePosSqr) < _mindist)) && (_tries<20)} do {
						_tries=_tries+1;
						// generate new target position (on the road)
						_tries=0;
						while {_tries<20} do {
							_targetPos=[_centerX,_centerY,_rangeX,_rangeY,_cosdir,_sindir,_areadir] call KRON_randomPos; 
							if (_iscar) then {
								_roadlist = _targetPos nearRoads 100;
								if (count _roadlist>0) then {
									_targetPos = getPos (_roadlist select 0);
									_tries=99;
								};
							} else {
								_tries=99;
							};
							sleep 0.1;
						};
						sleep 0.1;
					};
				};
				_avoidPos = [0,0]; _flankPos = [0,0]; _attackPos = [0,0];
				_gothit=false;
				_hitPos=[0,0,0];
				_fm=0;
				_leader setSpeedMode _orgSpeed;
				_newpos=true;
	
				// if we're waiting at patrol end points then don't create a new target right away. Keep cycling though to check for enemy encounters
				if ((_pause!="NOWAIT") && (_waiting<0)) then {_waiting = (15 + random 20)};
			};
		};
	};
	sleep 1;

	// if in water, get right back out of it again
	if (surfaceIsWater _currPos) then {
		if (_isman && !_swimming) then {
			_drydist=999;
			// look around, to find a dry spot
			for [{_a=0}, {_a<=270}, {_a=_a+90}] do {
				_dp=[_currPos,30,_a] call KRON_relPos; 
				if !(surfaceIsWater _dp) then {_targetPos=_dp};
				sleep 0.01;
			};
			_newpos=true; 
			_swimming=true;
		};
	} else {
		_swimming=false;
	};
		
	_waiting = _waiting - _currcycle;
	if ((_waiting<=0) && _newpos) then {
		// tell unit about new target position
		if (_fightmode!="walk") then {
			// reset patrol speed after following enemy for a while
			if (_timeontarget>ALERTTIME) then {
				_fightmode="walk";
				_speedmode = _orgSpeed;
				{
					_x setSpeedMode _speedmode;
					_x setBehaviour _orgMode;
					sleep 0.1;
				}forEach (units _group);
			};
			// use individual doMoves if pursuing enemy, 
			// as otherwise the group breaks up too much
			{
				_x doMove _targetPos;
				sleep 0.1;
			}forEach (units _group);
		} else {
			_group move _targetPos;
			_group setSpeedMode _speedmode;
		};

		_dist=0; 
		_moved=0; 
		_lastmove1=10; 
		_waiting=-1; 
		_newpos=false;
		_swimming=false;
		_timeontarget = 0; 
	};
	
	// move on
	_lastdist = _dist;
	_lastmove2 = _lastmove1;
	_lastmove1 = _moved;
	_lastdamm = _damm;

	// check external loop switch
	_cont = (call compile format ["KRON_UPS_%1",_npcname]);
	if (_cont==0) then {_exit=true};
	
	_makenewtarget=false;
	if ((_exit) || (count (units _group) == 0)) then {
		_loop=false;
	} else {
		// slowly increase the cycle duration after an incident
		if (_currcycle<_centerposYcle) then {_currcycle = _currcycle + 0.5};
		sleep _currcycle;
	};
};
