
player call power_regenerate_heal_tick;

// ['ace_medical_heartRate', 80, 0.2] call power_regenerate_check_int_value;
// ['ace_medical_bloodVolume', 100, 0.2] call power_regenerate_check_int_value;
// ['ace_medical_bloodPressure', [80,120], 0.2] call power_regenerate_check_array_value;

// player setVariable ['ace_medical_inCardiacArrest', false, true];
// ['ace_medical_peripheralResistance', 100, 2] call power_regenerate_check_int_value;


// _end = false;
// _wounds_list = [
// 	'ace_medical_openWounds',
// 	'ace_medical_bandagedWounds',
// 	'ace_medical_stitchedWounds'
// ];

// for [{ _i = 0 }, { (_i < count _wounds_list) && (!_end) }, { _i = _i + 1 }] do {
// 	if(count (player getVariable [_wounds_list # _i, []]) > 0) then {
// 		_wounds = player getVariable [_wounds_list # _i, []];

// 		_selected_wounds = selectrandom _wounds;
// 		_wounds = _wounds - [_selected_wounds];

// 		player setVariable [ _wounds_list # _i, _wounds, true];
// 		_end = true;
// 	};
// }; 

// if(!_end) then {
// 	player setVariable ['ace_medical_isLimping', false, true];
// 	player setVariable ['ace_medical_fractures', [0,0,0,0,0,0], true];
// 	player setVariable ['ace_medical_isBleeding', false, true];
// 	player setVariable ['ace_medical_bodyPartDamage', [0,0,0,0,0,0], true];
// };



/*

    // - Blood and heart ----------------------------------------------------------
    _unit setVariable [VAR_BLOOD_VOL, DEFAULT_BLOOD_VOLUME, true]; => 6
    _unit setVariable [VAR_HEART_RATE, DEFAULT_HEART_RATE, true]; => 80
    _unit setVariable [VAR_BLOOD_PRESS, [80, 120], true];
    _unit setVariable [VAR_PERIPH_RES, DEFAULT_PERIPH_RES, true]; => 100
    _unit setVariable [VAR_CRDC_ARRST, false, true];
    _unit setVariable [VAR_HEMORRHAGE, 0, true];

    // - Pain ---------------------------------------------------------------------
    _unit setVariable [VAR_PAIN, 0, true];
    _unit setVariable [VAR_IN_PAIN, false, true];
    _unit setVariable [VAR_PAIN_SUPP, 0, true];

    // - Wounds -------------------------------------------------------------------
    _unit setVariable [VAR_OPEN_WOUNDS, [], true];
    _unit setVariable [VAR_BANDAGED_WOUNDS, [], true];
    _unit setVariable [VAR_STITCHED_WOUNDS, [], true];
    _unit setVariable [QEGVAR(medical,isLimping), false, true];
    _unit setVariable [VAR_FRACTURES, DEFAULT_FRACTURE_VALUES, true]; => [0,0,0,0,0,0]

    // - Misc ---------------------------------------------------------------------
    _unit setVariable [VAR_UNCON, false, true];

    // - Treatments ---------------------------------------------------------------
    _unit setVariable [VAR_TOURNIQUET, DEFAULT_TOURNIQUET_VALUES, true];
    _unit setVariable [QEGVAR(medical,occludedMedications), nil, true]; // Delayed Medications (from tourniquets)
    _unit setVariable [QEGVAR(medical,ivBags), nil, true];

    // Update wound bleeding
    [_unit] call EFUNC(medical_status,updateWoundBloodLoss);

    // Triage card and logs
    _unit setVariable [QEGVAR(medical,triageLevel), 0, true];
    _unit setVariable [QEGVAR(medical,triageCard), [], true];

    // Damage storage
    _unit setVariable [QEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0], true];

    // Medication
    _unit setVariable [VAR_MEDICATIONS, [], true];

    // Unconscious spontanious wake up chance
    _unit setVariable [QEGVAR(medical,lastWakeUpCheck), nil];

*/