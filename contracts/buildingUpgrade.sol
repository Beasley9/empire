pragma solidity >0.8.0;

import "./buildingGeneration"

contract buildingUpgrade is resourceGeneration {

        function upgradeOutpost(address _user, uint _outpostId) public {
        // TODO: finish outpost upgrade function -> checks if user has enough supplies, then upgrades the specified outpost to a fort
        }

        function upgradeFort(address _user, uint _fortId) public {
        // TODO: finish fort upgrade function -> checks if user has enough supplies, then upgrades the specified fort to a stronghold
        }

        function upgradeStronghold(address _user, uint _strongholdId) {
        // TODO: finish stronghold upgrade function -> checks if user has enough supplies, then upgrades the specified stronghold's efficieny
        }

        function checkUpgrade(address _user, uint _buildingId) public view returns (string memory) {
        // TODO: tells the user if he has enough supplies/what supplies are required for specific upgrade
        }


}
