module 0x1b2afab3bb2ee1f837a8dd7ab13ff8d2c77f446d0dc80ce8b43fb4c9c213b8bc::cringe_stake_vote {

    use sui::object::UID;
    use sui::tx_context::{Self, TxContext};
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::table::{Self, Table};

    // Replace this with your actual SNOUT token type
    struct SNOUT has store, drop {}

    struct VoteInfo has store {
        votes: u64,
        total_stake: u64,
    }

    struct VotingPool has key {
        id: UID,
        stakes: Table<address, u64>,
        content_votes: Table<u64, VoteInfo>,
    }

    public fun init(ctx: &mut TxContext): VotingPool {
        let id = object::new(ctx);
        let stakes = Table::new(ctx);
        let content_votes = Table::new(ctx);
        VotingPool { id, stakes, content_votes }
    }

    /// Stake SNOUT tokens to vote for a content ID
    public entry fun stake_vote(
        pool: &mut VotingPool,
        content_id: u64,
        stake_coin: Coin<SNOUT>,
        ctx: &mut TxContext
    ) {
        let voter = tx_context::sender(ctx);
        let stake_amount = coin::value(&stake_coin);

        // Update total stake for content
        if (!Table::contains(&pool.content_votes, content_id)) {
            let info = VoteInfo { votes: 1, total_stake: stake_amount };
            Table::insert(&mut pool.content_votes, content_id, info);
        } else {
            let mut info = Table::borrow_mut(&mut pool.content_votes, content_id);
            info.votes = info.votes + 1;
            info.total_stake = info.total_stake + stake_amount;
        }

        // Update individual stake
        let current = Table::remove(&mut pool.stakes, voter).unwrap_or(0);
        Table::insert(&mut pool.stakes, voter, current + stake_amount);

        // Burn or hold the staked coin to lock it (here, just dropped)
        coin::destroy_zero(stake_coin);
    }

    /// View votes for a specific content
    public fun get_votes(pool: &VotingPool, content_id: u64): VoteInfo {
        Table::borrow(&pool.content_votes, content_id)
    }

    /// Reset voting data (admin-only in production)
    public entry fun reset_votes(pool: &mut VotingPool, ctx: &mut TxContext) {
        // Warning: Clears all data - not gas efficient. For demo use only.
        pool.content_votes = Table::new(ctx);
        pool.stakes = Table::new(ctx);
    }
}
