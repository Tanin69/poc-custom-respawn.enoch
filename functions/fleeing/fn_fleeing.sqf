/*
	Author: [GIE] Gavin "Morbakos" Sertix
	
	Description:
		Initialise le module de fuite des groupes paramilitaires.

		Pour qu'un groupe soit géré par la fonction : (group this) setVariable ["INT_groupIsParamil", true];

		Les paramètres peuvent être définis pour chaque groupe, avec la commande suivante: 
			(group this) setVariable ["coef_fuite_kia", [6, 8, 10]];
		
		Les différentes variables possibles sont:
			- coef_fuite_kia
			- coef_fuite_kia_allies
			- coef_fuite_tanks
			- coef_fuite_ifv
			- coef_fuite_helo
			- coef_fuite_allies_en_fuite

		Chaque variable doit être un tableau contenant 3 entiers du type [min, mid, max]. Le poids de chaque événement est choisi aléatoirement dans cet interval.
	
	Parameter(s):
		None
	
	Returns:
		Nothing
*/


LOG_PREFIX_FUITE = "[FLEEING_MODULE]";
int_delai_avant_scan = 5;
int_delay_between_check = 15;
int_corpses_distance = 30;
int_fleeing_distance = 50;
int_paramil_classname = ["O_G_Soldier_F", "O_G_Soldier_lite_F", "O_G_Soldier_unarmed_F", "O_G_Soldier_AR_F", "O_G_Soldier_A_F", "O_G_Soldier_LAT_F", "O_G_Soldier_LAT2_F", "O_G_Soldier_SL_F", "O_G_officer_F"];

// Coefficiens de fuite
int_coef_fuite_kia = [6, 8, 10];
int_coef_fuite_kia_allies = [1,1.5,2];
int_coef_fuite_tanks = [10, 12, 15];
int_coef_fuite_ifv = [8, 11, 13];
int_coef_fuite_helo = [10, 12, 15];
int_coef_fuite_allies_en_fuite = [5, 5, 7];

if (isNil "int_phase_defense") then {
	int_phase_defense = true;
};

[] spawn {
	sleep int_delai_avant_scan;
	systemChat format ["%1 Init fleeing module", LOG_PREFIX_FUITE];

	while {int_phase_defense} do {
		
		// Obtention de la liste des groupes de paramilitaires
		paramil_groups_list = (allGroups select { (side _x == east) && (_x getVariable ["INT_groupIsParamil", false]) && ((count (units _x)) > 0) });
		systemChat format ["%1 group count: %2", LOG_PREFIX_FUITE, count paramil_groups_list];

		{
			/*
				Les différentes conditions de fuite : 
				Trop de perte dans le groupe (pas systématique)
				Pertes alliés nombreuses à proximités (par exemple, si les 2 groupes les plus proches sont décimés, ils ont un % de fuite)
				C'est une "guerilla", donc ils peuvent fuir (ou en tout cas reculer) si ils aperçoivent des moyens lourds (Abrams, bradley, Apache en l'occurrence)
				Un groupe de paramil à proximité fuit
			*/
			private _cur_group = _x;
			private _fleeingRate = 0;

			// Récupération de potentielles valeurs perso
			private _kia             = _cur_group getVariable ["coef_fuite_kia", int_coef_fuite_kia];
			private _kia_allies      = _cur_group getVariable ["coef_fuite_kia_allies", int_coef_fuite_kia_allies];
			private _tanks           = _cur_group getVariable ["coef_fuite_tanks", int_coef_fuite_tanks];
			private _ifv             = _cur_group getVariable ["coef_fuite_ifv", int_coef_fuite_ifv];
			private _helo            = _cur_group getVariable ["coef_fuite_helo", int_coef_fuite_helo];
			private _allies_en_fuite = _cur_group getVariable ["coef_fuite_allies_en_fuite", int_coef_fuite_allies_en_fuite];

			// On compte le nombre de soldats dans le groupe
			private _soldiersCount = _cur_group getVariable ["INT_soldiersCount", false];
			
			if (_soldiersCount isEqualType false) then {
				_soldiersCount = (count (units _cur_group));
				_cur_group setVariable ["INT_soldiersCount", _soldiersCount];
			};

			// On récupère la liste des corps à proximités (à moins de X mètres et connu un minimum)
			private _dead_friendly_units = (allDeadMen select { (((leader _cur_group) distance2d _x) <= int_corpses_distance ) && ((typeOf _x) in int_paramil_classname) });

			// On vérifie si le groupe est au courant pour les véhicules lourds de l'OTAN
			private _knowned_heavy_vehicles = [];
			{
				private _unit = _x;
				if ((vehicle _unit) isKindOf "Tank" ) then {
					_knowned_heavy_vehicles pushBack (typeOf (vehicle _unit));
				};				
			} forEach ((leader _cur_group) targets [false, 0, [west, resistance]]);

			// On vérifie si un groupe de paramil à proximité fuit
			private _close_fleeing_groups = paramil_groups_list select { 
				(_x != _cur_group) && ((combatMode _x) in ["BLUE", "GREEN"]) && ((count (units _x)) > 0) && (((leader _cur_group) distance2d (leader _x)) <= int_fleeing_distance) 
			};
			

			// Calcul du poucentage de fuite
			if ((count (units _cur_group)) <= _soldiersCount) then { // Pourcentage de fuite si perte d'effectifs
				private _killed_soldiers = _soldiersCount - (count (units _cur_group));
				for "_i" from 1 to _killed_soldiers do {
					_fleeingRate = _fleeingRate + random _kia;
				};
			};

			if ((count _dead_friendly_units) > 0) then { // Pourcentage de fuite pour les alliés morts
				for "_i" from 1 to (count _dead_friendly_units) do {
					_fleeingRate = _fleeingRate + random _kia_allies;
				};
			};

			if ((count _knowned_heavy_vehicles) > 0) then { // Pourcentage de fuite pour les véhicules lourds
				{
					private _typeOf = _x;
					switch _typeOf do {
						case "rhsusf_m1a2sep1tuskiwd_usarmy": { _fleeingRate = _fleeingRate + random _tanks; };
						case "RHS_M2A2_BUSKI_WD": { _fleeingRate = _fleeingRate + random _ifv; };
						case "RHS_AH64D": { _fleeingRate = _fleeingRate + random _helo; };
						default { };
					};
				} forEach _knowned_heavy_vehicles;
			};

			if ((count _dead_friendly_units) > 0) then { // Pourcentage de fuite pour les alliés morts
				for "_i" from 1 to (count _dead_friendly_units) do {
					_fleeingRate = _fleeingRate + random _allies_en_fuite;
				};
			};
			
			systemChat format ["%1 fleeing rate of group %3: %2", LOG_PREFIX_FUITE, round _fleeingRate, _cur_group];

			if ( (random [50, 75, 100]) < _fleeingRate ) then { // Is group fleeing ?
				systemChat format ["%1 group %2 is fleeing", LOG_PREFIX_FUITE, _cur_group];
				[_cur_group] call INT_fnc_doFleeing;
			};

		} forEach paramil_groups_list;

		sleep int_delay_between_check;
	};
};

true;