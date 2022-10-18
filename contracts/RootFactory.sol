// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./interfaces/IRootLayer.sol";

contract RootFactory {
    event RootCreated(address indexed newRoot, string rootName);

    address public rootTemplate;
    address public layerTemplate;
    string[] public names;
    mapping(string => address) getRoot;

    constructor(address rootTemplate_, address layerTemplate_) {
        rootTemplate = rootTemplate_;
        layerTemplate = layerTemplate_;
    }

    function createRoot(string memory rootName) external returns (address) {
        require(getRoot[rootName] == address(0), "root name exist");
        address newRoot = Clones.clone(rootTemplate);
        IRootLayer(newRoot).initialize(layerTemplate);
        names.push(rootName);
        getRoot[rootName] = newRoot;
        emit RootCreated(newRoot, rootName);
        return newRoot;
    }
}
