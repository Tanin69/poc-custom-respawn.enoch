//Pseudo EH to respawn player when respawn conditions are satisfied
_condRespawn = ["ConditionalRespawn"] spawn {
	while { true } do {
		waitUntil {goRsp};
		["Terminate", [player]] call BIS_fnc_EGSpectator;
		setPlayerRespawnTime 5;
		goRsp = false;
		sleep 5;
		
	};
};

//ACE Self action to launch respawn  
_action = [ 
 "Respawn", 
 "Résusciter les morts", 
 "", 
	{ 
		goRsp = true;
		publicVariable "goRsp";
		nbRspTck = nbRspTck -1;
		publicVariable "nbRspTck";
	}, 
	{
		//Check conditions to allow respawn
		//int_fnc_isInLoadout is a very simple function to ckeck the presence of an object in unit inventory 
		([player, "ACE_Cellphone"] call int_fnc_isInLoadout) &&	(nbRspTck > 0) && (count ((units opSide) inAreaArray [getPosWorld Player, 300, 300]) == 0);
	} 
] call ace_interact_menu_fnc_createAction;

[
 	player, 
 	1, 
 	["ACE_SelfActions"], 
 	_action 
] call ace_interact_menu_fnc_addActionToObject;