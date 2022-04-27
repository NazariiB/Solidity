// contracts/ExampleToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/ownership/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/lifecycle/Pausable.sol";

contract Game is Ownable, Pausable {
    using SafeMath for uint256;
    using SafeMath for uint8;
    enum GameMode { ONE, ODD, EVEN, PAIR}
    mapping (address => uint256) private players;
    uint8 private upper = 6;
    
    function play( uint8 number, GameMode gameMode )external payable hasMoney whenNotPaused returns(uint8, bool){
        require(number > 0 && number <= upper, "incorect number");
        uint8 randNumber = randomNuber();
        bool win = false;
        if(gameMode == GameMode.ONE && randNumber == number){
            players[msg.sender].add(uint256(msg.value).mul(6));
            win = true;
        }else if(gameMode == GameMode.PAIR &&
         (number.mod(2) == 0 ? number : number.add(1)) == (randNumber.mod(2) == 0 ? randNumber : randNumber.add(1))){
            players[msg.sender] = players[msg.sender].add(uint256(msg.value).mul(3));
            win = true;
        }else if(gameMode == GameMode.ODD && randNumber.mod(2) != 0){
            players[msg.sender] = players[msg.sender].add(uint256(msg.value).mul(2));
            win = true;
        }else if(gameMode == GameMode.EVEN && randNumber.mod(2) == 0){
            players[msg.sender] = players[msg.sender].add(uint256(msg.value).mul(2));
            win = true;
        }else if(players[msg.sender] != 0) {
            delete players[msg.sender];
        }
        return(randNumber, win);
    }

    function checkMoney()public view returns(uint256) {
        return players[msg.sender];
    }

    function withdrawCash()external whenNotPaused {
        if(players[msg.sender] != 0){
            msg.sender.transfer(players[msg.sender]);
            players[msg.sender] = 0;
        }else{
            revert("you have no maney");
        }
    }
    
    function randomNuber()private view returns(uint8){
        return uint8(uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp))).mod(upper)) + 1;
    }

    function setUpper(uint8 up) public onlyOwner {
        upper = up;
    }

    function getUpper() public view returns(uint8){
        return upper;
    }

    modifier hasMoney(){
        require(msg.value > 0.1 ether, "you have no maney");
        _;
    }
}
