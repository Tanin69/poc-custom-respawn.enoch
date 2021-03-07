/*

Function : int_fnc_findUnloadPos

Description:
	Find a position between the nearest player and a given position, with a 
	given distance from player

Parameter(s):
	_posDepart    - Position to search from (optional, default [0,0,0]) <ARRAY>
	_safePos      - If the position have to be on water or not (optional, default [true, 0]). The second element must be one of : 0 (land only), 1 (land or water), 2 (water only) <ARRAY> [BOOL, NUMBER]
	_distance     - minimum distance from nearest player (optional, default 1000) <NUMBER>
	_createMarker - create a local marker at found position (optional, default: true) <BOOL>

Returns:
	An array with 0: found position (array [x,y,z]), nearest player position (array [x,y,z]), marker name (string) <ARRAY>

Examples:
(begin example)
	
	[getMarkerPos "marker_1", [true, 2], 300, true] call int_fnc_findUnloadPos;
(end)

Author:
    tanin69

*/

params [
	["_posDepart", [0,0,0], [[]], [2,3]],
	["_safePos", [true, 0], [[]], [2]],
	["_distance", 1000, [0]],
	["_createMarker", true, [true]]
];

private _allPlayers = playableUnits + (switchableUnits select {_x != HC_Slot});
private _currentDistance = 0;
private _nearestDistance = 1000000;
private _mrkUnload = objNull;
private _nearestPlayer = objNull;

{
	_currentDistance = _x distance2D _posDepart;
	if (_currentDistance < _nearestDistance) then {
		_nearestPlayer = _x;
		_nearestDistance = _currentDistance;
	};
} forEach _allPlayers;

_posNearestPlayer = position _nearestPlayer;
_posUnload =  [_posDepart, _nearestDistance - _distance, (_posNearestPlayer getdir _posDepart) - 180] call BIS_fnc_relPos;

if (_safePos#0) then {
	_posUnload = [_posUnload, 1, 150, 3, (_safePos#1), 0, 0] call BIS_fnc_findSafePos;
};

if (_createMarker) then {
	_mrkUnload = createMarkerLocal ["mrk" + str floor (random 10000), _posUnload];
	_mrkUnload setMarkerTypeLocal "hd_destroy";
	_mrkUnload setMarkerColorLocal "colorRed";
};

[_posUnload, _posNearestPlayer, _mrkUnload]




