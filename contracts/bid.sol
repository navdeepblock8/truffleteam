pragma solidity >=0.4.20 <0.6.0;

contract Mycontract {

    address payable public beneficiary;
    uint public bidtime;
    
    mapping(address => uint) previousBids;
    address public highestBider;
    uint public highestBid;
    
    bool ended;
    event Bidraised(address highestBidernow, uint highestBidnow );
    event bidended(address winner,uint winAmount);
    
    constructor(address payable _beneficiary, uint _bidtime)public{
        beneficiary = _beneficiary;
        bidtime = _bidtime;
    }
    
    function bid()payable public{
        require(
            bidtime>now) ;
        
        if(msg.value>highestBid)
        {
            highestBid = msg.value;
            highestBider = msg.sender;
            //emit Bidraised(highestBidernow,highestBid);
            previousBids[highestBider] += highestBid; 
        }
        
    }
    function withdrawbid()public returns(bool){
        uint amount = previousBids[msg.sender];
        if(amount>0)
        {
            previousBids[msg.sender] = 0;
        }
        if(!msg.sender.send(amount))
        {
            previousBids[msg.sender] = amount;
            return false;
        }
        return true;
    }
    function auctionend()public{
        require(now>bidtime);
        require(!ended);
        //emit bidended(highestBidernow,highestBid);
        beneficiary.transfer(highestBid);
        ended = true;
    }
}