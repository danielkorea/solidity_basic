// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Struct {
    struct Car{
        string model;
        unit year;
        address owner;

    }
    Car public car;
    Car[] public cars;
    mapping(address => Car[])public carsByOwner;
    function examples() external{
        Car memory toyota = Car("Toyota",1990,msg.sender);
        Car memory lambo = Car({year:1980,model:"lamborghini",owner:msg.sender});
        Car memory tesla;
        tesla.model = "Tesla";
        tesla.year = 2016;
        tesla.owner = msg.sender;
        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);

        cars.push(Car("Ferrari",2020,msg.sender));

        Car memory _car = cars[0];
        _car.mdoel;
        _car.year;
        _car.owner;
        Car storage _car2 = cars[0];
        _car2.year = 2020;
        delete _car2.owner;
    }
}