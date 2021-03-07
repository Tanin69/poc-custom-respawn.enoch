
// If already initiated
if (!(isNil "power_possession_init")) exitWith { };
power_possession_init = true;

power_possession_ui_init = {
	power_possession_ui_activate = false;
	power_possession_ui_has_text = false;
	
	_trimHtml = _this call string_remove_html_tag;
	_trimHtml = _trimHtml call string_remove_all_spaces;

	// TODO: systemChat to remove after tests
	_activate_possession_ui = "
		systemChat ((_this # 4) call string_remove_all_spaces);

		if ( ((_this # 4) call string_remove_all_spaces) == " + (str _trimHtml) + " ) then {
			power_possession_ui_activate = true;
		} else {
			power_possession_ui_activate = false;
		};
	";

	inGameUISetEventHandler ["PrevAction", _activate_possession_ui];
	inGameUISetEventHandler ["NextAction", _activate_possession_ui];
	

	onEachFrame {
		if (isActionMenuVisible && power_possession_ui_activate) then {

			if((cursorTarget isKindOf "Man") && (alive cursorTarget) && (!(cursorTarget getVariable ["ACE_isUnconscious",false])) && (cursorTarget getVariable ['GDC_possessed', -1] == -1)) then {
				if(!power_possession_ui_has_text) then {
					power_possession_ui_has_text = true;
					cutText ["<br /><br /><t color='#0000ff' size='3'>Posséder</t>", "PLAIN", -1, false, true];
				};
			} else {
				if(power_possession_ui_has_text) then {
					power_possession_ui_has_text = false;
					cutText ["", "PLAIN", -1, false, true];
				};
			};
		} else {
			if(power_possession_ui_has_text) then {
				power_possession_ui_has_text = false;
				cutText ["", "PLAIN", -1, false, true];
			};
		};
	};
};

power_possession_effect = {
	// _unit = vehicle cursortarget;
	_unit = cursortarget;

	_unit switchCamera "Internal";
	power_possession_ref_player remoteControl _unit;

	if(stance player == "STAND") then {
		power_possession_ref_player playActionNow "Crouch";
	};


	if(_unit getVariable ['GDC_possessed', -1] == -1) then {

		// TODO: Add a eventHandler for SHOOT, to change rank
		_unit addEventHandler ["FiredMan", {
			params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
			_unit addRating -2000;
		}];

		_actionId = _unit addEventHandler ["Killed", {
			params ["_unit", "_killer", "_instigator", "_useEffects"];

			// If the user still on this unit (has the cameron set on it)
			if(_unit == cameraOn) then {
				systemChat "Vous avez été ejecté du corps";
				hint "Vous avez été ejecté du corps";

				player switchCamera "internal";
				ObjNull remoteControl _unit;
				// power_possession_ref_player remoteControl power_possession_ref_player;

				// // Remove the action (useless or not?)
				// _unit removeEventHandler ["killed", _unit getVariable ['GDC_possessed', 0]];
			};
		}];
		_unit setVariable ['GDC_possessed', _actionId];
	};

	// Wait to be unpossessed
	[_unit] spawn {
		params ['_unit'];
		waitUntil { sleep 1; cameraOn != player };
		_unit removeEventHandler ["killed", _unit getVariable ['GDC_possessed', 0]];
	}
};

power_possession_show_action = {
	cameraOn == player;
};

power_possession_can_possession = {
	if(isPlayer cursorTarget) then {
		systemChat "Impossible de posséder un joueur";
		hint "Impossible de posséder un joueur";
		false;
	} else {
		if(cursorTarget isKindOf "Man") then {
			if((alive cursorTarget) && (!(cursorTarget getVariable ["ACE_isUnconscious",false]))) then {
				if(cursorTarget getVariable ['GDC_possessed', -1] == -1) then {
					true;
				} else {
					systemChat "Cible est ou a déjà été possédée";
					hint "Cible est ou a déjà été possédée";
					false;
				};
			} else {
				systemChat "Impossible de posséder un mort ou inconscient";
				hint "Impossible de posséder un mort ou inconscient";
				false;
			};
		} else {
			systemChat "Impossible de posséder un objet";
			hint "Impossible de posséder un objet";
			false;
		};
	};
};


// power_possession_cancel_init = {
	
// 	_actionid = player addAction [ 
// 		"Annuler la possession",
// 		{ 
// 			params ["_target", "_caller", "_actionId", "_arguments"]; 

// 			if(alive power_possession_ref_player) then {
// 				power_possession_ref_player switchCamera "Internal";
// 				power_possession_ref_player remoteControl power_possession_ref_player;
// 				power_possession_in_progress = false;
// 			} else {
// 				systemChat "Impossible, votre enveloppe d'origine n'est plus.";
// 				hint "Impossible, votre enveloppe d'origine n'est plus.";
// 			};
// 		}, 
// 		[], 
// 		1.5,
// 		true,
// 		true,
// 		"", 
// 		"power_possession_ref_player"
// 	];

// 	[_this, _actionid] spawn {
// 		params ['_power_id', '_action_id'];
// 		waitUntil { sleep 1; !(player getVariable [_power_id, true]) };

// 		power_possession_ref_player switchCamera "Internal";
// 		power_possession_ref_player remoteControl power_possession_ref_player;
// 		power_possession_in_progress = false;

// 		player removeAction _action_id;
// 	};
// };

