// SPDX-Identifier: MIT
pragma solidity 0.8.16;

import "./IERC721Metadata.sol";
import "./IERC721TokenReceiver.sol";
import "./IERC165.sol";

import "./ISeawaterAMM.sol";

/*
 * OwnershipNFTs is a simple interface for tracking ownership of
 * positions in the Seawater Stylus contract.
 */
contract OwnershipNFTs is IERC721Metadata, IERC165 {
    ISeawaterAMM public immutable SEAWATER;

    /**
     * @notice TOKEN_URI to set as the default token URI for every NFT
     * @dev immutable in practice (not set anywhere)
     */
    string public TOKEN_URI;

    /// @notice name of the NFT, set by the constructor
    string public name;

    /// @notice symbol of the NFT, set during the constructor
    string public symbol;

    /**
     * @notice getApproved that can spend the id of the tokens given
     * @dev required in the NFT spec and we simplify the use here by
     *      naming the storage slot as such
     */
    mapping(uint256 => address) private getApproved_;

    /// @inheritdoc IERC721Metadata
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    constructor(string memory _name, string memory _symbol, string memory _tokenURI, ISeawaterAMM _seawater) {
        name = _name;
        symbol = _symbol;
        TOKEN_URI = _tokenURI;
        SEAWATER = _seawater;
    }

    /// @inheritdoc IERC721Metadata
    function ownerOf(uint256 _tokenId) public view returns (address) {
        (bool ok, bytes memory rc) = address(SEAWATER).staticcall(
            abi.encodeWithSelector(SEAWATER.positionOwnerD7878480.selector, _tokenId)
        );
        require(ok, "position owner revert");
        address owner = abi.decode(rc, (address));
        return owner;
    }

    /// @inheritdoc IERC721Metadata
    function getApproved(uint256 _tokenId) external view returns (address) {
        address approved = getApproved_[_tokenId];
        require(approved != address(0), "not existing");
        return approved;
    }

    /**
     * @notice _onTransferReceived by calling the callback `onERC721Received`
     *         in the recipient if they have codesize > 0. if the callback
     *         doesn't return the selector, revert!
     * @param _sender that did the transfer
     * @param _from owner of the NFT that the sender is transferring
     * @param _to recipient of the NFT that we're calling the function on
     * @param _tokenId that we're transferring from our internal storage
     */
    function _onTransferReceived(address _sender, address _from, address _to, uint256 _tokenId) internal {
        // only call the callback if the receiver is a contract
        if (_to.code.length == 0) return;

        bytes4 data = IERC721TokenReceiver(_to).onERC721Received(
            _sender,
            _from,
            _tokenId,
            // this is empty byte data that can be optionally passed to
            // the contract we're confirming is able to receive NFTs
            ""
        );

        require(data == IERC721TokenReceiver.onERC721Received.selector, "bad nft transfer received data");
    }

    function _requireAuthorised(address _from, uint256 _tokenId) internal view {
        // revert if the sender is not authorised or the owner
        bool isAllowed = msg.sender == _from ||
            isApprovedForAll[_from][msg.sender] ||
            msg.sender == getApproved_[_tokenId];

        require(isAllowed, "not allowed");
        require(ownerOf(_tokenId) == _from, "_from is not the owner!");
    }

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        _requireAuthorised(_from, _tokenId);
        require(_to != address(0), "invalid recipient");
        getApproved_[_tokenId] = address(0);
        SEAWATER.transferPositionEEC7A3CD(_tokenId, _from, _to);
        emit Transfer(_from, _to, _tokenId);
    }

    /// @inheritdoc IERC721Metadata
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        // checks that the user is authorised
        _transfer(_from, _to, _tokenId);
    }

    /// @inheritdoc IERC721Metadata
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
        _transfer(_from, _to, _tokenId);
        _onTransferReceived(msg.sender, _from, _to, _tokenId);
    }

    /// @inheritdoc IERC721Metadata
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata /* _data */
    ) external payable {
        _transfer(_from, _to, _tokenId);
        _onTransferReceived(msg.sender, _from, _to, _tokenId);
    }

    /// @inheritdoc IERC721Metadata
    function approve(address _approved, uint256 _tokenId) external payable {
        address owner = ownerOf(_tokenId);
        require(owner == msg.sender || isApprovedForAll[owner][msg.sender], "not authorised");
        getApproved_[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    /// @inheritdoc IERC721Metadata
    function setApprovalForAll(address _operator, bool _approved) external {
        isApprovedForAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    /// @inheritdoc IERC721Metadata
    function balanceOf(address _spender) external view returns (uint256) {
        require(_spender != address(0), "invalid recipient");
        (bool ok, bytes memory rc) = address(SEAWATER).staticcall(
            abi.encodeWithSelector(SEAWATER.positionBalance4F32C7DB.selector, _spender)
        );
        require(ok, "position balance revert");
        uint256 balance = abi.decode(rc, (uint256));
        return balance;
    }

    /// @inheritdoc IERC721Metadata
    function tokenURI(uint256 /* _tokenId */) external view returns (string memory) {
        return TOKEN_URI;
    }

    /// @inheritdoc IERC165
    function supportsInterface(bytes4 _interfaceId) external pure returns (bool) {
        return
            _interfaceId == this.supportsInterface.selector ||
            _interfaceId ==
            this.balanceOf.selector ^
                this.ownerOf.selector ^
                bytes4(keccak256("safeTransferFrom(address,address,uint256)")) ^
                bytes4(keccak256("safeTransferFrom(address,address,uint256,bytes)")) ^
                this.transferFrom.selector ^
                this.approve.selector ^
                this.setApprovalForAll.selector ^
                this.getApproved.selector ^
                this.isApprovedForAll.selector ^
                this.name.selector ^
                this.symbol.selector ^
                this.tokenURI.selector;
    }
}
