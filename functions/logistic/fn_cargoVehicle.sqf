/* add cargo to an existing vehicle
 * params :
 * 0: the vehicle to which the load must be added <OBJECT vehicle>
 * 1: the cargo to be loaded in the vehicle <STRING>
 */

params ["_veh", "_cargo"];

//Vide le loadout du véhicule
clearMagazineCargoGlobal _veh;
clearWeaponCargoGlobal _veh;
clearItemCargoGlobal _veh;
clearBackpackCargoGlobal _veh;

//Ajoute le loadout
switch (_cargo) do {
	//Cargo des bradley
		case "cargo_ifv_aplha": {
		_veh addBackpackCargoGlobal ["B_Carryall_khk",3];
		_veh addItemCargoGlobal ["Toolkit", 2];
		_veh addItemCargoGlobal ["B_AssaultPack_cbr", 2];
		_veh addMagazineCargoGlobal ["rhsusf_100Rnd_762x51_m61_ap", 10];
		_veh addMagazineCargoGlobal ["rhsusf_100Rnd_556x45_mixed_soft_pouch", 20];
		_veh addMagazineCargoGlobal ["OFrP_25Rnd_556x45", 100];
		_veh addItemCargoGlobal ["OFrP_1Rnd_Grenade_APAV40", 20];
		_veh addItemCargoGlobal ["HandGrenade", 20];
		_veh addItemCargoGlobal ["rhs_weap_M136", 6];
		_veh addItemCargoGlobal ["SmokeShell",20];
		_veh addItemCargoGlobal ["SmokeShellGreen",10];
		_veh addItemCargoGlobal ["SmokeShellRed",10];
		_veh addItemCargoGlobal ["ACE_EntrenchingTool",9];
		_veh addItemCargoGlobal ["rhs_mag_30Rnd_556x45_M855A1_Stanag", 30];
		_veh addItemCargoGlobal ["ACE_salineIV_250",5];
	};
	case "cargo_ifv": {
		_veh addBackpackCargoGlobal ["B_Carryall_khk",3];
		_veh addItemCargoGlobal ["Toolkit", 2];
		_veh addItemCargoGlobal ["B_AssaultPack_cbr", 2];
		_veh addMagazineCargoGlobal ["rhsusf_100Rnd_762x51_m61_ap", 10];
		_veh addMagazineCargoGlobal ["rhsusf_100Rnd_556x45_mixed_soft_pouch", 20];
		_veh addMagazineCargoGlobal ["OFrP_25Rnd_556x45", 100];
		_veh addItemCargoGlobal ["OFrP_1Rnd_Grenade_APAV40", 20];
		_veh addItemCargoGlobal ["HandGrenade", 20];
		_veh addItemCargoGlobal ["rhs_weap_M136", 6];
		_veh addItemCargoGlobal ["SmokeShell",20];
		_veh addItemCargoGlobal ["SmokeShellGreen",10];
		_veh addItemCargoGlobal ["SmokeShellRed",10];
		_veh addItemCargoGlobal ["ACE_EntrenchingTool",9];
		_veh addItemCargoGlobal ["rhs_mag_30Rnd_556x45_M855A1_Stanag", 30];
	};
	//Cargo des Abrams
	case "cargo_mbt": {
		_veh addBackpackCargoGlobal ["B_Carryall_khk",4];
		_veh addItemCargoGlobal ["Toolkit", 2];
		_veh addItemCargoGlobal ["SmokeShell",10];
		_veh addItemCargoGlobal ["SmokeShellGreen",5];
		_veh addItemCargoGlobal ["SmokeShellRed",5];
		_veh addItemCargoGlobal ["rhs_mag_30Rnd_556x45_M855A1_Stanag", 30];
		_veh addItemCargoGlobal ["ACE_EntrenchingTool",3];
	};
	//Cargo du M1250A1
	case "cargo_medevac": {
		_veh addBackpackCargoGlobal ["B_Carryall_khk",4];
		_veh addItemCargoGlobal ["ACE_packingBandage",100];
		_veh addItemCargoGlobal ["ACE_quikclot",100];
		_veh addItemCargoGlobal ["ACE_elasticBandage",100];
		_veh addItemCargoGlobal ["ACE_fieldDressing",200];
		_veh addItemCargoGlobal ["ACE_salineIV_250",20];
		_veh addItemCargoGlobal ["ACE_salineIV_500",10];
		_veh addItemCargoGlobal ["ACE_salineIV",10];
		_veh addItemCargoGlobal ["ACE_morphine",10];
		_veh addItemCargoGlobal ["ACE_epinephrine",10];
		_veh addItemCargoGlobal ["ACE_atropine",10];
		_veh addItemCargoGlobal ["ACE_tourniquet",10];
		_veh addItemCargoGlobal ["ACE_surgicalKit",3];
		_veh addItemCargoGlobal ["ACE_splint",50];
		_veh addItemCargoGlobal ["ACE_Banana",200];
		_veh addItemCargoGlobal ["ACE_Bodybag",20];
	};
	//Cargo de l'UH-60
	case "cargo_UH60": {
		_veh addBackpackCargoGlobal ["B_Carryall_khk",4];
		_veh addItemCargoGlobal ["ACE_packingBandage",300];
		_veh addItemCargoGlobal ["ACE_quikclot",300];
		_veh addItemCargoGlobal ["ACE_elasticBandage",300];
		_veh addItemCargoGlobal ["ACE_fieldDressing",400];
		_veh addItemCargoGlobal ["ACE_salineIV_250",80];
		_veh addItemCargoGlobal ["ACE_salineIV_500",60];
		_veh addItemCargoGlobal ["ACE_salineIV",50];
		_veh addItemCargoGlobal ["ACE_morphine",50];
		_veh addItemCargoGlobal ["ACE_epinephrine",20];
		_veh addItemCargoGlobal ["ACE_atropine",10];
		_veh addItemCargoGlobal ["ACE_tourniquet",40];
		_veh addItemCargoGlobal ["ACE_surgicalKit",3];
		_veh addItemCargoGlobal ["ACE_splint",100];
		_veh addItemCargoGlobal ["ACE_Wirecutter",5];
		_veh addItemCargoGlobal ["ACE_Cabletie",5];
		_veh addItemCargoGlobal ["ACE_Banana",200];
		_veh addItemCargoGlobal ["ACE_Bodybag",20];
		_veh addItemCargoGlobal ["ACE_EntrenchingTool",2];
		_veh addItemCargoGlobal ["SmokeShell",10];
		_veh addItemCargoGlobal ["SmokeShellGreen",5];
		_veh addItemCargoGlobal ["SmokeShellRed",5];
		_veh addItemCargoGlobal ["rhs_mag_30Rnd_556x45_M855A1_Stanag", 30];
	};
	//Cargo de l'AH-64
	case "cargo_AH64": {
		_veh addBackpackCargoGlobal ["B_Carryall_khk",2];
		_veh addItemCargoGlobal ["ACE_EntrenchingTool",2];
		_veh addItemCargoGlobal ["SmokeShell",10];
		_veh addItemCargoGlobal ["SmokeShellGreen",5];
		_veh addItemCargoGlobal ["SmokeShellRed",5];
		_veh addItemCargoGlobal ["rhs_mag_30Rnd_556x45_M855A1_Stanag", 30];
	};
};
