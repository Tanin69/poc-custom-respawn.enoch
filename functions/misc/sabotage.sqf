/*Simule un sabotage par les résistants sur une des trois zones*/

//Choisit la zone de sabotage
private _zoneSabotage = selectRandom ["mrkSabotage_CampNowhere", "mrkSabotage_CampCastle", "mrkSabotage_FOBEddie"];

//Définit le temps avant le sabotage
private _delaySabotage = selectRandom [10,15,20,25,30];
private _str = "";

//Informe les joueurs de la zone de sabotage et du délai avant l'opération
switch _zoneSabotage do {
	case "mrkSabotage_CampNowhere": {
		_str = "le Camp Nowhere";
	};
	case "mrkSabotage_FOBEddie": {
		_str = "la FOB Eddie";
	};
	case "mrkSabotage_CampCastle": {
		_str = "le Camp Castle";
	};
};

"Un prisonnier a rejoint la cache et a pu contacter les guerrilleros.\n\nOn nous informe qu'ils procéderont à une opération de sabotage sur\n " + _str + ".\n\n Elle aura lieu dans " + str(_delaySabotage) + " minutes." remoteExec ["hint"];

//Dort en attendant le moment du sabotage
sleep (_delaySabotage * 60);
//sleep _delaySabotage;

//Fait exploser des charges dans la zone de sabotage 
for [{ _i = 0 }, { _i < 6 }, { _i = _i + 1 }] do {
	private _posBoum = [[_zoneSabotage]] call BIS_fnc_randomPos;
	private _boum = "SatchelCharge_Remote_Ammo_Scripted" createVehicle _posBoum;
	_boum setDamage 1;
	sleep random 60;
}
