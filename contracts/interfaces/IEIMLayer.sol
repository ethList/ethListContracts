// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEIMLayer {
    struct Item {
        uint256 parentId;
        string name;
        bool initialized;
    }

    event ItemAdded(
        address parentLayer,
        uint256 parentId,
        uint256 currentId,
        string name
    );

    function parentLayer() external view returns (IEIMLayer);

    function layerName() external view returns (string memory);

    function getItem(uint256 id) external view returns (Item memory);

    function initialize(address parentLayer_, string memory layerName_)
        external;
}
