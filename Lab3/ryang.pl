%...............................................................................
%Question 1:
xreverse([],[]). %this is the base case, the reverse of [] is []
xreverse([A|L1],L3):-xreverse(L1,N),append(N,[A],L3). %remove the first element of [A|L1] and append it to L2, then keep reversing L1 and L2
%...............................................................................


%...............................................................................
%Question 2:
xunique([],[]). %this is the base case, [] and [] are unique
xunique([A|L1],[A|L2]):- subtract(L1,[A],L3),xunique(L3,L2). %if two lists both have A as an element, remove all A's from L1, the result is L3, then keep checking if L2 is the reault of L3
%...............................................................................


%...............................................................................
%Question 3:
xunion(L1,L2,Res):-findall(X,myxunion(L1,L2,X),Out),want(1,Out,Res).
want(1,[H|_],H).
myxunion([],[],[]). %base case, the union of [] and [] is []
myxunion([A|L1],L2,[A|L3]):- subtract(L1,[A],L1_new),subtract(L2,[A],L2_new),myxunion(L1_new,L2_new,L3). %if [A|L1] has A. remove A's from all the list and append it to the result
myxunion(L1,[A|L2],[A|L3]):- subtract(L1,[A],L1_new),subtract(L2,[A],L2_new),myxunion(L1_new,L2_new,L3). %if [A|L2] has A. remove A's from all the list and append it to the result
%...............................................................................


%...............................................................................
%Question 4:
removeLast([A],[],A). %base case, for a list like [A], A is the last element, and the rest of it is []
removeLast([A|L],L1,Last):- removeLast(L,L2,Last),append([A],L2,L1). %if L is not [], then take the first element of the list and append it to L1, then keep figuring out the last element of the rest of the list
%...............................................................................


%...............................................................................
%Question 5:
%Testing DataBase:
node(a).
node(b).
node(c).
node(d).
node(e).

node(f).
node(g).
node(h).



edge(a,b).
edge(b,c).
edge(c,a).
edge(d,a).
edge(a,e).

edge(f,g).
edge(f,h).
edge(h,g).
%...............................................................................
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
%connect(A,[B|L]):-path(A,B),connect(A,L).

%path(A,B):-findall(X-Y,edge(X,Y),Edges1),findall(X-Y,edge(Y,X),Edges2),append(Edges1,Edges2,Edges),vertices_edges_to_ugraph([],Edges,L),reachable(A,L,PATHA),member(B,PATHA).
%...............................................................................
%5.2 maxclique
maxclique(N,Cliques):-oldmaxclique(N,Cliques1),xreverse(Cliques1,Cliques).
oldmaxclique(N,Cliques):-findall(X,mymaxclique(N,X),Cliques1),K is N+1,findall(X,mymaxclique(K,X),Cliques2),myremoveSubset(Cliques1,Cliques2,Cliques).

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
removeSubList([],_,Sub):-append([],Sub,[]).
removeSubList([A|L1],L2,Sub):-notMember(A,L2),removeSubList(L1,L2,MySub),append([A],MySub,Sub).
removeSubList([_|L1],L2,Sub):-removeSubList(L1,L2,Sub),Sub\==[].


%notSubsets returns true if any elements in A is not a subset of any elements in B
notMemberList([],_).
notMemberList([A|L],B):-notMember(A,B),notMemberList(L,B).

%notMember returns true if A is not a member of the input list
notMember(_,[]).
notMember(A,[B|R]):-notSameList(A,B),notMember(A,R).

%for the function of notSameList, it returns true if two lists are not the same
notSameList([],L):-L\==[].
notSameList(L,[]):-L\==[].
notSameList([X|_],[Y|_]):-X\==Y.
notSameList([X|L1],[X|L2]):-notSameList(L1,L2).

%subsetCreater(_,[],Out):-append([],Out,[]).
%subsetCreater(N,[A|In],Out):- subsetCreater(N,In,MyOut),xmysubset(N,A,MyOut2),append(MyOut2,MyOut,Out).

%xsubset returns all the subset of a list of all subsets
xsubset([],_).
xsubset([X|Xs],Set):- append(_,[X|Set1],Set),xsubset(Xs,Set1).

%xmysubset returns all the subset of a list of all subsets
xmysubset(In,Out):-findall(X,xsubset(X,In),Out).

oderedsubset(_,[],Out):-append([],[],Out).
oderedsubset(N,[A|L],Out):-length(A,N),oderedsubset(N,L,OldOut),append([A],OldOut,Out).
oderedsubset(N,[_|L],Out):-oderedsubset(N,L,Out).


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
