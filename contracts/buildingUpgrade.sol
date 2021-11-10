pragma solidity >0.8.0;

import "./buildingGeneration"

contract buildingUpgrade is resourceGeneration {

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
                        if (resourceToOwner[Resource[i]] == msg.sender) {
                        // TODO: Finish this function
                        }
                }
        }

        function upgradeOutpost(address _user, building _outpost) public {
                require(buildingToOwner[_building] == msg.sender);
        }

        function upgradeFort(address _user, uint _fortId) public {
        // TODO: finish fort upgrade function -> checks if user has enough supplies, then upgrades the specified fort to a stronghold
        }

        function upgradeStronghold(address _user, uint _strongholdId) {
        // TODO: finish stronghold upgrade function -> checks if user has enough supplies, then upgrades the specified stronghold's efficieny
        }

}
