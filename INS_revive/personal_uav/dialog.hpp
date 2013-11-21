#define GUI_GRID_X	(0)
#define GUI_GRID_Y	(0)
#define GUI_GRID_W	(0.025)
#define GUI_GRID_H	(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)

class UAV_Settings_Dialog {
	idd = 2800;
	enableSimulation = true;
	
	class Controls
	{
		class UAV_Title: UAV_RscText
		{
			idc = 1000;
			text = "UAV Settings"; //--- ToDo: Localize;
			x = 9 * GUI_GRID_W + GUI_GRID_X;
			y = 5.44 * GUI_GRID_H + GUI_GRID_Y;
			w = 23 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0.8};
		};
		class UAV_Back: UAV_RscText
		{
			idc = 1001;
			x = 9 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 23 * GUI_GRID_W;
			h = 9.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0.35};
		};
		class UAV_Text_Alt_Title: UAV_RscText
		{
			idc = 1002;
			text = "Altitude (in meters)"; //--- ToDo: Localize;
			x = 9.5 * GUI_GRID_W + GUI_GRID_X;
			y = 7 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class UAV_Text_Circle_Title: UAV_RscText
		{
			idc = 1003;
			text = "Radius of the circular movement (in meters)"; //--- ToDo: Localize;
			x = 9.5 * GUI_GRID_W + GUI_GRID_X;
			y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 21.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class UAV_Slider_Alt: UAV_RscXSliderH
		{
			idc = 1900;
			onSliderPosChanged = "[_this select 1] call FNC_alt_onsliderchange";
			tooltip = "Altitude";
			x = 10 * GUI_GRID_W + GUI_GRID_X;
			y = 8.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class UAV_Text_Alt: UAV_RscText
		{
			idc = 1004;
			x = 27 * GUI_GRID_W + GUI_GRID_X;
			y = 8.34 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class UAV_Slider_Circle: UAV_RscXSliderH
		{
			idc = 1901;
			onSliderPosChanged = "[_this select 1] call FNC_circle_onsliderchange";
			tooltip = "Circular movement";
			x = 10 * GUI_GRID_W + GUI_GRID_X;
			y = 12 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class UAV_Text_Circle: UAV_RscText
		{
			idc = 1005;
			x = 27 * GUI_GRID_W + GUI_GRID_X;
			y = 11.84 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class UAV_Text_Position_Title: UAV_RscText
		{
			idc = 1006;
			text = "Position"; //--- ToDo: Localize;
			x = 9.5 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscCombo_2100: UAV_RscCombo
		{
			idc = 2100;
			x = 14.5 * GUI_GRID_W + GUI_GRID_X;
			y = 14.16 * GUI_GRID_H + GUI_GRID_Y;
			w = 9.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class UAV_Button_OK: UAV_RscButtonMenu
		{
			idc = 2400;
			text = "OK"; //--- ToDo: Localize;
			onButtonClick = "[] call FNC_apply_settings; closeDialog 0;";
			x = 24.5 * GUI_GRID_W + GUI_GRID_X;
			y = 16.11 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class UAV_Button_Cancel: UAV_RscButtonMenu
		{
			idc = 2401;
			text = "Cancel"; //--- ToDo: Localize;
			onButtonClick = "closeDialog 0;";
			x = 9 * GUI_GRID_W + GUI_GRID_X;
			y = 16.11 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
	};
};