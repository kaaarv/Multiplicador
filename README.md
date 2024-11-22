# Multiplicador con signo
TEC, Escuela de Ingeniería Electrónica  
Tercer proyecto, Diseño Lógico 


Pablo Elizondo Espinoza | 2023396053  
Eduardo Tencio Solano | 2021079387  
Karina Quiros Avila | 2021044233  

## Descripción general de funcionamiento  
Este proyecto consiste en el diseño de un multiplicador con signo que despliega los valores numéricos ingresados y el resultado final del proceso de multiplicación en displays de 7 segmentos. Consta de tres subsistemas principales que se interconectan entre si para cumplir con el objetivo final que es entregar un valor numérico como resultado de la multiplicación de dos valores decimales de hasta dos dígitos; a continuación, se detalla por separado el funcionamiento general de cada uno de los subsistemas.  
### Subsistema de lectura de datos y teclado  
El siguiente diagrama muestra un sistema para el procesamiento de señales provenientes de un teclado. Los datos del teclado pasan primero por un divisor, que los ajusta a la frecuencia deseada. Posteriormente, un contador se encarga de contar y organizar la secuencia de datos, los cuales son convertidos de 2 a 4 bits. La señal pasa luego por un proceso de desbouncificación, que elimina posibles ruidos o señales erróneas causadas por las teclas al ser presionadas. Estos datos son luego enviados a un bloque de codificación, que organiza y prepara la información para ser almacenada en registros. Finalmente, los valores codificados se almacenan en registros tipo D, y el sistema envía la salida correspondiente al bloque de "Key", indicando que los datos están disponibles para su uso. El sistema asegura que los datos recibidos sean precisos y procesados de manera eficiente, permitiendo que se obtengan las salidas correctas en función de la tecla presionada.
![Imagen de WhatsApp 2024-11-22 a las 00 49 56_80be757d](https://github.com/user-attachments/assets/c565bffe-d3af-48ae-bd93-af40ceb65cd0)

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

La máquina de estados finitos que se muestra a continuación gestiona el procesamiento secuencial de dos números. Comienza en el estado S0, donde recibe las decenas y el signo del primer número, y luego pasa a los estados S1, S2, y S3 para capturar las unidades del primer número y las decenas y unidades del segundo número. Finalmente, en el estado S4, los números son ensamblados y validados. Una vez completado el proceso, el sistema regresa al estado S0 para iniciar el ciclo nuevamente.
![image](https://github.com/user-attachments/assets/ae188b46-6626-4872-bf72-767bf81129df)

### Máquina de estados del multiplicador  
El multiplicador cuenta con su propia máquina de estados que controla las operaciones que se van ejecutando conforme avanza el proceso. Tal como se mencionó anteriormente, se cuenta con 7 estados y 5 señales de control, según se detallan a continuación.  
![FSM_multiplicador](https://github.com/user-attachments/assets/0337ea92-20e2-4215-9126-b0c28856164e)  
En el caso del estado DECIDE, este no asgina ningún valor a alguna señal de control, pues solo es un estado de paso para decidir si se aplica una suma, una resta o si directamente se hace un shift aritmético a la derecha.  


## Análisis de una simulación completa del sistema 

A continuación, se presenta la simulación del teclado. Inicialmente, se presiona el número 1, que se puede observar en la señal dato[], y este se asigna a la señal decenas1[]. Después de un breve lapso, la señal dat_ready cambia a 1, indicando que el dato está listo. Luego, se presiona el número 5, que aparece en dato[] y se asigna a la señal unidades1[]. Tras un breve tiempo, dat_ready vuelve a marcar 1, confirmando que el número completo, almacenado en numero1_o, es 15.

Posteriormente, se ingresa el segundo número siguiendo el mismo procedimiento. Primero, se presiona el número 8, visible en dato[], y este se asigna a la señal decenas2[]. Una vez que dat_ready cambia a 1, se confirma que el dato está listo. A continuación, se ingresa el número 3, que se observa en dato[] y se almacena en unidades2[]. Al completarse el proceso, el segundo número, almacenado en numero2_o, es 83.

Finalmente, valid=1, indica que ambos números están almacenados. El sistema procede entonces a realizar la multiplicación correspondiente y muestra el resultado en el display. Cabe destacar que mientras se ingresa el segundo número, los datos del primero permanecen fijos en sus respectivas señales (decenas1[], unidades1[] y numero1_o) y no se ven afectados por el ingreso de un nuevo número, garantizando la integridad de la información.

![image](https://github.com/user-attachments/assets/9a1b684a-f9ce-4026-bf12-96d512cccf29)

Seguidamente, en la sigueinte simulación, se observa cómo el sistema comienza en un estado inicial donde no hay datos disponibles para procesar, lo cual se refleja con la salida u_mult_result=x. A medida que se ingresan los números 15 y 83 en las señales correspondientes, y una vez que ambas entradas están listas (Valid=1), el sistema inicia la operación de multiplicación.

En el transcurso del tiempo, se registran diversos estados intermedios mientras se realizan las operaciones y se actualizan las señales. Finalmente, el sistema calcula correctamente el producto de 15 y 83, que resulta ser 1245. Este valor se muestra de manera estable en u_mult_result una vez que la operación ha concluido. Además, el resultado se despliega secuencialmente en los diferentes segmentos del display (u_display_segments) y selecciona cada posición activa del mismo a través de la señal u_display_select. Esto demuestra que el sistema no solo realiza el cálculo de manera precisa, sino que también asegura que el resultado se visualice correctamente, manteniendo la integridad de los datos a lo largo de todo el proceso.

![image](https://github.com/user-attachments/assets/d3ee4ec8-d578-42d5-abfb-6463565dd9e1)

## Análisis del consumo de recursos en la FPGA  
La siguiente imagen muestra el consumo de recursos en la FPGA, se observa un uso altamente eficiente, con una ocupación mínima en comparación con la capacidad total del dispositivo. Por ejemplo, el consumo de slices es apenas del 1% (97 de 8640), lo que refleja una huella lógica reducida y deja un amplio margen para posibles expansiones o mejoras del diseño. Además, se observa que las entradas y salidas (IOB) utilizan solo 15 de los 274 pines disponibles, lo que equivale a un 5%. Esto sugiere que el diseño interactúa de manera moderada con periféricos externos, como displays o LEDs, manteniendo espacio para añadir futuras conexiones.

El uso de bloques de lógica, como las tablas de búsqueda multiplexerizadas (MUX2_LUT), es también muy bajo: apenas 9 para LUT5, 4 para LUT6, 2 para LUT7 y ninguno para LUT8. Este bajo consumo indica que el diseño no depende de operaciones lógicas complejas, mostrando un enfoque eficiente en términos de recursos. Otros elementos, como la memoria RAM, osciladores internos, bloques PLL o registros ODDR, no se encuentran en uso, lo que refuerza la sencillez del proyecto y su independencia de módulos avanzados. Por otro lado, algunos recursos básicos, como el suministro de voltaje (VCC y GND) y el reinicio global (GSR), alcanzan el 100% de uso, lo cual es esperado y necesario para el funcionamiento del dispositivo. Esto, sin embargo, no afecta la disponibilidad de otros recursos clave para el desarrollo.


## Reporte de velocidades y tiempos  
En cuanto a la velocidad de operación, los tiempos de respuesta del sistema dependen en gran medida de la frecuencia de los relojes generados por los módulos de control, así como de los contadores y divisores de frecuencia implementados. Los divisores de reloj utilizados en diferentes partes del sistema permiten la creación de señales temporales que sincronizan las acciones de los módulos, asegurando que cada proceso se ejecute en el tiempo adecuado. Esto es crucial para evitar conflictos o desincronizaciones, especialmente en sistemas que requieren realizar operaciones secuenciales, como los procesos de cálculo o de cambio de estados en máquinas de estados finitos (FSM). Los tiempos de ciclo y la frecuencia de reloj también dependen de cómo se configuran los contadores, que a su vez determinan la duración de las señales de salida. Si bien la FPGA tiene una capacidad para operar a frecuencias de hasta 27 MHz, las señales temporales en el sistema pueden estar limitadas por los valores de los divisores de reloj, como los valores establecidos para obtener frecuencias más bajas, como 10 kHz, lo que optimiza el tiempo de respuesta en las operaciones que no requieren alta velocidad.

Además, la sincronización de las señales, como las de control y de entrada/salida de datos, es un aspecto clave para mantener la estabilidad del sistema. La forma en que los registros de estado se actualizan en función de los flancos de reloj asegura que cada parte del sistema reaccione a tiempo, pero también hay que tener en cuenta que un retraso en un módulo puede propagar efectos adversos a otros, afectando el rendimiento general. Por otro lado, la eficiencia en términos de tiempo también está influenciada por las transiciones de estado y los ciclos de espera implementados en las máquinas de estados. En algunos casos, las operaciones de carga, desplazamiento y verificación de datos pueden involucrar múltiples ciclos de reloj, lo que podría generar latencia. Sin embargo, dado el bajo uso de los recursos y la implementación eficiente de los contadores, el impacto sobre el tiempo total de ejecución del sistema es relativamente bajo.



