_power_id = 'power_absolute_knowledge';
if(player getVariable [_power_id, false]) exitWith {};

// Init functions
call compileFinal preprocessFileLineNumbers "functions\powers\absolute_knowledge\functions.sqf";

// Power activated!
player setVariable [_power_id, true, true];


// PARAMS HERE!
params [
	['_cooldown', 300, [0]],
	['_maxDistance', -1, [0]],
	['_showTime', 30, [0]],
	['_blurTime', 5, [0]]
];
power_absolute_knowledge_cooldown = _cooldown;
power_absolute_knowledge_distance = _maxDistance;
power_absolute_knowledge_show_time = _showTime;
power_absolute_knowledge_blur_time = _blurTime;


[ 
	_power_id,
	power_absolute_knowledge_cooldown,
	{ player call power_absolute_knowledge_show_units_on_map },
	"Détecter les présences sur carte"
] call power_with_cooldown_init;


[
	_power_id, 
	"Pouvoir de connaissance absolue", 
	"Votre pouvoir vous permet d'acquérir le position de chaque entités via un rond pour une infanterie et un carré pour un véhicule.
	<br /> Chaque indications apparaient sur carte durant " + (
		power_absolute_knowledge_show_time call seconde_to_text
	) + "sans actualisation en temps réèl.
	<br />
	<br />Portée : " + (
		power_absolute_knowledge_distance call secure_meter_to_text
	) + "
	<br />Cible : Véhicules et humains
	<br />Cooldown : " + (
		power_absolute_knowledge_cooldown call seconde_to_text
	)
] call common_power_description_init;

[] spawn {
	[] call power_absolute_knowledge_show_own_position_on_map;
};