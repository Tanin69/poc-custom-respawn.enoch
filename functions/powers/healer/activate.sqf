_power_id = 'power_healer';
if(player getVariable [_power_id, false]) exitWith {};

// Init functions
call compileFinal preprocessFileLineNumbers "functions\powers\healer\functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\powers\regenerate\functions.sqf";

// Regneration power activated!
player setVariable [_power_id, true, true];


// PARAMS HERE!
params [
	['_distance', 3, [0]]
];
power_healer_distance = _distance;


// [
// 	_power_id, 
// 	1,
// 	"Pouvoir de soin",
// 	3,
// 	nil,
// 	{ call power_healer_heal_target; },
// 	nil,
// 	{ call power_healer_full_heal_target }
// ] call hold_power_with_cooldown_init;


{

	if(_x == player) then { 
		[
			_x,
			_power_id, 
			1,
			"Se soigner",
			{
				params ["_caller", "_target"];
				_hasPower = _caller getVariable ['power_healer', false];
				_hasPower && _caller == _target;
			}, // _can_activate
			{
				params ["_caller", "_target"];
				(_caller distance _target <= 3);
			}, // _can_activate
			{ call power_healer_heal_target; }, // _power_action
			nil, // _power_action_start
			{ call power_healer_full_heal_target } // _power_action_final
		] call hold_power_with_cooldown_init;

	} else {
		[
			_x,
			_power_id, 
			1,
			"Pouvoir de soin",
			{
				params ["_caller", "_target"];
				_distance = (_caller distance _target < 3);
				_hasPower = _caller getVariable ['power_healer', false];

				// systemChat str [_caller, _target, _hasPower];

				if(_hasPower && _distance && _caller != _target) then {
					_caller setVariable ['power_healer_target', _target];
				} else {
					_caller setVariable ['power_healer_target', objNull];
				};

				_hasPower;
			}, // _can_activate
			{
				params ["_caller", "_target"];
				(_caller distance _target <= 3)
			}, // _can_progress
			{ call power_healer_heal_target; }, // _power_action
			nil, // _power_action_start
			{ call power_healer_full_heal_target } // _power_action_final
		] call hold_power_with_cooldown_init;
	};
	
} forEach playableUnits;




[
	_power_id, 
	"Pouvoir de soin", 
	"Votre pouvoir vous permet de soigner les blessures comme par miracle.
	<br /> Chaque blessure se referme, chaque goute de sang se régénère, ...
	<br />
	<br />Portée : " + (
		power_healer_distance call secure_meter_to_text
	) + "
	<br />Cible : Humains
	<br />Cooldown : -"
] call common_power_description_init;


[_power_id] spawn {
// [_power_id, ((player actionParams (player getVariable (_power_id + '_cooldown_actionId')))#0)] spawn {
	params ['_power_id', '_actionName'];
	// (player getVariable (_power_id + '_cooldown_actionId')) spawn {
	"Se soigner" call power_healer_ui_init;
	[_power_id] call power_healer_hold_power_with_cooldown_desactivate;
};
