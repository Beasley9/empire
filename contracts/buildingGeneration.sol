pragma solidity >0.8.0;

import "@openzepplin/contracts/tokens/ERC20/ERC20.sol";
import "@openzepplin/contracts/tokens/ERC721/ERC721.sol";
import "./spawnEvent.sol";

contract buildingGeneration is ERC21, ERC721, spawnEvent {

        // Declare global structs in this block
        struct private building {
                address originalOwner;
                uint level;
                uint maxEfficiency;
                uint location;
                uint time;
                uint16 biome;
                uint16 secondaryDependency;
                uint16 tertiaryDependency;
        };

        struct private resource {
                uint16 biome;
                uint8 rarity;
        };

        // Initialize arrays
        building[] private Buildings;
        resource[] private Resources;

        // Order all events 
        event outpostGeneration(address originalOwner, uint level, uint maxEfficiency, uint location, uint time, uint16 biome, uint16 secondaryDependency, uint16 tertiaryDependency);

        // Order all mappings
        mapping (address => uint) private legacyOwnedBuildings;
        mapping (address => uint) private ownerNumBuildings;
        mapping (address => uint) private ownerNumResources;
        mapping (uint => address) private buildingToOwner;


        // Order all global variables
        uint private cooldownTime;

        // Order all modifier functions
        modifier outpostGenerationCooldownTime(address _user) {
                require(getCooldownTime(_user) + block.timestamp <= block.timestamp);
                _;
        }

        modifier isOwner(uint _address) {
                require(_address == msg.sender);
                _;
        }

        // Order all constructors




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
        function generateOutpost(address _user) public outpostGenerationCooldownTime(_user) {
                require(msg.sender == _user);
                //buildingId = Buildings.push(...) - 1
                buildingToOwner[buildingId] = _user
                ownerNumBuildings[_user]++;
                legacyNumBuildings[_user]++;
                cooldownTime = block.timestamp + 
                emit outpostGeneration(//Finsh)
        }

}
