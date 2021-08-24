pragma solidity ^0.4.23;

contract EMRList {
     
	address public doctor;
	struct bEMR{
		uint256 br;
		uint256 bs;
	}
	
    mapping(bytes32 => bEMR) internal beMap;
 
 
	event _Upload(address indexed requester);
	event _Check(address indexed requester);
	event _Get(address indexed requester);
    event _Revoke(address indexed requester);
    function EMRList() public {
		doctor = msg.sender;
    }
	
	function Upload(uint256 br, uint256 bs) public returns (bytes32){
		require(msg.sender == doctor);
		bytes32 index = keccak256(br,bs);
        beMap[index].br = br;
		beMap[index].bs = bs;
		_Upload(msg.sender);
        return index;
    }	

    function Check(uint256 br, uint256 bs) public view returns (bool) {
		bytes32 index = keccak256(br,bs);
		if(beMap[index].br == br  && beMap[index].bs == bs)
		{
			return true;
		}
		_Check(msg.sender);
        return false;
    }
	
	function Get(bytes32 index) public view returns (uint256, uint256) {
		_Retrieve(msg.sender);
        return (beMap[index].br, beMap[index].bs);
    }
	
	function Revoke(uint256 br, uint256 bs) public{
		require(msg.sender == doctor);		
        bytes32 index = keccak256(br,bs);
		if(beMap[index].br == br && beMap[index].bs == bs)
		{
			delete beMap[index];
		}
		_Revoke(msg.sender);
    }
    
}
