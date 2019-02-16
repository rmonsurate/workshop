pragma solidity ^0.4.20;
/**
* Metadata contract is upgradeable and returns metadata about Token
*/

import "./helpers/strings.sol";

contract Metadata {
    using strings for *;

    function tokenURI(uint _tokenId) public view returns (string _infoUrl) {
	    string memory base = "https://yourdomain.com/metadata/";
	    string memory id = uint2str(_tokenId);
	    return base.toSlice().concat(id.toSlice());
	}

	function uint2str(uint i) internal pure returns (string){
	    if (i == 0) return "0";
	    uint j = i;
	    uint length;
	    while (j != 0){
	        length++;
	        j /= 10;
	    }
	    bytes memory bstr = new bytes(length);
	    uint k = length - 1;
	    while (i != 0){
	        bstr[k--] = byte(48 + i % 10);
	        i /= 10;
	    }
	    return string(bstr);
	}


	function getMetadata() public view returns (address) {
    return metadata;
	}
	
	function tokenURI(uint _tokenId) public view returns (string _infoUrl) {
	    address _impl = getMetadata();
	    bytes memory data = msg.data;
	    assembly {
	        let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
	        let size := returndatasize
	        let ptr := mload(0x40)
	        returndatacopy(ptr, 0, size)
	        switch result
	        case 0 { revert(ptr, size) }
	        default { return(ptr, size) }
	    }
	    // this is how it would be done if returning a variable length were possible:
	    // return Metadata(metadata).tokenURI(_tokenId);
	}

}