pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MyToken is Context, ERC20, AccessControl {

    bytes32 private ADMIN = keccak256("ADMIN");
    bytes32 private USER = keccak256("USER");

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _grantRole(ADMIN, _msgSender());
    }

// you can't transfer over 100 tokens if you are an user
// you can transfer a lot tokens if you are an admin
    function transfer(address to, uint256 amount) public override returns(bool) {
        require((hasRole(USER, _msgSender()) && amount < 100) || hasRole(ADMIN, _msgSender()), "error");
        _transfer(_msgSender(), to, amount);
        return true;
    }

// user can mint if user have more than 1000 tokens
// admin can mint
    function mint(address account, uint256 amount)public {
        require(hasRole(ADMIN, _msgSender()) || (hasRole(USER, _msgSender()) && balanceOf(_msgSender()) > 1000), "error");
        _mint(account, amount);
    }

// only admin can burn
    function burn(address account, uint256 amount) public onlyRole(ADMIN) {
        _burn(account, amount);
    }

}
