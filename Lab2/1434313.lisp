;...............................................................................
;fl-interp is a function that interperates lisp functions
;if, null, atom, eq, first, rest, cons, equal, number, +, -, *, >, <, =, and, or, not are implemented in the function
;...............................................................................
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
          ;more concrete explanations can be found in the following functions
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
  (cond ((null argument) 0) ;when the argument is null, return 0
        (t (+ 1 (arg_length (cdr argument)))) ;increment the count everytime when we take the first element out
  )
)
;...............................................................................

;...............................................................................
;This function is used to find the number of arguments in a function definition in P
(defun num_arg (argument)
    (cond ((eq (cadr argument) '=) 0) ;when reach =, return 0
              (t (+ 1 (num_arg (cdr argument)))) ;otherwise, increment the count by 1 when we take one element out
    )
)
;...............................................................................

;...............................................................................
;This function is used to find the corresponding function in the program
(defun find_func (f arg P)
  (cond ((null P) nil) ;if P is null, return nil
        ((and (eq f (first (first P))) (eq (arg_length arg) (num_arg (first P)))) (first P)) ;if length of the argument is the same as the number of argument in the matching function definition, then it's the right function definition we want
        (t (find_func f arg (cdr P))) ;else, go check the rest of the function definitions
  )
)
;...............................................................................

;...............................................................................
;This function replaces the variables with specific values
;X stores the variable names, V stores the corresponding values, B is the program body
(defun replace_var (X V B)
  (cond ((null B) nil) ;the base case, when B is null, return nil
        ((atom (first B)) (if (eq (first B) X) (cons V (replace_var X V (cdr B)));if B is an atom, the replace it by a value
                              (cons (car B) (replace_var X V (cdr B)))
                          )
        )
        (T (cons (replace_var X V (car B)) (replace_var X V (cdr B)))) ;else, look into B and replace the corresponding variables
  )
)

;here X is a list of variable names, V is a list of variable values, B is the program body
(defun replace_var_list (X V B)
  (cond ((null X) B)
        (T (replace_var (car X) (car V) (replace_var_list (cdr X) (cdr V) B)));this line is used to replace a list of variable names by variable values
  )
)
;...............................................................................

;...............................................................................
;find_B is used to find the body of a function
;the return of this function is the body of a function
(defun find_B (P)
  (cond ((eq (first P) '=) (cdr P))
        (T (find_B (cdr P)))
  )
)

;find_A is used to find the arguments in a function definition
;the return of the function is a list of the the arguments
(defun find_A (P)
  (cond ((eq (cadr P) '=) nil)
        (t (cons (cadr P) (find_A (cdr P))))
  )
)
;...............................................................................

;...............................................................................
;this function is used to interperate a nested argument
(defun arg_interp (arg P)
  (cond ((null arg) nil) ;if the arg is null, return nil
        (T (cons (fl-interp (car arg) P)  (arg_interp (cdr arg) P))) ;else, keep interperating the nested arguments
  )
)
;...............................................................................
