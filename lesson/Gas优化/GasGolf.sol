// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract GasGolf{
    //gas优化
    uint public total;
    //未优化前的代码
    // function sumIfEvenAndLessThan99(uint[] memory nums)external{
    //     for(uint i = 0; i<nums.length;i+=1){
    //         bool isEven = nums[i]%2==0;
    //         bool isLessThan99 = nums[i]<99;
    //         if (isEven && isLessThan99){
    //             total+=nums[i];
    //         }
    //     }
    // }
    //[1,2,3,4,5,100];
    //start: gas =50860 gas
    //优化项目:============================
    // 1.use calldata;
    // 2.load state variables to memory;
    // 3.short circuit;
    // 4.loop increments use ++i better than i++
    // 5.cache array length
    // 6.load array elements to memory

    //1.nums memory 改为calldata  32015 gas


    // function sumIfEvenAndLessThan99(uint[] calldata nums)external{
    //     for(uint i = 0; i<nums.length;i+=1){
    //         bool isEven = nums[i]%2==0;
    //         bool isLessThan99 = nums[i]<99;
    //         if (isEven && isLessThan99){
    //             total+=nums[i];
    //         }
    //     }
    // }

    // function sumIfEvenAndLessThan99(uint[] calldata nums)external{
    // //2.将循环体内的状态变量放到外面来，避免每次都需要重新写入状态变量，节约gas  39474 gas 
    //     uint _total = total;
    //     for(uint i = 0; i<nums.length;i+=1){
    //         bool isEven = nums[i]%2==0;
    //         bool isLessThan99 = nums[i]<99;
    //         if (isEven && isLessThan99){
    //             total+=nums[i];
    //         }
    //     }
    //     //循环结束后再写入状态变量
    //     total = _total;
    // }
    // //3.短路  39220 gas===============
    //   function sumIfEvenAndLessThan99(uint[] calldata nums)external{
    // //2.将循环体内的状态变量放到外面来，避免每次都需要重新写入状态变量，节约gas  39474 gas 
    //     uint _total = total;
    //     for(uint i = 0; i<nums.length;i+=1){
    //         if (nums[i]%2==0 && nums[i]<99){//如果第一个条件不满足，就不会执行下一个条件，短路
    //             total+=nums[i];
    //         }
    //     }
    //     //循环结束后再写入状态变量
    //     total = _total;
    // }

    // //4.优化循环增量 =================38922 gas

    //   function sumIfEvenAndLessThan99(uint[] calldata nums)external{
    // //2.将循环体内的状态变量放到外面来，避免每次都需要重新写入状态变量，节约gas  39474 gas 
    //     uint _total = total;
    //     for(uint i = 0; i<nums.length;++i){//++i比i++更节省gas
    //     //当执行 i++ 的时候，要比 ++i 多执行一个 SWAP2 和一个 SWAP3，而每个 SWAP* 固定的消耗为 3 gas
    //         if (nums[i]%2==0 && nums[i]<99){//如果第一个条件不满足，就不会执行下一个条件，短路
    //             total+=nums[i];
    //         }
    //     }
    //     //循环结束后再写入状态变量
    //     total = _total;
    // }

//    //5.换存数组长度 =================38894 gas
//       function sumIfEvenAndLessThan99(uint[] calldata nums)external{
//     //2.将循环体内的状态变量放到外面来，避免每次都需要重新写入状态变量，节约gas  39474 gas 
//         uint _total = total;
//         uint len = nums.length;
//         for(uint i = 0; i<len;++i){//++i比i++更节省gas
//         //当执行 i++ 的时候，要比 ++i 多执行一个 SWAP2 和一个 SWAP3，而每个 SWAP* 固定的消耗为 3 gas
//             if (nums[i]%2==0 && nums[i]<99){//如果第一个条件不满足，就不会执行下一个条件，短路
//                 total+=nums[i];
//             }
//         }
//         //循环结束后再写入状态变量
//         total = _total;
//     }

       //6.存储数组元素 memory =================38764 gas
      function sumIfEvenAndLessThan99(uint[] calldata nums)external{
    //2.将循环体内的状态变量放到外面来，避免每次都需要重新写入状态变量，节约gas  39474 gas 
        uint _total = total;
        uint len = nums.length;
        for(uint i = 0; i<len;++i){//++i比i++更节省gas
        //当执行 i++ 的时候，要比 ++i 多执行一个 SWAP2 和一个 SWAP3，而每个 SWAP* 固定的消耗为 3 gas
           uint num = nums[i];
            if (num%2==0 && num<99){//如果第一个条件不满足，就不会执行下一个条件，短路
                total+=num;
            }
        }
        //循环结束后再写入状态变量
        total = _total;
    }
}