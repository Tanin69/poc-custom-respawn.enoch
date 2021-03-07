
// If already initiated
if (!(isNil "power_regenerate_init")) exitWith { };
power_regenerate_init = true;

power_regenerate_approach_to_value = {
	params["_value", "_wantedValue", "_step"];

	if(_wantedValue == _value) then {
		_wantedValue;
	} else {
		_newValue = _value;
		if(_wantedValue > _value) then {
			_newValue = _wantedValue min (_value + _step);
		} else {
			_newValue = _wantedValue max (_value - _step);
		};

		_newValue;
	};
};

power_regenerate_check_int_value = {
	params["_target", "_key", "_wantedValue", "_maxStep"];
	// diag_log ((str _key) + " / " + (str _wantedValue) + " / " + (str _maxStep) + " / ");

	_value = _target getVariable [_key, _wantedValue];
	_newValue = [_value, _wantedValue, _maxStep] call power_regenerate_approach_to_value;

	if(_newValue != _value) then {
		_target setVariable [
			_key,
			_newValue,
			true
		];
	};
};

power_regenerate_check_array_value = {
	params["_target", "_key", "_wantedValue", "_maxStep"];
	// diag_log ((str _key) + " / " + (str _wantedValue) + " / " + (str _maxStep) + " / ");

	_newValues = [];

	{
		_currentValue = _x;
		_currentWantedValue = _wantedValue # _forEachIndex;

		_newValues pushBack (switch (true) do {
			case (_currentWantedValue > _currentValue): { _currentWantedValue min (_currentValue + _maxStep); };
			case (_currentWantedValue < _currentValue): { _currentWantedValue max (_currentValue - _maxStep); };
			default { _currentValue; };
		});	
	} forEach (_target getVariable [_key, _wantedValue]);

	_target setVariable [_key, _newValues, true];
};

power_regenerate_heal_tick = {
	_target = _this;

	[_target, 'ace_medical_heartRate', 80, 0.6] call power_regenerate_check_int_value;
	[_target, 'ace_medical_bloodVolume', 100, 1] call power_regenerate_check_int_value;
	[_target, 'ace_medical_bloodPressure', [80,120], 0.6] call power_regenerate_check_array_value;

	_target setVariable ['ace_medical_inCardiacArrest', false, true];
	[_target, 'ace_medical_peripheralResistance', 100, 2] call power_regenerate_check_int_value;

	_end = false;
	_wounds_list = [
		'ace_medical_openWounds',
		'ace_medical_bandagedWounds'
	];

	// Heal wounds
	for [{ _j = 0 }, { (_j < power_regenerate_number_wound_repaired_per_loop) && (!_end) }, { _j = _j + 1 }] do {
		for [{ _i = 0 }, { (_i < count _wounds_list) && (!_end) }, { _i = _i + 1 }] do {
			if(count (_target getVariable [_wounds_list # _i, []]) > 0) then {
				_wounds = _target getVariable [_wounds_list # _i, []];

				_selected_wounds = selectrandom _wounds;
				_wounds = _wounds - [_selected_wounds];

				_target setVariable [ _wounds_list # _i, _wounds, true];
				_end = true;
			};
		}; 
	}; 

	if(!_end) then {

		// Remove wounds
		for [{ _j = 0 }, { (_j < power_regenerate_number_wound_repaired_per_loop) && (!_end) }, { _j = _j + 1 }] do {
			if(count (_target getVariable ['ace_medical_stitchedWounds', []]) > 0) then {
				_wounds = _target getVariable ['ace_medical_stitchedWounds', []];

				_selected_wounds = selectrandom _wounds;
				_wounds = _wounds - [_selected_wounds];

				_target setVariable [ 'ace_medical_stitchedWounds', _wounds, true];
				_end = true;
			}; 
		}; 

		_target setVariable ['ace_medical_isLimping', false, true];
		_target setVariable ['ace_medical_fractures', [0,0,0,0,0,0], true];
		// _target setVariable ['ace_medical_woundBleeding', false, true];


		// Add epinephrine
		// _target getVariable ["ace_medical_medications", ]
		//  * Arguments:
		//  * 0: The Unit <OBJECT>
		//  * 1: Medication <STRING>
		//  * 2: Time in system for the adjustment to reach its peak <NUMBER>
		//  * 3: Duration the adjustment will have an effect <NUMVER>
		//  * 4: Heart Rate Adjust <NUMVER>
		//  * 5: Pain Suppress Adjust <NUMVER>
		//  * 6: Flow Adjust <NUMVER>
		[_target, "Epinephrine", power_regenerate_loop_tick/2, power_regenerate_loop_tick, 0, 0, 0] call ace_medical_status_fnc_addMedicationAdjustment;


		// _target setVariable ['ace_medical_bodyPartDamage', [0,0,0,0,0,0], true];
		_target setVariable [
			'ace_medical_bodyPartDamage', 
			((_target getVariable ['ace_medical_bodyPartDamage', [0,0,0,0,0,0]]) apply { [_x, 0, power_regenerate_bodyPart_repair_coef] call power_regenerate_approach_to_value }),
			true];
	};

	[_target] call ace_medical_status_fnc_updateWoundBloodLoss;
	[_target] call ace_medical_engine_fnc_updateDamageEffects;
};



// TODO
// 10min
// 4 rafales => 1 rafale damage 5, seuil de 6.25 à 8.4
// Diminution lentes du ace_medical_bodyPartDamage

//


// Show damage : 

/*
private _headThreshhold = 1.25 * ace_medical_playerDamageThreshold;
private _bodyThreshhold = 1.5 * ace_medical_playerDamageThreshold;

_bodyPartDamage = player getVariable [ace_medical_bodyPartDamage, [0,0,0,0,0,0]];
_bodyPartDamage params ["_headDamage", "_bodyDamage"];

private _vitalDamage = ((_headDamage - _headThreshhold) max 0) + ((_bodyDamage - _bodyThreshhold) max 0);
private _chanceFatal = 1 - exp -((_vitalDamage/ace_medical_const_fatalSumDamageWeibull_L)^ace_medical_const_fatalSumDamageWeibull_K);
systemChat str [_bodyPartDamage,_vitalDamage,_chanceFatal]
*/
