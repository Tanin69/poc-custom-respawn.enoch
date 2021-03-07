//Determine who is the leader at the moment by checking if unit has the "special item" in his inventory
{_x hideObject false;} count units opSide;

private _leader = "";
{
	if ([_x, "ACE_Cellphone"] call int_fnc_isInLoadout) then {
		_leader = _x;
	}
} forEach (playableUnits + (switchableUnits select {_x != HC_Slot}));

//Determine the respawn position : near the leader
private _rspPos = [[[position _leader,20]]] call BIS_fnc_randomPos;

[player, _rspPos, true] call BIS_fnc_moveToRespawnPosition;

