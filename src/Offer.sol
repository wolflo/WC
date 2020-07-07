pragma solidity ^0.6.6;

// represents a one-time, partially fillable order with a fixed rate and a quantity upper bound
// Taker can take any portion of the order at any time
// Maker can decrease the amount sold at any time, but the rate is fixed
contract Offer {
    address immutable maker;  // sale contract
    address immutable taker;  // minion
    IERC20 immutable sellTok;
    IERC20 immutable buyTok;
    uint256 immutable rate;
    uint256 sellAmt;
    uint256 soldAmt;

    modifier maker() { require(msg.sender == maker); _; }
    modifier taker() { require(msg.sender == taker); _; }

    constructor(
        address _taker,
        IERC20 _sellTok,
        IERC20 _buyTok,
        uint256 _sellAmt,
        uint256 _rate
    ) public {
        maker = msg.sender;
        taker = _taker;
        sellTok = _sellTok;
        buyTok = _buyTok;
        sellAmt = _sellAmt;
        rate = _rate;
    }

    /// assert(soldAmt <= sellAmt)
    function buy(uint256 amt) public taker returns (bool) {
        require(amt <= sellAmt - soldAmt);
        soldAmt = soldAmt.add(amt);
        uint256 cost = amt.mul(rate);
        require(buyTok.transferFrom(msg.sender, maker, cost));
        require(sellTok.transfer(msg.sender, amt));
        return true;
    }

    function decSellAmt(uint256 damt) public maker returns (bool) {
        newSellAmt = sellAmt.sub(damt);
        require(newSellAmt >= soldAmt);
        sellAmt = newSellAmt;
        require(sellTok.transfer(damt));
        return true;
    }
}
