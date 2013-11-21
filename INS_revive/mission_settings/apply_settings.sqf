/*
 * Author:      Sinky
 * Date:        1st February 2011
 * Last Edited: 3rd February 2011
 * Version:     1.0
 */

#include "dialog\defines.sqf"
disableSerialization;

if (local player) then {

	// Grab access to the controls
	_dialog = findDisplay SINKY_DIALOG;
	_viewDistanceText = _dialog displayCtrl SINKY_VIEW_DISTANCE_TEXT;
	_viewDistance = _dialog displayCtrl SINKY_VIEW_DISTANCE;
	_grassSetting = _dialog displayCtrl SINKY_GRASS_SETTING;
	
	// Get the view distance selection and calculate
	_selectedViewDistance = lbCurSel _viewDistance;
	
	// If they selected a view distance, let's change it
	if (_selectedViewDistance >= 0) then {
	
		// Get the actual selected view distance
		_selectedViewDistance = lbText[SINKY_VIEW_DISTANCE, _selectedViewDistance];
		
		// Set the view distance
		setViewDistance (parseNumber _selectedViewDistance);
		
		// Tell the player about the change
		hint format ["View distance: %1", _selectedViewDistance];
		
	};
	
	// Get the grass selection and calculate
	_selectedGrass = lbCurSel _grassSetting;
	
	// If they selected a grass change, let's change it
	if (_selectedGrass >= 0) then {
	
		// Get the text representation of the selection made
		_selectedGrass = lbText[SINKY_GRASS_SETTING, _selectedGrass];
		
		// Change the grass accordingly
		switch (_selectedGrass) do {
		
			case "None": {
				
				setTerrainGrid 50;
				
			};
			
			case "Medium": {
			
				setTerrainGrid 12.5;
			
			};
			
			case "Full": {
			
				setTerrainGrid 3.125;
			
			};
		
		};
		
	};
	
	// Close the dialog, we don't need the controls anymore
	closeDialog 0;
	sleep 3;
	hint "";

};