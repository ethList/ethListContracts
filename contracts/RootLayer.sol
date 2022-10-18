// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "./interfaces/IEIMLayer.sol";
import "./interfaces/IRootLayer.sol";

contract RootLayer is IRootLayer, Initializable {
    address public override layerTemplate;
    mapping(address => address) public override getChildLayer;
    mapping(address => address) public override getParentLayer;

    function initialize(address layerTemplate_) external override initializer {
        layerTemplate = layerTemplate_;
    }

    function createLayer(address parentLayer, string memory layerName)
        external
        override
        returns (address)
    {
        require(getChildLayer[parentLayer] == address(0), "already has child");
        if (parentLayer != address(this)) {
            require(
                getParentLayer[parentLayer] != address(0),
                "parent not found"
            );
        }

        address newLayer = Clones.clone(layerTemplate);
        IEIMLayer(newLayer).initialize(parentLayer, layerName);

        getChildLayer[parentLayer] = newLayer;
        getParentLayer[newLayer] = parentLayer;

        emit LayerCreated(parentLayer, newLayer, layerName);
        return newLayer;
    }
}
