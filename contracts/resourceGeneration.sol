pragma solidity >0.8.0;

import "./buildingGeneration.sol"

contract resourceGeneration is marketplace {

        // Declare all variables here
        uint internal empireScore;
        // Declare all modifiers here 

        // Declare all constructors here

        // Declare all functions here

        // TODO: ensure that this function will produce an integer. UINTS CANNOT BE DECIMALS
        function calculateEffectiveEfficiency(address _user, building storage _building) internal returns (uint) {
                uint effectiveEfficiency = 0;
                if (_building.upgradeLevel == 1) {
                        effectiveEfficiency = uint((_building.maxEfficiency/(1 + (1.1 ** (-2 * _building.level)))));
                }
                else if (_building.upgradeLevel == 2) {
                        effectiveEfficiency = uint((_building.maxEfficiency/(1 + (1.5 ** (-.5 * _building.level)))));
                }
                else {
                        effectiveEfficiency = uint((_building.maxEfficiency/(1 + (1.5 ** (-1 * _building.level)))));
                }
                return effectiveEfficiency;
        }

        function collectResources(building storage _building) public {
                require(buildingToOwner[_building] == msg.sender);
                uint efficiency = calculateEffectiveEfficiency(_user, _building);
                //TODO: Finish this function to add to the user's resource pool
        }

        function collectAllResources() public {
                for (uint i = 0; i < ownerNumBuildings[msg.sender]; i++) {
                        collectResources(_user, i);
                }
        }

        function collectEmpireTokens() public {
                // TODO: write function for collecting stronghold tokens
        }
}
