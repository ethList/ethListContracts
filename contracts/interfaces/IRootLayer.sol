// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRootLayer {
    event LayerCreated(address parentLayer, address newLayer, string layerName);

    function layerTemplate() external view returns (address);

    function getChildLayer(address parentLayer)
        external
        view
        returns (address childLayer);

    function getParentLayer(address childLayer)
        external
        view
        returns (address parentLayer);

    function initialize(address layerTemplate_) external;

    function createLayer(address parentLayer, string memory layerName)
        external
        returns (address);
}
