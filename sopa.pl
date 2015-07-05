%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Explicacion de programa                                      		     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%El programa principal se inicia ejecuntando  main().
%Al ejecutar el programa principal se asigna la sopa invocando al predicado sopa(SOPA), la cual esta fija en este documento, y se muestra por pantalla.
%Luego se solicita el ingreso por consola de la palabra a buscar y una vez ingresada se procede a buscarla por la matriz.

%Para la busqueda se decidio separar la busqueda en 4 direcciones/sentidos (norte, sur, este, oeste).
%Los resultados de cada una de estas busquedas tienen esl siguiente formato [ [Coordena eje X | coordenada eje Y, direccion/sentido] |XSS]
%Es una lista de listas, para simplificar puede verse como una lista de ternas (X,Y,Direccion).
%El resultado que se muestra por pantalla es la concatenacion de busca la palabra en los 4 sentidos, ya que la misma palabra puede figurar en mas de una direccion/sentido.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   MAIN PROGRAM                                       		     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% rutina principal:
%%% Genera la sopa y verifica que esta sea una matriz cuadrada.
%%% Imprime por pantalla la sopa y solicita el ingreso por pantalla de la cadena a buscar.
%%% Busca la cadena dentro de la sopa en las direcciones/sentidos solicitados y devuelve una lista con los Resultados o una lista vacia en caso de no encontrar la palabra.
main 	:- 	write('Sopa cargada:'), nl,
				tab(20),
				sopaChar(SopaChar),
				print(SopaChar), nl,
				sopa(Sopa),
				matrizCuadrada(Sopa),
				tab(20), nl, write_ln(''),
				imprimirMatriz(Sopa),
				write('Ingrese la palabra a buscar: '), nl,
				read(Palabra),
				string_to_list_of_characters(Palabra, Palabraenlista),
				encontrarEnSopa(Palabraenlista,Resultados),
				print(Resultados).

sopa(Sopa) :- Sopa = [["h","f","g","h"],["o","b","c","d"],["l","j","k","l"],["a","n","o","p"]].
sopaChar(SopaChar):- SopaChar = [[h,f,g,h],
				 [o,b,c,d],
				 [l,j,k,l],
				 [a,n,o,p]].



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Funciones principales													 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% funcion que grafica la matriz por pantalla
%%% imprimirMatriz(+Lista) 
imprimirMatriz([]):-
write_ln('').
imprimirMatriz([X|XS]):-
imprimirFila(X),
imprimirMatriz(XS).

%%% funcion auxiliar que grafica una fila por pantalla
%%%	imprimirFila(+Lista) 
imprimirFila([]):-
write_ln('').
imprimirFila([X|XS]):-
print(X),tab(1),
imprimirFila(XS).

%%% funcion que verifica que la matriz sopa sea cuadrada, es decir sea NxN
%%% matrizCuadrada(+Lista)
matrizCuadrada([]).
matrizCuadrada([_|[]]).
matrizCuadrada([A,B|T]):-
length(A,LENGTH1),
length(B,LENGTH2),
LENGTH1==LENGTH2,
matrizCuadrada([B|T]).


%%% La busque de la palabra se divide en 4 funciones cada una de el busca en una direccion/sentido:
%%% horizontalesEste busca la palabra en direccion horizontal, sentido este
%%% horizontalesOeste busca la palabra en direccion horizontal, sentido oeste
%%% verticalesSur busca la palabra en direccion vertical, sentido sur
%%% verticalesNorte busca la palabra en direccion vertical, sentido norte
%%%	Estas 4 funciones reciben la sopa y la palabra a buscar y el resultado de la busqueda esta en el tercer parametro, 
%%% el resultado es una lista de listas que podria verse como una lista de ternas donde cada terna tiene la siguiente estructura
%%% (Coordenada eje X, coordenada eje Y, Direccion/Sentido en el que se busco) 
%%% El resultado de la busque da esta dado por la concatenacion de los resultados de las 4 funciones.
%%% encontrarEnSopa(Palabra, Lista con resultados )
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


