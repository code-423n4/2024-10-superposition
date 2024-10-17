# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Use assembly to check for `address(0)` | 3 |
| [GAS-2](#GAS-2) | Using bools for storage incurs overhead | 1 |
| [GAS-3](#GAS-3) | Use calldata instead of memory for function arguments that do not get mutated | 6 |
| [GAS-4](#GAS-4) | For Operations that will not overflow, you could use unchecked | 93 |
| [GAS-5](#GAS-5) | Use Custom Errors instead of Revert Strings to save Gas | 14 |
| [GAS-6](#GAS-6) | Avoid contract existence checks by using low level calls | 5 |
| [GAS-7](#GAS-7) | State variables only set in the constructor should be declared `immutable` | 4 |
| [GAS-8](#GAS-8) | Functions guaranteed to revert when called by normal users can be marked `payable` | 10 |
| [GAS-9](#GAS-9) | `internal` functions not called by the contract should be removed | 1 |
### <a name="GAS-1"></a>[GAS-1] Use assembly to check for `address(0)`
*Saves 6 gas per instance*

*Instances (3)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

59:         require(approved != address(0), "not existing");

100:         require(_to != address(0), "invalid recipient");

145:         require(_spender != address(0), "invalid recipient");

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

### <a name="GAS-2"></a>[GAS-2] Using bools for storage incurs overhead
Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (1)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

37:     mapping(address => mapping(address => bool)) public isApprovedForAll;

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

### <a name="GAS-3"></a>[GAS-3] Use calldata instead of memory for function arguments that do not get mutated
When a function with a `memory` array is called externally, the `abi.decode()` step has to use a for-loop to copy each index of the `calldata` to the `memory` index. Each iteration of this for-loop costs at least 60 gas (i.e. `60 * <mem_array>.length`). Using `calldata` directly bypasses this loop. 

If the array is passed to an `internal` function which passes the array to another internal function where the array is modified and therefore `memory` is used in the `external` call, it's still more gas-efficient to use `calldata` when the `external` function uses modifiers, since the modifiers may prevent the internal functions from being called. Structs have the same overhead as an array of length one. 

 *Saves 60 gas per instance*

*Instances (6)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

241:         bytes memory /* sig */

254:         bytes memory /* sig */

290:         bytes memory sig

326:         bytes memory sig

429:         address[] memory /* pools */,

430:         uint256[] memory /* ids */

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="GAS-4"></a>[GAS-4] For Operations that will not overflow, you could use unchecked

*Instances (93)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

4: import "./IERC721Metadata.sol";

5: import "./IERC721TokenReceiver.sol";

6: import "./IERC165.sol";

8: import "./ISeawaterAMM.sol";

123:         bytes calldata /* _data */

155:     function tokenURI(uint256 /* _tokenId */) external view returns (string memory) {

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

```solidity
File: ./pkg/sol/SeawaterAMM.sol

4: import "./ISeawaterExecutors.sol";

6: import "./ISeawaterAMM.sol";

12: bytes32 constant EXECUTOR_SWAP_SLOT = bytes32(uint256(keccak256("seawater.impl.swap")) - 1);

15: bytes32 constant EXECUTOR_SWAP_PERMIT2_A_SLOT = bytes32(uint256(keccak256("seawater.impl.swap_permit2.a")) - 1);

18: bytes32 constant EXECUTOR_QUOTE_SLOT = bytes32(uint256(keccak256("seawater.impl.quote")) - 1);

21: bytes32 constant EXECUTOR_POSITION_SLOT = bytes32(uint256(keccak256("seawater.impl.position")) - 1);

24: bytes32 constant EXECUTOR_UPDATE_POSITION_SLOT = bytes32(uint256(keccak256("seawater.impl.update_position")) - 1);

27: bytes32 constant EXECUTOR_ADMIN_SLOT = bytes32(uint256(keccak256("seawater.impl.admin")) - 1);

30: bytes32 constant EXECUTOR_ADJUST_POSITION_SLOT = bytes32(uint256(keccak256("seawater.impl.adjust_position")) - 1);

33: bytes32 constant EXECUTOR_SWAP_PERMIT2_B_SLOT = bytes32(uint256(keccak256("seawater.impl.swap_permit2.b")) - 1);

36: bytes32 constant EXECUTOR_FALLBACK_SLOT = bytes32(uint256(keccak256("seawater.impl.fallback")) - 1);

39: bytes32 constant PROXY_ADMIN_SLOT = bytes32(uint256(keccak256("seawater.role.proxy.admin")) - 1);

161:         address /* token */,

162:         uint256 /* sqrtPriceX96 */,

163:         uint32 /* fee */,

164:         uint8 /* tickSpacing */,

165:         uint128 /* maxLiquidityPerTick */

172:         address /* pool */,

173:         uint128 /* amount0 */,

174:         uint128 /* amount1 */,

175:         address /* recipient */

181:     function enablePool579DA658(address /* pool */, bool /* enabled */) external {

186:     function authoriseEnabler5B17C274(address /* enabler */, bool /* enabled */) external {

191:     function setSqrtPriceFF4DB98C(address /* pool */, uint256 /* price */) external {

196:     function updateNftManager9BDF41F6(address /* manager */) external {

201:     function updateEmergencyCouncil7D0C1C58(address /* council */) external {

209:         address /* pool */,

210:         bool /* zeroForOne */,

211:         int256 /* amount */,

212:         uint256 /* priceLimit */

219:         address /* pool */,

220:         bool /* zeroForOne */,

221:         int256 /* amount */,

222:         uint256 /* priceLimit */

228:     function quote2CD06B86E(address /* from */, address /* to */, uint256 /* amount */, uint256 /* minOut*/) external {

234:         address /* pool */,

235:         bool /* zeroForOne */,

236:         int256 /* amount */,

237:         uint256 /* priceLimit */,

238:         uint256 /* nonce */,

239:         uint256 /* deadline */,

240:         uint256 /* maxAmount */,

241:         bytes memory /* sig */

248:         address /* from */,

249:         address /* to */,

250:         uint256 /* amount */,

251:         uint256 /* minOut */,

252:         uint256 /* nonce */,

253:         uint256 /* deadline */,

254:         bytes memory /* sig */

261:         address /* tokenA */,

262:         address /* tokenB */,

263:         uint256 /* amountIn */,

264:         uint256 /* minAmountOut */

278:         require(-swapAmountOut >= int256(minOut), "min out not reached!");

302:         require(-swapAmountOut >= int256(minOut), "min out not reached!");

345:         address /* token */,

346:         int32 /* lower */,

347:         int32 /* upper */

348:     ) external returns (uint256 /* id */) {

353:     function positionOwnerD7878480(uint256 /* id */) external returns (address) {

359:     function transferPositionEEC7A3CD(uint256 /* id */, address /* from */, address /* to */) external {

364:     function positionBalance4F32C7DB(address /* user */) external returns (uint256) {

369:     function positionLiquidity8D11C045(address /* pool */, uint256 /* id */) external returns (uint128) {

374:     function positionTickLower2F77CCE1(address /* pool */, uint256 /* id */) external returns (int32) {

379:     function positionTickUpper67FD55BA(address /* pool */, uint256 /* id */) external returns (int32) {

384:     function sqrtPriceX967B8F5FC5(address /* pool */) external returns (uint256) {

389:     function feesOwed22F28DBD(address /* pool */, uint256 /* position */) external returns (uint128, uint128) {

394:     function curTick181C6FD9(address /* pool */) external returns (int32) {

399:     function tickSpacing653FE28F(address /* pool */) external returns (uint8) {

404:     function feeBB3CF608(address /* pool */) external returns (uint32) {

409:     function feeGrowthGlobal038B5665B(address /* pool */) external returns (uint256) {

414:     function feeGrowthGlobal1A33A5A1B(address /*pool */) external returns (uint256) {

420:         address /* pool */,

421:         uint256 /* id */,

422:         address /* recipient */

429:         address[] memory /* pools */,

430:         uint256[] memory /* ids */

437:         address /* pool */,

438:         uint256 /* id */,

439:         int128 /* delta */

446:         address /* pool */,

447:         uint256 /* id */,

448:         uint256 /* amount0Min */,

449:         uint256 /* amount1Min */,

450:         uint256 /* amount0Desired */,

451:         uint256 /* amount1Desired */

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="GAS-5"></a>[GAS-5] Use Custom Errors instead of Revert Strings to save Gas
Custom errors are available from solidity version 0.8.4. Custom errors save [**~50 gas**](https://gist.github.com/IllIllI000/ad1bd0d29a0101b25e57c293b4b0c746) each time they're hit by [avoiding having to allocate and store the revert string](https://blog.soliditylang.org/2021/04/21/custom-errors/#errors-in-depth). Not defining the strings also save deployment gas

Additionally, custom errors can be used inside and outside of contracts (including interfaces and libraries).

Source: <https://blog.soliditylang.org/2021/04/21/custom-errors/>:

> Starting from [Solidity v0.8.4](https://github.com/ethereum/solidity/releases/tag/v0.8.4), there is a convenient and gas-efficient way to explain to users why an operation failed through the use of custom errors. Until now, you could already use strings to give more information about failures (e.g., `revert("Insufficient funds.");`), but they are rather expensive, especially when it comes to deploy cost, and it is difficult to use dynamic information in them.

Consider replacing **all revert strings** with custom errors in the solution, and particularly those that have multiple occurrences:

*Instances (14)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

51:         require(ok, "position owner revert");

59:         require(approved != address(0), "not existing");

85:         require(data == IERC721TokenReceiver.onERC721Received.selector, "bad nft transfer received data");

94:         require(isAllowed, "not allowed");

95:         require(ownerOf(_tokenId) == _from, "_from is not the owner!");

100:         require(_to != address(0), "invalid recipient");

132:         require(owner == msg.sender || isApprovedForAll[owner][msg.sender], "not authorised");

145:         require(_spender != address(0), "invalid recipient");

149:         require(ok, "position balance revert");

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

```solidity
File: ./pkg/sol/SeawaterAMM.sol

68:         require(msg.sender == StorageSlot.getAddressSlot(PROXY_ADMIN_SLOT).value, "only proxy admin");

278:         require(-swapAmountOut >= int256(minOut), "min out not reached!");

302:         require(-swapAmountOut >= int256(minOut), "min out not reached!");

314:         require(swapAmountOut >= int256(minOut), "min out not reached!");

337:         require(swapAmountOut >= int256(minOut), "min out not reached!");

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="GAS-6"></a>[GAS-6] Avoid contract existence checks by using low level calls
Prior to 0.8.10 the compiler inserted extra code, including `EXTCODESIZE` (**100 gas**), to check for contract existence for external function calls. In more recent solidity versions, the compiler will not insert these checks if the external call has a return value. Similar behavior can be achieved in earlier versions by using low-level calls, since low level calls never check for contract existence

*Instances (5)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

112:         (bool success, bytes memory data) = _getExecutorAdmin().delegatecall(

271:         (bool success, bytes memory data) = _getExecutorSwap().delegatecall(

292:         (bool success, bytes memory data) = _getExecutorSwapPermit2A().delegatecall(

308:         (bool success, bytes memory data) = _getExecutorSwap().delegatecall(

328:         (bool success, bytes memory data) = _getExecutorSwapPermit2A().delegatecall(

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="GAS-7"></a>[GAS-7] State variables only set in the constructor should be declared `immutable`
Variables only set in the constructor and never edited afterwards should be marked as immutable, as it would avoid the expensive storage-writing operation in the constructor (around **20 000 gas** per variable) and replace the expensive storage-reading operations (around **2100 gas** per reading) to a less expensive value reading (**3 gas**)

*Instances (4)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

40:         name = _name;

41:         symbol = _symbol;

42:         TOKEN_URI = _tokenURI;

43:         SEAWATER = _seawater;

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

### <a name="GAS-8"></a>[GAS-8] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (10)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

123:     function updateProxyAdmin(address newAdmin) public onlyProxyAdmin {

456:     function setExecutorSwap(address a) external onlyProxyAdmin {

459:     function setExecutorSwapPermit2A(address a) external onlyProxyAdmin {

462:     function setExecutorQuote(address a) external onlyProxyAdmin {

465:     function setExecutorPosition(address a) external onlyProxyAdmin {

468:     function setExecutorUpdatePosition(address a) external onlyProxyAdmin {

471:     function setExecutorAdmin(address a) external onlyProxyAdmin {

474:     function setExecutorAdjustPosition(address a) external onlyProxyAdmin {

477:     function setExecutorSwapPermit2B(address a) external onlyProxyAdmin {

480:     function setExecutorFallback(address a) external onlyProxyAdmin {

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="GAS-9"></a>[GAS-9] `internal` functions not called by the contract should be removed
If the functions are required by an interface, the contract should inherit from that interface and use the `override` keyword

*Instances (1)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

59:     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Replace `abi.encodeWithSignature` and `abi.encodeWithSelector` with `abi.encodeCall` which keeps the code typo/type safe | 2 |
| [NC-2](#NC-2) | Array indices should be referenced via `enum`s rather than via numeric literals | 8 |
| [NC-3](#NC-3) | Control structures do not follow the Solidity Style Guide | 9 |
| [NC-4](#NC-4) | Default Visibility for constants | 18 |
| [NC-5](#NC-5) | Duplicated `require()`/`revert()` Checks Should Be Refactored To A Modifier Or Function | 11 |
| [NC-6](#NC-6) | Events that mark critical parameter changes should contain both the old and the new value | 1 |
| [NC-7](#NC-7) | Function ordering does not follow the Solidity style guide | 2 |
| [NC-8](#NC-8) | Functions should not be longer than 50 lines | 54 |
| [NC-9](#NC-9) | Lack of checks in setters | 33 |
| [NC-10](#NC-10) | Missing Event for critical parameters change | 28 |
| [NC-11](#NC-11) | NatSpec is completely non-existent on functions that should have them | 18 |
| [NC-12](#NC-12) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 2 |
| [NC-13](#NC-13) | Consider using named mappings | 2 |
| [NC-14](#NC-14) | Take advantage of Custom Error's return value property | 1 |
| [NC-15](#NC-15) | Contract does not follow the Solidity style guide's suggested layout ordering | 1 |
| [NC-16](#NC-16) | Internal and private variables and functions names should begin with an underscore | 3 |
| [NC-17](#NC-17) | `public` functions not called by the contract should be declared `external` instead | 1 |
### <a name="NC-1"></a>[NC-1] Replace `abi.encodeWithSignature` and `abi.encodeWithSelector` with `abi.encodeCall` which keeps the code typo/type safe
When using `abi.encodeWithSignature`, it is possible to include a typo for the correct function signature.
When using `abi.encodeWithSignature` or `abi.encodeWithSelector`, it is also possible to provide parameters that are not of the correct type for the function.

To avoid these pitfalls, it would be best to use [`abi.encodeCall`](https://solidity-by-example.org/abi-encode/) instead.

*Instances (2)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

49:             abi.encodeWithSelector(SEAWATER.positionOwnerD7878480.selector, _tokenId)

147:             abi.encodeWithSelector(SEAWATER.positionBalance4F32C7DB.selector, _spender)

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

### <a name="NC-2"></a>[NC-2] Array indices should be referenced via `enum`s rather than via numeric literals

*Instances (8)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

487:         if (uint8(msg.data[2]) == EXECUTOR_SWAP_DISPATCH)

490:         else if (uint8(msg.data[2]) == EXECUTOR_UPDATE_POSITION_DISPATCH)

493:         else if (uint8(msg.data[2]) == EXECUTOR_POSITION_DISPATCH)

496:         else if (uint8(msg.data[2]) == EXECUTOR_ADMIN_DISPATCH)

499:         else if (uint8(msg.data[2]) == EXECUTOR_SWAP_PERMIT2_A_DISPATCH)

502:         else if (uint8(msg.data[2]) == EXECUTOR_QUOTES_DISPATCH) directDelegate(_getExecutorQuote());

503:         else if (uint8(msg.data[2]) == EXECUTOR_ADJUST_POSITION_DISPATCH) directDelegate(_getExecutorAdjustPosition());

504:         else if (uint8(msg.data[2]) == EXECUTOR_SWAP_PERMIT2_B_DISPATCH) directDelegate(_getExecutorSwapPermit2B());

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-3"></a>[NC-3] Control structures do not follow the Solidity Style Guide
See the [control structures](https://docs.soliditylang.org/en/latest/style-guide.html#control-structures) section of the Solidity Style Guide

*Instances (9)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

74:         if (_to.code.length == 0) return;

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

```solidity
File: ./pkg/sol/SeawaterAMM.sol

487:         if (uint8(msg.data[2]) == EXECUTOR_SWAP_DISPATCH)

490:         else if (uint8(msg.data[2]) == EXECUTOR_UPDATE_POSITION_DISPATCH)

493:         else if (uint8(msg.data[2]) == EXECUTOR_POSITION_DISPATCH)

496:         else if (uint8(msg.data[2]) == EXECUTOR_ADMIN_DISPATCH)

499:         else if (uint8(msg.data[2]) == EXECUTOR_SWAP_PERMIT2_A_DISPATCH)

502:         else if (uint8(msg.data[2]) == EXECUTOR_QUOTES_DISPATCH) directDelegate(_getExecutorQuote());

503:         else if (uint8(msg.data[2]) == EXECUTOR_ADJUST_POSITION_DISPATCH) directDelegate(_getExecutorAdjustPosition());

504:         else if (uint8(msg.data[2]) == EXECUTOR_SWAP_PERMIT2_B_DISPATCH) directDelegate(_getExecutorSwapPermit2B());

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-4"></a>[NC-4] Default Visibility for constants
Some constants are using the default visibility. For readability, consider explicitly declaring them as `internal`.

*Instances (18)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

12: bytes32 constant EXECUTOR_SWAP_SLOT = bytes32(uint256(keccak256("seawater.impl.swap")) - 1);

15: bytes32 constant EXECUTOR_SWAP_PERMIT2_A_SLOT = bytes32(uint256(keccak256("seawater.impl.swap_permit2.a")) - 1);

18: bytes32 constant EXECUTOR_QUOTE_SLOT = bytes32(uint256(keccak256("seawater.impl.quote")) - 1);

21: bytes32 constant EXECUTOR_POSITION_SLOT = bytes32(uint256(keccak256("seawater.impl.position")) - 1);

24: bytes32 constant EXECUTOR_UPDATE_POSITION_SLOT = bytes32(uint256(keccak256("seawater.impl.update_position")) - 1);

27: bytes32 constant EXECUTOR_ADMIN_SLOT = bytes32(uint256(keccak256("seawater.impl.admin")) - 1);

30: bytes32 constant EXECUTOR_ADJUST_POSITION_SLOT = bytes32(uint256(keccak256("seawater.impl.adjust_position")) - 1);

33: bytes32 constant EXECUTOR_SWAP_PERMIT2_B_SLOT = bytes32(uint256(keccak256("seawater.impl.swap_permit2.b")) - 1);

36: bytes32 constant EXECUTOR_FALLBACK_SLOT = bytes32(uint256(keccak256("seawater.impl.fallback")) - 1);

39: bytes32 constant PROXY_ADMIN_SLOT = bytes32(uint256(keccak256("seawater.role.proxy.admin")) - 1);

43: uint8 constant EXECUTOR_SWAP_DISPATCH = 0;

44: uint8 constant EXECUTOR_UPDATE_POSITION_DISPATCH = 1;

45: uint8 constant EXECUTOR_POSITION_DISPATCH = 2;

46: uint8 constant EXECUTOR_ADMIN_DISPATCH = 3;

47: uint8 constant EXECUTOR_SWAP_PERMIT2_A_DISPATCH = 4;

48: uint8 constant EXECUTOR_QUOTES_DISPATCH = 5;

49: uint8 constant EXECUTOR_ADJUST_POSITION_DISPATCH = 6;

50: uint8 constant EXECUTOR_SWAP_PERMIT2_B_DISPATCH = 7;

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-5"></a>[NC-5] Duplicated `require()`/`revert()` Checks Should Be Refactored To A Modifier Or Function

*Instances (11)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

100:         require(_to != address(0), "invalid recipient");

145:         require(_spender != address(0), "invalid recipient");

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

```solidity
File: ./pkg/sol/SeawaterAMM.sol

116:         require(success, string(data));

274:         require(success, string(data));

278:         require(-swapAmountOut >= int256(minOut), "min out not reached!");

298:         require(success, string(data));

302:         require(-swapAmountOut >= int256(minOut), "min out not reached!");

311:         require(success, string(data));

314:         require(swapAmountOut >= int256(minOut), "min out not reached!");

334:         require(success, string(data));

337:         require(swapAmountOut >= int256(minOut), "min out not reached!");

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-6"></a>[NC-6] Events that mark critical parameter changes should contain both the old and the new value
This should especially be done if the new value is not required to be different from the old value

*Instances (1)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

138:     function setApprovalForAll(address _operator, bool _approved) external {
             isApprovedForAll[msg.sender][_operator] = _approved;
             emit ApprovalForAll(msg.sender, _operator, _approved);

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

### <a name="NC-7"></a>[NC-7] Function ordering does not follow the Solidity style guide
According to the [Solidity style guide](https://docs.soliditylang.org/en/v0.8.17/style-guide.html#order-of-functions), functions should be laid out in the following order :`constructor()`, `receive()`, `fallback()`, `external`, `public`, `internal`, `private`, but the cases below do not follow this pattern

*Instances (2)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

1: 
   Current order:
   public ownerOf
   external getApproved
   internal _onTransferReceived
   internal _requireAuthorised
   internal _transfer
   external transferFrom
   external safeTransferFrom
   external safeTransferFrom
   external approve
   external setApprovalForAll
   external balanceOf
   external tokenURI
   external supportsInterface
   
   Suggested order:
   external getApproved
   external transferFrom
   external safeTransferFrom
   external safeTransferFrom
   external approve
   external setApprovalForAll
   external balanceOf
   external tokenURI
   external supportsInterface
   public ownerOf
   internal _onTransferReceived
   internal _requireAuthorised
   internal _transfer

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

```solidity
File: ./pkg/sol/SeawaterAMM.sol

1: 
   Current order:
   internal getAddressSlot
   public updateProxyAdmin
   internal directDelegate
   external createPoolD650E2D0
   external collectProtocol7540FA9F
   external enablePool579DA658
   external authoriseEnabler5B17C274
   external setSqrtPriceFF4DB98C
   external updateNftManager9BDF41F6
   external updateEmergencyCouncil7D0C1C58
   external swap904369BE
   external quote72E2ADE7
   external quote2CD06B86E
   external swapPermit2EE84AD91
   external swap2ExactInPermit254A7DBB1
   external swap2ExactIn41203F1D
   external swapIn32502CA71
   external swapInPermit2CEAAB576
   external swapOut5E08A399
   external swapOutPermit23273373B
   external mintPositionBC5B086D
   external positionOwnerD7878480
   external transferPositionEEC7A3CD
   external positionBalance4F32C7DB
   external positionLiquidity8D11C045
   external positionTickLower2F77CCE1
   external positionTickUpper67FD55BA
   external sqrtPriceX967B8F5FC5
   external feesOwed22F28DBD
   external curTick181C6FD9
   external tickSpacing653FE28F
   external feeBB3CF608
   external feeGrowthGlobal038B5665B
   external feeGrowthGlobal1A33A5A1B
   external collectSingleTo6D76575F
   external collect7F21947C
   external updatePositionC7F1F740
   external incrPositionE2437399
   external setExecutorSwap
   external setExecutorSwapPermit2A
   external setExecutorQuote
   external setExecutorPosition
   external setExecutorUpdatePosition
   external setExecutorAdmin
   external setExecutorAdjustPosition
   external setExecutorSwapPermit2B
   external setExecutorFallback
   internal _getExecutorSwap
   internal _getExecutorSwapPermit2A
   internal _getExecutorQuote
   internal _getExecutorPosition
   internal _getExecutorUpdatePosition
   internal _getExecutorAdmin
   internal _getExecutorAdjustPosition
   internal _getExecutorSwapPermit2B
   internal _getExecutorFallback
   internal _setProxyAdmin
   internal _setProxies
   
   Suggested order:
   external createPoolD650E2D0
   external collectProtocol7540FA9F
   external enablePool579DA658
   external authoriseEnabler5B17C274
   external setSqrtPriceFF4DB98C
   external updateNftManager9BDF41F6
   external updateEmergencyCouncil7D0C1C58
   external swap904369BE
   external quote72E2ADE7
   external quote2CD06B86E
   external swapPermit2EE84AD91
   external swap2ExactInPermit254A7DBB1
   external swap2ExactIn41203F1D
   external swapIn32502CA71
   external swapInPermit2CEAAB576
   external swapOut5E08A399
   external swapOutPermit23273373B
   external mintPositionBC5B086D
   external positionOwnerD7878480
   external transferPositionEEC7A3CD
   external positionBalance4F32C7DB
   external positionLiquidity8D11C045
   external positionTickLower2F77CCE1
   external positionTickUpper67FD55BA
   external sqrtPriceX967B8F5FC5
   external feesOwed22F28DBD
   external curTick181C6FD9
   external tickSpacing653FE28F
   external feeBB3CF608
   external feeGrowthGlobal038B5665B
   external feeGrowthGlobal1A33A5A1B
   external collectSingleTo6D76575F
   external collect7F21947C
   external updatePositionC7F1F740
   external incrPositionE2437399
   external setExecutorSwap
   external setExecutorSwapPermit2A
   external setExecutorQuote
   external setExecutorPosition
   external setExecutorUpdatePosition
   external setExecutorAdmin
   external setExecutorAdjustPosition
   external setExecutorSwapPermit2B
   external setExecutorFallback
   public updateProxyAdmin
   internal getAddressSlot
   internal directDelegate
   internal _getExecutorSwap
   internal _getExecutorSwapPermit2A
   internal _getExecutorQuote
   internal _getExecutorPosition
   internal _getExecutorUpdatePosition
   internal _getExecutorAdmin
   internal _getExecutorAdjustPosition
   internal _getExecutorSwapPermit2B
   internal _getExecutorFallback
   internal _setProxyAdmin
   internal _setProxies

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-8"></a>[NC-8] Functions should not be longer than 50 lines
Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability 

*Instances (54)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

47:     function ownerOf(uint256 _tokenId) public view returns (address) {

57:     function getApproved(uint256 _tokenId) external view returns (address) {

72:     function _onTransferReceived(address _sender, address _from, address _to, uint256 _tokenId) internal {

88:     function _requireAuthorised(address _from, uint256 _tokenId) internal view {

98:     function _transfer(address _from, address _to, uint256 _tokenId) internal {

107:     function transferFrom(address _from, address _to, uint256 _tokenId) external payable {

113:     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {

130:     function approve(address _approved, uint256 _tokenId) external payable {

138:     function setApprovalForAll(address _operator, bool _approved) external {

144:     function balanceOf(address _spender) external view returns (uint256) {

155:     function tokenURI(uint256 /* _tokenId */) external view returns (string memory) {

160:     function supportsInterface(bytes4 _interfaceId) external pure returns (bool) {

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

```solidity
File: ./pkg/sol/SeawaterAMM.sol

59:     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {

123:     function updateProxyAdmin(address newAdmin) public onlyProxyAdmin {

181:     function enablePool579DA658(address /* pool */, bool /* enabled */) external {

186:     function authoriseEnabler5B17C274(address /* enabler */, bool /* enabled */) external {

191:     function setSqrtPriceFF4DB98C(address /* pool */, uint256 /* price */) external {

196:     function updateNftManager9BDF41F6(address /* manager */) external {

201:     function updateEmergencyCouncil7D0C1C58(address /* council */) external {

228:     function quote2CD06B86E(address /* from */, address /* to */, uint256 /* amount */, uint256 /* minOut*/) external {

270:     function swapIn32502CA71(address token, uint256 amountIn, uint256 minOut) external returns (int256, int256) {

307:     function swapOut5E08A399(address token, uint256 amountIn, uint256 minOut) external returns (int256, int256) {

353:     function positionOwnerD7878480(uint256 /* id */) external returns (address) {

359:     function transferPositionEEC7A3CD(uint256 /* id */, address /* from */, address /* to */) external {

364:     function positionBalance4F32C7DB(address /* user */) external returns (uint256) {

369:     function positionLiquidity8D11C045(address /* pool */, uint256 /* id */) external returns (uint128) {

374:     function positionTickLower2F77CCE1(address /* pool */, uint256 /* id */) external returns (int32) {

379:     function positionTickUpper67FD55BA(address /* pool */, uint256 /* id */) external returns (int32) {

384:     function sqrtPriceX967B8F5FC5(address /* pool */) external returns (uint256) {

389:     function feesOwed22F28DBD(address /* pool */, uint256 /* position */) external returns (uint128, uint128) {

394:     function curTick181C6FD9(address /* pool */) external returns (int32) {

399:     function tickSpacing653FE28F(address /* pool */) external returns (uint8) {

404:     function feeBB3CF608(address /* pool */) external returns (uint32) {

409:     function feeGrowthGlobal038B5665B(address /* pool */) external returns (uint256) {

414:     function feeGrowthGlobal1A33A5A1B(address /*pool */) external returns (uint256) {

456:     function setExecutorSwap(address a) external onlyProxyAdmin {

459:     function setExecutorSwapPermit2A(address a) external onlyProxyAdmin {

462:     function setExecutorQuote(address a) external onlyProxyAdmin {

465:     function setExecutorPosition(address a) external onlyProxyAdmin {

468:     function setExecutorUpdatePosition(address a) external onlyProxyAdmin {

471:     function setExecutorAdmin(address a) external onlyProxyAdmin {

474:     function setExecutorAdjustPosition(address a) external onlyProxyAdmin {

477:     function setExecutorSwapPermit2B(address a) external onlyProxyAdmin {

480:     function setExecutorFallback(address a) external onlyProxyAdmin {

512:     function _getExecutorSwap() internal view returns (address) {

515:     function _getExecutorSwapPermit2A() internal view returns (address) {

518:     function _getExecutorQuote() internal view returns (address) {

521:     function _getExecutorPosition() internal view returns (address) {

524:     function _getExecutorUpdatePosition() internal view returns (address) {

527:     function _getExecutorAdmin() internal view returns (address) {

530:     function _getExecutorAdjustPosition() internal view returns (address) {

533:     function _getExecutorSwapPermit2B() internal view returns (address) {

536:     function _getExecutorFallback() internal view returns (address) {

540:     function _setProxyAdmin(address newAdmin) internal {

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-9"></a>[NC-9] Lack of checks in setters
Be it sanity checks (like checks against `0`-values) or initial setting checks: it's best for Setter functions to have them

*Instances (33)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

138:     function setApprovalForAll(address _operator, bool _approved) external {
             isApprovedForAll[msg.sender][_operator] = _approved;
             emit ApprovalForAll(msg.sender, _operator, _approved);

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

```solidity
File: ./pkg/sol/SeawaterAMM.sol

123:     function updateProxyAdmin(address newAdmin) public onlyProxyAdmin {
             _setProxyAdmin(newAdmin);

123:     function updateProxyAdmin(address newAdmin) public onlyProxyAdmin {
             _setProxyAdmin(newAdmin);

191:     function setSqrtPriceFF4DB98C(address /* pool */, uint256 /* price */) external {
             directDelegate(_getExecutorAdmin());

191:     function setSqrtPriceFF4DB98C(address /* pool */, uint256 /* price */) external {
             directDelegate(_getExecutorAdmin());

196:     function updateNftManager9BDF41F6(address /* manager */) external {
             directDelegate(_getExecutorAdmin());

196:     function updateNftManager9BDF41F6(address /* manager */) external {
             directDelegate(_getExecutorAdmin());

201:     function updateEmergencyCouncil7D0C1C58(address /* council */) external {
             directDelegate(_getExecutorAdmin());

201:     function updateEmergencyCouncil7D0C1C58(address /* council */) external {
             directDelegate(_getExecutorAdmin());

436:     function updatePositionC7F1F740(
             address /* pool */,
             uint256 /* id */,
             int128 /* delta */
         ) external returns (int256, int256) {
             directDelegate(_getExecutorUpdatePosition());

436:     function updatePositionC7F1F740(
             address /* pool */,
             uint256 /* id */,
             int128 /* delta */
         ) external returns (int256, int256) {
             directDelegate(_getExecutorUpdatePosition());

456:     function setExecutorSwap(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_SLOT).value = a;

456:     function setExecutorSwap(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_SLOT).value = a;

459:     function setExecutorSwapPermit2A(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_PERMIT2_A_SLOT).value = a;

459:     function setExecutorSwapPermit2A(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_PERMIT2_A_SLOT).value = a;

462:     function setExecutorQuote(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_QUOTE_SLOT).value = a;

462:     function setExecutorQuote(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_QUOTE_SLOT).value = a;

465:     function setExecutorPosition(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_POSITION_SLOT).value = a;

465:     function setExecutorPosition(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_POSITION_SLOT).value = a;

468:     function setExecutorUpdatePosition(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_UPDATE_POSITION_SLOT).value = a;

468:     function setExecutorUpdatePosition(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_UPDATE_POSITION_SLOT).value = a;

471:     function setExecutorAdmin(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_ADMIN_SLOT).value = a;

471:     function setExecutorAdmin(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_ADMIN_SLOT).value = a;

474:     function setExecutorAdjustPosition(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_ADJUST_POSITION_SLOT).value = a;

474:     function setExecutorAdjustPosition(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_ADJUST_POSITION_SLOT).value = a;

477:     function setExecutorSwapPermit2B(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_PERMIT2_B_SLOT).value = a;

477:     function setExecutorSwapPermit2B(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_PERMIT2_B_SLOT).value = a;

480:     function setExecutorFallback(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_FALLBACK_SLOT).value = a;

480:     function setExecutorFallback(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_FALLBACK_SLOT).value = a;

540:     function _setProxyAdmin(address newAdmin) internal {
             StorageSlot.getAddressSlot(PROXY_ADMIN_SLOT).value = newAdmin;

540:     function _setProxyAdmin(address newAdmin) internal {
             StorageSlot.getAddressSlot(PROXY_ADMIN_SLOT).value = newAdmin;

544:     function _setProxies(
             ISeawaterExecutorSwap executorSwap,
             ISeawaterExecutorSwapPermit2A executorSwapPermit2A,
             ISeawaterExecutorQuote executorQuote,
             ISeawaterExecutorPosition executorPosition,
             ISeawaterExecutorUpdatePosition executorUpdatePosition,
             ISeawaterExecutorAdmin executorAdmin,
             ISeawaterExecutorAdjustPosition executorAdjustPosition,
             ISeawaterExecutorSwapPermit2B executorSwapPermit2B,
             ISeawaterExecutorFallback executorFallback
         ) internal {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_SLOT).value = address(executorSwap);
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_PERMIT2_A_SLOT).value = address(executorSwapPermit2A);
             StorageSlot.getAddressSlot(EXECUTOR_QUOTE_SLOT).value = address(executorQuote);
             StorageSlot.getAddressSlot(EXECUTOR_POSITION_SLOT).value = address(executorPosition);
             StorageSlot.getAddressSlot(EXECUTOR_UPDATE_POSITION_SLOT).value = address(executorUpdatePosition);
             StorageSlot.getAddressSlot(EXECUTOR_ADMIN_SLOT).value = address(executorAdmin);
             StorageSlot.getAddressSlot(EXECUTOR_ADJUST_POSITION_SLOT).value = address(executorAdjustPosition);
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_PERMIT2_B_SLOT).value = address(executorSwapPermit2B);
             StorageSlot.getAddressSlot(EXECUTOR_FALLBACK_SLOT).value = address(executorFallback);

544:     function _setProxies(
             ISeawaterExecutorSwap executorSwap,
             ISeawaterExecutorSwapPermit2A executorSwapPermit2A,
             ISeawaterExecutorQuote executorQuote,
             ISeawaterExecutorPosition executorPosition,
             ISeawaterExecutorUpdatePosition executorUpdatePosition,
             ISeawaterExecutorAdmin executorAdmin,
             ISeawaterExecutorAdjustPosition executorAdjustPosition,
             ISeawaterExecutorSwapPermit2B executorSwapPermit2B,
             ISeawaterExecutorFallback executorFallback
         ) internal {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_SLOT).value = address(executorSwap);
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_PERMIT2_A_SLOT).value = address(executorSwapPermit2A);
             StorageSlot.getAddressSlot(EXECUTOR_QUOTE_SLOT).value = address(executorQuote);
             StorageSlot.getAddressSlot(EXECUTOR_POSITION_SLOT).value = address(executorPosition);
             StorageSlot.getAddressSlot(EXECUTOR_UPDATE_POSITION_SLOT).value = address(executorUpdatePosition);
             StorageSlot.getAddressSlot(EXECUTOR_ADMIN_SLOT).value = address(executorAdmin);
             StorageSlot.getAddressSlot(EXECUTOR_ADJUST_POSITION_SLOT).value = address(executorAdjustPosition);
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_PERMIT2_B_SLOT).value = address(executorSwapPermit2B);
             StorageSlot.getAddressSlot(EXECUTOR_FALLBACK_SLOT).value = address(executorFallback);

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-10"></a>[NC-10] Missing Event for critical parameters change
Events help non-contract tools to track changes, and events prevent users from being surprised by changes.

*Instances (28)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

123:     function updateProxyAdmin(address newAdmin) public onlyProxyAdmin {
             _setProxyAdmin(newAdmin);

123:     function updateProxyAdmin(address newAdmin) public onlyProxyAdmin {
             _setProxyAdmin(newAdmin);

191:     function setSqrtPriceFF4DB98C(address /* pool */, uint256 /* price */) external {
             directDelegate(_getExecutorAdmin());

191:     function setSqrtPriceFF4DB98C(address /* pool */, uint256 /* price */) external {
             directDelegate(_getExecutorAdmin());

196:     function updateNftManager9BDF41F6(address /* manager */) external {
             directDelegate(_getExecutorAdmin());

196:     function updateNftManager9BDF41F6(address /* manager */) external {
             directDelegate(_getExecutorAdmin());

201:     function updateEmergencyCouncil7D0C1C58(address /* council */) external {
             directDelegate(_getExecutorAdmin());

201:     function updateEmergencyCouncil7D0C1C58(address /* council */) external {
             directDelegate(_getExecutorAdmin());

436:     function updatePositionC7F1F740(
             address /* pool */,
             uint256 /* id */,
             int128 /* delta */
         ) external returns (int256, int256) {
             directDelegate(_getExecutorUpdatePosition());

436:     function updatePositionC7F1F740(
             address /* pool */,
             uint256 /* id */,
             int128 /* delta */
         ) external returns (int256, int256) {
             directDelegate(_getExecutorUpdatePosition());

456:     function setExecutorSwap(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_SLOT).value = a;

456:     function setExecutorSwap(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_SLOT).value = a;

459:     function setExecutorSwapPermit2A(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_PERMIT2_A_SLOT).value = a;

459:     function setExecutorSwapPermit2A(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_PERMIT2_A_SLOT).value = a;

462:     function setExecutorQuote(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_QUOTE_SLOT).value = a;

462:     function setExecutorQuote(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_QUOTE_SLOT).value = a;

465:     function setExecutorPosition(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_POSITION_SLOT).value = a;

465:     function setExecutorPosition(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_POSITION_SLOT).value = a;

468:     function setExecutorUpdatePosition(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_UPDATE_POSITION_SLOT).value = a;

468:     function setExecutorUpdatePosition(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_UPDATE_POSITION_SLOT).value = a;

471:     function setExecutorAdmin(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_ADMIN_SLOT).value = a;

471:     function setExecutorAdmin(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_ADMIN_SLOT).value = a;

474:     function setExecutorAdjustPosition(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_ADJUST_POSITION_SLOT).value = a;

474:     function setExecutorAdjustPosition(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_ADJUST_POSITION_SLOT).value = a;

477:     function setExecutorSwapPermit2B(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_PERMIT2_B_SLOT).value = a;

477:     function setExecutorSwapPermit2B(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_SWAP_PERMIT2_B_SLOT).value = a;

480:     function setExecutorFallback(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_FALLBACK_SLOT).value = a;

480:     function setExecutorFallback(address a) external onlyProxyAdmin {
             StorageSlot.getAddressSlot(EXECUTOR_FALLBACK_SLOT).value = a;

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-11"></a>[NC-11] NatSpec is completely non-existent on functions that should have them
Public and external functions that aren't view or pure should have NatSpec comments

*Instances (18)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

456:     function setExecutorSwap(address a) external onlyProxyAdmin {

456:     function setExecutorSwap(address a) external onlyProxyAdmin {

459:     function setExecutorSwapPermit2A(address a) external onlyProxyAdmin {

459:     function setExecutorSwapPermit2A(address a) external onlyProxyAdmin {

462:     function setExecutorQuote(address a) external onlyProxyAdmin {

462:     function setExecutorQuote(address a) external onlyProxyAdmin {

465:     function setExecutorPosition(address a) external onlyProxyAdmin {

465:     function setExecutorPosition(address a) external onlyProxyAdmin {

468:     function setExecutorUpdatePosition(address a) external onlyProxyAdmin {

468:     function setExecutorUpdatePosition(address a) external onlyProxyAdmin {

471:     function setExecutorAdmin(address a) external onlyProxyAdmin {

471:     function setExecutorAdmin(address a) external onlyProxyAdmin {

474:     function setExecutorAdjustPosition(address a) external onlyProxyAdmin {

474:     function setExecutorAdjustPosition(address a) external onlyProxyAdmin {

477:     function setExecutorSwapPermit2B(address a) external onlyProxyAdmin {

477:     function setExecutorSwapPermit2B(address a) external onlyProxyAdmin {

480:     function setExecutorFallback(address a) external onlyProxyAdmin {

480:     function setExecutorFallback(address a) external onlyProxyAdmin {

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-12"></a>[NC-12] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor
If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (2)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

132:         require(owner == msg.sender || isApprovedForAll[owner][msg.sender], "not authorised");

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

```solidity
File: ./pkg/sol/SeawaterAMM.sol

68:         require(msg.sender == StorageSlot.getAddressSlot(PROXY_ADMIN_SLOT).value, "only proxy admin");

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-13"></a>[NC-13] Consider using named mappings
Consider moving to solidity version 0.8.18 or later, and using [named mappings](https://ethereum.stackexchange.com/questions/51629/how-to-name-the-arguments-in-mapping/145555#145555) to make it easier to understand the purpose of each mapping

*Instances (2)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

34:     mapping(uint256 => address) private getApproved_;

37:     mapping(address => mapping(address => bool)) public isApprovedForAll;

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

### <a name="NC-14"></a>[NC-14] Take advantage of Custom Error's return value property
An important feature of Custom Error is that values such as address, tokenID, msg.value can be written inside the () sign, this kind of approach provides a serious advantage in debugging and examining the revert details of dapps such as tenderly.

*Instances (1)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

149:                 revert(0, returndatasize())

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-15"></a>[NC-15] Contract does not follow the Solidity style guide's suggested layout ordering
The [style guide](https://docs.soliditylang.org/en/v0.8.16/style-guide.html#order-of-layout) says that, within a contract, the ordering should be:

1) Type declarations
2) State variables
3) Events
4) Modifiers
5) Functions

However, the contract(s) below do not follow this ordering

*Instances (1)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

1: 
   Current order:
   StructDefinition.AddressSlot
   FunctionDefinition.getAddressSlot
   ModifierDefinition.onlyProxyAdmin
   FunctionDefinition.constructor
   FunctionDefinition.updateProxyAdmin
   FunctionDefinition.directDelegate
   FunctionDefinition.createPoolD650E2D0
   FunctionDefinition.collectProtocol7540FA9F
   FunctionDefinition.enablePool579DA658
   FunctionDefinition.authoriseEnabler5B17C274
   FunctionDefinition.setSqrtPriceFF4DB98C
   FunctionDefinition.updateNftManager9BDF41F6
   FunctionDefinition.updateEmergencyCouncil7D0C1C58
   FunctionDefinition.swap904369BE
   FunctionDefinition.quote72E2ADE7
   FunctionDefinition.quote2CD06B86E
   FunctionDefinition.swapPermit2EE84AD91
   FunctionDefinition.swap2ExactInPermit254A7DBB1
   FunctionDefinition.swap2ExactIn41203F1D
   FunctionDefinition.swapIn32502CA71
   FunctionDefinition.swapInPermit2CEAAB576
   FunctionDefinition.swapOut5E08A399
   FunctionDefinition.swapOutPermit23273373B
   FunctionDefinition.mintPositionBC5B086D
   FunctionDefinition.positionOwnerD7878480
   FunctionDefinition.transferPositionEEC7A3CD
   FunctionDefinition.positionBalance4F32C7DB
   FunctionDefinition.positionLiquidity8D11C045
   FunctionDefinition.positionTickLower2F77CCE1
   FunctionDefinition.positionTickUpper67FD55BA
   FunctionDefinition.sqrtPriceX967B8F5FC5
   FunctionDefinition.feesOwed22F28DBD
   FunctionDefinition.curTick181C6FD9
   FunctionDefinition.tickSpacing653FE28F
   FunctionDefinition.feeBB3CF608
   FunctionDefinition.feeGrowthGlobal038B5665B
   FunctionDefinition.feeGrowthGlobal1A33A5A1B
   FunctionDefinition.collectSingleTo6D76575F
   FunctionDefinition.collect7F21947C
   FunctionDefinition.updatePositionC7F1F740
   FunctionDefinition.incrPositionE2437399
   FunctionDefinition.setExecutorSwap
   FunctionDefinition.setExecutorSwapPermit2A
   FunctionDefinition.setExecutorQuote
   FunctionDefinition.setExecutorPosition
   FunctionDefinition.setExecutorUpdatePosition
   FunctionDefinition.setExecutorAdmin
   FunctionDefinition.setExecutorAdjustPosition
   FunctionDefinition.setExecutorSwapPermit2B
   FunctionDefinition.setExecutorFallback
   FunctionDefinition.fallback
   FunctionDefinition._getExecutorSwap
   FunctionDefinition._getExecutorSwapPermit2A
   FunctionDefinition._getExecutorQuote
   FunctionDefinition._getExecutorPosition
   FunctionDefinition._getExecutorUpdatePosition
   FunctionDefinition._getExecutorAdmin
   FunctionDefinition._getExecutorAdjustPosition
   FunctionDefinition._getExecutorSwapPermit2B
   FunctionDefinition._getExecutorFallback
   FunctionDefinition._setProxyAdmin
   FunctionDefinition._setProxies
   
   Suggested order:
   StructDefinition.AddressSlot
   ModifierDefinition.onlyProxyAdmin
   FunctionDefinition.getAddressSlot
   FunctionDefinition.constructor
   FunctionDefinition.updateProxyAdmin
   FunctionDefinition.directDelegate
   FunctionDefinition.createPoolD650E2D0
   FunctionDefinition.collectProtocol7540FA9F
   FunctionDefinition.enablePool579DA658
   FunctionDefinition.authoriseEnabler5B17C274
   FunctionDefinition.setSqrtPriceFF4DB98C
   FunctionDefinition.updateNftManager9BDF41F6
   FunctionDefinition.updateEmergencyCouncil7D0C1C58
   FunctionDefinition.swap904369BE
   FunctionDefinition.quote72E2ADE7
   FunctionDefinition.quote2CD06B86E
   FunctionDefinition.swapPermit2EE84AD91
   FunctionDefinition.swap2ExactInPermit254A7DBB1
   FunctionDefinition.swap2ExactIn41203F1D
   FunctionDefinition.swapIn32502CA71
   FunctionDefinition.swapInPermit2CEAAB576
   FunctionDefinition.swapOut5E08A399
   FunctionDefinition.swapOutPermit23273373B
   FunctionDefinition.mintPositionBC5B086D
   FunctionDefinition.positionOwnerD7878480
   FunctionDefinition.transferPositionEEC7A3CD
   FunctionDefinition.positionBalance4F32C7DB
   FunctionDefinition.positionLiquidity8D11C045
   FunctionDefinition.positionTickLower2F77CCE1
   FunctionDefinition.positionTickUpper67FD55BA
   FunctionDefinition.sqrtPriceX967B8F5FC5
   FunctionDefinition.feesOwed22F28DBD
   FunctionDefinition.curTick181C6FD9
   FunctionDefinition.tickSpacing653FE28F
   FunctionDefinition.feeBB3CF608
   FunctionDefinition.feeGrowthGlobal038B5665B
   FunctionDefinition.feeGrowthGlobal1A33A5A1B
   FunctionDefinition.collectSingleTo6D76575F
   FunctionDefinition.collect7F21947C
   FunctionDefinition.updatePositionC7F1F740
   FunctionDefinition.incrPositionE2437399
   FunctionDefinition.setExecutorSwap
   FunctionDefinition.setExecutorSwapPermit2A
   FunctionDefinition.setExecutorQuote
   FunctionDefinition.setExecutorPosition
   FunctionDefinition.setExecutorUpdatePosition
   FunctionDefinition.setExecutorAdmin
   FunctionDefinition.setExecutorAdjustPosition
   FunctionDefinition.setExecutorSwapPermit2B
   FunctionDefinition.setExecutorFallback
   FunctionDefinition.fallback
   FunctionDefinition._getExecutorSwap
   FunctionDefinition._getExecutorSwapPermit2A
   FunctionDefinition._getExecutorQuote
   FunctionDefinition._getExecutorPosition
   FunctionDefinition._getExecutorUpdatePosition
   FunctionDefinition._getExecutorAdmin
   FunctionDefinition._getExecutorAdjustPosition
   FunctionDefinition._getExecutorSwapPermit2B
   FunctionDefinition._getExecutorFallback
   FunctionDefinition._setProxyAdmin
   FunctionDefinition._setProxies

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-16"></a>[NC-16] Internal and private variables and functions names should begin with an underscore
According to the Solidity Style Guide, Non-`external` variable and function names should begin with an [underscore](https://docs.soliditylang.org/en/latest/style-guide.html#underscore-prefix-for-non-external-functions-and-variables)

*Instances (3)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

34:     mapping(uint256 => address) private getApproved_;

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

```solidity
File: ./pkg/sol/SeawaterAMM.sol

59:     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {

132:     function directDelegate(address to) internal {

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="NC-17"></a>[NC-17] `public` functions not called by the contract should be declared `external` instead

*Instances (1)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

123:     function updateProxyAdmin(address newAdmin) public onlyProxyAdmin {

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | Fallback lacking `payable` | 11 |
| [L-2](#L-2) | NFT ownership doesn't support hard forks | 1 |
| [L-3](#L-3) | Solidity version 0.8.20+ may not work on other chains due to `PUSH0` | 2 |
### <a name="L-1"></a>[L-1] Fallback lacking `payable`

*Instances (11)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

36: bytes32 constant EXECUTOR_FALLBACK_SLOT = bytes32(uint256(keccak256("seawater.impl.fallback")) - 1);

97:         ISeawaterExecutorFallback _executorFallback

109:             _executorFallback

480:     function setExecutorFallback(address a) external onlyProxyAdmin {

481:         StorageSlot.getAddressSlot(EXECUTOR_FALLBACK_SLOT).value = a;

485:     fallback() external {

505:         else directDelegate(_getExecutorFallback());

536:     function _getExecutorFallback() internal view returns (address) {

537:         return StorageSlot.getAddressSlot(EXECUTOR_FALLBACK_SLOT).value;

553:         ISeawaterExecutorFallback executorFallback

563:         StorageSlot.getAddressSlot(EXECUTOR_FALLBACK_SLOT).value = address(executorFallback);

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="L-2"></a>[L-2] NFT ownership doesn't support hard forks
To ensure clarity regarding the ownership of the NFT on a specific chain, it is recommended to add `require(block.chainid == 1, "Invalid Chain")` or the desired chain ID in the functions below.

Alternatively, consider including the chain ID in the URI itself. By doing so, any confusion regarding the chain responsible for owning the NFT will be eliminated.

*Instances (1)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

155:     function tokenURI(uint256 /* _tokenId */) external view returns (string memory) {
             return TOKEN_URI;

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

### <a name="L-3"></a>[L-3] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`
The compiler for Solidity 0.8.20 switches the default target EVM version to [Shanghai](https://blog.soliditylang.org/2023/05/10/solidity-0.8.20-release-announcement/#important-note), which includes the new `PUSH0` op code. This op code may not yet be implemented on all L2s, so deployment on these chains will fail. To work around this issue, use an earlier [EVM](https://docs.soliditylang.org/en/v0.8.20/using-the-compiler.html?ref=zaryabs.com#setting-the-evm-version-to-target) [version](https://book.getfoundry.sh/reference/config/solidity-compiler#evm_version). While the project itself may or may not compile with 0.8.20, other projects with which it integrates, or which extend this project may, and those projects will have problems deploying these contracts/libraries.

*Instances (2)*:
```solidity
File: ./pkg/sol/OwnershipNFTs.sol

2: pragma solidity 0.8.16;

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/OwnershipNFTs.sol)

```solidity
File: ./pkg/sol/SeawaterAMM.sol

2: pragma solidity 0.8.16;

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Fees can be set to be greater than 100%. | 8 |
| [M-2](#M-2) | Library function isn't `internal` or `private` | 46 |
### <a name="M-1"></a>[M-1] Fees can be set to be greater than 100%.
There should be an upper limit to reasonable fees.
A malicious owner can keep the fee rate at zero, but if a large value transfer enters the mempool, the owner can jack the rate up to the maximum and sandwich attack a user.

*Instances (8)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

389:     function feesOwed22F28DBD(address /* pool */, uint256 /* position */) external returns (uint128, uint128) {
             directDelegate(_getExecutorAdmin());

389:     function feesOwed22F28DBD(address /* pool */, uint256 /* position */) external returns (uint128, uint128) {
             directDelegate(_getExecutorAdmin());

404:     function feeBB3CF608(address /* pool */) external returns (uint32) {
             directDelegate(_getExecutorAdmin());

404:     function feeBB3CF608(address /* pool */) external returns (uint32) {
             directDelegate(_getExecutorAdmin());

409:     function feeGrowthGlobal038B5665B(address /* pool */) external returns (uint256) {
             directDelegate(_getExecutorAdmin());

409:     function feeGrowthGlobal038B5665B(address /* pool */) external returns (uint256) {
             directDelegate(_getExecutorAdmin());

414:     function feeGrowthGlobal1A33A5A1B(address /*pool */) external returns (uint256) {
             directDelegate(_getExecutorAdmin());

414:     function feeGrowthGlobal1A33A5A1B(address /*pool */) external returns (uint256) {
             directDelegate(_getExecutorAdmin());

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

### <a name="M-2"></a>[M-2] Library function isn't `internal` or `private`
In a library, using an external or public visibility means that we won't be going through the library with a DELEGATECALL but with a CALL. This changes the context and should be done carefully.

*Instances (46)*:
```solidity
File: ./pkg/sol/SeawaterAMM.sol

123:     function updateProxyAdmin(address newAdmin) public onlyProxyAdmin {

160:     function createPoolD650E2D0(

171:     function collectProtocol7540FA9F(

181:     function enablePool579DA658(address /* pool */, bool /* enabled */) external {

186:     function authoriseEnabler5B17C274(address /* enabler */, bool /* enabled */) external {

191:     function setSqrtPriceFF4DB98C(address /* pool */, uint256 /* price */) external {

196:     function updateNftManager9BDF41F6(address /* manager */) external {

201:     function updateEmergencyCouncil7D0C1C58(address /* council */) external {

208:     function swap904369BE(

218:     function quote72E2ADE7(

228:     function quote2CD06B86E(address /* from */, address /* to */, uint256 /* amount */, uint256 /* minOut*/) external {

233:     function swapPermit2EE84AD91(

247:     function swap2ExactInPermit254A7DBB1(

260:     function swap2ExactIn41203F1D(

270:     function swapIn32502CA71(address token, uint256 amountIn, uint256 minOut) external returns (int256, int256) {

283:     function swapInPermit2CEAAB576(

307:     function swapOut5E08A399(address token, uint256 amountIn, uint256 minOut) external returns (int256, int256) {

319:     function swapOutPermit23273373B(

344:     function mintPositionBC5B086D(

353:     function positionOwnerD7878480(uint256 /* id */) external returns (address) {

359:     function transferPositionEEC7A3CD(uint256 /* id */, address /* from */, address /* to */) external {

364:     function positionBalance4F32C7DB(address /* user */) external returns (uint256) {

369:     function positionLiquidity8D11C045(address /* pool */, uint256 /* id */) external returns (uint128) {

374:     function positionTickLower2F77CCE1(address /* pool */, uint256 /* id */) external returns (int32) {

379:     function positionTickUpper67FD55BA(address /* pool */, uint256 /* id */) external returns (int32) {

384:     function sqrtPriceX967B8F5FC5(address /* pool */) external returns (uint256) {

389:     function feesOwed22F28DBD(address /* pool */, uint256 /* position */) external returns (uint128, uint128) {

394:     function curTick181C6FD9(address /* pool */) external returns (int32) {

399:     function tickSpacing653FE28F(address /* pool */) external returns (uint8) {

404:     function feeBB3CF608(address /* pool */) external returns (uint32) {

409:     function feeGrowthGlobal038B5665B(address /* pool */) external returns (uint256) {

414:     function feeGrowthGlobal1A33A5A1B(address /*pool */) external returns (uint256) {

419:     function collectSingleTo6D76575F(

428:     function collect7F21947C(

436:     function updatePositionC7F1F740(

445:     function incrPositionE2437399(

456:     function setExecutorSwap(address a) external onlyProxyAdmin {

459:     function setExecutorSwapPermit2A(address a) external onlyProxyAdmin {

462:     function setExecutorQuote(address a) external onlyProxyAdmin {

465:     function setExecutorPosition(address a) external onlyProxyAdmin {

468:     function setExecutorUpdatePosition(address a) external onlyProxyAdmin {

471:     function setExecutorAdmin(address a) external onlyProxyAdmin {

474:     function setExecutorAdjustPosition(address a) external onlyProxyAdmin {

477:     function setExecutorSwapPermit2B(address a) external onlyProxyAdmin {

480:     function setExecutorFallback(address a) external onlyProxyAdmin {

485:     fallback() external {

```
[Link to code](https://github.com/code-423n4/2024-10-superposition/blob/main/./pkg/sol/SeawaterAMM.sol)

