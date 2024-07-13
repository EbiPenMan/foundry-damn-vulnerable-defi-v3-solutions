<!-- ![](cover.png) -->

```solidity

______                        _   _       _                      _     _       ______    ______ _
|  _  \                      | | | |     | |                    | |   | |      |  _  \   |  ___(_)
| | | |__ _ _ __ ___  _ __   | | | |_   _| |_ __   ___ _ __ __ _| |__ | | ___  | | | |___| |_   _
| | | / _` | '_ ` _ \| '_ \  | | | | | | | | '_ \ / _ | '__/ _` | '_ \| |/ _ \ | | | / _ |  _| | |
| |/ | (_| | | | | | | | | | \ \_/ | |_| | | | | |  __| | | (_| | |_) | |  __/ | |/ |  __| |   | |
|___/ \__,_______| |_|_| |_|  \___/ \__,_|_|_| |_|\______  \__,_|_.___|_|\___| |___/ \___\_|   |_|
           |  ___|                  | |            |  ___|  | (_| | (_)
           | |_ ___  _   _ _ __   __| |_ __ _   _  | |__  __| |_| |_ _  ___  _ __
           |  _/ _ \| | | | '_ \ / _` | '__| | | | |  __|/ _` | | __| |/ _ \| '_ \
           | || (_) | |_| | | | | (_| | |  | |_| | | |__| (_| | | |_| | (_) | | | |
           \_| \___/ \__,_|_| |_|\__,_|_|   \__, | \____/\__,_|_|\__|_|\___/|_| |_|
                                             __/ |
                                            |___/

```

# Damn Vulnerable DeFi - Foundry Edition

**A set of challenges to learn offensive security of smart contracts in Ethereum.**

This repository is Solutions of the
[Foundry-based  Damn Vulnerable DeFi V3](https://github.com/EbiPenMan/foundry-damn-vulnerable-defi-v3) project. The challenges feature
flash loans, price oracles, governance, NFTs, lending pools, smart contract wallets, timelocks, and more!


## How to Use

This repository uses Foundry for running tests and interacting with smart contracts. Follow the instructions below to
get started:

### Prerequisites

- Install [Foundry](https://getfoundry.sh/).
- Install [NodeJS](https://nodejs.org/en/download/package-manager).

### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/EbiPenMan/foundry-damn-vulnerable-defi-v3-solutions
   cd foundry-damn-vulnerable-defi-v3-solutions
   ```

2. Install dependencies:
   ```sh
    bun install # install Solhint, Prettier, and other Node.js deps
   ```


### Running Tests

To run the specefic tests, use the following command:

```sh
forge test --match-test testUnstoppable
```

To run the all tests, use the following command:

```sh
forge test
```

### Todo List

- [x] 1: Unstoppable
- [x] 2: Naive receiver
- [x] 3: Truster
- [x] 4: Side Entrance
- [x] 5: The Rewarder
- [x] 6: Selfie
- [x] 7: Compromised
- [x] 8: Puppet
- [ ] 9: Puppet V2
- [ ] 10: Free Rider
- [ ] 11: Backdoor
- [ ] 12: Climber
- [ ] 13: Wallet Mining
- [ ] 14: Puppet V3
- [ ] 15: ABI Smuggling

## Disclaimer

All Solidity code, practices, and patterns in this repository are **DAMN VULNERABLE** and for educational purposes only.

Please note that the conversion of tests from Hardhat to Foundry and the update of dependencies may contain errors.
