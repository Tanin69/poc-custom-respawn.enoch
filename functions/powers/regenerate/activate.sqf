_power_id = 'power_regenerate';
if(player getVariable [_power_id, false]) exitWith {};

// Init functions
call compileFinal preprocessFileLineNumbers "functions\powers\regenerate\functions.sqf";

// Regneration power activated!
player setVariable [_power_id, true, true];


// PARAMS HERE!
params [
	// Apply heal effect every _loopTime secondes
	['_loopTime', 5, [0]],
	// Apply heal effect every _loopTime secondes
	['_number_wound_repaired_per_loop', 2, [0]],
	// Threshold for damage, abstract number of damage ignored before check if unit must be killed
	// Max ACE value is 25, but a heavy blast but .50mm could be from 6 to 19.... so  19-25 < 0, only one blast is not FATAL!
	['_playerDamageThreshold', 40, [0]],
	// Threshold for damage, abstract number of damage ignored before check if unit must be killed
	['_bodyPart_repair_coef', 0.1, [0]]	
];

power_regenerate_loop_tick = _loopTime;
power_regenerate_number_wound_repaired_per_loop = _number_wound_repaired_per_loop;
power_regenerate_playerDamageThreshold = _playerDamageThreshold;
power_regenerate_bodyPart_repair_coef = _bodyPart_repair_coef;


// Init the power effects !
[] spawn compileFinal preprocessFileLineNumbers "functions\powers\regenerate\loop.sqf";

[
	_power_id, 
	"Pouvoir de regénération", 
	"Votre mouvoir vous évite de pourir, vos blessures se referment d'elles mêmes. Mais ce n'est pas encore toute à fait au point."
] call common_power_description_init;
