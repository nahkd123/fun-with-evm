// SPDX-License-Identifier: GPL-3.0-OR-LATER
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TokenTrade is IERC721Receiver {

    address public requester;
    ERC721 public tokenContract;
    uint256 public requestedPrice;

    bool public offerOver;
    bool public canceled;
    bool public requestMade;
    uint256 public tokenId;

    constructor(address contractAddress, uint256 _requestedPrice) {
        requester = msg.sender;
        tokenContract = ERC721(contractAddress);
        requestedPrice = _requestedPrice;

        offerOver = false;
        canceled = false;
        requestMade = false;
    }

    modifier notCanceled() { require(!canceled, "TokenTrade: offer canceled"); _; }
    modifier notOver() { require(!offerOver, "TokenTrade: offer canceled"); _; }
    modifier callFromTokenContract() { require(msg.sender == address(tokenContract), "TokenTrade: function not called from token contract"); _; }
    
    modifier fromRequester(address target) { require(target == requester, "TokenTrade: function must be called by requester"); _; }
    modifier requestHaveMade() { require(requestMade, "TokenTrade: The token haven't transfered to this contract yet"); _; }
    modifier requestAwaiting() { require(!requestMade, "TokenTrade"); _; }

    modifier priceMatch() { require(requestedPrice == msg.value, "TokenTrade: value does not equals with requested price"); _; }
    modifier fromBuyer() { require(msg.sender != requester, "TokenTrade: you can't buy your own token"); _; }

    function onERC721Received(
        address operator,
        address from,
        uint256 _tokenId,
        bytes calldata data
    ) override external fromRequester(operator) callFromTokenContract requestAwaiting notCanceled notOver returns (bytes4) {
        requestMade = true;
        tokenId = _tokenId;
        return TokenTrade.onERC721Received.selector;
    }

    function buy() public payable requestHaveMade priceMatch fromBuyer notCanceled notOver {
        tokenContract.safeTransferFrom(address(this), msg.sender, tokenId);
        payable(requester).transfer(requestedPrice);
        offerOver = true;
    }

}