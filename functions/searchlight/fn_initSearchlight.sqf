/* Initialise les projecteurs lumineux CUP_X_SearchLight_static_XXX */

params [
	["_searchlightClassNames",["CUP_B_SearchLight_static_ACR","CUP_B_SearchLight_static_BAF_DDPM","CUP_B_SearchLight_static_BAF_WDL","CUP_B_SearchLight_static_BAF_MPT","CUP_B_SearchLight_static_GER_Fleck","CUP_B_SearchLight_static_GER","CUP_B_SearchLight_static_CDF","CUP_B_SearchLight_static_HIL","CUP_B_SearchLight_static_US","CUP_b_SearchLight_static_USMC","CUP_O_SearchLight_static_RU","CUP_O_SearchLight_static_ChDKZ","CUP_O_SearchLight_static_SLA","CUP_O_SearchLight_static_TK","CUP_O_SearchLight_static_TK_INS","CUP_I_SearchLight_static_NAPA","CUP_I_SearchLight_static_RACS","CUP_I_SearchLight_static_TK_GUE","CUP_I_SearchLight_static_UN"]],
	["_nightTimeHours", [18.45, 6]] 
];


if !(isServer) exitWith {};

private _tbSearchlights = []; //Tableau de tous les projecteurs de la classe requise
private _tbManagedSearchlights = []; //Tableau des projecteurs à gérer par le script

{

	private _tbTmp = allMissionObjects _x;
	_tbSearchlights = _tbSearchlights + _tbTmp;

} forEach _searchlightClassNames;


{

	//Pour chaque projecteur, s'assure qu'il n'est pas exclu du script (this setVariable ["searchlight", false]) et qu'il y a une IA qui contrôle le projecteur
	private _isManagedSearchlight = _x getVariable ["searchlight", true];
	if ((_isManagedSearchlight) && !(isNull (gunner _x))) then {
		//Ajoute le projecteur dans le tableau des projecteurs à gérer
		_tbManagedSearchlights pushBack _x;
		//Pour le projecteur à gérer, ajoute un marqueur de zone pour un balayage aléatoire	(marqueur local uniquement)
		private _sufMrkName = random 10000;
		private _prefMrkName = random 10000;
		private _mrkName = "tan_mrkSearchlight_" + str _prefMrkName + "_" +str _sufMrkName;
		private _angle = direction (gunner _x);
		private _mrk = createMarkerLocal [_mrkName, position (gunner _x)];
		_mrk setMarkerDirLocal _angle;
		_mrk setMarkerSizeLocal [80, 120];
		_mrk setMarkerShapeLocal "ELLIPSE";
		_mrk setMarkerBrushLocal "Border";
		_mrk setMarkerColorLocal "colorWhite";
		_x setVariable ["searchlightArea", _mrk];
		//systemChat str (_x getVariable "searchlightArea");
	};

} forEach _tbSearchlights;

private _searchlightIsOn = false;
//Vérifie toutes les 5 minutes si on est dans la tranche horaire définie et, si oui, active les projecteurs
while {true} do {

	if ((daytime > (_nightTimeHours#0)) || (daytime > 0 && daytime < (_nightTimeHours#1))) then {
		if !(_searchlightIsOn) then {
			_searchlightIsOn = true;
			{
				private _watchMrk = _x getVariable "searchlightArea";
				[_x, true, _watchMrk] spawn int_fnc_searchlight;
				//[_x, true, _watchMrk] execVM "functions\searchlight\fn_searchlight.sqf";
			} forEach _tbManagedSearchlights;
		};
	} else {
		if (_searchlightIsOn) then {
			//On éteint les projecteurs s'ils ont été allumés et qu'on est en dehors de la tranche horaire définie
			_searchlightIsOn = false;
			{
				[_x, false] spawn int_fnc_searchlight;
				//[_x, false] execVM "functions\searchlight\fn_searchlight.sqf";
			} forEach _tbManagedSearchlights;
		};
	};
	sleep 15;
	//sleep 300;
};
