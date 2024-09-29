// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Rings is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {

    uint256 public constant SPOUSE1_TOKEN_ID = 1;
    uint256 public constant SPOUSE2_TOKEN_ID = 2;

    constructor(address spouse1, address spouse2)
        ERC721("Rings", "RING")
        Ownable(msg.sender)
    {
        _safeMint(spouse1, SPOUSE1_TOKEN_ID);
        _safeMint(spouse2, SPOUSE2_TOKEN_ID);
    }

    function burn(uint256 tokenId) public override onlyOwner {
        _update(address(0), tokenId, _msgSender());
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(ERC721, IERC721) {
        revert("Rings are non-transferable");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public override(ERC721, IERC721) {
        revert("Rings are non-transferable");
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function revokeRings() public onlyOwner {
        burn(SPOUSE1_TOKEN_ID);
        burn(SPOUSE2_TOKEN_ID);
    }

    
}