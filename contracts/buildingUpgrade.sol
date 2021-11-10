pragma solidity >0.8.0;

import "./buildingGeneration"

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

        function getPrimaryUpgradePoints(building _building) internal view returns (uint) {
                return ((_building.maxEfficiency * (_building.level ** 2)) / 4);
        }

        function getSecondaryUpgradePoints(building _building) internal view returns (uint) {
                if (_building.level <= 3) {
                        return 0;
                }
                else {
                        return ((_building.maxEfficiency * ((_building.level - 3) ** 2)) / 4);
                }
        }
        function getTertiaryUpgradePoints(building _building) internal view returns (uint) {
                if (_building.level <= 5) {
                        return 0;
                }
                else {
                        return ((_building.maxEfficiency * ((_building.level - 5) ** 2)) / 4);
                }
        }

        function canUpgrade(address _user, building _building) internal view returns (bool) {
                uint primaryPoints = getPrimaryUpgradePoints(_building);
                uint secondaryPoints = getSecondaryUpgradePoints(_building);
                uint tertiaryPoints = getTertiaryUpgradePoints(_building);
                uint userPrimaryResourcePoints = 0;
                uint userSecondaryResourcePoints = 0;
                uint userTertiaryResourcePoints = 0;
                for (int i = 0; i < Resources.length; i++) {
                        if (resourceToOwner[Resources[i]] == msg.sender) {
                                if (Resources[i].biome == _building.biome) {
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
                                else if (Resources[i].biome == _building.secondaryDependency) {
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
                                else if (Resources[i].biome == _building.tertiaryDependency) {
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
        function upgradeOutpost(address _user, building _outpost) public {
                require(buildingToOwner[_outpost] == msg.sender);
                require(_outpost.level == 1);
                require(canUpgrade(_user, _outpost), "You do not have enough resources to upgrade your outpost!");
                // Burn Resources and upgrade outpost level. Doing so also increases maxEfficiency
                _outpost.level++;
        }

        function upgradeFort(address _user, uint _fortId) public {
                require(buildingToOwner[_building] == msg.sender);
                require(_outpost.level == 2);
                require(canUpgrade(_user, _building), "You do not have enough resources to upgrade your outpost!");
                _outpost.level++;
                // Burn Resources and upgrade to stronghold class. Doing so also increases maxEfficiency
        }

        function upgradeStronghold(address _user, uint _strongholdId) public {
                require(buildingToOwner[_building] == msg.sender);
                require(_outpost.level == 3);
                require(canUpgrade(_user, _building), "You do not have enough resources to upgrade your outpost!");
                // Burn Resources and increase maxEfficiency
        }

}
