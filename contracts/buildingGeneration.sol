pragma solidity >0.8.0; hi

import "@openzepplin/contracts/tokens/ERC20/ERC20.sol";
import "@openzepplin/contracts/tokens/ERC721/ERC721.sol";
import "@openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract buildingGeneration is ERC20, ERC721, spawnEvent {

        using SafeMath for uint256;

        // Declare global structs in this block
        struct internal building {
                address originalOwner;
                uint level;
                uint maxEfficiency;
                uint location;
                uint time;
                uint16 biome;
                uint16 secondaryDependency;
                uint16 tertiaryDependency;
        };

        struct internal resource {
                uint16 biome;
                uint8 rarity;
        };

        // Initialize arrays
        building[] internal Buildings;
        resource[] internal Resources;

        // Order all events 
        event outpostGeneration(address originalOwner, uint level, uint maxEfficiency, uint location, uint time, uint16 biome, uint16 secondaryDependency, uint16 tertiaryDependency);

        // Order all mappings
        mapping (address => uint) internal legacyOwnedBuildings;
        mapping (address => uint) internal ownerNumBuildings;
        mapping (uint => address) internal buildingToOwner;
        mapping (uint => address) internal resourceToOwner;


        // Order all global variables
        uint private cooldownTime;
        uint private genesisPeriod
        uint internal spawnFrequency;
        uint internal fortSpawnRarity;
        uint internal strongholdSpawnRarity;

        // Order all modifier functions
        modifier outpostGenerationCooldownTime(address _user) {
                require(getCooldownTime(_user) + block.timestamp <= block.timestamp);
                _;
        }

        modifier isOwner(uint _address) {
                require(_address == msg.sender);
                _;
        }

        modifier isGenesis() {
                require(block.timestamp <= genesisPeriod);
                _;
        }

        // Order all constructors
        constructor() {
                genesisPeriod = block.timestamp + 30 days;
        }

        constructor(address _owner) {
                _mint(_owner, 10000);
        }

        // Order all functions

        function getCooldownTime(address _user) public view returns (uint) {
                return cooldownTime;
        }

        function _setCooldownTime(address _user) internal {
                if (legacyOwnedBuildings[_user] == 0) {
                        cooldownTime = 0 days;
                }
                else if (legacyOwnedBuildings[_user] <= 2) {
                        cooldownTime = legacyOwnedBuildings[_user] - 1 days;
                }
                else {
                        cooldownTime = (7 * (1 - (12/(legacyOwnedBuildings[_user] * 7)))) days;
                }
        }

        // TODO: Implement the OracleInterface and use it to finish this function
        function generateOutpost(address _user) public outpostGenerationCooldownTime(_user) isOwner {
                // Will require oracle before the buildingId
                buildingId = Buildings.push(building(_user, 1, //Finish) - 1
                buildingToOwner[buildingId] = _user
                ownerNumBuildings[_user]++;
                legacyNumBuildings[_user]++;
                cooldownTime = block.timestamp + 
                emit outpostGeneration(//Finsh)
                if (buildingId % spawnFrequency == 0) {
                        _spawnEvent();
                }
        }
        function generateGenesisOutpost(address _user) public outpostGenerationCooldownTime(_user) isGenesis isOwner {
                // Function will be the same as previous, except with more powerful maxEfficiency
        }


        // Spawn Events
        function _getRandomSpawnIndex(uint _max) private view returns (uint) {
                // TODO: use an oracle to find a random number between 1 and _max;
        }

        function setSpawnFrequency(uint _newSpawnFrequency) public onlyOwner {
                spawnFrequency = _newSpawnFrequency;
        }

        function setFortSpawnRarity(uint _newFortSpawnRarity) public onlyOwner {
                fortSpawnRarity = _newFortSpawnRarity;
        }

        function setStrongholdSpawnRarity(uint _newStrongholdSpawnRarity) public onlyOwner {
                strongholdSpawnRarity = _newStrongholdSpawnRarity;
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

        function _spawnEvent() internal {
                uint spawnIndex = getRandomSpawnIndex(Buildings.length);
        }

        function _tokenBurn() internal {
        }
}
