pragma solidity >0.8.0;

import "@openzepplin/contracts/access/Ownable.sol";

contract spawnEvent is Ownable {

        // Declare all variables here

        uint private spawnFrequency;
        uint private fortSpawnRarity;
        uint private strongholdSpawnRarity;

        // Declare all modifiers here

        // Declare all functions here

        function setSpawnFrequency(uint _newSpawnFrequency) public onlyOwner {
        // TODO: Make a simple function to set a spawn frequency based on the number of buildings being generated
        }

        function setFortSpawnRarity(uint _newFortSpawnRarity) public onlyOwner {
        // TODO: Make a simple function that sets the fort spawn rarity. Spawn rarity is how often forts will be called. Going to be a number out of 100. i.e. 2 is a 2% chance that it spawns
        }

        function setStrongholdSpawnRarity(uint _newStrongholdSpawnRarity) public onlyOwner {
        // TODO: Make a function that does the exact same thing as above, except for stronghold spawn rate.
        }

        function getSpawnFrequency() external view returns (uint) {
                return spawnFrequency;
        }

        function getFortSpawnRarity() external view returns (uint) {
                return fortSpawnRarity;
        }

        function getStrongholdSpawnRarity() external view returns (uint) {
                return strongholdSpawnRarity();
        }

        function spawnEvent() internal {
                // TODO: Make function which spawns a new outpost. This function will be called for buildingGeneration.sol
        }
}
