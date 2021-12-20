/*
 SPDX-License-Identifier: MIT
*/

pragma solidity >0.8.0;

import "./buildingGeneration.sol";

abstract contract marketplace is buildingGeneration {
	
	// Declare all events here
	event resourceListed(uint item, uint quantity, uint price, address owner);
	event buildingListed(uint price, address owner);
	event resourceLotteryBegin(uint entryFee);
	event buildingLotteryBegin(uint entryFee);
	event resourceSold(uint price, address to, address from);
	event buildingSold(uint price, address to, address from);
	event resourceLotteryWon(address winner);
	event buildingLotteryWon(address winner);

	// Declare all variables here
	uint private winningIndex;
	
	// Declare all modifiers
	modifier enoughResources(address _address, uint16 _biome, uint8 _rarity, uint _quantity) {
		uint counter = 0;
		for(uint i = 0; i < Resources.length; i++) {
			if (resourceToOwner[i] == msg.sender) {
				if (Resources[i].biome == _biome && Resources[i].rarity == _rarity) {
					counter++;
				}
			}
		}
		require(counter >= _quantity);
		_;
	}
	
	// Declare all functions here

        function _randomIndex() internal view returns (uint) {
	// TODO: use an oracle to get a random number
	}
	
	function listItem(uint _quantity, uint _price, uint16 _biome, uint8 _rarity, address _owner) public enoughResources(_owner, _biome, _rarity, _quantity) {
	// TODO: Puts the item in escrow, where a person can pay the address _price tokens and receive _item
	}
}
