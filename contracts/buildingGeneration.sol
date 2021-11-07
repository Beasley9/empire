pragma solidity >0.8.0;

import "@openzepplin/contracts/tokens/ERC20/ERC20.sol";
import "@openzepplin/contracts/tokens/ERC721/ERC721.sol";
import "@openzepplin/contracts/access/Ownable.sol";

contract buildingGeneration is ERC21, ERC721, Ownable {

        struct building {
                uint location;
                uint time;
                address originalOwner;
                uint16 biome;
                uint16 secondaryDependency;
                uint16 tertiaryDependency;
        }

        building[] Buildings;

        event outpostGeneration(uint location, uint time, address originalOwner, uint16 biome, uint16 secondaryDependency, uint16 tertiaryDependency);

        mapping (address => uint) legacyOwnedBuildings
        mapping (address => uint) ownerNumBuildings
        mapping (address => uint) ownerNumResources
        mapping (uint => address) buildingToOwner

        uint private cooldownTime;

        function getCooldownTime(address _user) public view returns (uint) {
                return cooldownTime;

        function setCooldownTime(address _user) internal {
                if (legacyOwnedBuildings[_user] == 0) {
                        cooldownTime = 0 days;
                }
                else if (legacyOwnedBuildings[_user] <= 2) {
                        cooldownTime = legacyOwnedBuildings[_user] - 1 days;
                }
                else {
                        cooldownTime = (7 * (1 - (12/(legacyOwnedBuildings[_user] * 7)))) days;

        modifier outpostGenerationCooldownTime(address _user) {
                require (getCooldownTime(_user) + block.timestamp <= block.timestamp);
                _;
        }


        //Function will require oracles
        function generateOutpost(address _user) public outpostGenerationCooldownTime(_user) {
                require(msg.sender == _user);
                //buildingId = Buildings.push(...) - 1
                buildingToOwner[buildingId] = _user
                ownerNumBuildings[_user]++;
                legacyNumBuildings[_user]++;
                cooldownTime = block.timestamp + 
                emit outpostGeneration(//Finsh)
