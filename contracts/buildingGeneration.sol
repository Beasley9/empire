pragma solidity >0.8.0;

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
        mapping (address => uint) internal playerCooldownTime;
        mapping (uint => address) internal buildingToOwner;
        mapping (uint => address) internal resourceToOwner;

        // Order all global variables
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

        constructor() {
                uint internal globalNonce = 0;
                uint internal maxEfficiencyCap = 20;
                uint internal genesisEfficiency = 30;
                uint internal generationDepreciation = 2;
                uint internal genesisTime = block.timestamp;
                uint internal generationOne = block.timestamp + 90 days;
                uint internal generationTwo = block.timestamp + 365 days;
                uint internal generationThree = block.timestamp + 3 years;
                uint internal generationFour = block.timestamp + 5 years;
                uint internal generationFive = block.timestamp + 10 years;
                uint internal generationSix = block.timestamp + 20 years;
                uint internal genesisPeriod = block.timestamp + 30 days;
        }
        // Order all functions

        // TODO: Include Empire Score Integration
        function getCurrentEfficiencyValue() internal returns (uint) {
                if (block.timestamp <= generationOne) {
                        return maxEfficiencyCap;
                }
                else if (block.timestamp <= generationTwo) {
                        return maxEfficiencyCap - (1 * generationDepreciation);
                }
                else if (block.timestamp <= generationThree) {
                        return maxEfficiencyCap - (2 * generationDepreciation);
                }
                else if (block.timestamp <= generationFour) {
                        return maxEfficiencyCap - (3 * generationDepreciation);
                }
                else if (block.timestamp <= generationFive) {
                        return maxEfficiencyCap - (4 * generationDepreciation);
                }
                else if (block.timestamp <= generationSix) {
                        return maxEfficiencyCap - (5 * generationDepreciation);
                }
        }

        function _getBiome() internal returns (uint16) {
                return _effectiveRandomNumber(16);
        }

        function setMaxEfficiencyCap(uint _newMax) public onlyOwner {
                maxEfficiencyCap = _newMax;
        }

        function setGenerationDepreciation(uint _newDepreciation) public onlyOwner {
                generationDepreciation = _newDepreciation;
        }

        function _effectiveRandomNumber(uint _max) internal returns (uint) {
                globalNonce++;
                return uint(keccak256(abi.encodePacked(block.timestamp, globalNonce, msg.sender))) % _max;

        // TODO: Recheck this function
        function _setPlayerCooldownTime(address _user) internal view returns (uint) {
                if (legacyOwnedBuildings[_user] == 0) {
                        return playerCooldownTime[_user] +  0 days;
                }
                else if (legacyOwnedBuildings[_user] <= 2) {
                        return playerCooldownTime[_user] + legacyOwnedBuildings[_user] - 1 days;
                }
                else {
                        return playerCooldownTime[_user] + (7 * (1 - (12/(legacyOwnedBuildings[_user] * 7)))) days;
                }
        }

        //TODO: Recheck this function
        function generateOutpost(address _user) public outpostGenerationCooldownTime(_user) isOwner {
                require(playerCooldownTime[_user] <= block.timestamp || legacyNumBuildings[_user] == 0);
                uint cappedEfficiency = getEfficiencyValue();
                uint randomBiome = _getBiome();
                uint secondaryReq = randomBiome;
                uint tertiaryReq = randomBiome;
                while (randomBiome != secondaryReq && randomBiome != tertiaryReq) {
                        secondaryReq = _getBiome();
                        tertiaryReq = _getBiome();
                }
                buildingId = Buildings.push(building(_user, 1, cappedEfficiency, /* location, */ block.timestamp, randomBiome, secondaryReq, tertiaryReq)) - 1;
                buildingToOwner[buildingId] = _user;
                ownerNumBuildings[_user]++;
                legacyNumBuildings[_user]++;
                playerCooldownTime[_user] = block.timestamp + _setPlayerCooldownTime(_user);
                emit outpostGeneration(_user, 1, cappedEfficiency, /* location*/ block.timestamp, randomBiome, secondaryReq, tertiaryReq);
                if (buildingId % spawnFrequency == 0) {
                        _spawnEvent();
                }
        }
        function generateGenesisOutpost(address _user) public outpostGenerationCooldownTime(_user) isGenesis isOwner {
                require(playerCooldownTime[_user] <= block.timestamp || legacyNumBuildings[_user] == 0);
                uint cappedEfficiency = genesisEfficiency;
                uint randomBiome = _getBiome();
                uint secondaryReq = randomBiome;
                uint tertiaryReq = randomBiome;
                while (randomBiome != secondaryReq && randomBiome != tertiaryReq) {
                        secondaryReq = _getBiome();
                        tertiaryReq = _getBiome();
                }
                buildingId = Buildings.push(building(_user, 1, cappedEfficiency, /* location, */ block.timestamp, randomBiome, secondaryReq, tertiaryReq)) - 1;
                buildingToOwner[buildingId] = _user;
                ownerNumBuildings[_user]++;
                legacyNumBuildings[_user]++;
                playerCooldownTime[_user] = block.timestamp + _setPlayerCooldownTime(_user);
                emit outpostGeneration(_user, 1, cappedEfficiency, /* location*/ block.timestamp, randomBiome, secondaryReq, tertiaryReq);
                if (buildingId % spawnFrequency == 0) {
                        _spawnEvent();
                }
        }

        // Spawn Events
        function setSpawnFrequency(uint _newSpawnFrequency) public onlyOwner {
                spawnFrequency = _newSpawnFrequency;
        }

        function setFortSpawnRarity(uint _newFortSpawnRarity) public onlyOwner {
                fortSpawnRarity = _newFortSpawnRarity;
        }

        function setStrongholdSpawnRarity(uint _newStrongholdSpawnRarity) public onlyOwner {
                strongholdSpawnRarity = _newStrongholdSpawnRarity;
        }

        function getSpawnFrequency() public view returns (uint) {
                return spawnFrequency;
        }

        function getFortSpawnRarity() public view returns (uint) {
                return fortSpawnRarity;
        }

        function getStrongholdSpawnRarity() public view returns (uint) {
                return strongholdSpawnRarity();
        }

        function _spawnEvent() internal {
                uint spawnIndex = _effectiveRandomNumber(Buildings.length);

        }

        function _tokenBurn() internal {
        }
}
