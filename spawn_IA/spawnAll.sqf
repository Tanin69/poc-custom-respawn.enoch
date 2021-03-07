//Définition des goroupes
private _fsl_ENI_1    = "rhs_vmf_flora_rifleman";
private _lat_ENI_1    = "rhs_vmf_flora_lat";
private _aa_ENI_1     = "rhs_vmf_flora_aa";
private _at_ENI_1     = "rhs_vmf_flora_at";
private _ass_at_ENI_1 = "rhs_vmf_flora_strelok_rpg_assist";
private _lmg_ENI_1    = "rhs_vmf_flora_junior_sergeant";
private _mg_ENI_1     = "rhs_vmf_flora_machinegunner";
private _ass_mg_ENI_1 = "rhs_vmf_flora_machinegunner_assistant";
private _gl_ENI_1     = "rhs_vmf_flora_grenadier";
private _tl_ENI_1     = "rhs_vmf_flora_sergeant";
private _sl_ENI_1     = "rhs_vmf_flora_officer_armored";
private _medic_ENI_1  = "rhs_vmf_flora_medic";

GROUPE_ENI = [
	[_sl_ENI_1, _medic_ENI_1, _tl_ENI_1, _at_ENI_1, _ass_at_ENI_1, _fsl_ENI_1, _tl_ENI_1, _mg_ENI_1, _ass_mg_ENI_1, _tl_ENI_1, _gl_ENI_1]
];

//Spawn des patrouilles
["Vincinity_1", [3], GROUPE_ENI, opfor] spawn int_fnc_spawnRdmPatrols;
["Vincinity_2", [3], GROUPE_ENI, opfor] spawn int_fnc_spawnRdmPatrols;
["Vincinity_3", [3], GROUPE_ENI, opfor] spawn int_fnc_spawnRdmPatrols;
["Vincinity_3", [3], GROUPE_ENI, opfor] spawn int_fnc_spawnRdmPatrols;
["Away_1", [10], GROUPE_ENI, opfor] spawn int_fnc_spawnRdmPatrols;
["Away_2", [10], GROUPE_ENI, opfor] spawn int_fnc_spawnRdmPatrols;
["Away_3", [10], GROUPE_ENI, opfor] spawn int_fnc_spawnRdmPatrols;
["Away_4", [10], GROUPE_ENI, opfor] spawn int_fnc_spawnRdmPatrols;

