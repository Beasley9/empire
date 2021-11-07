pragma solidity >0.8.0;

import "./buildingGeneration.sol"

contract marketplace is buildingGeneration {

        event itemListed(uint item, uint quantity, uint price, address owner);
        event lotteryBegin(uint entryFee);
        event buildingListed(uint price, address owner);

        uint private winningIndex;
        

        //oracle required
        function _randomIndex() internal view returns (uint) {
        }

        function listItem(uint _item, uint _quantity, uint _price, address _owner) public {
               require (
}
