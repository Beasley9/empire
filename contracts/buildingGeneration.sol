pragma solidity >0.8.0;

import "@openzepplin/contracts/tokens/ERC20/ERC20.sol";
import "@openzepplin/contracts/tokens/ERC721/ERC721.sol";
import "@openzepplin/contracts/access/Ownable.sol";

contract buildingGeneration is ERC21, ERC721, Ownable {

        struct building {
                uint location;
                uint time;
                uint originalOwner;
                uint16 biome;
                uint16 secondaryDependency;
                uint16 tertiaryDependency;
        }
