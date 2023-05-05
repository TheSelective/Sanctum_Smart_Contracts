// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract Pawn is ERC721URIStorage, AccessControl, Ownable, Pausable {
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    using Counters for Counters.Counter;
    Counters.Counter public _tokenIdCounter;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER");
    bytes32 public constant URL_CONTROLLER_ROLE = keccak256("URLCONTROLLER");

    constructor() ERC721("Sanctum Pawn", "PAWN") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mint(address to) public whenNotPaused returns (uint256) {
        require(hasRole(MINTER_ROLE, msg.sender), "Only Minter can do this");
        _safeMint(to, _tokenIdCounter.current());

        _tokenIdCounter.increment();

        return _tokenIdCounter.current();
    }

    function mint_id(address to, uint id) public whenNotPaused returns(uint256) {
        require(hasRole(MINTER_ROLE, msg.sender), "Only Minter can do this");
        _safeMint(to, id);

        _tokenIdCounter.increment();

        return id;
    }

    function mint_url(address to, string memory _tokenUrl) public whenNotPaused returns (uint256) {
        require(hasRole(MINTER_ROLE, msg.sender), "Only Minter can do this");
        _safeMint(to, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), _tokenUrl);

        _tokenIdCounter.increment();

        return _tokenIdCounter.current();
    }

    function burn(uint256 tokenId) public whenNotPaused {
        require(hasRole(BURNER_ROLE, msg.sender), "Only Burner can do this");

        _burn(tokenId);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public whenNotPaused {
        require(hasRole(URL_CONTROLLER_ROLE, msg.sender), "Only Url Controller can do this");

        _setTokenURI(tokenId, _tokenURI);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}
