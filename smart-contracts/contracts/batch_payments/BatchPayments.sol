// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract BatchPayments {

    error Reverted();
    
    function recieve() external payable {
        revert Reverted();
    }

    function batchEtherPayment(address[] calldata recipients, uint256[] calldata values) external payable {
        for (uint256 i = 0; i < recipients.length; i++)
            payable(recipients[i]).transfer(values[i]);
        uint256 balance = address(this).balance;
        if (balance > 0)
            payable(msg.sender).transfer(balance);
    }


    /// @notice Costs 77093 gas to tranfer 6e18 to three address.  costs 7351 gas less to execute.
    function batchERC20Payment(IERC20 token, address[] calldata recipients, uint256[] calldata values) external {
        for (uint256 i = 0; i < recipients.length; i++)
            token.transferFrom(msg.sender, recipients[i], values[i]);
    }
}