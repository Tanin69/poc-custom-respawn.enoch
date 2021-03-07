
hold_power_with_cooldown_init = {
	params ['_unit', '_power_id', '_cooldown_time', '_power_name',
		['_can_activate', { true; }],
		['_can_progress', { true; }],
		['_power_action', { }],
		['_power_action_start', { }],
		['_power_action_final', { }],
		['_power_action_interrupted', { }],
		// ['_power_action', { systemChat ("tick: " + (str (_this#0))) }],
		// ['_power_action_start', { systemChat ("start: " + (str (_this#0))) }],
		// ['_power_action_final', { systemChat ("final: " + (str (_this#0))) }],
		// ['_power_action_interrupted', { systemChat ("interrupted: " + (str (_this#0))) }],
		['_calculate_target', { ""; }]
	];

	_cooldown_var = _power_id + '_hold_cooldown';

	// test3 = _cooldown_var;

	_doStartAction = "_this call (compile " + (str (_power_action_start call GDC_fnc_expressionToString)) + ");";
	_doEveryTickAction = "_this call (compile " + (str (_power_action call GDC_fnc_expressionToString)) + ");";
	_doAction = "
		(_this#1) setVariable [""" + _cooldown_var + """, time + " + (str _cooldown_time) + "];
		_this call (compile " + (str (_power_action_final call GDC_fnc_expressionToString)) + ");
	";
	_doInterruptedAction = "
		(_this#1) setVariable [""" + _cooldown_var + """, time + " + (str _cooldown_time) + "];
		_this call (compile " + (str (_power_action_interrupted call GDC_fnc_expressionToString)) + ");
	";

	// test1 = "(_this distance ([" + (str _power_distance) + "] call common_power_cursorTarget_or_self) < " + (str _power_distance) + ") && (player getVariable [""" + _cooldown_var + """, 0] < time) && (_this call (compile " + (str (_can_activate call GDC_fnc_expressionToString)) + "))";
	// test2 = "(_caller distance ([" + (str _power_distance) + "] call common_power_cursorTarget_or_self) < " + (str _power_distance) + ")";

	_actionId = [
		_unit,
		_power_name,
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",
		
		// "(_this distance _target < " + (str _power_distance) + ") && (player getVariable [""" + _cooldown_var + """, 0] < time) && (_this call (compile " + (str (_can_activate call GDC_fnc_expressionToString)) + "))",
		// "(_caller distance _target < " + (str _power_distance) + ")",
		// "(_this distance ([" + (str _power_distance) + ", _target ] call common_power_cursorTarget_or_self) < " + (str _power_distance) + ") && (_this getVariable [""" + _cooldown_var + """, 0] < time) && (_this call (compile " + (str (_can_activate call GDC_fnc_expressionToString)) + "))",
		// "(_caller distance ([" + (str _power_distance) + ", _target ] call common_power_cursorTarget_or_self) < " + (str _power_distance) + ")",
		"(_this getVariable [""" + _cooldown_var + """, 0] < time) && ([_this, _target] call (compile " + (str (_can_activate call GDC_fnc_expressionToString)) + "))",
		"([_this, _target] call (compile " + (str (_can_progress call GDC_fnc_expressionToString)) + "))",

		compile _doStartAction, // start : params ["_target", "_caller", "_actionId", "_arguments"];
		compile _doEveryTickAction, // every tick : params ["_target", "_caller", "_actionId", "_arguments", "_progress", "_maxProgress"];
		compile _doAction, // Completed : params ["_target", "_caller", "_actionId", "_arguments"];
		compile _doInterruptedAction, // Interrupted : params ["_target", "_caller", "_actionId", "_arguments"];
		[],
		4,
		0,
		false,
		true
	] call BIS_fnc_holdActionAdd;


	_unit setVariable [_power_id + '_cooldown_actionId', _actionId];
	// [_actionId, _power_name, _calculate_target] call common_power_with_cooldown_effect_ready_text;

	// Prepare the action suppress when desactivate the power
	// [_actionid, _power_id, _calculate_target] call common_power_with_cooldown_target;
	_actionId;
};



