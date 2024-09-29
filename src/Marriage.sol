// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Marriage is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {

    uint256 public constant SPOUSE1_TOKEN_ID = 1;
    uint256 public constant SPOUSE2_TOKEN_ID = 2;
    mapping (address => address) spouse;

    constructor(address _spouse1, address _spouse2, address initialOwner, string memory SPOUSE1_URI, string memory SPOUSE2_URI)
        ERC721("Marriage", "RING")
        Ownable(initialOwner)
    {
        _safeMint(_spouse1, SPOUSE1_TOKEN_ID);
        spouse[_spouse1] = _spouse2;
        _setTokenURI(SPOUSE1_TOKEN_ID, SPOUSE1_URI);
        _safeMint(_spouse2, SPOUSE2_TOKEN_ID);
        _setTokenURI(SPOUSE2_TOKEN_ID, SPOUSE1_URI);
        spouse[_spouse2] = _spouse1;
    }

    function burn(uint256 tokenId) public override onlyOwner {
        _update(address(0), tokenId, _msgSender());
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public       pure
    override(ERC721, IERC721) {
        revert("Rings are non-transferable");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public pure
    override(ERC721, IERC721) {
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

    function spouseOf (address _address) public view returns (address) {
        return(spouse[_address]);
    }
    
}