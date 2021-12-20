/*
 SPDX-License-Identifier: MIT
*/

pragma solidity >0.8.0;

import "./resourceGeneration.sol";

contract buildingUpgrade is resourceGeneration {
	
	using SafeMath for uint256;

	// Put global variables here
	uint private commonMultiplier;
	uint private uncommonMultiplier;
	uint private rareMultiplier;
	uint private specialMultiplier;
	// Put the modifiers here
	
	// Put the functions here 
	
	function setCommonMultiplier(uint _commonMultiplier) public onlyOwner {
		commonMultiplier = _commonMultiplier;
	}

	function setUncommonMultiplier(uint _uncommonMultiplier) public onlyOwner {
		uncommonMultiplier = _uncommonMultiplier;
	}

	function setRareMultiplier(uint _rareMultiplier) public onlyOwner {
		rareMultiplier = _rareMultiplier;
	}

	function setSpecialMultiplier(uint _specialMultiplier) public onlyOwner {
		specialMultiplier = _specialMultiplier;
	}

	function _getPrimaryUpgradePoints(uint _buildingId) internal view returns (uint) {
		return ((Buildings[_buildingId].maxEfficiency * (Buildings[_buildingId].level ** 2)) / 4);
	}

	function _getSecondaryUpgradePoints(uint _buildingId) internal view returns (uint) {
		if (Buildings[_buildingId].level <= 3) {
			return 0;
		}
		else {
			return ((Buildings[_buildingId].maxEfficiency * ((Buildings[_buildingId].level - 3) ** 2)) / 4);
		}
	}
	function _getTertiaryUpgradePoints(uint _buildingId) internal view returns (uint) {
		if (Buildings[_buildingId].level <= 5) {
			return 0;
		}
		else {
			return ((Buildings[_buildingId].maxEfficiency * ((Buildings[_buildingId].level - 5) ** 2)) / 4);
		}
	}


	function canUpgrade(uint _buildingId) public view returns (bool) {
		uint primaryPoints = _getPrimaryUpgradePoints(_buildingId);
                uint secondaryPoints = _getSecondaryUpgradePoints(_buildingId);
                uint tertiaryPoints = _getTertiaryUpgradePoints(_buildingId);
		uint userPrimaryResourcePoints = 0;
		uint userSecondaryResourcePoints = 0;
		uint userTertiaryResourcePoints = 0;
		for (uint i = 0; i < Resources.length; i++) {
			if (resourceToOwner[i] == msg.sender) {
				if (Resources[i].biome == Buildings[_buildingId].biome) {
					if (Resources[i].rarity == 1) {
						userPrimaryResourcePoints = userPrimaryResourcePoints.add(commonMultiplier);
					}
					else if (Resources[i].rarity == 2) {
						userPrimaryResourcePoints = userPrimaryResourcePoints.add(uncommonMultiplier);
					}
					else if (Resources[i].rarity == 3) {
						userPrimaryResourcePoints = userPrimaryResourcePoints.add(rareMultiplier);
					}
					else {
						userPrimaryResourcePoints = userPrimaryResourcePoints.add(specialMultiplier);
					}
				}
				else if (Resources[i].biome == Buildings[_buildingId].secondaryDependency) {
					if (Resources[i].rarity == 1) {
                                                userSecondaryResourcePoints = userSecondaryResourcePoints.add(commonMultiplier);
                                        }
                                        else if (Resources[i].rarity == 2) {
                                                userSecondaryResourcePoints = userSecondaryResourcePoints.add(uncommonMultiplier);                  
                                        }
                                        else if (Resources[i].rarity == 3) {
                                                userSecondaryResourcePoints = userSecondaryResourcePoints.add(rareMultiplier);
                                        }
                                        else {
                                                userSecondaryResourcePoints = userSecondaryResourcePoints.add(specialMultiplier);
                                        }
                                }
				else if (Resources[i].biome == Buildings[_buildingId].tertiaryDependency) {
                                        if (Resources[i].rarity == 1) {
                                                userTertiaryResourcePoints = userTertiaryResourcePoints.add(commonMultiplier);
                                        }
                                        else if (Resources[i].rarity == 2) {
                                                userTertiaryResourcePoints = userTertiaryResourcePoints.add(uncommonMultiplier);
                                        }
                                        else if (Resources[i].rarity == 3) {
                                                userTertiaryResourcePoints = userTertiaryResourcePoints.add(rareMultiplier);
                                        }
                                        else {
                                                userTertiaryResourcePoints = userTertiaryResourcePoints.add(specialMultiplier);
                                        }
                                }
			}
		}
		if ((userPrimaryResourcePoints >= primaryPoints) && (userSecondaryResourcePoints >= secondaryPoints) && (userTertiaryResourcePoints >= tertiaryPoints)) {
			return true;
		}
		else {
			return false;
		}
	}
	
	// Do we need "building storage thisBuilding = Buildings[_buildingId];"???
	function upgradeOutpost(address _user, uint _buildingId) public {
		building storage myBuilding = Buildings[_buildingId];
		require(buildingToOwner[_buildingId] == msg.sender);
		require(myBuilding.level == 1);
		require(canUpgrade(_buildingId), "You do not have enough resources to upgrade your outpost!");
		uint primaryPoints = _getPrimaryUpgradePoints(_buildingId);
		uint secondaryPoints = _getSecondaryUpgradePoints(_buildingId);
		uint tertiaryPoints = _getTertiaryUpgradePoints(_buildingId);
		
		Buildings[_buildingId].level++;
	}

	function upgradeFort(address _user, uint _buildingId) public {
		require(buildingToOwner[_buildingId] == msg.sender);
		require(Buildings[_buildingId].level == 2);
                require(canUpgrade(_buildingId), "You do not have enough resources to upgrade your fort!");
		Buildings[_buildingId].level++;
		// Burn Resources and upgrade to stronghold class. Doing so also increases maxEfficiency
	}

	function upgradeStronghold(address _user, uint _buildingId) public {
		require(buildingToOwner[_buildingId] == msg.sender);
		require(Buildings[_buildingId].level == 3);
                require(canUpgrade(_buildingId), "You do not have enough resources to upgrade your stronghold!");
		// Burn Resources and increase maxEfficiency
	}
	
}
