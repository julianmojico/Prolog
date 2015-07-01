%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Pueden probar las funciones principales con estos predicados	     %%
%% 	encontrarEnSopa([r,j,z],A).
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
sopaChar(SopaChar):- SopaChar = [[h,f,g,h],
				 [o,b,c,d],
				 [l,j,k,l],
				 [a,n,o,p]].
cargarAlfabeto :-consult('alfabeto.pl') .


comienzo 	:- 	write('Sopa cargada:'), nl,
				tab(20),
				sopaChar(SopaChar),
				print(SopaChar), nl,
				sopa(Sopa),
				matrizCuadrada(Sopa),
				tab(20), nl, write_ln(''),
				imprimirMatriz(Sopa),
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

%imprimirMatriz(+Lista)
imprimirMatriz([]):-
write_ln('').
imprimirMatriz([X|XS]):-
imprimirFila(X),
imprimirMatriz(XS).

%imprimirFila(+Lista)
imprimirFila([]):-
write_ln('').
imprimirFila([X|XS]):-
print(X),tab(1),
imprimirFila(XS).

%matrizCuadrada(+Lista)
matrizCuadrada([]).
matrizCuadrada([_|[]]).
matrizCuadrada([A,B|T]):-
length(A,LENGTH1),
length(B,LENGTH2),
LENGTH1==LENGTH2,
matrizCuadrada([B|T]).

encontrarEnSopa(Palabra,Resultados):- 
    sopaChar(Sopa),
    length(Palabra,LargoPalabra),
    horizontalesEste(Palabra,Sopa, RHE),
    procesarSalidaEste(4,RHE,RHEMOD), %5 = NRO matriz cuadrada
    horizontalesOeste(Palabra,Sopa, RHO),
    procesarSalidaOeste(4,LargoPalabra,RHO,RHOMOD), %5 = NRO matriz cuadrada
    verticalesSur(Palabra,Sopa, RVS),
    procesarSalidaSur(4,RVS,RVSMOD),
    verticalesNorte(Palabra,Sopa, RVN),
    procesarSalidaNorte(4,LargoPalabra,RVN,RVNMOD),
    append([],RHEMOD,R1),
    append(R1,RHOMOD,R2),
    append(R2,RVSMOD,R3),
    append(R3,RVNMOD,Resultados).

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

procesarSalidaNorte(_,_,[],[]).
procesarSalidaNorte(LargoMatriz,LargoPalabra,C1,C2):- 
    append([[X,Y,Z]],D1,C1),   
    restar(LargoMatriz,Y,NuevoX),
    restar(LargoPalabra,1,LargoP),
    sumar(X,LargoP,NuevoY),
    append([[NuevoX,NuevoY,Z]],D2,C2),    
    procesarSalidaNorte(LargoMatriz,LargoPalabra,D1,D2).


%Invierte X por Y
%El nuevo X es Largo matriz - Xanterior
procesarSalidaSur(_,[],[]).
procesarSalidaSur(LargoMatriz,C1,C2):- 
    append([[X,Y,Z]],D1,C1),
    restar(LargoMatriz,Y,Resta1),  
    append([[Resta1,X,Z]],D2,C2),    
    procesarSalidaSur(LargoMatriz,D1,D2).

procesarSalidaEste(_,[],[]).
procesarSalidaEste(Largo,C1,C2):- 
    append([[X,Y,Z]],D1,C1),
    restar(Largo,Y,Resta),%Recalcula pos Y
    append([[X,Resta,Z]],D2,C2),    
    procesarSalidaEste(Largo,D1,D2).

procesarSalidaOeste(_,_,[],[]).
procesarSalidaOeste(LargoMatriz,LargoPalabra,C1,C2):- 
    append([[X,Y,Z]],D1,C1),
    restar(LargoMatriz,Y,Resta),%Recalcula pos Y    
    %LargoPalabra is LargoP +1,
    restar(LargoPalabra,1,LargoP),
    sumar(X,LargoP,PosX),
    append([[PosX,Resta,Z]],D2,C2),    
    procesarSalidaOeste(LargoMatriz,LargoPalabra,D1,D2).


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

sumar(A, B, C):- C is A + B.
restar(A, B, C):- C is A - B.

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
sublistaIndex(L,[X|M],0):-prefijo(L,[X|M]).
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
