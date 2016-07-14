;Question 1
;this function checks if X is a member of Y
(defun xmember (X Y)
  (cond ((null Y) nil) ;when Y is null, returns nil
        ((equal X (car Y)) T) ;when X equals the first member of Y, return T
        (t (xmember X (rest Y))) ;else, check if X is in the rest of Y
  )
)


;Question 2
;this function returns a list that only contains atoms
(defun flatten (x)
  (cond ((null x) nil) ;if X is (), return ()
        ((atom (first x)) (cons (first x) (flatten (rest x)))) ;if the X is an atom, return a list whose first element is that atom and keep flatten the rest of the list
        (t (append (flatten (first x)) (flatten (rest x)))) ;if the first element is not an atom, keep flatten th efirst element and the rest of the list, and make the whole thing a list
  )
)


;Question 3
;this function mixes the elements of L1 and L2 into a single list, by choosing elements from L1 and L2 alternatingly
(defun mix (L1 L2)
  (cond ((null L1) (append L1 L2))
        ((null L2) (append L1 L2)) ;if either of the lists is empty, then return other one; if both are empty, return nil
        (t (append (cons (first L1) (cons (first L2) nil)) (mix (rest L1) (rest L2)))) ;otherwise, choose the first element in L1 and L2 as the first two element and mix them with the rest of the list which is mixed
  )
)


;Question 4
;this function splits the elements of L into a list of two sublists (L1 L2), by putting elements from L into L1 and L2 alternatingly
(defun split (L)
  (cond ((null L)  '(nil nil));if the original list is empty, return ( () () )
        ((null (rest L)) (list (list (first L)) '())) ;if the original list only contains one atom, the return ( (first element of L) ())
        (t (list (list* (first L) (first (split (rest (rest L)))))  (list* (second L) (second (split (rest (rest L))))))) ;else, take the first two elements of the list and make them into two seperate lists and keep spliting the rest of the list
  )
)

;Question 5
;#5.1
;False
;Counter Example, when given two lists with different lengths, L1 (a b c) L2(d e f g h)
;(mix L1 L2) gives (a d b e c f g h)
;(split (mix L1 L2)) will return (a b c g) and (d e f h), the two lists returned by split have the same length
;therefor, the first statement is False

;#5.2
;True
;There are two conditions
;Condition 1: L contains even number of elements
;then (split L) returns two lists which have the same number of elements, therefore mix of the returned lists will give the original list
;Condition 2: L contains odd number of elements
;In this case, (split L) returns two list while the first list has one more element than the second list
;mix of the two list will still return the original list
;therefore, the second statement is true



;Question 6
;given a list of numbers L and a sum S, this function will find a subset of the numbers in L that sums up to S
(defun subsetsum-accumulate (L x A) ;L is list, x is the sum, A is the accumulation list
  (cond ((< x 0) nil) ;if x is less than 0, return nil
        ((= x 0) A) ;is x is 0, return the accumulation list
        ((xmember x L) (cons x A))  ;if x is a member in L, then just construct a list of x and A
        ((null L) nil) ;is L is null, return nil
        ((> (car L) x) (subsetsum-accumulate (cdr L) x A)) ;if the first element of the list is larger than the sum, which is impossible, delate it from the list
        (t (let ((Y (subsetsum-accumulate (cdr L) (- x (car L)) (cons (car L) A)))) ;try to include the first element in the accumulation list
            (if (not (null Y)) ;if Y is not null
            Y ;then Y is what we want
            (subsetsum-accumulate (cdr L) x A) ;otherwise, do the function again without including the first element in the accumulation list
            )
          )
        )
  )
)

;this function reverse the order in a list
(defun myreverse (L)
      (if (null L)
          L
          (append (myreverse (cdr L))
                  (cons (car L) nil))
      )
)

;this function returns the list with the original order
(defun original-order (L1 L2)
  (cond ((null L2) nil)
        ((xmember (first L1) L2) (cons (first L1) (original-order (rest L1) (delete (first L1) L2 :count 1))))
        (t (original-order (rest L1) L2))
  )
)


;this function just simply pass a empty list to subsetsum-accumulate function and reverse the order of the final result
(defun subsetsum (L x)
   (original-order L (myreverse (subsetsum-accumulate (sort (copy-list L) '>) x nil)))
)
