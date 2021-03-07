/*
Description :
Check if a given object (any class) is in unit's loadout.

Parameters
0 : OBJECT - the unit which loadout is to be checked
1 : STRING - class name of the object to be searched

Example :
[player, "itemMap"] call isInLoadout

Returns :
TRUE : the object is in unit's loadout
FALSE : otherwise

*/


params ["_unit", "_object"];

private _loadout = [headgear _unit] + [uniform _unit] + [vest _unit] + (items _unit) + (magazines _unit) + (assignedItems _unit);

private _isInLoadout = _object in _loadout;

_isInLoadout


