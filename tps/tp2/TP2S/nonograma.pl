% Ejercicio 1

% Caso base
matriz(0, _, []).

% Caso recursivo
matriz(F, C, [Fila|Resto]) :-
    F > 0,
    length(Fila, C),		% ?- length([a,b,c], m) <=> m = 3. como en pl esto debe cumplirse para ambos lados, se van construyendo las listas así
    F1 is F-1,						
    matriz(F1, C, Resto).

% Ejercicio 2

% Caso base
replicar(_, 0, []).

% Caso recursivo
replicar(Elem, N, [Elem|Resto]) :-
    N > 0,
    N1 is N - 1,
    replicar(Elem, N1, Resto).

% Ejercicio 3

% Caso base
transponer([], []).

% Caso cuando las filas están vacías
transponer([[]|_], []) :- !.   				% si todas las filas están vacías, terminamos

% Caso recursivo
transponer(M, [Columna|Resto]) :-
    maplist(nth1(1), M, Columna),       	% toma el primer elemento de cada fila
    maplist(restoFila, M, MsinPrimero), 	% quita el primero de cada fila
    transponer(MsinPrimero, Resto).

restoFila([_|Resto], Resto).


% Predicado dado armarNono/3
armarNono(RF, RC, nono(M, RS)) :-
	length(RF, F),
	length(RC, C),
	matriz(F, C, M),
	transponer(M, Mt),
	zipR(RF, M, RSFilas),
	zipR(RC, Mt, RSColumnas),
	append(RSFilas, RSColumnas, RS).

zipR([], [], []).
zipR([R|RT], [L|LT], [r(R,L)|T]) :- zipR(RT, LT, T).

% Aux: coincide_con_celdas

coincide_con_celdas([], []).
coincide_con_celdas([X|Xs], [C|Cs]) :-
    ( var(C) -> true
    ; C = X
    ),
    coincide_con_celdas(Xs, Cs).

% Ejercicio 4

% Caso base -> hay una sola restricción [H], y la lista L debe tener al menos H celdas
pintadasValidas(r([H], L)) :-
    length(L, N),                       % longitud de L = lista de celdas
    N >= H,                             % debe haber al menos H celdas
    replicar(x, H, Pintadas),           % se crean las H celdas pintadas
    K is N - H,                      	% K = cantidad de celdas restantes (blancas)
    between(0, K, U),               	% U = cantidad de blancas antes
    replicar(o, U, Anterior),           % se crean las U celdas blancas antes
    V is K - U,                      	% V = cantidad de blancas después
    replicar(o, V, Posterior),          % se crean las V celdas blancas después
    append(Anterior, Pintadas, L1),     % L1 = Anterior ++ Pintadas
    append(L1, Posterior, Lista),       % Lista = L1 ++ Posterior = Anterior ++ Pintadas ++ Posterior
    coincide_con_celdas(Lista, L),      % se valida que Lista coincide con L
    L = Lista.                          % se unifaca L con Lista para evitar soluciones múltiples

% Caso recursivo -> restricción [H | T], y la lista L debe tener al menos H + 1 celdas
pintadasValidas(r([H | T], L)) :-
    length(L, N),                      	% longitud de L = lista de celdas
    N >= H + 1,                     	% debe haber al menos H + 1 celdas
    replicar(x, H, Pintadas),           % se crean las H celdas pintadas
    
    % se divide L en: Anterior ++ Pintadas ++ [o] ++ Resto
    append(Anterior, Resto1, L),        % L = Anterior ++ Resto1 = Anterior ++ Pintadas ++ [o] ++ Resto
    append(Pintadas, [o], Bloque),      % Bloque = Pintadas ++ [o]
    append(Bloque, Resto, Resto1),      % Resto1 = Bloque ++ Resto

    % validar parcial
    append(Anterior, Bloque, Parcial),  % Parcial = Anterior ++ Pintadas ++ [o]
    coincide_con_celdas(Parcial, L),    % se valida que Parcial coincide con L, 

    % se calcula la longitud disponible para el resto de restricciones
    length(Anterior, U),                % U = cantidad de celdas blancas antes
    Usados is U + H + 1,                % Usados = celdas usadas = U (blancas antes) + H (pintadas) + 1 (blanca entre bloques)
    NRest is N - Usados,                % NRest = celdas restantes para el resto de restricciones
    NRest >= 0,

    % eñ resto debe tener exactamente NRest celdas
    length(Resto, NRest),               % se fuerza que Resto tenga NRest celdas

    % se resuelve recursivamente el resto
    pintadasValidas(r(T, Resto)).

