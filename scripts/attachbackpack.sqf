//HALOpack
//
//example:
// _nil = [this,"parachute classname"] execVM "attachbackpack.sqf"; //parachute is optional, leave "" blank for standard steerable
//

_unit = _this select 1;

haloed = true;
hintSilent "Click on the map where you'd like to HALO.";
onMapSingleClick "player setPos [(_pos select 0), (_pos select 1), 1000]; haloed = false;hint 'Close the map and dont forget to open your chute!'";
waitUntil{!haloed};
onMapSingleClick "";

if (isDedicated) exitWith {};

_pack = typeof (unitBackpack _unit);
_loadout = [player] call INS_REV_FNCT_get_loadout;
removeBackpack player;

_unit addBackpack "B_Parachute";

_nil = [_unit,_pack, _loadout] spawn {
	_unit = _this select 0;
	_pack = _this select 1;
	_loadout = _this select 2;
	
	waitUntil {animationState _unit == "para_pilot"}; //wait for parachute open

	waitUntil {isTouchingGround _unit || (getPosASL _unit) select 2 < 0.1};

	_loadout = [player, _loadout] call INS_REV_FNCT_set_loadout;
};