zombie(juan).
zombie(valeria).

tomo_mate_despues(juan,carlos).
tomo_mate_despues(clara,juan).

infectade(ernesto).
infectade(X) :- zombie(X).
infectade(X) :- zombie(Y), tomo_mate_despues(Y,X).
