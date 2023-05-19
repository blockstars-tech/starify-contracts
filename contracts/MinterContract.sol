// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// Openzeppelin imports
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/// Local imports
import "./Charity.sol";
import "./Starify.sol";
import "./IStarify.sol";


contract MinterContract is Ownable {
    Charity public _charity;
    IStarify public _starify;

    address private _signer;

    constructor(
        address charityAddress,
        address starifyAddres
    ) {
        _charity = Charity(charityAddress);
        _starify = IStarify(starifyAddres);
        _signer = msg.sender;
    }

    function changeSigner(address signer) public onlyOwner {
        _signer = signer;
    }

    function _mint(
        address tokenOwner,
        bytes32 charityId,
        uint256 amount,
        bytes memory signature
    ) public {
        require(
            verify(tokenOwner, charityId, amount, signature),
            "Invalid signature"
        );
        _charity.addCharity(charityId, amount);
        _starify.safeMint(tokenOwner, amount, charityId);
    }

    function getMessageHash(
        address tokenOwner,
        bytes32 charityId,
        uint256 amount
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(tokenOwner, charityId, amount));
    }

    function getEthSignedMessageHash(bytes32 _messageHash)
        internal
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    _messageHash
                )
            );
    }

    function verify(
        address tokenOwner,
        bytes32 charityId,
        uint256 amount,
        bytes memory signature
    ) internal view returns (bool) {
        bytes32 messageHash = getMessageHash(tokenOwner, charityId, amount);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

    function recoverSigner(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) internal pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig)
        internal
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }
    }
}
