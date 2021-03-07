/*

Description :
Activate a Shinriel's Power if the unit is holding a given object. A blur effect is played each time the power is activated (i.e. presence of the object in unit inventory is confirmed). To be placed in an event handler.

Parameters
0 : OBJECT - the unit to give the power
1 : STRING - class name of the object to look for
2 : STRING - power name ("regenerate" and "infinite_stamina" tested so far)

Example :
player addEventHandler ["InventoryClosed", { 
	[_this#0, "V_MU_EOD_AAF", "regenerate"] call int_fnc_activatePowerWithObject;
}];

Returns :
Nothing

*/

params ["_unit", "_object", "_power"];

private _reqObject = [_unit, _object] call int_fnc_isInLoadout;

if (_reqObject) then {
    private _isPowerActive = _unit getVariable [_power, false];
    if !(_isPowerActive) then {
        [_power] call activatePower;
    };
    _lancePpEffect = _unit getVariable["hasSpecialObject",false];
    if !(_lancePpEffect) then {
    ["DynamicBlur", 400, [10]] spawn 
        { 
            params ["_name", "_priority", "_effect", "_handle"]; 
            while { 
                _handle = ppEffectCreate [_name, _priority]; 
                _handle < 0 
            } do { 
                _priority = _priority + 1; 
            }; 
            _handle ppEffectEnable true; 
            _handle ppEffectAdjust _effect; 
            _handle ppEffectCommit 10; 
            sleep 5;
            _effect = [0];
            _handle ppEffectAdjust _effect;
            _handle ppEffectCommit 10;
        };
        _unit setVariable ["hasSpecialObject",true];
    };
} else {
    _unit setVariable ["hasSpecialObject", false];
	[_power] call desactivatePower;
};