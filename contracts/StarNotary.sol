pragma solidity >=0.4.24;

//Importing openzeppelin-solidity ERC-721 implemented Standard
import "../app/node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

// StarNotary Contract declaration inheritance the ERC721 openzeppelin implementation
contract StarNotary is ERC721 {

    struct Star {
        string name;
        string symbol;
    }

    mapping(uint256 => Star) public tokenIdToStarInfo; // mapping the Star with the Owner Address
    mapping(uint256 => uint256) public starsForSale; // mapping the TokenId and price

    
    function name() public pure returns (string memory) {
        return "NL Stars";
    }

    function symbol() public pure returns (string memory) {
        return "NLS";
    }
    
    // Minting the new star
    function createStar(string memory _name, string memory _symbol, uint256 _tokenId) public { 
        Star memory newStar = Star(_name, _symbol);
        tokenIdToStarInfo[_tokenId] = newStar;
        _mint(msg.sender, _tokenId); // _mint assign the the star with _tokenId to the sender address (ownership)
    }

    // Putting an Star for sale (Adding the star tokenid into the mapping starsForSale, verifying that the sender is the owner)
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You cannot sell a Star you do not own!");
        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable {
        require(starsForSale[_tokenId] > 0, "The Star should be up for sale");
        uint256 starCost = starsForSale[_tokenId];
        address ownerAddress = ownerOf(_tokenId);
        require(msg.value > starCost, "You need to have enough Ether");
        _transferFrom(ownerAddress, msg.sender, _tokenId); // We can't use _addTokenTo or_removeTokenFrom functions, now we have to use _transferFrom
        address payable ownerAddressPayable = _make_payable(ownerAddress); // We need to make this conversion to be able to use transfer() function to transfer ethers
        ownerAddressPayable.transfer(starCost);
        if(msg.value > starCost) {
            msg.sender.transfer(msg.value - starCost);
        }
    }

    function lookUptokenIdToStarInfo (uint _tokenId) public view returns (string memory) {
        Star memory starByTokenId = tokenIdToStarInfo[_tokenId];
        return starByTokenId.name;
    }

    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
        // Passing to star tokenId you need to check if the owner of _tokenId1 or _tokenId2 is the sender
        require(msg.sender == ownerOf(_tokenId1) || msg.sender == ownerOf(_tokenId2),
         "Sender should be the owner of one of the exchanged Stars");

        // Get the owner of the two tokens (ownerOf(_tokenId1), ownerOf(_tokenId2)
        address ownerAddress1 = ownerOf(_tokenId1);
        address ownerAddress2 = ownerOf(_tokenId2);

        // Use _transferFrom function to exchange the tokens.
        _transferFrom(ownerAddress1, ownerAddress2, _tokenId1);
        _transferFrom(ownerAddress2, ownerAddress1, _tokenId2);
    }

    function transferStar(address _to1, uint256 _tokenId) public {
        // Check if the sender is the ownerOf(_tokenId)
        require(ownerOf(_tokenId) == msg.sender, "You cannot transfer a Star you do not own!");
        
        // Use the transferFrom(from, to, tokenId); function to transfer the Star
        _transferFrom(msg.sender, _to1, _tokenId);
    }

    // Utility function that allows you to convert an address into a payable address
    function _make_payable(address x) internal pure returns (address payable) {
        return address(uint160(x));
    }

}
