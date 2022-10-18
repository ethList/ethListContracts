// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IEIMLayer.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract EIMLayer is IEIMLayer, Initializable {
    IEIMLayer public override parentLayer;
    string public override layerName;

    mapping(uint256 => Item) private items;

    function initialize(address parentLayer_, string memory layerName_)
        external
        initializer
    {
        parentLayer = IEIMLayer(parentLayer_);
        layerName = layerName_;
    }

    function getItem(uint256 id) public view override returns (Item memory) {
        return items[id];
    }

    function addSingleItem(
        uint256 parentId,
        uint256 itemId,
        string memory name
    ) external returns (bool) {
        _addItem(parentId, itemId, name);
        return true;
    }

    function batchAddItemsToSingleParent(
        uint256 parentId,
        uint256[] memory itemIds,
        string[] memory names
    ) external returns (bool) {
        require(
            itemIds.length == names.length,
            "itemIds.length != names.length"
        );
        for (uint256 i = 0; i < itemIds.length; i++) {
            _addItem(parentId, itemIds[i], names[i]);
        }
        return true;
    }

    function batchAddItemsToMultiParents(
        uint256[] memory parentIds,
        uint256[] memory itemIds,
        string[] memory names
    ) external returns (bool) {
        require(
            itemIds.length == parentIds.length,
            "itemIds.length != parentIds.length"
        );
        require(
            itemIds.length == names.length,
            "itemIds.length != names.length"
        );
        for (uint256 i = 0; i < parentIds.length; i++) {
            _addItem(parentIds[i], itemIds[i], names[i]);
        }
        return true;
    }

    function _addItem(
        uint256 parentId,
        uint256 itemId,
        string memory name
    ) internal {
        require(
            parentLayer.getItem(parentId).initialized,
            "parentId not found"
        );
        require(!items[itemId].initialized, "itemId exist");
        Item memory item = Item(parentId, name, true);
        items[itemId] = item;
        emit ItemAdded(address(parentLayer), parentId, itemId, name);
    }
}
