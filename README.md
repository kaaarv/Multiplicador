# Multiplicador con signo
TEC, Escuela de Ingeniería Electrónica  
Tercer proyecto, Diseño Lógico 


Pablo Elizondo Espinoza | 2023396053  
Eduardo Tencio Solano | 2021079387  
Karina Quiros Avila | 2021044233  

## Descripción general de funcionamiento  
Este proyecto consiste en el diseño de un multiplicador con signo que despliega los valores numéricos ingresados y el resultado final del proceso de multiplicación en displays de 7 segmentos. Consta de tres subsistemas principales que se interconectan entre si para cumplir con el objetivo final que es entregar un valor numérico como resultado de la multiplicación de dos valores decimales de hasta dos dígitos; a continuación, se detalla por separado el funcionamiento general de cada uno de los subsistemas.  
### Subsistema de lectura de datos y teclado  
### Subsistema de multiplicación  
El subsistema de multiplicación se compone de dos módulos principalmente. Por un lado está el módulo que contiene toda la lógica de multiplicación regida por el algortimo de Booth, y también está la máquina de estados finitos que controla la lógica de multiplicación y lleva el registro de todo el proceso hasta que este se complete en su totalidad.  
Primero se tiene al módulo con la lógica del algoritmo de Booth, este recibe las señales de control provenientes de la máquina de estados y los dos valores numéricos que se requieren multiplicar (en caso de un número negativo, este se procesa como un número binario en complemento a dos). Además, este módulo tiene como salidas un valor binario de dos bits que le permite a la máquina de estados verificar el comportamiento que está teniendo el proceso, así como el resultado final de la multiplicación.  
![image](https://github.com/user-attachments/assets/6aaceda1-f84e-4ea2-8071-882604772610)  
El proceso de multiplicación se puede entender con mayor facilidad con ayuda del diagrama de bloques correspondiente a este subsistema.  
En cuanto a la máquina de estados del multiplicador, esta es la que recibe la señal de validación en cuanto están listos los dos números que se van a multiplicar, para que el proceso de multiplicación de inicio. Su estructura se basa en 7 estados concretamente.  
![image](https://github.com/user-attachments/assets/e713484b-d117-444e-9ba9-056bbec59137)  
Se detalla a continuación la funcionalidad de cada uno de los estados:  
1. IDLE: Es simplemente un estado de espera, en el que va a permanecer la máquina de estados simpre que la señal de validación no esté activa o bien cuando la señal de reset se ponga en algo también se podrá pasar a este estado de espera. En el momento en el que la señal de validación (valid) se ponga en alto, el siguiente estado será designado como el estado INIT.  
2. INIT: Este estado es el inicio al proceso de multiplicación, acá solamente se cargan las variables que van a formar parte del proceso de multiplicación y se reinician a cero aquellas que correspondan.   
3. DECIDE: Este estado considera la entrada Qo_Qprev y en base al valor de esta variable (00, 01, 10 o 11), se definirá cuál debe de ser el siguiente estado. En caso de que la señal tenga un valor de 00 o 11, el siguiente estado será simplemente SHIFT, en el cual se efectuará el corrimiento aritmético, si la señal vale 01 el siguiente estado deberá de ser ADD y si vale 10 deberá de ser SUBSTRACT. 
4. SUBSTRACT: Este estado se pone en funcionamiento cuando al evaluar Qo_Qprev en DECIDE, esta señal resulta ser 10. Lo que procede es restar al conjunto de bits más significativos (HQ) el valor del multiplicando (M). Luego, el siguiente estado será SHIFT, siguiendo la lógica del algoritmo de Booth.  
5. ADD: Este estado se pone en funcionamiento cuando al evaluar Qo_Qprev en DECIDE, esta señal resulta ser 01. Lo que procede es sumar al conjunto de bits más significativos (HQ) el valor del multiplicando (M). Y a continuación e igual que en el estado SUBSTRACT, lo que sigue es pasar al estado SHIFT para hacer el corrimiento aritmético a la derecha. 
6. SHIFT: Se debe de pasar a este estado siempre, en cada una de las iteraciones y no es necesario evaluar el valor de la señal Qo_Qprev. Lo que se aplica es un corrimiento aritmético a la derecha; además, en este estado se debe de aumentar el valor en una unidad, del contador que lleva el registro de la cantidad de iteraciones que se han realizado, para detener el proceso cuando se complete la multiplicación; esto se hace dentro de la FSM también, pero en un bloque secuencial evaluando el valor de la señal shift_all la cual se activa únicamente en el estado SHIFT, en caso de que el contador llegue a su límite, se interpreta como que se ha finalizado el proceso de multiplicación y se pasa al estado CHECK, de lo contrario se vuelve nuevamente al estado DECIDE para continuar con el proceso de multiplicación.   
7. CHECK: Este estado se pone en funcionamiento solo cuando el contador ha llegado a su límite. Para evitar que se borre el resultado de la multiplicación o que cambie algún valor, se permanece en este estado hasta que no se active la señal de reset; una vez que se pone reset en alto, se vuelve al estado IDLE y se repite nuevamente el proceso descrito.  
### Subsistema de despliegue  
Este es el subsistema que procesa el resultado de la multiplicación y lo despliega en los displays de 7 segmentos. Como se comentó en uno de los puntos anteriores, los números negativos se manejan como números binarios en complemento a dos dentro del subsistema de multiplicación, por lo que al subsistema de despliegue le corresponde detectar la llegada o no de un número negativo y procesarlo. Este subsistema se compone de cuatro módulos principales, los cuales se detallan a continuación:  
1. Módulo sign_magnitude: Recibe directamente el resultado de la multiplicación y evalúa el bit más significativo, en caso de ser un 1 se detecta que el valor de la multiplicación corresponde a un número negativo y se procede a separar la magnitud y el signo del número; por el contrario, si el bit más significativo es un 0 entonces se asume que el número es positivo y se deja pasar como una sola magnitud en su totalidad. 
2. Módulo binary_BCD: Este módulo es el primer paso de la preparación del resultado de la multiplicación, para ser mostrado en los displays de 7 segmentos. Se separa el valor numérico en un código que contiene cada dígito (unidades, decenas, centenas y miles) separados en un solo código binario (código BCD). Lo cual permite poder seleccionar cuál de los cuatro digitos se desea obtener, solo indicando las coordenadas dentro del código binario de 16 bits.  
3. Módulo clk_display: Este módulo sirve para dividir el reloj de la FPGA que es de 27 MHz, en una frecuencia más pequeña de 10 kHz, para de esta manera poder mostrar más adecuadamente los números en los 4 displays; sin embargo, la frecuencia resultante a la cual se actualizan los displays será de 60 Hz aproximadamente, esta reducción final se lleva a cabo propiamente en el módulo del display.
4. Módulo display_submodule: Acá está el proceso final para poder mostrar el valor numérico en los displays de 7 segmentos, el módulo recibe como entradas el código BCD generado anteriormente y una señal de control que indica cuando dicho código BCD está listo para utilizarse (además de la señal de reloj y reset). Este módulo tiene un iterador interno mediante un flip-flop que va controlando cuál de los cuatro displays es el que está activo, de manera que se actualiza cada 167 ciclos de reloj (el reloj de 10 kHz dividido previamente), dando como resultado un tiempo de actividad de 16,67 ms para cada display o lo que es lo mismo, una frecuencia de actualización de 60 Hz.  
![image](https://github.com/user-attachments/assets/eea475be-4916-49c0-952b-9b3d3767de88)  
La imagen anterior, muestra la estructura que se encarga de refrescar los displays cada 16,67 ms. De igual manera, se muestra la sección de la lógica encargada de producir el código BCD para los displays.
![image](https://github.com/user-attachments/assets/43584d6d-119b-46dd-b8e6-d47afb2cc511)  
## Diagramas de bloques e interconexiones  
### Diagramas del subsistema de lectura de datos y teclado   
### Diagramas del subsistema de multiplicación  
Para el sistema de multiplicación se cuenta con el módulo que contiene la lógica del algortimo de Boot y su FSM que lo controla, tal como se mencionó en uno de los apartados anteriores. Se cuenta con un total de 4 señales de control directas desde la FSM hasta el multiplicador, en cuanto al proceso de suma o resta, este se rige por el estado actual en el que se encuentre la FSM y por el valor de Qo_Qprev.  
![Multiplicador](https://github.com/user-attachments/assets/58961c2b-4316-40ad-805b-b39f7417a06b)  
El multiplicador continúa su proceso de iteración, sumando, restando y haciendo shift aritmético según corresponda, con la ruta de datos descrita en la imagen. 


### Diagramas del subsistema de despliegue  
Para este caso, se puede dividir en tres diagramas de bloques y uno principal que muestre las conexiones entre los tres. Por un lado se tiene al diagrama del módulo que separa el signo y la magnitud del resultado de la multiplicación.  
![Diagrama signo_magnitud](https://github.com/user-attachments/assets/0c5cc9db-b6cf-49b9-9a1b-d84282ec23be)  

Luego, se tiene al módulo que convierte la magnitud de la multiplicación en un código BCD para poder ser mostrado.  

![Diagrama BCD](https://github.com/user-attachments/assets/ed9646db-a5b4-4219-be8a-79ea726d519b)  

Finalmente, está el módulo del display el cual obtiene cada uno de los digitos del resultado, del código BCD y los va desplegando en los displays de 7 segmentos.  
![Diagrama display](https://github.com/user-attachments/assets/89b08950-c4d4-4269-830f-1546802ff175)  
Todo lo anterior, se puede resumir en un digrama que interconecta todos los módulos para llegar a formar el subsistema de despliegue, cabe aclarar que acá se está integrando el proceso de binario a BCD dentro del subsistema de despliegue en lugar de separarlo como otro subsistema aparte.  
![Diagrama subsistema](https://github.com/user-attachments/assets/4c92236e-42bc-4fa0-afd0-16eb2ecd8bf4)





## Diagramas de estados de las máquinas de estado  
### Máquina de estados principal  
### Máquina de estados para control en el teclado  
### Máquina de estados del multiplicador  
El multiplicador cuenta con su propia máquina de estados que controla las operaciones que se van ejecutando conforme avanza el proceso. Tal como se mencionó anteriormente, se cuenta con 7 estados y 5 señales de control, según se detallan a continuación.  
![FSM_multiplicador](https://github.com/user-attachments/assets/0337ea92-20e2-4215-9126-b0c28856164e)  
En el caso del estado DECIDE, este no asgina ningún valor a alguna señal de control, pues solo es un estado de paso para decidir si se aplica una suma, una resta o si directamente se hace un shift aritmético a la derecha.  


## Análisis de una simulación completa del sistema  

## Análisis del consumo de recursos en la FPGA  

## Reporte de velocidades y tiempos  

## Reporte de problemas encontrados y soluciones aplicadas  



