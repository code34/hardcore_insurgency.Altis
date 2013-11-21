_center = _this select 0;
_range = _this select 1;

if (isServer) then 
{
	While {true} do 
	{
		_garbage = nearestObjects [_center,["ReammoBox","BagBase","WeaponHolderSimulated"],_range];
		
		if ((count _garbage)>0) then 
		{
			{
				if (({isPlayer _x}count (nearestObjects [_x,["CAManBase"],5]))==0) then 
				{
					deleteVehicle _x;
				};
			
			}ForEach _garbage;
		};	
		sleep 240;
	};
};