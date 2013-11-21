// S_NVG v0.7.090708 (modified by naong)

private ["_S_NVG_on_delayed","_wasvehicle","_incar","_oldplayer"];
call compile preProcessFileLineNumbers "INS_revive\S_NVG\functions.sqf";

//["S_NVG_keypressed","_this call S_NVG_keypressed;"] call S_displayEventHandler_Keydown_add;

// Set action title
S_NVG_enable_title = "<t color='#5bff41'>Enable NV auto-adjust</t>";
S_NVG_disable_title = "<t color='#5bff41'>Disable NV auto-adjust</t>";

// Wait until main scrren
waitUntil { !isNull(findDisplay 46); };
sleep 0.1;

// Add keydown event handler
S_NVG_keyhandle = (findDisplay 46) displayAddEventHandler ["KeyDown","_this call S_NVG_keypressed"];

// Set default config
S_NVG_sensitivity = 1.5; // default NV sensitivity setting (lower is brighter)
S_NVG_on = false;
player action ["NVGOGGLESOFF", player];
S_NVG_settingon = false;
//S_NVG_settingon = (getNumber(configFile>> "S_NVG_Settings" >> "Default_Setting") == 1);  // the default setting - false for autoadjust, true for fixed - set to false due to arma2 nvg actually being fairly decent

// Set S_NVG shortcut key
S_NVG_sensitivity_up = 201;
S_NVG_sensitivity_down = 209;

/*  Keycodes are listed below

ESC = 1 
F1 = 59 
F2 = 60 
F3 = 61 
F4 = 62 
F5 = 63 
F6 = 64 
F7 = 65 
F8 = 66 
F9 = 67 
F10 = 68 
F11 = 87 
F12 = 88 
PRINT = 183 
SCROLL = 70 
PAUSE = 197 
^ = 41 
1 = 2 
2 = 3 
3 = 4 
4 = 5 
5 = 6 
6 = 7 
7 = 8 
8 = 9 
9 = 10 
0 = 11 
©¬ = 12 
¢¥ = 13 
# = 43 
< = 86 
, = 51 
. = 52 
- = 53 
+ = NOT DEFINED 
POS1 = 199 
TAB = 15 
ENTER = 28 
DELETE = 211 
BACKSPACE = 14 
INSERT = 210 
END = 207 
PAGEUP = 201 
PAGEDOWN = 209 
CAPS = 58 
A = 30 
B = 48 
C = 46 
D = 32 
E = 18 
F = 33 
G = 34 
H = 35 
I = 23 
J = 36 
K = 37 
L = 38 
M = 50 
N = 49 
O = 24 
P = 25 
Q = 16 
U = 22 
R = 19 
S = 31 
T = 20 
V = 47 
W = 17 
X = 45 
Y = 44 
Z = 21 
SHIFTL = 42 
SHIFTR = 54 
UP = 200 
DOWN = 208 
LEFT = 203 
RIGHT = 205 
NUM_0 = 82 
NUM_1 = 79 
NUM_2 = 80 
NUM_3 = 81 
NUM_4 = 75 
NUM_5 = 76 
NUM_6 = 77 
NUM_7 = 71 
NUM_8 = 72 
NUM_9 = 73 
NUM_+ = 78 
NUM = 69 
NUM_/ = 181 
NUM_* = 55 
NUM_- = 74 
NUM_, = 83 
NUM_ENTER = 156 
STRGL = 29 
STRGR = 157 
WINL = 220 
WINR = 219 
ALT = 56 
SPACE = 57 
ALTGR = 184 
APP = 221
*/

