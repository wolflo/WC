# Overview
Breaks raise structure into several components:
- `capTok`: the token that capital is raised in (e.g. dai)
- `retTok`: the token that returns are expected in
    - Could be any ERC20 token representing equity, rev share token, etc.
- `Offer`: a standalone contract representing a one-time offer from `maker` to sell `capTok` to `maker` in exchange for `retTok`
    - In our case, the offer sets a fixed exchange rate and a quantity upper bound, meaning the `maker` can withdraw any amount that has not already been sold
    - In theory, the offer could be on a drip or a bonding curve, meaning capital costs the `taker` more at different points on the curve
- `maker`: the entity offering to exchange `capTok` for `retTok`
    - Could be a single VC, a DAO, a simple Raise contract (our case), or a more complex Raise that allows users to exit with accrued rev share payouts
- `taker`: the entity seeking `capTok`
    - In this case, the DAO building things and willing to give up future revenue claims for capital

# Benefits
- strikes a balance between something we can build now and something more permanent by allowing flexibility and swapping of components in the future
    - crucially, this swapping of components does not require 'upgrading', we can just use a new set of contracts for the next raise
benefits of separating offer, sale, and token:
- simpler to verify -- dont have to mix state of the raise with state of capital usage / purchase
- represents more general offers of capital. Any arbitrary group (dao, sale participants, vc) can generate some offer with specific characteristics. Then, the org in need of capital can take some or all of that offer (depending on the terms). Offer prices may vary in some way, such as along a bonding curve, and takers might have multiple offers of capital from different entities and take some portion of each one
- if someone is unhappy with the structure of the raise, they can just make their own raise contract
- if someone is unhappy with the terms of the offer of capital, they can just make their own Offer
