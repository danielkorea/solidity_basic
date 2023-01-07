// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


contract MultiDelegatecall{
    error DelegatecallFailed();
    function multiDelegatecall(bytes[] calldata data)
        external
        payable
        returns (bytes[] memory results)
    {
        results = new bytes[](data.length);
        for (uint i; i<data.length;i++){
            (bool ok,bytes memory res) = address(this).delegatecall(data[i]);
            if(!ok){
                revert DelegatecallFailed();
            }
            results[i] = res;
        }

    }
}
//委托调用合约不能单独存在，委托调用只能够调用自身合约！合约如果不是自己的 编写，也没有办法使用委托调用。
contract TestMultiDelegatecall is MultiDelegatecall{
    event Log(address caller,string func,uint i);
    function func1(uint x,uint y)external{
        emit Log(msg.sender,"func1",x+y);
    }
    function func2()external returns (uint){
        emit Log(msg.sender,"func2",2);
        return 111;
    }
    //委托调用存在漏洞，示例,（不要重复地计算主币数量或者委托调用不能接受主币也是一种解决方案)
    mapping(address => uint) public balanceOf;//余额
    function mint()external payable{
        balanceOf(msg.sender) += msg.value;//发送一个ether ,结果会重复计算
    }

 

}
contract Helper{
    function getData1(uint x, uint y) external pure returns(bytes memory){
    
        return abi.encodeWithSelector(TestMultiDelegatecall.func1.selector,x,y);//方法二

    }
    function getData2() external pure returns(bytes memory){
       
        return abi.encodeWithSelector(TestMultiDelegatecall.func2.selector);//方法二

    }
    function getMintData() external pure returns(bytes memory){
       
        return abi.encodeWithSelector(TestMultiDelegatecall.mint.selector);//方法二

    }
}
}