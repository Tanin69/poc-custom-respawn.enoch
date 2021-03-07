
power_with_cooldown_desactivate = {
	params ['_power_id'];

	// secure if call the function and not spawn
	_power_id spawn {
		waitUntil { sleep 1; !(player getVariable [_this, true]) };
		player removeAction (player getVariable [_this + '_cooldown_actionId', 0]);
	}
};

power_with_cooldown_init = {
	params ['_power_id', '_cooldown_time', '_power_action', '_power_name', ['_can_activate', { true; }], ['_calculate_target', { ""; }], ['_can_show', { true; }]];

	_cooldown_var = _power_id + '_cooldown';
	// player setVariable [_cooldown_var, 0];


	_doAction = "
		params [""_target"", ""_caller"", ""_actionId"", ""_arguments""];

		if(player getVariable [""" + _cooldown_var + """, 0] < time) then {
			if(_this call (compile " + (str (_can_activate call GDC_fnc_expressionToString)) + ")) then {
				player setVariable [""" + _cooldown_var + """, time + " + (str _cooldown_time) + "];
				[player, _actionId, """ + _cooldown_var + """, """ + _power_name + """, time, compile " + (str (_calculate_target call GDC_fnc_expressionToString)) + "] spawn common_power_with_cooldown_effect;
				_this call (compile " + (str (_power_action call GDC_fnc_expressionToString)) + ");
			};
		};
	";

	_actionid = player addAction [
		_power_name,
		compile _doAction, 
		[], 
		1.5,
		true,
		true,
		"", 
		"_this call (compile " + (str (_can_show call GDC_fnc_expressionToString)) + ")"
	];

	player setVariable [_power_id + '_cooldown_actionId', _actionid];
	[_actionId, _power_name, _calculate_target] call common_power_with_cooldown_effect_ready_text;

	// Prepare the action suppress when desactivate the power
	[_power_id] call power_with_cooldown_desactivate;
	[_actionid, _power_id, _calculate_target] call common_power_with_cooldown_target;

	_actionid;
};