%%% recorre la lista de resultados y recomputa las coordenadas:
%%% procesarSalidaNorte(Largo de matriz, largo de palabra a buscar, resultado de buscar en sentido norte, resultado recorregido)
%%% las coordenadas deben corregirse ya que para buscar en sentido norte se invirtio la matriz sopa y la palabra a buscar.
%%% NuevoY = ViejoX + (largoPalabra -1) 
%%% NuevoX = largoMatriz - ViejoY
procesarSalidaNorte(_,_,[],[]).
procesarSalidaNorte(LargoMatriz,LargoPalabra,C1,C2):- 
    append([[X,Y,Z]],D1,C1),   
    restar(LargoMatriz,Y,NuevoX),
    restar(LargoPalabra,1,LargoP),
    sumar(X,LargoP,NuevoY),
    append([[NuevoX,NuevoY,Z]],D2,C2),    
    procesarSalidaNorte(LargoMatriz,LargoPalabra,D1,D2).


%%% recorre la lista de resultados y recomputa las coordenadas:
%%% procesarSalidaSur(Largo de matriz, largo de palabra a buscar, resultado de buscar en sentido sur, resultado recorregido)
%%% las coordenadas deben corregirse ya que para buscar en sentido sur se invirtio la matriz sopa
%%% NuevoY = ViejoX 
%%% NuevoX = largoMatriz - ViejoY
procesarSalidaSur(_,[],[]).
procesarSalidaSur(LargoMatriz,C1,C2):- 
    append([[X,Y,Z]],D1,C1),
    restar(LargoMatriz,Y,Resta1),  
    append([[Resta1,X,Z]],D2,C2),    
    procesarSalidaSur(LargoMatriz,D1,D2).

%%% recorre la lista de resultados y recomputa las coordenadas:
%%% procesarSalidaEste(Largo de matriz, largo de palabra a buscar, resultado de buscar en sentido este, resultado recorregido)
%%% las coordenadas deben corregirse
%%% NuevoY = LargoPalabra - ViejoY
%%% NuevoX = ViejoX
procesarSalidaEste(_,[],[]).
procesarSalidaEste(Largo,C1,C2):- 
    append([[X,Y,Z]],D1,C1),
    restar(Largo,Y,Resta),
    append([[X,Resta,Z]],D2,C2),    
    procesarSalidaEste(Largo,D1,D2).


%%% recorre la lista de resultados y recomputa las coordenadas:
%%% procesarSalidaOeste(Largo de matriz, largo de palabra a buscar, resultado de buscar en sentido oeste, resultado recorregido)
%%% las coordenadas deben corregirse ya que para buscar en sentido oeste se invirtio la palabra a buscar
%%% NuevoY = LargoMatriz - ViejoY
%%% NuevoX = (LargoPalabra -1) + ViejoX
procesarSalidaOeste(_,_,[],[]).
procesarSalidaOeste(LargoMatriz,LargoPalabra,C1,C2):- 
    append([[X,Y,Z]],D1,C1),
    restar(LargoMatriz,Y,Resta), 
    restar(LargoPalabra,1,LargoP),
    sumar(X,LargoP,PosX),
    append([[PosX,Resta,Z]],D2,C2),    
    procesarSalidaOeste(LargoMatriz,LargoPalabra,D1,D2).


%%% Econtrar es un metodo generico que intera una matriz (vease como una lista de filas) donde recorre fila por fila de izquierda a derecha.
%%% Busca dentro de la fila la aparicion de la palabra solicitada y en caso de encontrarla lo agrega a la lista de resultados con el formato 
%%% previamente mencionado (CoordenadX, CoordendaY, sentido)
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
%%   Predicados auxiliares													 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

string_to_list_of_characters(String, Characters) :-
    name(String, Xs),
    maplist( number_to_character,
       Xs, Characters ).

number_to_character(Number, Character) :-
    name(Character, [Number]).


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
