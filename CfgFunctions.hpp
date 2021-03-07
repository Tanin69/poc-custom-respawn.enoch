class CfgFunctions
{
	
	class int
	{
		class spawn_zone
		{
			file="functions\spawn_zone";
			class spawnFixedWeapons {};
			class spawnGarnisons {};
			class spawnRdmPatrols {};
			class spawnMechInfantry {};
		};

		class fleeing
		{
			file="functions\fleeing";
			class doFleeing {};
			class fleeing {};
		};

		class logistic
		{
			file="functions\logistic";
			class SSSCargo {};
			class refuelTank {};
			class addCargo {};
		};
		
		class misc
		{
			file="functions\misc";
			class probaChallenge {};
			class findClearZoneInArea {};
			class isInLoadout {};
			class skipTimeWithFog {};
			class findUnloadPos {};
			class sideGroupsKnowPlayer {};
		};

		class searchlight
		{
			file="functions\searchlight";
			class initSearchlight {};
			class searchlight {};
		}

		class powers
		{
			file="functions\powers";
			class activatePowerWithObject {};
		};

	}

};