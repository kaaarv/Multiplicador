`timescale 1 ns / 100 ps

//Se tiene que añadir el modulo de control y la señal de signo

module Top_module (
    input logic clk,               // Reloj principal
    input logic rst,               // Reset global
    input logic [3:0] key_in,      // Entrada del teclado sin debounce
    input logic dat_ready,         //Botón para el control de la FSM
    input logic signo,


    output logic data_available,    // Señal que indica que el dato está listo
    output logic [3 : 0] columna_o, //Señal barrido de columnas
    output logic [7:0] numero1_o, numero2_o,
    output logic [3:0] dato_o,     // Valor binario de la tecla presionada.
    output logic valid
    
);

    // Señales internas para conexiones entre módulos
    logic prd_out;                // Salida del divisor de frecuencia
    logic [1:0] dato_codc;        // Salida codificada de columna y salida del contador de 2 bits
    logic [1:0] dato_codf;        // Salida codificada de fila
    //logic signo;


    // Instancia del divisor de frecuencia
    module_divisor #(.COUNT(13500)) divisor (
        .clk(clk),
        .rst(rst),
        .prd_out(prd_out)
    );

    module_cont_2b contador (
        .clk (prd_out),
        .rst (rst),
        .stop (data_available),
        .cont_out(dato_codc)
    );

    module_keypress keypress (
        .dato_codc_i (dato_codc),
        .posf_i (key_in),
        .dato_codf_o (dato_codf),
        .columna_o (columna_o)
    );

    module_Debounce debounce (
        .clk (clk),
        .filas_in (key_in),
        .enable (data_available)
    );

    module_dato dato (
        .clk (clk),
        .rst (rst),
        .dato_listo_i (data_available),
        .dato_codc_i (dato_codc),
        .dato_codf_i (dato_codf),
        //.signo_o (signo),
        .dato_o (dato_o)
    );

    module_control control (
        .clk (clk),
        .rst (rst),
        .dat_ready (dat_ready),
        .dato (dato_o),
        .signo (signo),
        .numero1_o (numero1_o),
        .numero2_o (numero2_o),
        .valid (valid)
    );

endmodule
