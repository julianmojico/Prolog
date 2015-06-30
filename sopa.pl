%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Pueden probar las funciones principales con estos predicados	     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   MAIN PROGRAM                                       		     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cargarSopa	:-	write('Escribe el nombre de la Sopa de Letras (extemción pl): '), nl,
				read(Archivo),
				consult(Archivo),
				comienzo .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Cargar Sopa                                                              %%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sopa(Sopa) :- Sopa = [["h","f","g","h"],["o","b","c","d"],["l","j","k","l"],["a","n","o","p"]].
sopaChar(SopaChar):- SopaChar = [[h,f,g,h],[o,b,c,d],[l,j,k,l],[a,n,o,p]].
cargarAlfabeto :-consult('alfabeto.pl') .


comienzo 	:- 	write('Sopa cargada:'), nl,
				tab(20),
				sopaChar(SopaChar),
				print(SopaChar), nl,
				sopa(Sopa),
				matrizCuadrada(Sopa),
				tab(20), nl,
				write('Ingrese la palabra a buscar: '), nl,
				read(Palabra) ,
				horizontalesEste(Palabra, Sopa, M), nl,
				print(M),
				horizontalesOeste(Palabra, Sopa, M), nl,
				print(M),
				verticalesSur(Palabra, Sopa, M), nl,
				print(M),
				verticalesNorte(Palabra, Sopa, M), nl,
				print(M).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Funciones principales													 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%matrizCuadrada(+Lista)
matrizCuadrada([]).
matrizCuadrada([A|[]]).
matrizCuadrada([A,B|T]):-
length(A,LENGTH1),
length(B,LENGTH2),
LENGTH1==LENGTH2,
matrizCuadrada([B|T]).

%horizontalesEste(+lpalabra,+Sopa,subconjuto de sopa que contiene "palabra")
% Direccion Horizontal
% Sentido Oeste-->Este
horizontalesEste(_,[],_).
horizontalesEste(X,A,C) :-  encontrar(X,A,C), subconjunto(C,A).

%horizontalesOeste(+lpalabra,+Sopa,subconjuto de sopa que contiene "palabra")
% Direccion Horizontal
% Sentido Este-->Oeste
horizontalesOeste(_,[],_).
horizontalesOeste(X,A,C) :- invertir(X,Z), encontrar(Z,A,C), subconjunto(C,A).

%verticalesSur(+lpalabra,+Sopa,subconjuto de sopa que contiene "palabra")
% Direccion Vertical
% Sentido Norte-->Sur
verticalesSur(_,[],_).
verticalesSur(X,A,C) :- getVerticales(A,V), encontrar(X,V,C), subconjunto(C,V).

%verticalesNorte(+lpalabra,+Sopa,subconjuto de sopa que contiene "palabra")
% Direccion Vertical
% Sentido Sur-->Norte
verticalesNorte(_,[],_).
verticalesNorte(X,A,C) :- invertir(X,Z), getVerticales(A,V) , encontrar(Z,V,C), subconjunto(C,V).

%Busca en una fila en sentido --> si encuentra la palabra dada
%encontrar(+lpalabra,+Sopa,-listas que contienen la palabra)
encontrar(_,[],_).
encontrar(X,[A|AS],C):- sublista(X, A), contienelista(A,C), encontrar(X,AS,C).
encontrar(X,[_|AS],C):- encontrar(X,AS,C).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Funciones auxiliares													 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Invierte la lista que recibe en el primer nivel
invertir([X],[X]).
invertir([X|M],Z):-invertir(M,S), concatenar(S,[X],Z).

%Concatena dos listas
concatenar([],L,L).
concatenar([X|M],L,[X|Z]):-concatenar(M,L,Z).

% Determina si lo que recibe es una lista
lista([]):-!.
lista([_|Y]):-lista(Y).

%subconjunto(subconjunto, conjunto) ambas son listas de listas
subconjunto([],_).
subconjunto([A|AS] , B):- contienelista(A,B), subconjunto(AS,B).

% Determina si la primer lista es prefijo de la segunda
prefijo([],_):-!.
prefijo([X],[X|_]):-!.
prefijo([X|L],[X|M]):-prefijo(L,M).
prefijo([X|T],[L|M]):-lista(X),prefijo(X,L),prefijo(T,M).

% Verifica si la primer lista se encuentra en la segunda lista
%contienelista(lista, listadeLista)
contienelista([],_):-!.
contienelista(L,[L|_]).
contienelista(L,[_|M]):-contienelista(L,M).
    
%16-Determina si la primer lista es sublista de la segunda*/
sublista([],_):-!.
sublista(L,[X|M]):-prefijo(L,[X|M]).
sublista(L,[_|M]):-sublista(L,M).

% getVertical(+Sopa, -Columna, +Filas)
%   Obtiene una columna de la sopa de letras.
getVertical([], [], []).
getVertical([[S|Opitas]|Resto], [S|Columna], [Opitas|Filas]) :-  getVertical(Resto, Columna, Filas).

% getVerticales(+Sopa, -Verticales)
%   Obtiene la lista con todas las columnas de la sopa de letras.
getVerticales([[]|_], []).
getVerticales(Sopa, [Vertical|Resto]) :- getVertical(Sopa, Vertical, Opa),  getVerticales(Opa, Resto).
