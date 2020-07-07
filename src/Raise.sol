pragma solidity ^0.6.6;

import "./Offer.sol";

// raise contract that has 3 states: open, closed, failed
// - when open, it sells shares in exchange for capTok up to some maximum
// - to close, shares sold must be > some minimum and raise time expired
    // - on close, deploy an order to sell capTok to Minion for rewardToken
// - when closed, any participant can withdraw at any time
    // - withdraw returns their share of remaining capTok + their share of the filled portion of the order, and decreases the order by the amt returned to the withdrawer
// - when failed, any participant can withdraw at any time
    // - withdraw returns their share of capTok
contract Raise {
    enum State {
        Open,
        Closed,
        Failed
    }
    uint256 immutable closeTime;
    uint256 immutable minRaise;
    uint256 immutable maxRaise;
    address immutable recipient; // address raised funds will be offered to
    IERC20 immutable capTok;   // token representing initial capital
    IERC20 immutable retTok;   // token representing expected returns

    State state;
    uint256 total;
    address offer;
    mapping (address => uint256) shares;

    modifier open() { require(state == State.Open); _; }
    modifier closed() { require(state == State.Closed); _; }
    modifier failed() { require(state == State.Failed); _; }
    modifier closable() {
        require(state == State.Open);
        require(block.timestamp > closeTime);
        _;
    }

    function enter(uint256 amt) external open returns (bool) {
        uint256 newTotal = total.add(amt);
        require(newTotal <= MAX_RAISE);
        require(capTok.transferFrom(msg.sender, address(this), amt));
        // require(capTok.balanceOf(address(this) >= amt)
        shares[msg.sender] = shares[msg.sender].add(amt);
    }

    // partial exits?
    function exit(uint256 numShares) external closed returns (bool) {
        require(state == State.Closed);

        uint256 origShares = shares[msg.sender];
        shares[msg.sender] = origShares.sub(numShares);

        uint256 capTokOwed = ;  // related to shares and share price
        uint256 retTokOwed = ;  // related to shares and order fill amt
        require(capTok.transfer(msg.sender, capTokOwed));
        require(retTok.transfer(msg.sender, retTokOwed));
    }


    function close() external closable {
        require(total >= minRaise);
        state = State.Closed;
        // deploy Offer
        offer = new Offer(recipient, capTok, buyTok, total, );
    }

    function closeFailed() external closable {
        require(total < minRaise);
        state = State.Failed;
    }

    function exitFailed() external failed {}
}
