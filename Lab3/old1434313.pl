%...............................................................................
%Question 1:
xreverse([],[]). %this is the base case, the reverse of [] is []
xreverse([A|L1],L3):-append(L2,[A],L3),xreverse(L1,L2). %remove the first element of [A|L1] and append it to L2, then keep reversing L1 and L2
%...............................................................................


%...............................................................................
%Question 2:
xunique([],[]). %this is the base case, [] and [] are unique
xunique([A|L1],[A|L2]):- subtract(L1,[A],L3),xunique(L3,L2). %if two lists both have A as an element, remove all A's from L1, the result is L3, then keep checking if L2 is the reault of L3
%...............................................................................


%...............................................................................
%Question 3:
xunion([],[],[]). %base case, the union of [] and [] is []
xunion([A|L1],L2,[A|L3]):- subtract(L1,[A],L1_new),subtract(L2,[A],L2_new),xunion(L1_new,L2_new,L3). %if [A|L1] has A. remove A's from all the list and append it to the result
xunion(L1,[A|L2],[A|L3]):- subtract(L1,[A],L1_new),subtract(L2,[A],L2_new),xunion(L1_new,L2_new,L3). %if [A|L2] has A. remove A's from all the list and append it to the result
%...............................................................................


%...............................................................................
%Question 4:
removeLast([A],[],A). %base case, for a list like [A], A is the last element, and the rest of it is []
removeLast([A|L],L1,Last):- removeLast(L,L2,Last),append([A],L2,L1). %if L is not [], then take the first element of the list and append it to L1, then keep figuring out the last element of the rest of the list
%...............................................................................


%...............................................................................
%Question 5:
%Buildin functions
clique(L) :- findall(X,node(X),Nodes),subset(L,Nodes), allConnected(L).

subset([], _).
subset([X|Xs], Set) :-append(_, [X|Set1], Set),subset(Xs, Set1).

append([], L, L).
append([H|T], L, [H|R]) :-append(T, L, R).

%...............................................................................
%5.1 allConnected
allConnected([]).
allConnected([A|L]):-connect(A,L),allConnected(L).

connect(_,[]).
connect(A,[B|L]):-(edge(A,B);edge(B,A)),connect(A,L).

%...............................................................................
%5.2 maxclique
maxclique(N,Cliques):-findall(X,mymaxclique(N,X),Cliques1),K is N+1,findall(X,mymaxclique(K,X),Cliques2),myremoveSubset(Cliques1,Cliques2,Cliques).

%,findall(X,mymaxclique(N+1,X),Cliques2),subsetfinder(Cliques1,Cliques2,Cliques)
mymaxclique(N,Cliques):-findall(X,node(X),NODES),mysubset(N,NODES,Cliques),clique(Cliques).


myremoveSubset(L1,L2,Res):-findall(X,removeSubset(L1,L2,X),Set),take(1,Set,Res).

take(1,[H|_],H).
%used to remove subsets
removeSubset([],_,[]).
removeSubset([A|L1],L2,Set):-issubset(A,L2),removeSubset(L1,L2,Set).
removeSubset([A|L1],L2,Set):-removeSubset(L1,L2,MySet),append([A],MySet,Set).

%used to test if A is a subset of any element of L
issubset(A,[B|_]):-subset(A,B).
issubset(A,[_|L]):-issubset(A,L).


%...............................................................................
xsubset([],_).
xsubset([X|Xs],Set):- append(_,[X|Set1],Set),xsubset(Xs,Set1).

%xmysubset returns all the subset of a list of all subsets
xmysubset(In,Out):-findall(X,xsubset(X,In),Out).

%mysubset returns all the subsets with a specific number of elements
mysubset(N, In, Out) :-
    mysplitSet(In,_,SL),
    permutation(SL,Out),
    length(Out,N).
mysplitSet([ ],[ ],[ ]).
mysplitSet([H|T],[H|L],R) :-
    mysplitSet(T,L,R).
mysplitSet([H|T],L,[H|R]) :-
    mysplitSet(T,L,R).
