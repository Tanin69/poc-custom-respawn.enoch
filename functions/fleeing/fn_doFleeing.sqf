params [
	["_group", grpNull, [grpNull]]
];

if (_group == grpNull) exitWith {
	hint "group can't be empty";
};

private _mrkInitial = createMarker [
	format ["mrk_init_%1", _group],
	getPos (leader _group)
];

private _distanceFromToParamilPos = (getMarkerPos _mrkInitial) distance2D (getMarkerPos "paramil_pos");
private _range = _distanceFromToParamilPos / 10;

// Clear existing waypoints
[_group] call CBA_fnc_clearWaypoints;

for "_i" from 1 to 10 do 
{
	private _wpPos = [];
	private _dummy = [["paramil_pos"], []] call BIS_fnc_randomPos;

	if (_i == 1) then {
		_wpPos = [
			(getPos leader _group),
			_range,
			((getPos leader _group) getDir _dummy)
		] call BIS_fnc_relPos;
	} else {
		_wpPos = [
			(getMarkerPos format ["marker_%1_%2", _i - 1, _group]),
			_range,
			((getPos leader _group) getDir _dummy)
		] call BIS_fnc_relPos;
	};

	_mrk = createMarker [
		format ["marker_%1_%2", _i, _group],
		_wpPos
	];
	_mrk setMarkerType "mil_dot";
	_mrk setMarkerText format ["marker_%1_%2", _i, _group];

	[
		_group,
		_wpPos,
		0,
		"MOVE",
		"FULL",
		"AWARE",
		selectRandom ["BLUE", "GREEN"],
		"RANDOM",
		30,
		[0,0,0],
		["true", ""]
	] call GDC_fnc_lucyAddWaypoint;
};