/* Saute à une heure donnée et choisit un type de brume */

params [
	"_timeToSkipTo",
	["_fog","NOFOG",[""]]
];

[0,"BLACK",3] call BIS_fnc_fadeEffect;  

switch _fog do {
	case "NOFOG": {
		[0, [0, 0, 0]] remoteExecCall ["setFog", 2] ;
	};
	case "SEAFOG": {
		[0, [0.8, 0.2, 0]] remoteExecCall ["setFog", 2];
	};
	case "MOUTAINFOG": {
		[0, [0.7, -0.5, 70]] remoteExecCall ["setFog", 2];
	};
};

[(_timeToSkipTo - daytime + 24 ) % 24] remoteExecCall ["skipTime", 2];

[1,"BLACK",3] call BIS_fnc_fadeEffect;
