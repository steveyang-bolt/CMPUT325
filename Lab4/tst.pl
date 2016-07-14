:- use_module(library(clpfd)).

%% Q1

%tc1
tc1(Var) :- fourSquares(20, Var).
%Var = [0, 0, 2, 4] ;
%Var = [1, 1, 3, 3] ;
%false.

%tc2
tc2(Var) :- fourSquares(-20, Var).
%false.

%tc3
tc3(Var) :- fourSquares(0, Var).
%Var = [0, 0, 0, 0].

p1T(N,V) :- statistics(runtime,[T0|_]),
	fourSquares(N,V),
	statistics(runtime, [T1|_]),
	T is T1 - T0,
	format('fourSqaures/2 takes ~3d sec.~n', [T]).
%% Q2

%tc4
p1(S) :- disarm([1,3,3,4,6,10,12],[3,4,7,9,16],S).
%S = [[[1, 3], [4]], [[3, 6], [9]], [[10], [3, 7]], [[4, 12], [16]]].

p2 :- disarm([],[],[]).
%true.

p3(S) :- disarm([1,2,3,3,8,5,5],[3,6,4,4,10],S).
%S = [[[1, 2], [3]], [[3, 3], [6]], [[8], [4, 4]], [[5, 5], [10]]].


p4(S) :- disarm([1,2,2,3,3,8,5],[3,2,6,4,4,10],S).
%false.

p5(S) :- disarm([1,2,2,3,3,8,5,5,6,7],[3,2,6,4,4,10,1,5,2],S).
%false.

p6(S) :- disarm([1,2,2,116,3,3,5,2,5,8,5,6,6,8,32,2],[3,5,11,4,37,1,4,121,3,3,14],S).
%S = [[[1, 2], [3]], [[2, 2], [4]], [[2, 3], [5]], [[5], [4, 1]], [[6], [3, 3]], [[3, 8], [11]], [[6|...], [...]], [[...|...]|...], [...|...]].


p2T(S) :- statistics(runtime,[T0|_]),
	p6(S),
	statistics(runtime, [T1|_]),
	T is T1 - T0,
	format('p6/1 takes ~3d sec.~n', [T]).
%p6/1 takes 10.532 sec.
%S = [[[1, 2], [3]], [[2, 2], [4]], [[2, 3], [5]], [[5], [4, 1]], [[6], [3, 3]], [[3, 8], [11]], [[6|...], [...]], [[...|...]|...], [...|...]].

%...............................................................................
%Question 1:
fourSquares(N, Vars):-
  Vars = [S1, S2, S3, S4],
  N#=S1*S1+S2*S2+S3*S3+S4*S4,
  S1#>=0, S2#>=0,S3#>=0,S4#>=0,
  S1#=<S2,S2#=<S3,S3#=<S4,
  label([S1,S2,S3,S4]).
%...............................................................................


%...............................................................................
%Question 2:
disarm(A,B,S):-mydisarm2(A,B,S1),compute_sum(S1,Sum),sort(Sum,SortedSum),matchIndex(S1,Sum,SortedSum,S).

mydisarm2(A,B,S):-mydisarm(A,B,S).

%mydisarm2(A,B,S):-findall(X,mydisarm(A,B,X),K),nth0(0,K,S).

mydisarm([],[],[]).
mydisarm(A,B,S):-
  sum_list(A,SumA),sum_list(B,SumB),SumA#=SumB,
  mysubset(A,Set1,ALeft),
  sum_list(Set1,Set1Sum),
  Set1Sum#=TempB,
  S1 = [Set1, [TempB]],
  select(TempB,B,NewB),
  mydisarm(ALeft,NewB,S2),
  append([S1],S2,S),!.
mydisarm(A,B,S):-
  sum_list(A,SumA),sum_list(B,SumB),SumA#=SumB,
  mysubset(B,Set1,BLeft),
  sum_list(Set1,Set1Sum),
  Set1Sum#=TempA,
  S1 = [[TempA], Set1],
  select(TempA,A,NewA),
  mydisarm(NewA,BLeft,S2),
  append([S1],S2,S),!.

%this function is used to sort a list using a corresponding sorted list
%ex matchIndex([1,2,3],[1,2,3],[3,2,1],L) ==> L = [3, 2, 1]
matchIndex(_,_,[],[]).
matchIndex(In,Ori,[S|Sor],Out):-indexOf(Ori,S,Index),matchIndex(In,Ori,Sor,Out1),nth0(Index,In,InA),append([InA],Out1,Out).

%this function gives a list of sum
%ex compute_sum([[[1, 3], [4]], [[3, 4], [7]], [[6, 10], [16]], [[12], [3, 9]]],L) ==> L = [4, 7, 16, 12]
compute_sum([],[]).
compute_sum([L|A],SumList):-sum2(L,S),compute_sum(A,SumList2),append([S],SumList2,SumList).
sum2([L|_],S):-sum_list(L,S).

%this function gets list of elements specified by a list of indexes
%ex getByIndex([1,2,3,4,5],[0,2,3],R) ==> R = [1, 3, 4]
getByIndex(_,[],[]).
getByIndex(A,[I|IList],R):-nth0(I,A,IA),getByIndex(A,IList,R1),append([IA],R1,R).


%this function compares two lists of numbers
%ex sumCompare([1,2,3],[1,2,3],[4,1,2],A,B) ==> A = [0, 1],B = [1, 2]
sumCompare([],_,_,[],[]).
sumCompare([A1|A],L,B,IndexA,IndexB):-member(A1,B),indexOf(L,A1,IA),indexOf(B,A1,IB),sumCompare(A,L,B,IndexA1,IndexB1),append([IA],IndexA1,IndexA),append([IB],IndexB1,IndexB).
sumCompare([A1|A],L,B,IndexA,IndexB):-not(member(A1,B)),sumCompare(A,L,B,IndexA,IndexB).


%this function gives the index of an element in a list
%ex indexof([2,3,4,1],1,A) ==> A = 3
indexOf([Element|_], Element, 0):- !.
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1),
  !,
  Index is Index1+1.


%mysubset generates all the subsets with 2 elements
mysubset(S,[A,B],L):-A#=<B,member(A,S),member(B,S),select(A,S,L1),select(B,L1,L).

%my sumcalculate the sum of a list of lists
%ex mysum([[1, 2], [1, 3], [2, 3]],L) ==>  L = [3, 4, 5]
mysum([],[]).
mysum([A|B],L):-sum_list(A,SumA),mysum(B,L2),append([SumA],L2,L).
