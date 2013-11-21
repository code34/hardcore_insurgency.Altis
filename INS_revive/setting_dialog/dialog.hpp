////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by naong, v1.062, #Labycu)
////////////////////////////////////////////////////////
#define GUI_GRID_X	(0)
#define GUI_GRID_Y	(0)
#define GUI_GRID_W	(0.025)
#define GUI_GRID_H	(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)

class INS_Settings_Dialog {
	idd = 2700;
	enableSimulation = true;
	
	class Controls
	{
		class INS_Title: INS_RscText
		{
			idc = 1000;
			text = "INS_revive Settings"; //--- ToDo: Localize;
			x = 14.5 * GUI_GRID_W + GUI_GRID_X;
			y = 7.92 * GUI_GRID_H + GUI_GRID_Y;
			w = 12 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0.7};
		};
		class INS_Back: INS_RscText
		{
			idc = 1001;
			x = 14.5 * GUI_GRID_W + GUI_GRID_X;
			y = 9 * GUI_GRID_H + GUI_GRID_Y;
			w = 12 * GUI_GRID_W;
			h = 5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0.35};
		};
		class INS_Button_Display: INS_RscButton
		{
			idc = 1600;
			text = "Display"; //--- ToDo: Localize;
			x = 15.5 * GUI_GRID_W + GUI_GRID_X;
			y = 9.46 * GUI_GRID_H + GUI_GRID_Y;
			w = 10 * GUI_GRID_W;
			h = 1.15733 * GUI_GRID_H;
			action = "[] call FNC_check_display";
		};
		class INS_Button_Group: INS_RscButton
		{
			idc = 1601;
			text = "Squad Management"; //--- ToDo: Localize;
			x = 15.5 * GUI_GRID_W + GUI_GRID_X;
			y = 10.84 * GUI_GRID_H + GUI_GRID_Y;
			w = 10 * GUI_GRID_W;
			h = 1.19667 * GUI_GRID_H;
			action = "[] call FNC_check_squad";
		};
		class INS_Button_UAV: INS_RscButton
		{
			idc = 1602;
			text = "UAV Settings"; //--- ToDo: Localize;
			x = 15.55 * GUI_GRID_W + GUI_GRID_X;
			y = 12.30 * GUI_GRID_H + GUI_GRID_Y;
			w = 9.95238 * GUI_GRID_W;
			h = 1.15734 * GUI_GRID_H;
			action = "[] call FNC_check_uav";
		};
		class INS_Button_OK: INS_RscButtonMenu
		{
			idc = 2400;
			text = "Close"; //--- ToDo: Localize;
			x = 20.5 * GUI_GRID_W + GUI_GRID_X;
			y = 14.16 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			action = "closeDialog 0";
		};
	};
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