% Ejercicio 5
resolverNaive(_) :-  completar("Ejercicio 5").

% Ejercicio 6
pintarObligatorias(_) :- completar("Ejercicio 6").

% Predicado dado combinarCelda/3
combinarCelda(A, B, _) :- var(A), var(B).
combinarCelda(A, B, _) :- nonvar(A), var(B).
combinarCelda(A, B, _) :- var(A), nonvar(B).
combinarCelda(A, B, A) :- nonvar(A), nonvar(B), A = B.
combinarCelda(A, B, _) :- nonvar(A), nonvar(B), A \== B.

% Ejercicio 7
deducir1Pasada(_) :- completar("Ejercicio 7").

% Predicado dado
cantidadVariablesLibres(T, N) :- term_variables(T, LV), length(LV, N).

% Predicado dado
deducirVariasPasadas(NN) :-
	NN = nono(M,_),
	cantidadVariablesLibres(M, VI), % VI = cantidad de celdas sin instanciar en M en este punto
	deducir1Pasada(NN),
	cantidadVariablesLibres(M, VF), % VF = cantidad de celdas sin instanciar en M en este punto
	deducirVariasPasadasCont(NN, VI, VF).

% Predicado dado
deducirVariasPasadasCont(_, A, A). % Si VI = VF entonces no hubo más cambios y frenamos.
deducirVariasPasadasCont(NN, A, B) :- A =\= B, deducirVariasPasadas(NN).

% Ejercicio 8
restriccionConMenosLibres(_, _) :- completar("Ejercicio 8").

% Ejercicio 9
resolverDeduciendo(NN) :- completar("Ejercicio 9").

