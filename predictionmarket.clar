;; markets db
(define-map marketDatabase
    {marketId int}
    {question (string-ascii 99)}
    {balance int 0}
    {totalVotes int 0}
    {resolver principal}
)

;; yesvoters db
(define-map yesvoters (voter principal) (marketId int) (amount uid))

;; novoters db
(define-map novoters (voter principal) (marketId int) (amount uid))

;; track marketIds
(define-data-var numberOfMarkets int 0) 

;; increment marketId
(define-private (incrementMarketIds)  
    (begin
    (var-set numberOfMarkets (+ (var-get numberOfMarkets) 1))
    (ok (var-get numberOfMarkets)))) 

;; create a new prediction market
(define-public (createMarket (question (string-ascii 99)) (participant principal)  )
    (begin    
    (map-set marketDatabase ( (marketId (+ (var-get numberOfMarkets) 1)) (question question) (totalVotes (int 0)) (balance (int 0)) (resolver (participant principal)) ) 
        (incrementMarketIds)
        (ok "Prediction market created")
    )   
    (err "Failed to create market")
))    

;; users join a side yes vs no
(define-public (join (marketId int) (side bool) (amount uint)) 
    (if  (is-eq side true)
        ;; joining yesvoters for this marketId
        (begin 
            ;; add to yesvoters
            (map-set yesvoters (voter tx-sender) (marketId marketId) (amount uint))
        )
        (begin 
            ;; add to novoters
            (map-set novoters (voter tx-sender) (marketId marketId) (amount uint))
        ) 
    )
    (addBalance participant amount)
    ;; update market balance
    (map-update marketDatabase {id marketId} merge {balance (getBalance (marketId))})
    (ok "Joined market")
)

;; add stx to the contract
(define-private (addBalance (participant principal) (amount uint)) 
 (as-contract 
    (stx-transfer? amount participant tx-sender))
)

;; get balance of marketId
(define-private (getBalance (marketId int)) 
    (get balance (map-get? marketDatabase {marketId marketId}))
)

;; resolve and payout
;; resolve market
(define-public (resolveMarket (marketId int) (result bool))
    (begin    
        if(is-eq (get resolver (map-get? marketDatabase {marketId: marketId}) tx-sender) (payWinners) (ok "Not authorized to resolve this market"))
        (votescount (to-uint 0))
        (incrementMarketIds)
        (ok "Prediction market resolved")
    )   
    (err "Failed to create market")
)

(define-private payWinners
    ;; need to find a way to loop thru correct guessors and pay them
)
