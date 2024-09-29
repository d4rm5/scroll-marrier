//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {Marriage} from "./Marriage.sol";

contract MarriageFactory is EIP712 {
    string private constant SIGNING_DOMAIN = "MarriageFactory";
    string private constant SIGNATURE_VERSION = "1";

    struct MarriageData {
        address spouse1;
        address spouse2;
        uint256 deadline;
    }

    mapping(address => address) public marriageContractOf;

    event MarriageCreated(address indexed spouse1, address indexed spouse2, address marriageContract);
    event Divorced(address indexed spouse1, address indexed spouse2);

    constructor() EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION) {}

    function verify(MarriageData memory marriageData, bytes memory signature1, bytes memory signature2) internal view returns (bool) {
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
            marriageData.spouse1,
            marriageData.spouse2,
            marriageData.deadline
        )));

        address signer1 = ECDSA.recover(digest, signature1);
        address signer2 = ECDSA.recover(digest, signature2);

        return (signer1 == marriageData.spouse1 && signer2 == marriageData.spouse2 && block.timestamp <= marriageData.deadline);
    }

    function createMarriage(
        MarriageData memory marriageData,
        bytes memory signature1,
        bytes memory signature2,
        string memory SPOUSE1_URI,
        string memory SPOUSE2_URI
    ) public returns (address) {
        require(verify(marriageData, signature1, signature2), "Invalid signatures");
        
        // Verify that addresses aren't married
        require(marriageContractOf[marriageData.spouse1] == address(0), "Spouse 1 is already married");
        require(marriageContractOf[marriageData.spouse2] == address(0), "Spouse 2 is already married");

        Marriage newMarriage = new Marriage(marriageData.spouse1, marriageData.spouse2, address(this), SPOUSE1_URI, SPOUSE2_URI);
        address marriageAddress = address(newMarriage);

        marriageContractOf[marriageData.spouse1] = marriageAddress;
        marriageContractOf[marriageData.spouse2] = marriageAddress;

        emit MarriageCreated(marriageData.spouse1, marriageData.spouse2, marriageAddress);
        return marriageAddress;
    }

    function divorce(MarriageData memory divorceData, bytes memory signature1, bytes memory signature2) public {
        require(marriageContractOf[divorceData.spouse1] == marriageContractOf[divorceData.spouse2], "Addresses aren't married");
        require(verify(divorceData, signature1, signature2), "Invalid signatures");
        
        delete marriageContractOf[divorceData.spouse1];
        delete marriageContractOf[divorceData.spouse2];

        emit Divorced(divorceData.spouse1, divorceData.spouse2);
    }

    function getMarriageStatus(address person) public view returns (bool) {
        return ((marriageContractOf[person] != address(0)));
    }
}