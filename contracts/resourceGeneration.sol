pragma solidity >0.8.0;

import "./buildingGeneration.sol"

contract resourceGeneration is marketplace {

        // Declare all variables here

        // Declare all modifiers here 

        // Declare all constructors here

        // Declare all functions here

        // TODO: ensure that this function will produce an integer. UINTS CANNOT BE DECIMALS
        function calculateEffectiveEfficiency(address _user, uint _buildingId) internal returns (uint) {
                uint effectiveEfficiency = 0;
                if (buildingToOwner[_buildingId].upgradeLevel == 1) {
                        effectiveEfficiency = (buildingToOwner[_buildingId].maxEfficiency/(1 + (1.1 ** (-2 * buildingToOwner[_buildingId].level))));
                }
                else if (buildingToOwner[_id].upgradeLevel == 2) {
                        effectiveEfficiency = (buildingToOwner[_buildingId].maxEfficiency/(1 + (1.5 ** (-.5 * buildingToOwner[_buildingId].level))));
                }
                else {
                        effectiveEfficiency = (buildingToOwner[_buildingId].maxEfficiency/(1 + (1.5 ** (-1 * buildingToOwner[_buildingId].level))));
                }
                return effectiveEfficiency;
        }

        function collectResources(address _user, uint _buildingId) public {
                uint efficiency = calculateEffectiveEfficiency(_user, _buildingId);
                //TODO: Finish this function to add to the user's resource pool
        }

        function collectAllResources(address _user) public isOwner(_user) {
                for (uint i = 0; i < ownerNumBuildings[_user]; i++) {
                        collectResources(_user, i);
                }
        }
}
