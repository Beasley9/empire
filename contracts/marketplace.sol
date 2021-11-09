pragma solidity >0.8.0;

import "./buildingGeneration.sol"

contract marketplace is buildingGeneration {

        // Declare all events here
        event itemListed(uint item, uint quantity, uint price, address owner);
        event lotteryBegin(uint entryFee);
        event buildingListed(uint price, address owner);

        // Declare all variables here
        uint private winningIndex;

        // Declare all modifiers
        modifier enoughResources(address _address, uint16 _biome, uint8 _rarity, address _amount) {
                uint counter;
                for(uint i = 0; i < resources.length; i++) {
                        if(resources[i].biome == _biome && resources[i].rarity == _rarity) {
                                counter++;
                        }
                }
                require(counter >= _amount);
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
