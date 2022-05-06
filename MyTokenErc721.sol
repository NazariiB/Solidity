// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyTokenErc721 is ERC721, Ownable {

    constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol ) {}

    function transfer(address to, uint256 tokenId) external {
        require(balanceOf(_msgSender()) > 5, "error");
        _transfer(_msgSender(), to, tokenId);
    }

    function mint(address to, uint256 tokenId)external onlyOwner() {
        _mint(to, tokenId);
    }
}