// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScooterRental {
    address payable public owner;
    mapping(address => uint) public balances;
    mapping(address => bool) public rented;
    uint public rentalPrice = 100 wei;

    event ScooterRented(address indexed user);
    event ScooterReturned(address indexed user);

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier notRented() {
        require(!rented[msg.sender], "Scooter already rented");
        _;
    }

    function rentScooter() external payable notRented {
        require(msg.value == rentalPrice, "Incorrect payment amount");
        balances[msg.sender] += msg.value;
        rented[msg.sender] = true;
        emit ScooterRented(msg.sender);
    }

    function returnScooter() external {
        require(rented[msg.sender], "Scooter not rented");
        rented[msg.sender] = false;
        balances[msg.sender] -= rentalPrice;
        owner.transfer(rentalPrice);
        emit ScooterReturned(msg.sender);
    }
}
