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
En cuanto a la máquina de estados del multiplicador, esta es la que recibe la señal de validación en cuanto están listos los dos números que se van a multiplicar, para que el proceso de multiplicación de inicio. Su estructura se basa en 7 estados concretamente, se detalla a continuación la funcionalidad de cada uno de los estados:  
1. IDLE: Es simplemente un estado de espera, en el que va a permanecer la máquina de estados simpre que la señal de validación no esté activa o bien cuando la señal de reset se ponga en algo también se podrá pasar a este estado de espera. En el momento en el que la señal de validación (valid) se ponga en alto, el siguiente estado será designado como el estado INIT.  
2. INIT: Este estado es el inicio al proceso de multiplicación, acá solamente se cargan las variables que van a formar parte del proceso de multiplicación y se reinician a cero aquellas que correspondan.   
3. DECIDE: Este estado considera la entrada Qo_Qprev y en base al valor de esta variable (00, 01, 10 o 11), se definirá cuál debe de ser el siguiente estado. En caso de que la señal tenga un valor de 00 o 11, el siguiente estado será simplemente SHIFT, en el cual se efectuará el corrimiento aritmético, si la señal vale 01 el siguiente estado deberá de ser ADD y si vale 10 deberá de ser SUBSTRACT. 
4. SUBSTRACT: Este estado se pone en funcionamiento cuando al evaluar Qo_Qprev en DECIDE, esta señal resulta ser 10. Lo que procede es restar al conjunto de bits más significativos (HQ) el valor del multiplicando (M). Luego, el siguiente estado será SHIFT, siguiendo la lógica del algoritmo de Booth.  
5. ADD: Este estado se pone en funcionamiento cuando al evaluar Qo_Qprev en DECIDE, esta señal resulta ser 01. Lo que procede es sumar al conjunto de bits más significativos (HQ) el valor del multiplicando (M). Y a continuación e igual que en el estado SUBSTRACT, lo que sigue es pasar al estado SHIFT para hacer el corrimiento aritmético a la derecha. 
6. SHIFT: Se debe de pasar a este estado siempre, en cada una de las iteraciones y no es necesario evaluar el valor de la señal Qo_Qprev. Lo que se aplica es un corrimiento aritmético a la derecha; además, en este estado se debe de aumentar el valor en una unidad, del contador que lleva el registro de la cantidad de iteraciones que se han realizado, para detener el proceso cuando se complete la multiplicación; esto se hace dentro de la FSM también, pero en un bloque secuencial evaluando el valor de la señal shift_all la cual se activa únicamente en el estado SHIFT, en caso de que el contador llegue a su límite, se interpreta como que se ha finalizado el proceso de multiplicación y se pasa al estado CHECK, de lo contrario se vuelve nuevamente al estado DECIDE para continuar con el proceso de multiplicación.   
7. CHECK: Este estado se pone en funcionamiento solo cuando el contador ha llegado a su límite. Para evitar que se borre el resultado de la multiplicación o que cambie algún valor, se permanece en este estado hasta que no se active la señal de reset; una vez que se pone reset en alto, se vuelve al estado IDLE y se repite nuevamente el proceso descrito.  





### Subsistema de despliegue


## Diagramas de bloques e interconexiones  
### Diagramas del subsistema de lectura de datos y teclado   
### Diagramas del subsistema de multiplicación  
### Diagramas del subsistema de despliegue  

## Diagramas de estados de las máquinas de estado  
### Máquina de estados principal  
### Máquina de estados para control en el teclado  
### Máquina de estados del multiplicador  

## Análisis de una simulación completa del sistema  

## Análisis del consumo de recursos en la FPGA  

## Reporte de velocidades y tiempos  

## Reporte de problemas encontrados y soluciones aplicadas  



