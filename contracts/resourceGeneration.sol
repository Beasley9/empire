/*
 SPDX-License-Identifier: MIT
*/

pragma solidity >0.8.0;

import "./marketplace.sol";

contract resourceGeneration is marketplace {

	// Declare all variables here
	uint internal empireScore;	
	uint private lastCollectionTime;
	// Declare all modifiers here 
	
	// Declare all constructors here
	
	// Declare all functions here
	
	/*// TODO: ensure that this function will produce an integer. UINTS CANNOT BE DECIMALS
        function calculateEffectiveEfficiency(uint _buildingId) internal returns (uint) {
                uint effectiveEfficiency = 0;
		if (Buildings[_buildingId].level == 1) {
                        effectiveEfficiency = uint((Buildings[_buildingId].maxEfficiency/(1 + (1.1 ** (-2 * Buildings[_buildingId].level)))));
                }
                else if (Buildings[_buildingId].level == 2) {
                        effectiveEfficiency = uint((Buildings[_buildingId].maxEfficiency/(1 + (1.5 ** (-.5 * Buildings[_buildingId].level)))));
                }
                else {
                        effectiveEfficiency = uint((Buildings[_buildingId].maxEfficiency/(1 + (1.5 ** (-1 * Buildings[_buildingId].level)))));
                }
                return effectiveEfficiency;
	}

	function collectResources(uint _buildingId) public {
		require(buildingToOwner[_buildingId] == msg.sender);
		uint efficiency = calculateEffectiveEfficiency(_buildingId);
		
	}
       
	
        function collectAllResources() public {
                for (uint i = 0; i < ownerNumBuildings[msg.sender]; i++) {
                        collectResources(i);
                }
        }
       */

	function collectEmpireTokens() public {
		// TODO: write function for collecting stronghold tokens
	}
}
