pragma solidity ^0.4.23;

contract BCList {
     
	address public CA;
	struct BCert{
		uint256 br;
		uint256 bs;
	}
	
    mapping(bytes32 => BCert) internal bcMap;
 
 
	event _Upload(address indexed requester);
	event _Check(address indexed requester);
	event _Retrieve(address indexed requester);
    event _Revoke(address indexed requester);
    function BCList() public {
		CA = msg.sender;
    }
	
	function Upload(uint256 br, uint256 bs) public returns (bytes32){
		require(msg.sender == CA);
		bytes32 index = keccak256(br,bs);
        bcMap[index].br = br;
		bcMap[index].bs = bs;
		_Upload(msg.sender);
        return index;
    }	

    function Check(uint256 br, uint256 bs) public view returns (bool) {
		bytes32 index = keccak256(br,bs);
		if(bcMap[index].br == br  && bcMap[index].bs == bs)
		{
			return true;
		}
		_Check(msg.sender);
        return false;
    }
	
	function Retrieve(bytes32 index) public view returns (uint256, uint256) {
		_Retrieve(msg.sender);
        return (bcMap[index].br, bcMap[index].bs);
    }
	
	function Revoke(uint256 br, uint256 bs) public{
		require(msg.sender == CA);		
        bytes32 index = keccak256(br,bs);
		if(bcMap[index].br == br && bcMap[index].bs == bs)
		{
			delete bcMap[index];
		}
		_Revoke(msg.sender);
    }
    
}
