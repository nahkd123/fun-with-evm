// SPDX-License-Identifier: GPL-3.0-OR-LATER
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CreditCard is ERC721 {

    uint256 private counter;
    mapping (uint256 => uint256) public credits;

    constructor() ERC721("Credit Card", "CRIT") {
        counter = 0;
    }

    modifier onlyOwner(uint256 tokenId) { require(ownerOf(tokenId) == msg.sender, "CreditCard: Sender is not the owner of this token"); _; }

    function newCard() public returns (uint256) {
        uint256 tokenId = counter++;
        _safeMint(msg.sender, tokenId);
        credits[tokenId] = 0;
        return tokenId;
    }

    function sendCredit(uint256 tokenId) public payable onlyOwner(tokenId) {
        credits[tokenId] += msg.value;
    }

    function burnCard(uint256 tokenId) public onlyOwner(tokenId) {
        _burn(tokenId);
        uint256 credit = credits[tokenId];
        payable(msg.sender).transfer(credit);
        delete credits[tokenId];
    }

}
