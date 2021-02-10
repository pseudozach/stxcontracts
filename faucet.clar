;; This is a Stacks faucet - Anyone can fund - Anyone can withdraw 1 stack only once.

;; maximum payout from the faucet is 1 Stack token
(define-constant maxPayout 1)

;; index to track users that withdrew
(define-data-var index int 0)

;; list of users that already withdrew from the faucet
(define-map users ((user principal)) ((index int))
)

;; fund the faucet
(define-public (fundFaucet (funder principal) (amount uint)) 
    (as-contract (stx-transfer? amount funder tx-sender)
    )
)

;; withdraw from faucet - check if this address already withdrew before
(define-public (getStacks (requester principal))
    (begin
        (if (is-none(get index(map-get? {user: requester}))) (sendStacks requester) (err "Already got stacks"))
    )
)

;; send stacks from faucet
(define-private (sendStacks (requester principal))
    (begin
        (as-contract (stx-transfer? maxPayout tx-sender requester))
        (map-set users {user: requester} {index: (var-get index)})
        (var-set index (+ (var-get index) 1) )
    )
)