#define INS_DIALOG_ID		(2700)
#define INS_CTRL_FRAME_ID	(1001)
#define INS_CTRL_BTN1_ID	(1600)
#define INS_CTRL_BTN2_ID	(1601)
#define INS_CTRL_BTN3_ID	(1602)
#define INS_CTRL_BTN_OK_ID	(2400)

private ["_count","_dialog","_btn1","_btn2","_btn3","_btnOK","_btn1_pos","_btn2_pos","_btn3_pos","_btnOK_pos","_frame","_frame_pos"];

createDialog "INS_Settings_Dialog";
disableSerialization;

_dialog = findDisplay INS_DIALOG_ID;
_btn1 = _dialog displayCtrl INS_CTRL_BTN1_ID;
_btn2 = _dialog displayCtrl INS_CTRL_BTN2_ID;
_btn3 = _dialog displayCtrl INS_CTRL_BTN3_ID;
_btnOK = _dialog displayCtrl INS_CTRL_BTN_OK_ID;
_frame = _dialog displayCtrl INS_CTRL_FRAME_ID;
_btn1_pos = ctrlPosition _btn1;
_btn2_pos = ctrlPosition _btn2;
_btn3_pos = ctrlPosition _btn3;
_btnOK_pos = ctrlPosition _btnOK;
_frame_pos = ctrlPosition _frame;

_count = 0;
if (INS_REV_CFG_taw_view) then {
	_count = _count + 1;
};

if (INS_REV_CFG_squad_management) then {
	_count = _count + 1;
	if (_count == 0) then {
		ctrlShow [INS_CTRL_BTN1_ID, false];
		_btn2 ctrlSetPosition _btn1_pos;
		_frame_pos ctrlSetPosition [_frame_pos select 0, _frame_pos select 1, _frame_pos select 2, (_frame_pos select 3) - 10];
		_btnOK ctrlSetPosition [_btnOK select 0, (_btnOK select 1) - 10, _btnOK select 2, _btnOK select 3];
	};
};

if (INS_REV_CFG_uav && INS_REV_CFG_uav_setting_dialog && GVAR_is_arma3) then {
	_count = _count + 1;
	switch (_count) do {
		case 0: {
			ctrlShow [INS_CTRL_BTN1_ID, false];
			ctrlShow [INS_CTRL_BTN2_ID, false];
			_btn3 ctrlSetPosition _btn1_pos;
			_frame_pos ctrlSetPosition [_frame_pos select 0, _frame_pos select 1, _frame_pos select 2, (_frame_pos select 3) - 20];
			_btnOK ctrlSetPosition [_btnOK select 0, (_btnOK select 1) - 20, _btnOK select 2, _btnOK select 3];
		};
		case 1: {
			if (INS_REV_CFG_taw_view) then {
				ctrlShow [INS_CTRL_BTN1_ID, false];
			} else {
				ctrlShow [INS_CTRL_BTN2_ID, false];
			};
			_btn3 ctrlSetPosition _btn2_pos;
			_frame_pos ctrlSetPosition [_frame_pos select 0, _frame_pos select 1, _frame_pos select 2, (_frame_pos select 3) - 10];
			_btnOK ctrlSetPosition [_btnOK select 0, (_btnOK select 1) - 10, _btnOK select 2, _btnOK select 3];
		};
	};
};
