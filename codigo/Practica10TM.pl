iesimo(0, [X|_], X).
iesimo(I, [_|XS], R) :- I > 0, J is I - 1, iesimo(J, XS, R).

iesimo2(I, L, X) :- 
    length(L, N), between(0, N, I), iesimo(I, L, X).

iesimo3(0, [X|_], X).
iesimo3(I, [_|XS], R) :- iesimo3(J, XS, R), J is I - 1.
    % no anda porque la segunda solución siempre explota
    % no es reversible


% iesimo3(0, [a,b,c], X)
%   iesimo3(J, [b,c], X)  
%         -> J=0,X=b
%         -> iesimo(J2, [c], X), J2 is J - 1.

iesimo4(0, [X|_], X).
iesimo4(I, [_|XS], R) :- iesimo4(J, XS, R), I is J + 1.

% iesimo4(1, [a,b,c], R)
%     -> 1era no regla no unifica
%     -> iesimo4(J1, [b,c], R), 1 is J1 + 1. { I1=1, XS1=[b,c], R1=R }
%        -> 1 is 0 + 1.  { J1 = 0, X2 = b, X2=R }
%            -> ok . R = b;
%        -> iesimo4(J2, [c], R2), I2 is J2 + 1, 1 is J1 + 1. { I1 = J1,  XS2 = [c], R2=R}
%            ->  ... falla el 1 is 1 + 1        ^^^^^^^^^^^ {R2=c, J2=0}


desde(X, X).
desde(X, Y) :- var(Y), N is X+1, desde(N, Y).
desde(X, Y) :- nonvar(Y), X < Y. % ojo repite si =<

%! par(+X)
par(X) :- 0 =:= X mod 2.

%! pmq(+X, -Y)
pmq(X, Y) :- between(0, X, Y), par(Y).

% pmq(X, Y) :- parQueEnumera(Y), Y =< X. Se colgaría

%! pares(-X, -Y) 
% enumera los pares de enteros positivos
pares(X, Y) :- 
    desde(1, N), 
    between(1, N, X), 
    Y is N - X, Y > 0.

%! sonCoprimos(+X, +Y)
sonCoprimos(X, Y) :- 1 =:= gcd(X, Y).

%! coprimos(-X, -Y)
coprimos(X, Y) :- 
    pares(X, Y), sonCoprimos(X, Y).
    
% coprimos(X, Y) :- desde(1, X), between(1, X, Y), 1 =:= gcd(X, Y).

%! unCorte(+L, -L1, -L2, -D)
unCorte(L, L1, L2, D) :- 
    append(L1, L2, L), 
    sumlist(L1, SL1),
    sumlist(L2, SL2),
    D is abs(SL1 - SL2).

%! hayUnCorteMejorQue(+L, +D)
hayUnCorteMejorQue(L, D) :- unCorte(L, _, _, D2), D2 < D.

%! esElMasParejo(+L, +D)
esElMasParejo(L, D) :- not(hayUnCorteMejorQue(L, D)).

%! corteMasParejo(+L,-L1,-L2)
corteMasParejo(L,L1,L2) :-
    unCorte(L, L1, L2, D), esElMasParejo(L, D).


%! esElMasParejo2(+L, +D)
esElMasParejo2(L, D) :- not( (unCorte(L, _, _, D2), D2 < D) ).

corteMasParejo3(L,L1,L2) :-
    unCorte(L, L1, L2, D), 
    not( (unCorte(L, _, _, D2), D2 < D) ).


%! esPrimo(+N)
esPrimo(N) :- 
    M is N - 1, 
    not((between(2, M, K), mod(N, K) =:= 0)).

% No anda
% esPrimo2(N) :- 
%     M is N - 1,
%     between(2, M, K),
%     mod(N, K) =\= 0.

%! proximoPrimo(+N, -P).
proximoPrimo(N, P) :- NM1 is N+1, desde(NM1, P), esPrimo(P), !.

proximoPrimo2(N, P) :- P is N+1, esPrimo(P).
proximoPrimo2(N, P) :- 
    M is N+1, not(esPrimo(M)), proximoPrimo2(M, P).

%! esTriangulo(+T)
esTriangulo(tri(A,B,C)) :- 
    esLadoValido(A, B, C),
    esLadoValido(B, A, C),
    esLadoValido(C, A, B).

% esLadoValido(X, Y, Z) :- Max is Y + Z, Min is abs(Y-Z), 
%     Min < X, X < Max.

esLadoValido(X, Y, Z) :- Max is Y + Z - 1, Min is abs(Y-Z) + 1, 
    between(Min, Max, X).

%! perimetro(?T, ?P)
perimetro(tri(A,B,C), P) :- ground(tri(A,B,C)),
    esTriangulo(tri(A,B,C)), P is A + B + C.
perimetro(tri(A,B,C), P) :- not(ground(tri(A,B,C))),
    desde(3, P),
    between(1,P,A),
    PmA is P - A,
    between(1, PmA, B),
    C is PmA - B,
    esTriangulo(tri(A,B,C)).


triangulo(T) :- perimetro(T, _).