setPlayerRespawnTime 28800;

//Fade to black
[0,"BLACK",4, 1] call BIS_fnc_fadeEffect; 
[1,"BLACK",4] call BIS_fnc_fadeEffect;

//Enter spectator mode
["Initialize", [player, [], true, true, true, true, true, true, true, true]] call BIS_fnc_EGSpectator;

//Hide hostile units that are not in vincinity of alive players to prevent spoil (thanks to VDauphin for the code optim !)
//Average loop execution time : 8ms (heavy !). Execution every 10 s. seems to be a good balance
while {!alive player} do {

	{hideObject _x;} count units opSide; //opSide variabale initialized in init.sqf
	{
		_alivePlayer = _x;
		{
			_x hideObject false;
		} forEach ((units opSide) inAreaArray [getPosWorld _alivePlayer, 300, 300]);

	} forEach (playableUnits + (switchableUnits select {_x != HC_Slot}));
	sleep 10;
};
