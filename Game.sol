//  SPDX-License-Identifier: <SPDX-License>
pragma solidity >=0.7.0 <0.9.0;



// при деплої контракту потрібно внести певну суму на рахунок контракту, щоб потім з того рахунку знімалися гроші тим хто пререміг
contract Storage {
    address payable private owner;

    // режими гри: ONE-вгадай 1 число 
    // ODD- вгадай не парне
    // EVEN- вгадай парне число
    // PAIR- вгадай пару(1,2 або 3,4 або 5,6)
    enum GameMode {ONE, ODD, EVEN, PAIR}
    mapping(address =>uint256) private playersAccount;

    constructor()payable{
        owner = payable(msg.sender);
    }

// приймає 2 режима гри ONE і PAIR
// чомусь не працює коректно
    function play(uint8 number, GameMode gameMode)external payable hasMoney addPlayer(msg.sender){
        require(number > 0 && number < 7, "incorect number");
        uint8 randNumber = randomNuber();
        if(gameMode == GameMode.ONE){
            if(randNumber == number){
                playersAccount[msg.sender] *= 6;
            }else{
                playersAccount[msg.sender] = 1;
            }
        }else if(gameMode == GameMode.PAIR){
            if((number % 2 == 0? number : number + 1) == (randNumber % 2 == 0? randNumber : randNumber + 1)){
                playersAccount[msg.sender] *= 3;
            }else{
                playersAccount[msg.sender] = 1;
            }
        }
    }

// приймає 2 режими гри ODD і EVEN
    function playOddEven(GameMode gameMode)external payable hasMoney addPlayer(msg.sender){
        uint8 randNumber = randomNuber();
        if(gameMode == GameMode.ODD){
            if(randNumber % 2 != 0){
                playersAccount[msg.sender] *= 2;
            }else{
                playersAccount[msg.sender] = 1;
            }
        }else if(gameMode == GameMode.EVEN){
            if(randNumber % 2 == 0){
                playersAccount[msg.sender] *= 2;
            }else{
                playersAccount[msg.sender] = 1;
            }
        }
    }

// перевірка балансу
    function checkMoney(address ad)public view returns(uint256){
        return playersAccount[ad] - 1;
    }

// зняття з балансу
    function withdrawCash()external payable{
        if(playersAccount[msg.sender] > 1){
            payable(msg.sender).transfer(playersAccount[msg.sender]);
            playersAccount[msg.sender] = 1;
        }else{
            revert("you have no money");
        }
    }

// зупиняє контракт і надсилає гроші власнику контракту
    function stopContract()external{
        selfdestruct(owner);
    }

// генерує рандомні числа від 1 до 6
    function randomNuber()private view returns(uint8){
        return uint8(uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp))) % 6) + 1;
    }

//  добавляє гравця в гру
    modifier addPlayer(address ad){
        if(playersAccount[ad] == 0 || playersAccount[ad] == 1){
            playersAccount[ad] = msg.value;
        }
        _;
    }

//  перевіряє чи гравець має необхідну суму
    modifier hasMoney(){
        require(msg.value > .001 ether || playersAccount[msg.sender] != 1, "you have no maney");
        _;
    }
    
}