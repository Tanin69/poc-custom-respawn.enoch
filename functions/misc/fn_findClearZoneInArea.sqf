/*
	Author: [GIE] Gavin "Morbakos" Sertix
	
	Description:
		Retourne une position dans un marqueur à condition que cette dernière n'ait pas d'hostile dans un rayon défini.
	
	Parameter(s):
		1: STRING - Le marqueur
		2: NUMBER - Rayon dans lequel il ne doit y avoir aucun hostile.
		3: SIDE - Side contre lequel il ne doit pas y avoir d'hostile dans la zone
		4: ARRAY (optionnal, default: ["Man", "Tank"]) - Type d'entités à rechercher dans le rayon (paramètre 2)
	
	Returns:
		Array - position
*/

params [
	["_marker", "", [""]], 
	["_clearRadius", -1, [0]], 
	["_side", sideEmpty, [opfor]], 
	["_searchType", ["Man", "Tank"], [[]]]
];


// Input check
if (_marker == "") exitWith {
	hint "Le marqueur doit être défini";
};

if (_clearRadius < 0) exitWith {
	hint "Le rayon doit être défini";
};

if (_side == sideEmpty) exitWith {
	hint "Le side doit être défini";
};

// Do the job
private _pos = [ 
	[_marker],
	["water"],
	{
		private _liste = _this nearEntities [_searchType, _clearRadius];
		private _resultat = [];
		
		{
			private _entity = _x;
			private _eSide = side _entity;
			if ( ([_eSide, _side] call BIS_fnc_sideIsEnemy) && (alive _entity) && (((nearestBuilding _entity) distance2D _entity) > 3) ) then {
				_resultat pushBack _entity;
			};
		} forEach _liste;

		count _resultat == 0;
	}
] call BIS_fnc_randomPos;
_pos;