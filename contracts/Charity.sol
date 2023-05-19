// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract Charity is Ownable {
    constructor(){
        minter = msg.sender;
    }

    address public minter;

    modifier onlyMinter {
        require(msg.sender == minter, "You are not minter");
        _;
    }

    function changrMinter(address _minter) public onlyOwner {
        minter = _minter;
    }

    mapping(bytes32 => uint256) charities;  //todo change string

    function getCharities (bytes32 charityId) public view returns(uint256 amount) {
        require(charities[charityId] > 0, "dont have charity for this id");
        return charities[charityId];
    }

    function addCharity (bytes32 charityId, uint256 amount) public onlyMinter {
        require(amount > 0, "Amount can not be zero");
        require(charities[charityId] == 0, "This id of charity already exists");
        charities[charityId] = amount;
    }
}
