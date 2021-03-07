/* Définit la cargaison d'un airdrop logistique pour le module SSS*/


private _listSSS = [];

if (isNil "isTruck1Delivered") then {
	_listSSS pushBack
		[
			"rhsusf_M1078A1P2_B_M2_WD_fmtv_usarmy",
			"",
			"",
			{
				clearMagazineCargoGlobal _this;
				clearWeaponCargoGlobal _this;
				clearItemCargoGlobal _this;
				clearBackpackCargoGlobal _this;
				_this addItemCargoGlobal ["Toolkit",5];
				isTruck1Delivered = true;
			}
		]
};

if (isNil "isTruck2Delivered") then {
	_listSSS pushBack
		[
			"rhsusf_M1078A1P2_B_WD_fmtv_usarmy",
			"",
			"",
			{
				clearMagazineCargoGlobal _this;
				clearWeaponCargoGlobal _this;
				clearItemCargoGlobal _this;
				clearBackpackCargoGlobal _this;
				_this addItemCargoGlobal ["Toolkit",5];
				isTruck2Delivered = true;
			}
		]
};

if (isNil "isTruck3Delivered") then {
	_listSSS pushBack
		[
			"rhsusf_M1078A1R_SOV_M2_D_fmtv_socom",
			"",
			"",
			{
				clearMagazineCargoGlobal _this;
				clearWeaponCargoGlobal _this;
				clearItemCargoGlobal _this;
				clearBackpackCargoGlobal _this;
				_this addItemCargoGlobal ["Toolkit",5];
				isTruck3Delivered = true;
			}
		]
};

if (isNil "isCar1Delivered") then {
	_listSSS pushBack
		[
			"rhsusf_mrzr4_d",
			"",
			"",
			{
				clearMagazineCargoGlobal _this;
				clearWeaponCargoGlobal _this;
				clearItemCargoGlobal _this;
				clearBackpackCargoGlobal _this;
				_this addItemCargoGlobal ["Toolkit",5];
				isCar1Delivered = true;
			}
		]
};

_listSSS pushBack
	[
		"B_supplyCrate_F",
		"Munitions",
		"\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa",
		{
			clearItemCargoGlobal _this;
			clearMagazineCargoGlobal _this;
			clearWeaponCargoGlobal _this;
			clearBackpackCargoGlobal _this;

			_this addMagazineCargoGlobal ["rhs_mag_30Rnd_556x45_Mk318_Stanag",30];
			_this addMagazineCargoGlobal ["rhs_mag_100Rnd_556x45_M855_cmag",10];
			_this addMagazineCargoGlobal ["rhsusf_mag_17Rnd_9x19_FMJ",20];
			_this addItemCargoGlobal ["rhs_mag_an_m8hc",10];
			_this addItemCargoGlobal ["rhs_mag_m67", 10];
			
			_this addMagazineCargoGlobal ["rhs_30Rnd_545x39_7N6M_AK",30];
			_this addMagazineCargoGlobal ["rhs_100Rnd_762x54mmR",10];
			_this addMagazineCargoGlobal ["rhs_10Rnd_762x54mmR_7N1",20];
			_this addItemCargoGlobal ["rhs_mag_rdg2_white",10];
			_this addMagazineCargoGlobal ["rhs_rpg7_PG7VL_mag",5];
			_this addMagazineCargoGlobal ["rhs_mag_9k38_rocket",5];			
		}
	];

_listSSS
