// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/utils/cryptography/ECDSA.sol";
/*
Signature Replay
Signing messages off-chain and having a contract 
that requires that signature before executing a function is a useful technique.

For example this technique is used to:

reduce number of transaction on chain
gas-less transaction, called meta transaction
Vulnerability
Same signature can be used multiple times to execute a function. 
This can be harmful if the signer's intention was to approve a transaction once.
在链下签署消息并拥有在执行功能之前需要该签名的合约是一项有用的技术。

例如，此技术用于：

减少链上交易数量
无气体交易，称为meta transaction
漏洞
可以多次使用相同的签名来执行一个函数。如果签名者的意图是一次批准交易，这可能是有害的。*/
contract MultiSigWallet {
    using ECDSA for bytes32;

    address[2] public owners;

    constructor(address[2] memory _owners) payable {
        owners = _owners;
    }

    function deposit() external payable {}
//方法一：新增 _nonce 参数来确定唯一的签名，
    function transfer(address _to, uint _amount, bytes[2] memory _sigs) external {
        bytes32 txHash = getTxHash(_to, _amount);
        require(_checkSigs(_sigs, txHash), "invalid sig");

        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }

    function getTxHash(address _to, uint _amount) public view returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount));
    }

    function _checkSigs(
        bytes[2] memory _sigs,
        bytes32 _txHash
    ) private view returns (bool) {
        bytes32 ethSignedHash = _txHash.toEthSignedMessageHash();

        for (uint i = 0; i < _sigs.length; i++) {
            address signer = ethSignedHash.recover(_sigs[i]);
            bool valid = signer == owners[i];

            if (!valid) {
                return false;
            }
        }

        return true;
    }
}
