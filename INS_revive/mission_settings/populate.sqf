/*
 * Author:      Sinky
 * Date:        1st February 2011
 * Last Edited: 1st February 2011
 * Version:     1.0
 */

#include "dialog\defines.sqf";
disableSerialization;

if (local player) then {

	// Grab access to the controls
	_dialog = findDisplay SINKY_DIALOG;
	_viewDistanceText = _dialog displayCtrl SINKY_VIEW_DISTANCE_TEXT;
	_viewDistance = _dialog displayCtrl SINKY_VIEW_DISTANCE;
	_grassSetting = _dialog displayCtrl SINKY_GRASS_SETTING;

	// Display the current view distance
	_viewDistanceText ctrlSetText format [" View Distance ( Current: %1 )", round(viewDistance)];

	// Populate the view distance list box
	_viewDistanceIndex = _viewDistance lbAdd "1000";
	_viewDistanceIndex = _viewDistance lbAdd "1500";
	_viewDistanceIndex = _viewDistance lbAdd "2000";
	_viewDistanceIndex = _viewDistance lbAdd "2500";
	_viewDistanceIndex = _viewDistance lbAdd "3000";
	_viewDistanceIndex = _viewDistance lbAdd "3500";
	_viewDistanceIndex = _viewDistance lbAdd "4000";
	_viewDistanceIndex = _viewDistance lbAdd "4500";
	_viewDistanceIndex = _viewDistance lbAdd "5000";
	
	// Populate the grass setting list box
	_grassSettingIndex = _grassSetting lbAdd "None";
	_grassSettingIndex = _grassSetting lbAdd "Medium";
	_grassSettingIndex = _grassSetting lbAdd "Full";
	
	// Set default value
	lbSetCurSel [SINKY_VIEW_DISTANCE, 2];
	lbSetCurSel [SINKY_GRASS_SETTING, 0];
};