/* Ajoute les objets à un conteneur (véhicule, caisse ou sac à dos)

Paramètres :
0: OBJ, vehicle to which items will be added
1: ARRAY of STRINGS, array of classnames to add to the vehicle

*/

params [
	"_veh",
	["_clear", true],
	"_tbClassNames"
];

if (_clear) then {
	clearItemCargoGlobal _this;
	clearMagazineCargoGlobal _this;
	clearWeaponCargoGlobal _this;
	clearBackpackCargoGlobal _this;
};

{
	if (_x isKindOf "Bag_Base") then {
		_veh addBackpackCargoGlobal _x;
	} else {
		_veh addItemCargoGlobal _x;
	}
	
} forEach _tbClassNames;