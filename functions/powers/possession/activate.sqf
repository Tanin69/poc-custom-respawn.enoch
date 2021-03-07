_power_id = 'power_possession';
if(player getVariable [_power_id, false]) exitWith {};

// Init functions
call compileFinal preprocessFileLineNumbers "functions\powers\possession\functions.sqf";

// Power activated!
player setVariable [_power_id, true, true];


// PARAMS HERE!
params [
	['_cooldown', 120, [0]]
];
power_possession_cooldown = _cooldown;
power_possession_ref_player = player;
_displayName = "Posséder";

[ 
	_power_id,
	power_possession_cooldown,
	{ call power_possession_effect },
	_displayName,
	{ call power_possession_can_possession },
	nil,
	{ call power_possession_show_action }
] call power_with_cooldown_init;


[_displayName, _power_id] spawn {
	params ['_displayName', '_power_id'];
	// _power_id call power_possession_cancel_init;
	_displayName call power_possession_ui_init;
};


[
	_power_id, 
	"Pouvoir de possession", 
	"Votre pouvpoir vous permet de posséder des humains pour contrôler leur mouvement.
	<br /> Le contrôle complet d'une personne jusqu'au plus petit orteille, attention tout de même votre corps d'origine reste vulnérable.
	<br />
	<br />Portée : 10 kilomètre
	<br />Cible : Humains
	<br />Cooldown : " + (
		power_possession_cooldown call seconde_to_text
	)
] call common_power_description_init;
