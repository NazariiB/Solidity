pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20{

    mapping(address => uint256) private _balances;

    uint256 private _totalSupply = 10000;

    string private _name = "MyToken";

    string private _symbol = "MTK";

    uint8 private decimal = 18;

    address private owner;

    constructor() ERC20("MyToken", "MTK") { 
        owner = msg.sender;
    }

    function transfer(address to, uint256 amount)public override returns(bool) {
        require(amount < 100, "you can transfer only below 100 tokens");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function mint(address ad,uint amount) external {
        require(ad == owner, "you are not an owner");
        _balances[ad] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), ad, amount);
    }

    function burn(address ad, uint amount) external {
        require(_balances[ad] > 1000, "you dont have enough tokens");
        _balances[ad] -= amount;
        _totalSupply -= amount;
        emit Transfer(address(0), ad, amount);
    }
}