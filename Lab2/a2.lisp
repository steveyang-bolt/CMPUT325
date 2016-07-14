(defun fl-interp (E P)
  (cond
      ((atom E) E) ;this includes the case where expr is nil
      (t (let* ((f (car E)) (arg (cdr E)) (df (find_func f arg P))) ;when the expression is not nil
          ;.....................................................................
          ;this part handles the primitive functions
          (cond ((eq f 'if)   (if (fl-interp (car arg) P) (fl-interp (cadr arg) P) (fl-interp (caddr arg) P)));implementing if
                ((eq f 'null)  (null (fl-interp (car arg) P)));implementing null
                ((eq f 'atom)  (atom (fl-interp (car arg) P)));implementing atom
                ((eq f 'eq)    (eq (fl-interp (car arg) P) (fl-interp (cadr arg) P)));implementing eq
                ((eq f 'first)  (car (fl-interp (car arg) P)));implementing first
                ((eq f 'rest)   (cdr (fl-interp (car arg) P)));implementing rest
                ((eq f 'cons)  (cons (fl-interp (car arg) P) (fl-interp (cadr arg) P)));implementing cons
                ((eq f 'equal) (equal (fl-interp (car arg) P) (fl-interp (cadr arg) P)));implementing equal
                ((eq f 'number) (numberp (fl-interp (car arg) P)));implementing number
                ((eq f '+)      (+ (fl-interp (car arg) P) (fl-interp (cadr arg) P)));implementing +
                ((eq f '-)      (- (fl-interp (car arg) P) (fl-interp (cadr arg) P)));implementing -
                ((eq f '*)      (* (fl-interp (car arg) P) (fl-interp (cadr arg) P)));implementing *
                ((eq f '>)      (> (fl-interp (car arg) P) (fl-interp (cadr arg) P)));implementing >
                ((eq f '<)      (< (fl-interp (car arg) P) (fl-interp (cadr arg) P)));implementing <
                ((eq f '=)      (= (fl-interp (car arg) P) (fl-interp (cadr arg) P)));implementing =
                ((eq f 'and)    (and (fl-interp (car arg) P) (fl-interp (cadr arg) P)));implementing and
                ((eq f 'or)     (or  (fl-interp (car arg) P) (fl-interp (cadr arg) P)));implementing or
                ((eq f 'not)    (not (fl-interp (car arg) P)));implementing not
          ;.....................................................................
          ;this part handles functions that are included in the function list P
          ;this should have nested functions for checking all the functions in P
                ((not (null df)) (fl-interp (replace_var_list (find_A df) (arg_interp arg P) (first (find_B df)))  P))

          ;...............................................................................
                (t E);otherwise, the function returns E
          );cond
        );let
      );t
  );cond
);first (

;...............................................................................
;This function returns the length of a list
(defun arg_length (argument)
  (cond ((null argument) 0)
        (t (+ 1 (arg_length (cdr argument))))
  )
)
;...............................................................................

;...............................................................................
;This function is used to find the number of arguments in a function in P
(defun num_arg (argument)
    (cond ((eq (cadr argument) '=) 0)
              (t (+ 1 (num_arg (cdr argument))))
    )
)
;...............................................................................

;...............................................................................
(defun find_func (f arg P)
  (cond ((null P) nil)
        ((and (eq f (first (first P))) (eq (arg_length arg) (num_arg (first P)))) (first P))
        (t (find_func f arg (cdr P)))
  )
)
;...............................................................................

;...............................................................................
;This function replaces the variables with specific values
(defun replace_var (X V B)
  (cond ((null B) nil)
        ((atom (first B)) (if (eq (first B) X) (cons V (replace_var X V (cdr B)))
                          (cons (car B) (replace_var X V (cdr B)))
                          )
        )
        (T (cons (replace_var X V (car B)) (replace_var X V (cdr B))))
  )
)

(defun replace_var_list (X V B)
  (cond ((null X) B)
        (T (replace_var (car X) (car V) (replace_var_list (cdr X) (cdr V) B)))
  )
)
;...............................................................................

;...............................................................................
;find_B is used to find the body of a function
(defun find_B (P)
  (cond ((eq (first P) '=) (cdr P))
        (T (find_B (cdr P)))
  )
)

;find_A is used to find the arguments in a function definition
(defun find_A (P)
  (cond ((eq (cadr P) '=) nil)
        (t (cons (cadr P) (find_A (cdr P))))
  )
)
;...............................................................................

;...............................................................................
(defun arg_interp (arg P)
  (cond ((null arg) nil)
        (T (cons (fl-interp (car arg) P)  (arg_interp (cdr arg) P)))
  )
)
