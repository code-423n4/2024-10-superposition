# Superposition audit details
- Total Prize Pool: $21,000 in USDC
  - HM awards: $17,400 in USDC
  - Judge awards: $1,900 in USDC
  - Validator awards: $1,200 in USDC
  - Scout awards: $500 in USDC
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts October 18, 2024 20:00 UTC
- Ends November 1, 2024 20:00 UTC

ℹ️ While there are no QA awards, QA reports are encouraged as a fallback in the event of no valid HMs. 

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-10-superposition/blob/main/4naly3er-report.md).

_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._

* Operator makes a mistake with a trusted function.


# Overview


Longtail is a concentrated liquidity AMM powered by Arbitrum Stylus. Arbitrum Stylus is a WASM frontend to the EVM on Arbitrum.

Longtail differs from a traditional V3 AMM in the following ways:

1. One contract for everything: Liquidity is centralised in one contract.
2. One shared asset between every pool: fUSDC is shared between every pool.
3. Contract addresses are embedded in the compiled code: Contract addresses are set using environment variables.
4. Native support for permit2: Permit2 is natively supported for a better UX.
5. Diamond-like proxy for dispatch: A Solidity contract is used to delegatecall to different facets of the contract.

See [pkg/README.md](https://github.com/code-423n4/2024-10-superposition/blob/main/pkg/README.md) for deployment addresses and more details.

## Links

- **Previous audits:**  
  - https://audits.long.so/
  - ✅ C4 August audit
- **Documentation:** https://docs.long.so
- **Website:** https://superposition.so
- **X/Twitter:** https://x.com/superpositionso
- **Discord:** https://discord.gg/Xxa8H3tp

---

# Scope

*See [scope.txt](https://github.com/code-423n4/2024-10-superposition/blob/main/scope.txt)*

### Files in scope


✅ - update table
| File   | Logic Contracts | Interfaces | nSLOC | Purpose | Libraries used |
| ------ | --------------- | ---------- | ----- | -----   | ------------ |
| /pkg/seawater/src/lib.rs | ****| **** | 812 | ||
| /pkg/seawater/src/main.rs | ****| **** | 8 | ||
| /pkg/seawater/src/maths/mod.rs | ****| **** | 9 | ||
| /pkg/sol/OwnershipNFTs.sol | 1| **** | 106 | ||
| /pkg/sol/SeawaterAMM.sol | 2| **** | 290 | ||
| **Totals** | **3** | **** | **1225** | | |

### Files out of scope

*See [out_of_scope.txt](https://github.com/code-423n4/2024-10-superposition/blob/main/out_of_scope.txt)*


## Scoping Q &amp; A

### General questions


| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| ERC20 used by the protocol              |       USDC             |
| Test coverage                           |       N/A                          |
| ERC721 used  by the protocol            |            OwnershipNFTs              |
| ERC777 used by the protocol             |           None                |
| ERC1155 used by the protocol            |              None            |
| Chains the protocol will be deployed on | Superposition   |

### External integrations (e.g., Uniswap) behavior in scope:


| Question                                                  | Answer |
| --------------------------------------------------------- | ------ |
| Enabling/disabling fees (e.g. Blur disables/enables fees) | No   |
| Pausability (e.g. Uniswap pool gets paused)               |  No   |
| Upgradeability (e.g. Uniswap gets upgraded)               |   No  |


### EIP compliance checklist
N/A



# Additional context

## Main invariants

The functionality should be reasonably similar to Uniswap's.

## Attack ideas (where to focus for bugs)
1. Discrepancy with Uniswap in an end to end environment
2. Fee taking isn't correct. Full ticks aren't correct


## All trusted roles in the protocol

| Role                                    |  Description                                                    |
| --------------------------------------- | --------------------------------------------------------------- |
| Operator                                | Controls access to the repo, and implementation addresses.      |
| Emergency Council                       | Can shut the dapp down if needed.                               |
| NFT manager                             | Allows addresses to control their ownership of assets as a NFT. |

## Describe any novel or unique curve logic or mathematical models implemented in the contracts:

Concentrated liquidity math


## Running tests

See [pkg/README](https://github.com/code-423n4/2024-10-superposition/blob/main/pkg/README.md#building) for a detailed explanation



Then run the following command:
```bash
https://github.com/code-423n4/2024-10-superposition
cd 2024-10-superposition/pkg
rustup target add wasm32-unknown-unknown
cargo install cargo-stylus
./tests.sh # this would test the rust files from the files in `tests`.

```

## Miscellaneous
Employees of Superposition and employees' family members are ineligible to participate in this audit.

Code4rena's rules cannot be overridden by the contents of this README. In case of doubt, please check with C4 staff.
