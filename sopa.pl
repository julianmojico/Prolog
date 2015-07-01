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

encontrarEnSopa(Palabra,Resultados):- 
    sopaChar(Sopa),
    horizontalesEste(Palabra,Sopa, RHE),
    horizontalesOeste(Palabra,Sopa, RHO),
    verticalesSur(Palabra,Sopa, RVS),
    verticalesNorte(Palabra,Sopa, RVN),
    append([],RHE,R1),
    append(R1,RHO,R2),
    append(R2,RVS,R3),
    append(R3,RVN,Resultados).

%horizontalesEste(+lpalabra,+Sopa,subconjuto de sopa que contiene "palabra")
% Direccion Horizontal
% Sentido Oeste-->Este
horizontalesEste(Palabra,Sopa,Resultado) :-  
    encontrar(Palabra,Sopa,Resultado,_,este).

%horizontalesOeste(+lpalabra,+Sopa,subconjuto de sopa que contiene "palabra")
% Direccion Horizontal
% Sentido Este-->Oeste
horizontalesOeste(Palabra,Sopa,Resultado) :- 
    invertir(Palabra,PalabraMod), 
    encontrar(PalabraMod,Sopa,Resultado,_,oeste).

%verticalesSur(+lpalabra,+Sopa,subconjuto de sopa que contiene "palabra")
% Direccion Vertical
% Sentido Norte-->Sur
verticalesSur(Palabra,Sopa,Resultado) :- 
    getVerticales(Sopa,SopaInversa),
    encontrar(Palabra,SopaInversa,Resultado,_,sur).

%verticalesNorte(+lpalabra,+Sopa,subconjuto de sopa que contiene "palabra")
% Direccion Vertical
% Sentido Sur-->Norte
verticalesNorte(Palabra,Sopa,Resultado) :- 
    invertir(Palabra,PalabraInversa),
    getVerticales(Sopa,SopaInversa),
    encontrar(PalabraInversa,SopaInversa,Resultado,_,norte).


%encontrar(Palabra,Sopa,Resultado,IndiceY,Direccion)
encontrar(_,[],[],0, _).
encontrar(X,[A|AS],C,IndiceY,Dir):- 
    sublistaIndex(X, A,IndiceX),
    append([[IndiceX,IndiceY,Dir]],D,C),
    encontrar(X,AS,D,Index,Dir), 
    IndiceY is Index+1.
encontrar(X,[_|AS],C,IndiceY,Dir):- 
    append([],D,C),
    encontrar(X,AS,D,Index,Dir),
    IndiceY is Index+1.


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

%16-Determina si la primer lista es sublista de la segunda*/
sublistaIndex([],_,_):-!.
sublistaIndex(L,[X|M],1):-prefijo(L,[X|M]).
sublistaIndex(L,[_|M],IndiceX):-sublistaIndex(L,M,Index),IndiceX is Index+1.

% getVertical(+Sopa, -Columna, +Filas)
%   Obtiene una columna de la sopa de letras.
getVertical([], [], []).
getVertical([[S|Opitas]|Resto], [S|Columna], [Opitas|Filas]) :-  getVertical(Resto, Columna, Filas).

% getVerticales(+Sopa, -Verticales)
%   Obtiene la lista con todas las columnas de la sopa de letras.
getVerticales([[]|_], []).
getVerticales(Sopa, [Vertical|Resto]) :- 
    getVertical(Sopa, Vertical, Opa), 
    getVerticales(Opa, Resto).
