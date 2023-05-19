// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./ERC721S.sol";


interface IStarify {
    
    function setURI(string memory _uri) external;

    function changeMinter (address newMinter ) external;

    function tokenName(uint256 tokenId) external view returns (string memory name);

    function setLimit (uint256 limit) external;

    function safeMint(address to, uint256 quantity, bytes32 charityId) external;
       
    function setName(uint256 tokenId, string memory name) external;
        
    function setMetadata(uint256 tokenId, uint256 metadata) external;
        
}