% Ejercicio 10
solucionUnica(NN) :- completar("Ejercicio 10").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              %
%    Ejemplos de nonogramas    %
%        NO MODIFICAR          %
%    pero se pueden agregar    %
%                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fáciles
nn(0, NN) :- armarNono([[1],[2]],[[],[2],[1]], NN).
nn(1, NN) :- armarNono([[4],[2,1],[2,1],[1,1],[1]],[[4],[3],[1],[2],[3]], NN).
nn(2, NN) :- armarNono([[4],[3,1],[1,1],[1],[1,1]],[[4],[2],[2],[1],[3,1]], NN).
nn(3, NN) :- armarNono([[2,1],[4],[3,1],[3],[3,3],[2,1],[2,1],[4],[4,4],[4,2]], [[1,2,1],[1,1,2,2],[2,3],[1,3,3],[1,1,1,1],[2,1,1],[1,1,2],[2,1,1,2],[1,1,1],[1]], NN).
nn(4, NN) :- armarNono([[1, 1], [5], [5], [3], [1]], [[2], [4], [4], [4], [2]], NN).
nn(5, NN) :- armarNono([[], [1, 1], [], [1, 1], [3]], [[1], [1, 1], [1], [1, 1], [1]], NN).
nn(6, NN) :- armarNono([[5], [1], [1], [1], [5]], [[1, 1], [2, 2], [1, 1, 1], [1, 1], [1, 1]], NN).
nn(7, NN) :- armarNono([[1, 1], [4], [1, 3, 1], [5, 1], [3, 2], [4, 2], [5, 1], [6, 1], [2, 3, 2], [2, 6]], [[2, 1], [1, 2, 3], [9], [7, 1], [4, 5], [5], [4], [2, 1], [1, 2, 2], [4]], NN).
nn(8, NN) :- armarNono([[5], [1, 1], [1, 1, 1], [5], [7], [8, 1], [1, 8], [1, 7], [2, 5], [7]], [[4], [2, 2, 2], [1, 4, 1], [1, 5, 1], [1, 8], [1, 7], [1, 7], [2, 6], [3], [3]], NN).
nn(9, NN) :- armarNono([[4], [1, 3], [2, 2], [1, 1, 1], [3]], [[3], [1, 1, 1], [2, 2], [3, 1], [4]], NN).
nn(10, NN) :- armarNono([[1], [1], [1], [1, 1], [1, 1]], [[1, 1], [1, 1], [1], [1], [ 1]], NN).
nn(11, NN) :- armarNono([[1, 1, 1, 1], [3, 3], [1, 1], [1, 1, 1, 1], [8], [6], [10], [6], [2, 4, 2], [1, 1]], [[2, 1, 2], [4, 1, 1], [2, 4], [6], [5], [5], [6], [2, 4], [4, 1, 1], [2, 1, 2]], NN).
nn(12, NN) :- armarNono([[9], [1, 1, 1, 1], [10], [2, 1, 1], [1, 1, 1, 1], [1, 10], [1, 1, 1], [1, 1, 1], [1, 1, 1, 1, 1], [1, 9], [1, 2, 1, 1, 2], [2, 1, 1, 1, 1], [2, 1, 3, 1], [3, 1], [10]], [[], [9], [2, 2], [3, 1, 2], [1, 2, 1, 2], [3, 11], [1, 1, 1, 2, 1], [1, 1, 1, 1, 1, 1], [3, 1, 3, 1, 1], [1, 1, 1, 1, 1, 1], [1, 1, 1, 3, 1, 1], [3, 1, 1, 1, 1], [1, 1, 2, 1], [11], []], NN).
nn(13, NN) :- armarNono([[2], [1,1], [1,1], [1,1], [1], [], [2], [1,1], [1,1], [1,1], [1]], [[1], [1,3], [3,1,1], [1,1,3], [3]], NN).
nn(14, NN) :- armarNono([[1,1], [1,1], [1,1], [2]], [[2], [1,1], [1,1], [1,1]], NN).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              %
%    Predicados auxiliares     %
%        NO MODIFICAR          %
%                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%! completar(+S)
%
% Indica que se debe completar el predicado. Siempre falla.
completar(S) :- write("COMPLETAR: "), write(S), nl, fail.

%! mostrarNono(+NN)
%
% Muestra una estructura nono(...) en pantalla
% Las celdas x (pintadas) se muestran como ██.
% Las o (no pintasdas) se muestran como ░░.
% Las no instanciadas se muestran como ¿?.
mostrarNono(nono(M,_)) :- mostrarMatriz(M).

%! mostrarMatriz(+M)
%
% Muestra una matriz. Solo funciona si las celdas
% son valores x, o, o no instanciados.
mostrarMatriz(M) :-
	M = [F|_], length(F, Cols),
	mostrarBorde('╔',Cols,'╗'),
	maplist(mostrarFila, M),
	mostrarBorde('╚',Cols,'╝').

mostrarBorde(I,N,F) :-
	write(I),
	stringRepeat('══', N, S),
	write(S),
	write(F),
	nl.

stringRepeat(_, 0, '').
stringRepeat(Str, N, R) :- N > 0, Nm1 is N - 1, stringRepeat(Str, Nm1, Rm1), string_concat(Str, Rm1, R).

%! mostrarFila(+M)
%
% Muestra una lista (fila o columna). Solo funciona si las celdas
% son valores x, o, o no instanciados.
mostrarFila(Fila) :-
	write('║'),
	maplist(mostrarCelda, Fila),
	write('║'),
	nl.

mostrarCelda(C) :- nonvar(C), C = x, write('██').
mostrarCelda(C) :- nonvar(C), C = o, write('░░').
mostrarCelda(C) :- var(C), write('¿?').
