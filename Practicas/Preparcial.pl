% Ej 1

unico(L, U) :-      append(Prefijo, [U | Sufijo], L),
                    append(Prefijo, Sufijo, Resto),
                    not(member(U, Resto)).

% Ej 2

sinRepetidos(L) :-  not(noEstaSolo(_, L)).

noEstaSolo(X, L) :- member(X, L),
                    not(unico(L, X)).

% Ej 3

% esto es un generador de números naturales
desde(X, X).
desde(X, Y) :-  N is X + 1,
                desde(N, Y).

formulasConNSubformulas(1, VS, F)           :- member(F, VS).                           % caso base
formulasConNSubformulas(N, VS, neg(F))      :- N > 1,
                                               N1 is N - 1,
                                               formulasConNSubformulas(N1, VS, F).
formulasConNSubformulas(N, VS, imp(FP, FQ)) :- N > 2,
                                               N1 is N - 1,
                                               between (1, N1, NP),
                                               NQ is N1 - NP,
                                               formulasConNSubformulas(NP, VS, FP),
                                               formulasConNSubformulas(NQ, VS, FQ).

formula(VS, F) :- desde(1, N),                        % Primero prueba N=1, luego N=2...
                  formulasConNSubformulas(N, VS, F).  % Genera fórmulas de ese tamaño exacto
