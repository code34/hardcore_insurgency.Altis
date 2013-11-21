
private ["_itemsToClear","_obj","_rad","_delay"];
_obj = getMarkerPos "respawn_west"; // get spawn - might as well
_rad = 17000;  //  radius outwards from center point to clear items.
_delay = 30; // amount of time in-between clean-ups
 
while {true} do
{
	sleep _delay;
	debugMessage = "Clearing items from spawn...";
	publicVariable "debugMessage";
	_itemsToClear = nearestObjects [_obj,["weaponholder"],_rad];
	{
		deleteVehicle _x;
	} forEach _itemsToClear;
	debugMessage = "Items cleared.";
	publicVariable "debugMessage";
};