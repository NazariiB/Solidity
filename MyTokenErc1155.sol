// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract MyTokenErc1155 is Context, ERC1155, Ownable  {
    constructor(string memory _uri) ERC1155(_uri) { }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public
        onlyOwner {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public
        onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    function transferTo( address to, uint256 id, uint256 amount, bytes memory data) public {
        _safeTransferFrom(_msgSender(), to, id, amount, data);
    }

    function transferBatchTo(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public {
        _safeBatchTransferFrom(_msgSender(), to, ids, amounts, data);
    }
}