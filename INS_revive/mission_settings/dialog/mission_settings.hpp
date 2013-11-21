/*
 * Author:      Sinky
 * Date:        1st February 2011
 * Last Edited: 1st February 2011
 * Version:     1.0
 */

#include "defines.sqf"

class MissionSettings {

	idd = SINKY_DIALOG;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "[] execVM 'INS_revive\mission_settings\populate.sqf'";
	
	class controlsBackground {
		
		class MainBG : Sinky_RscPicture {
		
			idc = -1;
			text = "\ca\ui\data\ui_background_controlers_ca.paa";
			
			moving = true;
			
			x = 0.325; y = 0.1;
			w = 0.55; h = 0.3;
		
		};
		
		class MainTitle : Sinky_RscText {
		
			idc = -1;
			text = "Mission Display Settings";
			
			x = 0.33; y = 0.103;
			w = 0.3; h = 0.05;
		
		};
		
		class CreatorText : Sinky_RscText {
		
			idc = -1;
			text = "Created by Sinky";
			sizeEx = 0.02;
			
			x = 0.58; y = 0.3;
			w = 0.3; h = 0.05;
		
		};
		
	};
	
	class controls {
		
		class ViewDistanceTitle : Sinky_RscText {
		
			idc = SINKY_VIEW_DISTANCE_TEXT;
			text = "";
			sizeEx = 0.02;
			
			x = 0.33; y = 0.18;
			w = 0.3; h = 0.05;
		
		};
		
		class ViewDistanceSelection : Sinky_RscCombo {
		
			idc = SINKY_VIEW_DISTANCE;
			
			x = 0.59; y = 0.195;
			w = 0.12; h = 0.023;
		
		};
		
		class GrassSelectionTitle : Sinky_RscText {
		
			idc = -1;
			text = " Desired Grass Setting: ";
			sizeEx = 0.02;
			
			x = 0.33; y = 0.23;
			w = 0.3; h = 0.05;
		
		};
		
		class GrassSelection : Sinky_RscCombo {
		
			idc = SINKY_GRASS_SETTING;
			
			x = 0.59; y = 0.245;
			w = 0.12; h = 0.023;
		
		};
		
		class CloseButton : Sinky_RscButton {
			
			text = "Close";
			onButtonClick = "closeDialog 0;";
			
			x = 0.34; y = 0.345;
			w = 0.125; h = 0.05;
			
		};
		
		class AcceptButton : Sinky_RscButton {
		
			text = "Accept";
			onButtonClick = "[] execVM 'INS_revive\mission_settings\apply_settings.sqf';";
			
			x = 0.59; y = 0.345;
			w = 0.125; h = 0.05;
			
		};
		
	};

};