// SPDX-License-Identifier: GPL-3.0-OR-LATER
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract UniqueToken is ERC721 {

    uint256 private counter;

    constructor() ERC721("Unique Token", "TKN") {
        counter = 0;
    }

    modifier onlyOwner(uint256 tokenId) { require(ownerOf(tokenId) == msg.sender, "UniqueToken: Sender is not the owner of this token"); _; }

    function mintToken() public returns (uint256) {
        uint256 tokenId = counter++;
        _safeMint(msg.sender, tokenId);
        return tokenId;
    }

    function burnToken(uint256 tokenId) public onlyOwner(tokenId) {
        _burn(tokenId);
    }

}