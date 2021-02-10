;; initial numbers to start the game
(define-data-var thenumber int 8)

(define-public (guessNumber (inputNumber uint) (amount uint) (guess string-ascii))
    (begin
        (stx-transfer? amount tx-sender (as-contract tx-sender))
        (if ((is-eq "higher" guess) and (> thenumber (unwrap! (get-block-info? time inputNumber)))) (correctGuess tx-sender inputNumber) (ok "Wrong guess"))
        (if ((is-eq "lower" guess) and (< thenumber (unwrap! (get-block-info? time inputNumber)))) (correctGuess tx-sender inputNumber) (ok "Wrong guess"))
        (ok "Something else happened")
    )
)

;; user guessed right! send half the balance
(define-private (correctGuess (user principal) (blockheight uint))
    (begin
        (as-contract (stx-transfer? (/ (stx-get-balance (as-contract tx-sender)) 2) tx-sender user))
        (var-set thenumber (unwrap! (get-block-info? time blockheight))
    )
)

