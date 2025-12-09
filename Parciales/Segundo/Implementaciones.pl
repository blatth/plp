% Ej 1

unico(L, U) :- 
    select(U, L, Resto),        % Saco a U de L, devuelvo Resto, que es la lista L sin U
    not(member(U, Resto)).      % Me fijo si en Resto aparece nuevamente U

% Ej 2

sinRepetidos([]).               % La lista vacía no tiene repetidos
sinRepetidos([H|T]) :-
    not(member(H, T)),          % Veo que H (head) no pertenezca a T (tail)
    sinRepetidos(T).            % Llamo a la función con Tail para la recursión 

% Posible solución que veo más rebuscada
% sinRepetidos(L)  :- not(noEstaSolo(_, L)).
% noEstaSolo(X, L) :- member(X, L),
%                    not(unico(L, X)).

% Ej 3

formulasConNSubformulas(1, VS, F)           :- member(F, VS).   % Caso base
formulasConNSubformulas(N, VS, neg(F))      :- N > 1,                                   % Ej: Si N = 2
                                               N1 is N - 1,                             % Ej: => N1 = 1
                                               formulasConNSubformulas(N1, VS, F).      % Ej: formulasConNSubformulas(1, VS, F). Previamente se corrió formulasConNSubformulas(N, VS, neg(F)), por lo que el F resultante de la primera unifica y genera neg(F) 
formulasConNSubformulas(N, VS, imp(FP, FQ)) :- N > 2,                                   % Ej: Si N = 4
                                               N1 is N - 1,                             % => N1 = 3
                                               between(1, N1, NIzq),                    % between(1, 3, NIzq). En NIzq guardo las combinaciones 1 = NIzq, 2 = NIzq, 3 = NIzq.
                                               NDer is N1 - NIzq,                       % Genero las combinaciones para NDer: NDer = 3 - 1, NDer = 3 - 2, NDer = 3 - 3.
                                               formulasConNSubformulas(NIzq, VS, FP),   % Llamo a las fórmulas P con la cantidad de NIzq (paso recursivo)
                                               formulasConNSubformulas(NDer, VS, FQ).   % Llamo a las fórmulas Q con la cantidad de NDer (paso recursivo)

formula(VS, F) :- between(0, inf, N),                   % Primero prueba N=1, luego N=2...
                  formulasConNSubformulas(N, VS, F).    % Genera fórmulas de ese tamaño exacto


% Ej 1

esRotacion(L, R) :-
    length(L, Len),         % Chequeo que las longitudes de ambas listas sean iguales
    length(R, Len),         % Chequeo que las longitudes de ambas listas sean iguales
    append(L_1, L_2, L),    % Divido a L en 2 partes: L_1 y L_2. Acá digo que L es la lista resultante de hacer append de L_1 y L_2
    append(L_2, L_1, R).    % Chequeo que R sea la lista resultante de hacer appende de L_2 y L_1 (o sea, la lista L inversa)

% Ej 2

collatz(1, [1]).                % Caso base, cuando se llega a 1 termina.
collatz(N, [N|Resto]) :-        % Caso N par
    N > 1,
    N mod 2 =:= 0,              % Veo que sea par
    Sig is N // 2,              % Sig = n/2
    collatz(Sig, Resto).        % Paso recursivo
collatz(N, [N|Resto]) :-        % Caso N impar
    N > 1,
    N mod 2 =\= 0,              % Veo que sea impar
    Sig is 3*N+1,               % Sig = 3*N+1
    collatz(Sig, Resto).        % Paso recursivo

% Ej 3

collatzMayor(N, Max) :-
    collatz(N, L),              % Hago collatz con N, devuelvo la lista L
    maximo_lista(L, Max).       % Busco el máximo en la lista L

maximo_lista([X], X).           % Si la lista tiene un solo elem, ese es el máximo
maximo_lista([H|T], Max) :-
    maximo_lista(T, MaxResto),  % Calculo el máximo del tail, lo guardo como MaxResto
    Max is max(H, MaxResto).    % Ahora a Max le doy el valor del máximo entre el head y el máximo del tail (MaxResto)


% Ej 1

% Primero tengo que definir cómo se comportarán los pasos de acuerdo a los movimientos, defino:

paso((X, Y), (X, Y1)) :- Y1 is Y + 1.  % Arriba
paso((X, Y), (X, Y1)) :- Y1 is Y - 1.  % Abajo
paso((X, Y), (X1, Y)) :- X1 is X + 1.  % Derecha
paso((X, Y), (X1, Y)) :- X1 is X - 1.  % Izquierda

% Tengo que controlar la cant. de pasos porque sino puede seguir infinitamente para un lado y nunca encontrar caminos

caminoDeNPasos(P, [P], 0).              % El camino tiene 0 pasos, entonces la pos. inicial = camino
caminoDeNPasos(P, [P|T], Pasos) :-
    Pasos > 0,
    PasosT is Pasos - 1,                % El LargoT (largo tail) es el largo restante, como recorro solo H, es -1.
    paso(P, Sig),                       % Sigo al próximo paso
    caminoDeNPasos(Sig, T, PasosT).     % Llamo a la función con el nuevo paso, el tail de la lista y la cantidad de pasos restantes

% Ahora que tengo una forma de controlar los casos donde Pasos = 0 y Pasos > 0, además de que cambio la operación de movimientos de 'paso', puedo llamar a la original

caminoDesde(P, C) :-
    between(0, inf, Pasos),             % Genero pasos (núms naturales) de 0 a inf
    caminoDeNPasos(P, C, Pasos).        % Llamo a la auxiliar para que corra infinitamente

% Ej 1

subsecuenciaCreciente(L, S) :-
    subsecuencia(L, S),
    esCreciente(S).

% Lista1 = L1 = [H|T1], Lista2 = L2 = [H|T2] 

subsecuencia([], []).
subsecuencia([H|T1], [H|T2]) :-
    subsecuencia(T1, T2).
subsecuencia([_|T1], L2) :-
    subsecuencia(T1, L2).

esCreciente([]).
esCreciente([_]).
esCreciente([A,B|T]) :-
    A < B,
    esCreciente([B|T]).

% Ej 2

subsecuenciaMasLarga(L, S) :-
    subsecuenciaCreciente(L, S),       % candidato S1
    length(S, N1), 
    not((
        subsecuenciaCreciente(L, S2),   % candidato S2
        length(S2, N2),
        N2 > N1
    )).

% Ej 3

fibonacci(X) :-
    fibonacci_aux(0, 1, X).

fibonacci_aux(_, Act, Act).
fibonacci_aux(Ant, Act, X) :-
    Siguiente is Ant + Act,
    fibonacci_aux(Act, Siguiente, X).

generarCapicuas(L) :-
    between(1, inf, N),         % genero N = 1 -> inf
    listaQueSuma(N, L),         % llamo al generador de listas que suman N
    reverse(L, L).              % verifico que sea capicua

listaQueSuma(0, []).            % si la lista suma 0 => es la vacía
listaQueSuma(N, [H|T]) :-       
    N > 0,                      % me aseguro que N > 0
    between(1, N, H),           % genero N = 1 -> inf y los pongo en la pos de H
    Resto is N - H,             % calculo Nresto
    listaQueSuma(Resto, T).     % llamo al tail con nresto