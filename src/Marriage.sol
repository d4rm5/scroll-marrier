//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Rings} from "./Rings.sol";

contract Marriage {

    address spouse1;
    address spouse2;
    address controller;
    Rings rings;

    constructor(
        address _spouse1,
        address _spouse2,
        address _controller
    ) {
        spouse1 = _spouse1;
        spouse2 = _spouse2;
        controller = _controller;
        rings = new Rings(spouse1, spouse2);
    }

    function divorce() public onlyController {
        rings.revokeRings();

    }

    modifier onlyController() {
        require(msg.sender == controller, "Not controller");
        _;
    }

}
