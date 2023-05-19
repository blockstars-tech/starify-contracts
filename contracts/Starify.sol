// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

//local imports
import "./ERC721S.sol";
import "./IStarify.sol";

contract Starify is IStarify, Initializable, ERC721S, OwnableUpgradeable {
    
    function initialize (uint256 maxBatchSize_, uint256 collectionSize_) public initializer {
        __ERC721S_init("Starify", "STF", maxBatchSize_, collectionSize_);
        __Ownable_init();
        minter = msg.sender;
        additionalInfo = msg.sender;
    }

    struct Star {
        string name;
        uint256 metadata;
    }

    string internal uri;
    address public minter;
    address public additionalInfo;
    uint256 public limitForMint;
    bool public isLimitSet;

    mapping (uint256 => Star) public tokenDetails;

    event tokenCreated(address from, address to, uint256 tokenID, uint256 quantity, bytes32 CharityId);

    modifier onlyMinter {
        require(msg.sender == minter, "You are not minter");
        _;
    }

    modifier onlyAddInfoContract {
        require(msg.sender == additionalInfo, "You are not minter");
        _;
    }

    modifier whenLimitNotSet {
        require(!isLimitSet, "Limit are set, and cannot be changed");
        _;
    }

    function setURI(string memory _uri) public onlyOwner {
        uri = _uri;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return uri;
    }

    function safeMint(address to, uint256 quantity, bytes32 charityId) public onlyMinter {
        if(isLimitSet) {
            require(totalSupply() + quantity <= limitForMint, "Limit for mint is sold out");
        }
        _safeMint(to, quantity, charityId);
        //emit tokenCreated(quantity, to, charityId);
    }

    function changeMinter (address newMinter ) public onlyOwner {
        minter = newMinter;
    }

    function changeAddInfoAddress (address addInfoAddress) public onlyOwner {
        additionalInfo = addInfoAddress;
    }

    function setName(uint256 tokenId, string memory name) public {
        require(msg.sender == ownerOf(tokenId), "You are not owner of this token");
        Star storage star = tokenDetails[tokenId];
        star.name = name;
    }

    function setMetadata(uint256 tokenId, uint256 metadata) public onlyAddInfoContract {
        Star storage star = tokenDetails[tokenId];
        star.metadata = metadata;
    }

    function tokenName(uint256 tokenId) public view returns (string memory name) {
        Star storage star = tokenDetails[tokenId];
        return star.name;
    }

    function setLimit (uint256 limit) public onlyOwner whenLimitNotSet {
        require(limit >= totalSupply(), "Limit must be greater than or equal to total supply");
        limitForMint = limit;
        isLimitSet = true;
    }

    function _afterTokenTransfers(
        address from,
        address to,
        uint256 tokenId,
        uint256 quantity,
        bytes32 charityId
    ) internal override {
        if(from == address(0)){
            emit tokenCreated(address(0), to, tokenId, quantity, charityId); //todo from to null
        }
        else{
            emit tokenCreated(from, to, tokenId, quantity, "");
        }
    }
}
