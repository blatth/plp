
%iesimo(+I,+L,-X)
iesimo(0,[X|_],X).
iesimo(I,[_|L],X):- I > 0, J is I-1, iesimo(J,L,X).

%iesimoRev(?I,+L,-X)
iesimoRev(0,[X|_],X).
iesimoRev(I,[_|XS],X) :- iesimoRev(J,XS,X), I is J+1.


%desde(+X,-Y)
desde(X,X).
desde(X,Y) :- N is X+1, desde(N,Y).

%desdeRev(+X,?Y)
desdeRev(X,Y) :- nonvar(Y), Y >= X.
desdeRev(X,Y) :- var(Y), desde(X,Y).

%pmq(+X,-Y)
pmq(X,Y) :- between(0,X,Y), mod(Y,2) =:= 0.


%coprimos(-X,-Y)
coprimos(X,Y) :- armarPares(X,Y), gcd(X,Y) =:= 1.


armarPares(X,Y) :- desde(0,S), between(0,S,X), Y is S-X.

% unCorte(+L,-L1,-L2,-D)
unCorte(L,L1,L2,D) :- append(L1,L2,L), sumlist(L1,S1), sumlist(L2,S2), D is abs(S1-S2).

corteMasParejo(L, L1, L2) :- unCorte(L,L1,L2,D), not((unCorte(L,_,_,D2), D2 < D)).

% primo(+N)
primo(N) :- N > 1, N1 is N-1, not((between(2,N1,V), N mod V =:= 0)).

% Instacia en P el siguiente numero primo mayor a N
proximoPrimo(N,P) :- N1 is N+1,siguientePrimo(N1,P).

% Instacia en P el siguiente numero primo N (podria ser N)
siguientePrimo(P,P) :- primo(P).
siguientePrimo(N,P) :- not(primo(N)), N1 is N+1, siguientePrimo(N1,P).

p(a,b).
p(c,d).
p(a,c).
p(a,b).

esTriangulo(tri(A,B,C)) :- 
	A > 0, B > 0, C > 0,
	A < B+C, B < A+C, C < A+B.


perimetro(tri(A,B,C),P) :- 
	ground(tri(A,B,C)), 
	esTriangulo(tri(A,B,C)),
	P is A+B+C.

perimetro(tri(A,B,C), P) :-
	not(ground(tri(A,B,C))),
	desdeRev(3,P),
	armarTriplas(P,A,B,C),
	esTriangulo(tri(A,B,C)).


% armarTriplas(+P,-A,-B,-C)
armarTriplas(P,A,B,C) :- 
	between(1,P,A),
	LB is P - A, between(1,LB,B),
	C is P -A -B.

triangulos(T) :- perimetro(T,_).





