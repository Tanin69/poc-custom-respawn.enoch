/*

Description :
Order a unit to use a search light to scan a zone until enemy detection. Usable only with CUP_X_SearchLight_static_XXX objetcs.

Parameters
0 : OBJECT - the searchlight
1 : BOOL (default true) - wether to turn on the searchlight (true) or to turn it off (false)
1 : STRING - marker name (area marker) defining aera to scan 

Example :
Example needed (special tribute to biki :-D)

Returns :
Nothing

*/

params [
	"_searchlight",
	["_turnOn", true],
	["_watchMrk",[]]
];

if !(isServer) exitWith {};

private _watcher = gunner _searchlight;

if (_turnOn) then {
	_watcher action ["SearchlightOn", _searchlight];

	private _isNearbyENI = objNull;
	private _isScanOn = _searchlight getVariable ["isScanOn", false];	
	
	if !(_isScanOn) then {
		
		_searchlight setVariable ["isScanOn", true];
		while {alive _watcher && (isNull _isNearbyENI)} do {  
			_isNearbyENI = _watcher findNearestEnemy position _watcher;
			private _watchPos = [[_watchMrk]] call BIS_fnc_randomPos;
			_watcher doWatch _watchPos;  
			sleep 15 + (random 15);
		};
		_searchlight setVariable ["isScanOn", false];
	};

} else {
	_watcher action ["SearchlightOff", _searchlight];
};


