// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// Local imports
import "./Starify.sol";
import "./IStarify.sol";

contract AddInfo {

    IStarify public _starify;

    constructor(address starifyAddres) {
        _starify = IStarify(starifyAddres);
    }

    // function setName(uint256 tokenId, string memory name) public {
    //     _starify.setName(msg.sender, tokenId, name);
    // }

    function setMetadata(uint256 tokenId, uint256 metadata) public {
        _starify.setMetadata(tokenId, metadata);
        // address(_starify).delegatecall(abi.encodeWithSignature(
        //         "setMetadata(uint256, uint256)",
        //         tokenId, metadata
        //     ));
    }

}

