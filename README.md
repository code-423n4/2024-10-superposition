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

Operator makes a mistake with a trusted function

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

# Overview

[ ⭐️ SPONSORS: add info here ]

## Links

- **Previous audits:**  https://audits.long.so/

And Codearena audit from before
  - ✅ SCOUTS: If there are multiple report links, please format them in a list.
- **Documentation:** https://docs.long.so
- **Website:** https://superposition.so
- **X/Twitter:** https://x.com/superpositionso
- **Discord:** https://discord.gg/Xxa8H3tp

---

# Scope

*See [scope.txt](https://github.com/code-423n4/2024-10-superposition/blob/main/scope.txt)*

### Files in scope


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

| File         |
| ------------ |
| ./cmd/faucet.superposition/graph/filter.go |
| ./cmd/faucet.superposition/graph/filter_test.go |
| ./cmd/faucet.superposition/graph/generated.go |
| ./cmd/faucet.superposition/graph/model/models_gen.go |
| ./cmd/faucet.superposition/graph/resolver.go |
| ./cmd/faucet.superposition/graph/schema.resolvers.go |
| ./cmd/faucet.superposition/graph/stakers.go |
| ./cmd/faucet.superposition/graph/verify-turnstile.go |
| ./cmd/faucet.superposition/lib/faucet/faucet.go |
| ./cmd/faucet.superposition/lib/faucet/request.go |
| ./cmd/faucet.superposition/main.go |
| ./cmd/faucet.superposition/tools.go |
| ./cmd/graphql.ethereum/graph/consts.go |
| ./cmd/graphql.ethereum/graph/generated.go |
| ./cmd/graphql.ethereum/graph/math.go |
| ./cmd/graphql.ethereum/graph/mocked.go |
| ./cmd/graphql.ethereum/graph/model/amount.go |
| ./cmd/graphql.ethereum/graph/model/liquidity-campaign.go |
| ./cmd/graphql.ethereum/graph/model/liquidity.go |
| ./cmd/graphql.ethereum/graph/model/models_gen.go |
| ./cmd/graphql.ethereum/graph/model/pagination.go |
| ./cmd/graphql.ethereum/graph/model/pool-config.go |
| ./cmd/graphql.ethereum/graph/model/price.go |
| ./cmd/graphql.ethereum/graph/model/price_test.go |
| ./cmd/graphql.ethereum/graph/model/seawater.go |
| ./cmd/graphql.ethereum/graph/model/swaps.go |
| ./cmd/graphql.ethereum/graph/model/token.go |
| ./cmd/graphql.ethereum/graph/model/wallet.go |
| ./cmd/graphql.ethereum/graph/resolver.go |
| ./cmd/graphql.ethereum/graph/schema.resolvers.go |
| ./cmd/graphql.ethereum/lib/erc20/erc20.go |
| ./cmd/graphql.ethereum/lib/erc20/erc20_test.go |
| ./cmd/graphql.ethereum/main.go |
| ./cmd/graphql.ethereum/pools.go |
| ./cmd/graphql.ethereum/tools.go |
| ./cmd/ingestor.logs.ethereum/func.go |
| ./cmd/ingestor.logs.ethereum/func_test.go |
| ./cmd/ingestor.logs.ethereum/main.go |
| ./cmd/ingestor.logs.ethereum/polling-db.go |
| ./cmd/ingestor.logs.ethereum/reflect.go |
| ./cmd/snapshot.ethereum/database.go |
| ./cmd/snapshot.ethereum/main.go |
| ./cmd/snapshot.ethereum/rpc.go |
| ./cmd/snapshot.ethereum/rpc_test.go |
| ./lib/config/config.go |
| ./lib/config/defaults.go |
| ./lib/config/pools.go |
| ./lib/events/erc20/erc20.go |
| ./lib/events/erc20/types.go |
| ./lib/events/events.go |
| ./lib/events/fluidity/fluidity.go |
| ./lib/events/fluidity/types.go |
| ./lib/events/leo/leo.go |
| ./lib/events/leo/leo_test.go |
| ./lib/events/leo/types.go |
| ./lib/events/multicall/multicall.go |
| ./lib/events/multicall/types.go |
| ./lib/events/seawater/seawater.go |
| ./lib/events/seawater/seawater_test.go |
| ./lib/events/seawater/types.go |
| ./lib/events/thirdweb/thirdweb.go |
| ./lib/events/thirdweb/types.go |
| ./lib/features/features.go |
| ./lib/features/features_test.go |
| ./lib/features/list.go |
| ./lib/heartbeat/heartbeat.go |
| ./lib/math/concentrated-liq.go |
| ./lib/math/concentrated-liq_test.go |
| ./lib/math/decimals.go |
| ./lib/math/decimals_test.go |
| ./lib/setup/setup.go |
| ./lib/types/erc20/erc20.go |
| ./lib/types/seawater/classifications.go |
| ./lib/types/seawater/seawater.go |
| ./lib/types/types.go |
| ./pkg/leo/src/calldata.rs |
| ./pkg/leo/src/calldata_seawater.rs |
| ./pkg/leo/src/erc20.rs |
| ./pkg/leo/src/error.rs |
| ./pkg/leo/src/events.rs |
| ./pkg/leo/src/host.rs |
| ./pkg/leo/src/host_seawater.rs |
| ./pkg/leo/src/immutables.rs |
| ./pkg/leo/src/lib.rs |
| ./pkg/leo/src/main.rs |
| ./pkg/leo/src/maths.rs |
| ./pkg/leo/src/nft_manager.rs |
| ./pkg/leo/src/seawater.rs |
| ./pkg/leo/src/wasm_seawater.rs |
| ./pkg/leo/tests/lib.rs |
| ./pkg/seawater/src/test_shims.rs |
| ./pkg/seawater/src/test_utils.rs |
| ./pkg/seawater/tests/get-liq-for-amounts.rs |
| ./pkg/seawater/tests/lib-end-to-end-proptest.rs |
| ./pkg/seawater/tests/lib-high-level-tests.rs |
| ./pkg/seawater/tests/math-proptest.rs |
| ./pkg/seawater/tests/pools.rs |
| ./pkg/seawater/tests/reference/full_math.rs |
| ./pkg/seawater/tests/reference/mod.rs |
| ./pkg/seawater/tests/reference/tick_math.rs |
| ./pkg/seawater/tests/reference_impls.rs |
| ./pkg/sol/Faucet.sol |
| ./pkg/sol/IERC165.sol |
| ./pkg/sol/IERC20.sol |
| ./pkg/sol/IERC721Metadata.sol |
| ./pkg/sol/IERC721TokenReceiver.sol |
| ./pkg/sol/IFaucet.sol |
| ./pkg/sol/ILeo.sol |
| ./pkg/sol/ILeoEvents.sol |
| ./pkg/sol/ISeawater.sol |
| ./pkg/sol/ISeawaterAMM.sol |
| ./pkg/sol/ISeawaterEvents.sol |
| ./pkg/sol/ISeawaterExecutors.sol |
| ./pkg/sol/ISeawaterMigrations.sol |
| ./pkg/test/LightweightERC20.sol |
| ./pkg/test/permit2.sol |
| ./tools/ethereum-selector-mine.go |
| Totals: 117 |

## Scoping Q &amp; A

### General questions
### Are there any ERC20's in scope?: Yes

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".

Specific tokens (please specify)
USDC

### Are there any ERC777's in scope?: No

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".

OwnershipNFTs

### Are there any ERC721's in scope?: Yes

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".

OwnershipNFTs

### Are there any ERC1155's in scope?: No

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".



✅ SCOUTS: Once done populating the table below, please remove all the Q/A data above.

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| ERC20 used by the protocol              |       🖊️             |
| Test coverage                           | ✅ SCOUTS: Please populate this after running the test coverage command                          |
| ERC721 used  by the protocol            |            🖊️              |
| ERC777 used by the protocol             |           🖊️                |
| ERC1155 used by the protocol            |              🖊️            |
| Chains the protocol will be deployed on | OtherSuperposition testnet and mainnet  |

### ERC20 token behaviors in scope

| Question                                                                                                                                                   | Answer |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| [Missing return values](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#missing-return-values)                                                      |   Out of scope  |
| [Fee on transfer](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#fee-on-transfer)                                                                  |  Out of scope  |
| [Balance changes outside of transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#balance-modifications-outside-of-transfers-rebasingairdrops) | Out of scope    |
| [Upgradeability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#upgradable-tokens)                                                                 |   Out of scope  |
| [Flash minting](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#flash-mintable-tokens)                                                              | Out of scope    |
| [Pausability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#pausable-tokens)                                                                      | Out of scope    |
| [Approval race protections](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#approval-race-protections)                                              | Out of scope    |
| [Revert on approval to zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-approval-to-zero-address)                            | Out of scope    |
| [Revert on zero value approvals](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-approvals)                                    | Out of scope    |
| [Revert on zero value transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                    | Out of scope    |
| [Revert on transfer to the zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-transfer-to-the-zero-address)                    | Out of scope    |
| [Revert on large approvals and/or transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-large-approvals--transfers)                  | Out of scope    |
| [Doesn't revert on failure](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#no-revert-on-failure)                                                   |  Out of scope   |
| [Multiple token addresses](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                          | Out of scope    |
| [Low decimals ( < 6)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#low-decimals)                                                                 |   Out of scope  |
| [High decimals ( > 18)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#high-decimals)                                                              | Out of scope    |
| [Blocklists](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#tokens-with-blocklists)                                                                | Out of scope    |

### External integrations (e.g., Uniswap) behavior in scope:


| Question                                                  | Answer |
| --------------------------------------------------------- | ------ |
| Enabling/disabling fees (e.g. Blur disables/enables fees) | No   |
| Pausability (e.g. Uniswap pool gets paused)               |  No   |
| Upgradeability (e.g. Uniswap gets upgraded)               |   No  |


### EIP compliance checklist
N/A

✅ SCOUTS: Please format the response above 👆 using the template below👇

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| src/Token.sol                           | ERC20, ERC721                |
| src/NFT.sol                             | ERC721                       |


# Additional context

## Main invariants

The functionality should be reasonably similar to Uniswap's.


✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## Attack ideas (where to focus for bugs)
1. Discrepancy with Uniswap in an end to end environment
2. Fee taking isn't correct. Full ticks aren't correct

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## All trusted roles in the protocol

Operator, emergency council, ownership NFTs

✅ SCOUTS: Please format the response above 👆 using the template below👇

| Role                                | Description                       |
| --------------------------------------- | ---------------------------- |
| Owner                          | Has superpowers                |
| Administrator                             | Can change fees                       |

## Describe any novel or unique curve logic or mathematical models implemented in the contracts:

Concentrated liquidity math

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## Running tests

It's difficult to build the contract on its own, so it's best to simply run ./tests.sh inside the pkg directory.

✅ SCOUTS: Please format the response above 👆 using the template below👇

```bash
git clone https://github.com/code-423n4/2023-08-arbitrum
git submodule update --init --recursive
cd governance
foundryup
make install
make build
make sc-election-test
```
To run code coverage
```bash
make coverage
```
To run gas benchmarks
```bash
make gas
```

✅ SCOUTS: Add a screenshot of your terminal showing the gas report
✅ SCOUTS: Add a screenshot of your terminal showing the test coverage

## Miscellaneous
Employees of Superposition and employees' family members are ineligible to participate in this audit.

Code4rena's rules cannot be overridden by the contents of this README. In case of doubt, please check with C4 staff.


_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._
