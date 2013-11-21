private["_dialog","_slider_alt","_slider_circle","_text_alt","_text_circle","_combo_position"];

createDialog "UAV_Settings_Dialog";
disableSerialization;

_dialog = findDisplay 2800;
_slider_alt = _dialog displayCtrl 1900;
_slider_circle = _dialog displayCtrl 1901;
_text_alt = _dialog displayCtrl 1004;
_text_circle = _dialog displayCtrl 1005;
_combo_position = _dialog displayCtrl 2100;

// Altitude slider
_slider_alt sliderSetRange [100,2000];
_slider_alt slidersetSpeed [100,100,100];
_slider_alt sliderSetPosition UAV_GVAR_alt;
_text_alt ctrlSetText format["%1",UAV_GVAR_alt];

// Circle slider
_slider_circle sliderSetRange [50,500];
_slider_circle slidersetSpeed [10,10,10];
_slider_circle sliderSetPosition UAV_GVAR_circle;
_text_circle ctrlSetText format["%1",UAV_GVAR_circle];

// Position combo
_combo_position lbAdd "Track Player";
_combo_position lbAdd "Map Click";
lbSetCurSel [2100, UAV_GVAR_position];