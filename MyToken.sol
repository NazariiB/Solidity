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
    function transfer(address to, uint256 amount) public virtual override returns(bool) {
        bool res = false;
        if(hasRole(ADMIN, _msgSender())){
            _transfer(_msgSender(), to, amount);
            res = true;
        }else if(hasRole(USER, _msgSender())){
            require(amount < 100, "you can't transfer over 100 tokens");
            _transfer(_msgSender(), to, amount);
            res = true;
        }else {
            revert("you have no role");
        }
        return res;
    }

// user can mint if user have more than 1000 tokens
// admin can mint
    function mint(address account, uint256 amount)public virtual {
        if(hasRole(ADMIN, _msgSender())) {
            _mint(account, amount);
        }else if(hasRole(USER, _msgSender())) {
            require(balanceOf(_msgSender()) > 1000, "you do not have enough tokens");
            _mint(account, amount);
        }else {
            revert("you have no role");
        }
    }

// only admin can burn
    function burn(address account, uint256 amount) public virtual onlyRole(ADMIN) {
        _burn(account, amount);
    }

// only admin can add an account a role
    function grantRole(bytes32 role, address account)public virtual override onlyRole(ADMIN){
        _grantRole(role, account);
    }
}
