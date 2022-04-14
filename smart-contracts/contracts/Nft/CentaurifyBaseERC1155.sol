// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

/// @custom:security-contact security@centaurify.com
contract CentaurifyBaseERC1155 is ERC1155, AccessControl, Pausable, ERC1155Burnable, ERC1155Supply {
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant DEV_ROLE = keccak256("DEV_ROLE");


    constructor(address _owner) ERC1155("") {
        _grantRole(DEFAULT_ADMIN_ROLE, _owner);
        _grantRole(URI_SETTER_ROLE, _owner);
        _grantRole(PAUSER_ROLE, _owner);
        _grantRole(MINTER_ROLE, _owner);
        _grantRole(DEV_ROLE, _owner);
    }

    function setURI(string memory newuri) public onlyRole(URI_SETTER_ROLE) {
        _setURI(newuri);
    }

    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        external
        onlyRole(MINTER_ROLE)
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        external
        onlyRole(MINTER_ROLE)
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function remove() external onlyRole(DEV_ROLE) {
        selfdestruct(payable(address(msg.sender)));
    }
}