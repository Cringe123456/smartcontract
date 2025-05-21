https://suiscan.xyz/testnet/object/0x2a250854a06b483889f6c09d2ef0fe6b29162e21fedaa273638cfc39512c0df1/

Successfully published package:
Package ID: 0x2a250854a06b483889f6c09d2ef0fe6b29162e21fedaa273638cfc39512c0df1

Deployment Summary:
-------------------
Token Name: SNOUT Token
Token Symbol: SNT
Token Decimals: 18
Total Supply: 1000000000000000000000000 (raw units)
Token Owner: 0x4f59bec0f58ec3f3bf4f9ba2d877d11d695ceacda5c65109f575bd2d7909d53a


# Cringe Stake-to-Vote Smart Contract (Sui Move)

Cringe is a memecoin short-content platform where users vote on content using **$SNOUT** tokens. This smart contract allows users to **stake to vote**, increasing the weight of their opinion with the amount of SNOUT they commit.

---

## 📜 Smart Contract Purpose

The smart contract enables a **"Stake-to-Vote"** system, where:

- Users **stake SNOUT tokens** to vote on specific content.
- Each vote is associated with a **content ID**.
- Votes are **weighted by the amount staked**.
- Stakes are **locked or burned** to ensure voting commitment.
- Voting data (total votes, total staked) is tracked per content.
- Admin (owner) can **reset voting pools** after each voting cycle.

---

## ⚙️ How It Works

1. Users call `stake_vote()` with SNOUT tokens and a content ID.
2. The contract increases the vote count and stake total for the content.
3. Stake is locked (burned or stored, depending on implementation).
4. Admin can reset the pool for a new voting round.

---

## 🧩 Functions

### ✅ Implemented Functions

| Function | Description |
|---------|-------------|
| `init(ctx: &mut TxContext)` | Initializes a new VotingPool object. |
| `stake_vote(pool: &mut VotingPool, content_id: u64, stake_coin: Coin<SNOUT>, ctx: &mut TxContext)` | Allows a user to vote for a content ID by staking SNOUT tokens. |
| `get_votes(pool: &VotingPool, content_id: u64): VoteInfo` | Returns current votes and total stake for a content ID. |
| `reset_votes(pool: &mut VotingPool, ctx: &mut TxContext)` | Resets all voting and stake data. Intended for admin use. |

---

## ⏭️ Suggested Future Add-ons

You may want to implement the following in future versions:

- `withdraw_stake()` – let users reclaim SNOUT after voting periods.
- `set_vote_period(start: u64, end: u64)` – time-gate when voting is allowed.
- `reward_top_content()` – reward creators of top-voted content with tokens.
- `penalize_sybil_votes()` – prevent spam voting by enforcing minimum stake.
- `only_owner()` – restrict reset functions to admin address.

---

## 📂 File

| Filename | Description |
|----------|-------------|
| `cringe_stake_vote.move` | Main smart contract file written in Move for the Sui blockchain. |

---

## 🧪 Example Content IDs

You can represent content IDs using any `u64` hash or sequence number:

```rust
let content_id = 420; // e.g., ID for a meme video or short
