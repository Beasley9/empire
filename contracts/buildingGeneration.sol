/*
 SPDX-License-Identifier: MIT
*/

pragma solidity >0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract buildingGeneration is ERC721, Ownable {
	
	using SafeMath for uint256;

	// Declare global structs in this block
	struct building {
		address originalOwner;
		uint level;
		uint maxEfficiency;
		uint time;
		uint16 biome;
		uint16 secondaryDependency;
		uint16 tertiaryDependency;
	}

	struct resource {
		uint16 biome;
		uint8 rarity;
	}

	uint globalNonce = 0;
        uint maxEfficiencyCap = 20;
        uint genesisEfficiency = 30;
        uint generationDepreciation = 2;
        uint genesisTime = block.timestamp;
        uint generationOne = block.timestamp + 90 days;
        uint generationTwo = block.timestamp + 365 days;
        uint generationThree = block.timestamp + 900 days;
        uint generationFour = block.timestamp + 1500 days;
        uint generationFive = block.timestamp + 3000 days;
        uint generationSix = block.timestamp + 6000 days;
        uint genesisPeriod = block.timestamp + 30 days;	

	// Initialize arrays
	building[] internal Buildings;
	resource[] internal Resources;

	// Order all events 
	event outpostGeneration(address originalOwner, uint level, uint maxEfficiency, uint time, uint16 biome, uint16 secondaryDependency, uint16 tertiaryDependency);
	
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
                require(playerCooldownTime[_user] <= block.timestamp);
                _;
        }
	
	modifier isOwner(address _address) {
		require(_address == msg.sender);
		_;	
	}
	
	modifier isGenesis() {
		require(block.timestamp <= genesisPeriod);
		_;
	}

	constructor() ERC721("Empire", "EMP") {}

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
		else {
			return maxEfficiencyCap - (6 * generationDepreciation);
		}
	}

	function _getBiome() internal returns (uint) {
		return _effectiveRandomNumber(16);
	}

	function setMaxEfficiencyCap(uint _newMax) public onlyOwner{
		maxEfficiencyCap = _newMax;
	}

	function setGenerationDepreciation(uint _newDepreciation) public onlyOwner{
		generationDepreciation = _newDepreciation;
	}

	function _effectiveRandomNumber(uint _max) internal returns (uint) {
		globalNonce++;
		return uint(keccak256(abi.encodePacked(block.timestamp, globalNonce, msg.sender))) % _max;
	}

	// TODO: Recheck this function
	function _setPlayerCooldownTime(address _user) internal view returns (uint) {
		if (legacyOwnedBuildings[_user] == 0) {
			return playerCooldownTime[_user] +  0 days;
		}
		else if (legacyOwnedBuildings[_user] <= 2) {
			return playerCooldownTime[_user] + legacyOwnedBuildings[_user] - 1 days;
		}
		else {
			return playerCooldownTime[_user] + (7 * (1 - (12/(legacyOwnedBuildings[_user] * 7))));
		}
	}

	//TODO: Recheck this function
	function generateOutpost(address _user) public payable outpostGenerationCooldownTime(_user) isOwner(_user) {
		require(playerCooldownTime[_user] <= block.timestamp || legacyOwnedBuildings[_user] == 0);
		uint cappedEfficiency = getCurrentEfficiencyValue();
		uint16 randomBiome = uint16(_getBiome() % 16);
		uint16 secondaryReq = randomBiome;
		uint16 tertiaryReq = randomBiome;
		while (randomBiome != secondaryReq && randomBiome != tertiaryReq) {
			secondaryReq = uint16(_getBiome() % 16);
			tertiaryReq = uint16(_getBiome() % 16);
		}
		Buildings.push(building(_user, 1, cappedEfficiency, block.timestamp, randomBiome, secondaryReq, tertiaryReq));
		uint buildingId = Buildings.length;
		buildingToOwner[buildingId] = _user;
		ownerNumBuildings[_user]++;
		legacyOwnedBuildings[_user]++;
		playerCooldownTime[_user] = block.timestamp + _setPlayerCooldownTime(_user);
		emit outpostGeneration(_user, 1, cappedEfficiency, block.timestamp, randomBiome, secondaryReq, tertiaryReq);
		if (buildingId % spawnFrequency == 0) {
			_spawnEvent();
		}
	}
	function generateGenesisOutpost(address _user) public outpostGenerationCooldownTime(_user) isGenesis isOwner(_user) {
		require(playerCooldownTime[_user] <= block.timestamp || legacyOwnedBuildings[_user] == 0);
                uint cappedEfficiency = genesisEfficiency;
                uint16 randomBiome = uint16(_getBiome() % 16);
                uint16 secondaryReq = randomBiome;
                uint16 tertiaryReq = randomBiome;
                while (randomBiome != secondaryReq && randomBiome != tertiaryReq) {
                        secondaryReq = uint16(_getBiome() % 16);
                        tertiaryReq = uint16(_getBiome() % 16);
                }
                Buildings.push(building(_user, 1, cappedEfficiency, block.timestamp, randomBiome, secondaryReq, tertiaryReq));
		uint buildingId = Buildings.length;
                buildingToOwner[buildingId] = _user;
                ownerNumBuildings[_user]++;
                legacyOwnedBuildings[_user]++;
                playerCooldownTime[_user] = block.timestamp + _setPlayerCooldownTime(_user);
                emit outpostGeneration(_user, 1, cappedEfficiency, block.timestamp, randomBiome, secondaryReq, tertiaryReq);
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
                return strongholdSpawnRarity;
        }

	function _spawnEvent() internal {
	}

        function _tokenBurn() internal {
        }
}
