_power_id = 'power_gravity';
if(player getVariable [_power_id, false]) exitWith {};

// Init functions
call compileFinal preprocessFileLineNumbers "functions\powers\gravity\functions.sqf";

// Power activated!
player setVariable [_power_id, true, true];


// PARAMS HERE!
params [
	['_cooldown', 120, [0]],
	['_distance', 300, [0]]
];
power_gravity_cooldown = _cooldown;
power_gravity_distance = _distance;


_power_id spawn {
	_displayName = "Inverser la gravité";
	[ 
		_this,
		power_gravity_cooldown,
		{ call power_gravity_effect },
		_displayName,
		{ call power_gravity_can_gravity },
		{ call power_gravity_show_name }
	] call power_with_cooldown_init;
};

[
	_power_id, 
	"Pouvoir d'anti gravité", 
	"Votre pouvoir vous pouvez par le pouvoir de votre volonté bloquer une cible dans un mouvement perpétuel.
	<br />
	<br />Portée :" + (
		power_gravity_distance call secure_meter_to_text
	) + " maximum
	<br />Cible : Véhicules et humains
	<br />Cooldown : " + (
		power_gravity_cooldown call seconde_to_text
	)
] call common_power_description_init;
