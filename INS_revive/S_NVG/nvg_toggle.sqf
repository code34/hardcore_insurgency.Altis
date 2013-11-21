// S_NVG v0.7.090708
if (S_NVG_settingon) then
{
	hint "NV auto-adjust enabled";
	setAperture -1;
	S_NVG_settingon = false;
	(_this select 0) removeAction S_NVG_nvgaction;
	S_NVG_nvgaction = (vehicle player) addAction [S_NVG_disable_title, "INS_revive\S_NVG\nvg_toggle.sqf","",-1,false];
}
else
{
	hint parseText format ["<t align='center'>NV auto-adjust disabled.</t><br/><t color='#FFCF11'>'%1'</t> to increase<br/><t color='#FFCF11'>'%2'</t> to decrease sensitivity.",keyName S_NVG_sensitivity_up,keyName S_NVG_sensitivity_down];	
	setAperture (S_NVG_sensitivity);
	S_NVG_settingon = true;
	(_this select 0) removeAction S_NVG_nvgaction;
	S_NVG_nvgaction = (vehicle player) addAction [S_NVG_enable_title, "INS_revive\S_NVG\nvg_toggle.sqf","",-1,false];
};