// Start main code
[] spawn {
	// Set variable
	//_lastdaytime = daytime;
	_S_NVG_on_delayed = false;
	_wasvehicle = (vehicle player);
	_incar = false;
	_oldplayer = player;
	
	// Start mail loop
	while { true } do {
		sleep 1;
		
		// Remove keydown evnet handler
		(findDisplay 46) displayRemoveEventHandler ["KeyDown",S_NVG_keyhandle];
		S_NVG_keyhandle = (findDisplay 46) displayAddEventHandler ["KeyDown","_this call S_NVG_keypressed"];
		
		////////////////////////////////////
		//// switch code
		////////////////////////////////////
		if (S_NVG_on and !_S_NVG_on_delayed) then {		// enable
			sleep 0.1;
			player action ["NVGOGGLES", player];
			//cutText [" ","PLAIN"];
			//cutText [" ","BLACK IN",0.5];
			_S_NVG_on_delayed = true;
			if (!isNil "S_NVG_nvgaction") then {
				(_wasvehicle) removeAction S_NVG_nvgaction;		// just in case we left our tail in the door
				(vehicle player) removeAction S_NVG_nvgaction;
			};
			if (S_NVG_settingon) then	{
				S_NVG_nvgaction = (vehicle player) addAction [S_NVG_enable_title, "INS_revive\S_NVG\nvg_toggle.sqf","",-1,false];
			} else {
				S_NVG_nvgaction = (vehicle player) addAction [S_NVG_disable_title, "INS_revive\S_NVG\nvg_toggle.sqf","",-1,false];
			};
		};
		
		if (!S_NVG_on and _S_NVG_on_delayed) then {		// disable
			if (!isNil "S_NVG_nvgaction") then {
				(_wasvehicle) removeAction S_NVG_nvgaction;
			};
			sleep 0.1;
			//cutText [" ","PLAIN"];
			//cutText [" ","BLACK IN",2];
			player action ["NVGOGGLESOFF", player];
			player action ["NVGOGGLESOFF", player];
			_S_NVG_on_delayed = false;
		};
		////////////////////////////////////
		//// end of switch code
		////////////////////////////////////
		
		if (S_NVG_on and S_NVG_settingon) then {
			//time and date code go here
			
			setAperture (S_NVG_sensitivity);
		};
		if (S_NVG_on) then {
			////////////////////////////////////
			//// vehicle code
			////////////////////////////////////
			if ((!(vehicle player == player) and !(_incar)) or ((vehicle player == player) and (_incar))) then {
				if (!isNil "S_NVG_nvgaction") then {
					(_wasvehicle) removeAction S_NVG_nvgaction;		// just in case we left our tail in the door
					(vehicle player) removeAction S_NVG_nvgaction;
				};
				if (S_NVG_settingon) then {
					S_NVG_nvgaction = (vehicle player) addAction [S_NVG_enable_title, "INS_revive\S_NVG\nvg_toggle.sqf","",-1,false];
				} else {
					S_NVG_nvgaction = (vehicle player) addAction [S_NVG_disable_title, "INS_revive\S_NVG\nvg_toggle.sqf","",-1,false];
				};
			};
			_incar = !(vehicle player == player);
			_wasvehicle = (vehicle player);
			////////////////////////////////////
			//// end of vehicle code
			////////////////////////////////////
			////////////////////////////////////
			//// disabletrap code
			////////////////////////////////////
			if (																// end the party if..
				!([player] call FNC_has_nvg)		// if player drops NVG
				or
				!(alive player)										// if player dies
				//or				// doesn't work.. and i don't care about this check enough to see what's wrong
				//((abs ((daytime) -_lastdaytime)) > 0.001)	// time has changed by more than a thousandth of an hour
				or
				!(player == _oldplayer)						// he's somebody else! :O
				or						// hotfix
				!(isPlayer _oldplayer)			// hotfix
			) then {
				_this call S_NVG_offbutton;
				if (!isNil "S_NVG_nvgaction") then {
					(vehicle _oldplayer) removeAction S_NVG_nvgaction;		// remove action on teamswitch  hotfix
				};
			};
			//_lastdaytime = daytime;
			_oldplayer = player;
			////////////////////////////////////
			//// end of disabletrap code
			////////////////////////////////////
			
			//debug text
			//hint format ["_yeararc:%1 player:%2 hour:%3 aperture:%4 _hours_minutes:%5 _aperture_summer:%6 _aperture_winter:%7, vehicle:%8,isinvehicle: %9 daytime: %10 months:%11 _summeraperture:%12 _winteraperture:%13",_yeararc,player,_hour,S_NVG_sensitivity, _hours_minutes,_aperture_summer select _hour,_aperture_winter select _hour, vehicle player, (!(vehicle player == player)), (daytime),_months,_summeraperture , _winteraperture];
		};
	};
};