;; Marketing Department Verification Contract
;; This contract validates marketing departments and stores their credentials

(define-data-var admin principal tx-sender)

;; Map to store verified marketing departments
(define-map verified-departments principal bool)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-ALREADY-VERIFIED u101)
(define-constant ERR-NOT-VERIFIED u102)

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Verify a marketing department
(define-public (verify-department (department principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-none (map-get? verified-departments department)) (err ERR-ALREADY-VERIFIED))
    (ok (map-set verified-departments department true))))

;; Revoke verification from a department
(define-public (revoke-verification (department principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-some (map-get? verified-departments department)) (err ERR-NOT-VERIFIED))
    (ok (map-delete verified-departments department))))

;; Check if a department is verified
(define-read-only (is-verified (department principal))
  (default-to false (map-get? verified-departments department)))

;; Transfer admin rights
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (ok (var-set admin new-admin))))
