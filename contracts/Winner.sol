// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

contract PickWinner {
    address public owner;
    struct WinnerDetails {
        uint256 amountSent;
        uint256 timestamp;
    }
    mapping(address => WinnerDetails) public winners;
    uint256 public contractBalance;

    event Winner(address indexed winner, uint256 amountSent, uint256 timestamp);

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only contract owner can call this function"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
        contractBalance = address(this).balance;
    }

    receive() external payable {
        contractBalance += msg.value;
    }

    function sendFunds(address payable recipient) external onlyOwner {
        require(contractBalance >= 0.1 ether, "Insufficient funds");

        uint256 amountToSend = contractBalance - 0.1 ether;
        recipient.transfer(amountToSend);
        winners[recipient] = WinnerDetails(amountToSend, block.timestamp);
        contractBalance -= amountToSend;

        emit Winner(recipient, amountToSend, block.timestamp);
    }
}
