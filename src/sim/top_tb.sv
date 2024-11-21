// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Multiplicador con signo (testbench)
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila

`timescale 1 ns / 100 ps

module Top_module_tb;

    // Señales de testbench
    logic clk;
    logic rst;
    logic [3:0] key_in;
    logic dat_ready;
    logic signo;

    // Señales de salida del DUT
    logic [6:0] u_display_segments;
    logic [3:0] u_display_select;
    logic u_mult_sign;
    logic [3:0] columna_o;  // Se mantiene columna_o porque está definida como salida en top
    logic [7:0] numero1_o, numero2_o; // Se agregan las señales de los números
    logic valid; // Se agrega la señal valid
    logic u_mult_ready; // Se agrega la señal de salida u_mult_ready
    logic [15:0] u_mult_result; // Nueva señal para el resultado del multiplicador

    // Instancia del módulo `top`
    top DUT (
        .clk(clk),
        .reset(rst),
        .key_in(key_in),
        .dat_ready(dat_ready),
        .signo(signo),
        .u_display_segments(u_display_segments),
        .u_display_select(u_display_select),
        .u_mult_sign(u_mult_sign),
        .columna_o(columna_o),
        .numero1_o(numero1_o),
        .numero2_o(numero2_o),
        .valid(valid),  // Conexión de la señal valid
        .u_mult_ready(u_mult_ready),  // Conexión de la señal u_mult_ready
        .u_mult_result(u_mult_result)  // Nueva conexión para el resultado
    );

    // Generación de reloj principal a 27 MHz
    initial begin
        clk = 0;
        forever #18.5 clk = ~clk;  // Periodo de 37 ns (aprox. 27 MHz)
    end

    // Proceso de simulación
    initial begin
        // Inicialización
        signo = 0;
        rst = 0;
        dat_ready = 1'b0;
        key_in = 4'b1111; // Sin teclas presionadas al inicio
        #20000; 
        // Activación de reset
        rst = 1;
        #5;
        
        // Primera tecla presionada - Fila 1
        key_in = 4'b1110;  // Simula la activación de la fila 1
        #200000;
        dat_ready = 1'b1;
        #200000;
        dat_ready = 1'b0;
        #200000;            // Espera de tiempo para procesar

        // Segunda tecla presionada - Fila 2
        key_in = 4'b1101;  // Simula la activación de la fila 2
        #200000;
        dat_ready = 1'b1;
        #200000;
        dat_ready = 1'b0;
        #200000;            // Espera de tiempo para procesar

        // Tercera tecla presionada - Fila 3
        key_in = 4'b1011;  // Simula la activación de la fila 3
        #200000;
        dat_ready = 1'b1;
        #200000;
        dat_ready = 1'b0;
        #200000;            // Espera de tiempo para procesar

        // Cuarta tecla presionada 
        key_in = 4'b1110;  // Simula la activación de la fila 1
        #400000;
        dat_ready = 1'b1;
        #400000;
        dat_ready = 1'b0;
        #20;            // Espera de tiempo para procesar

        // Finalizar simulación
        #16670000;
        $finish;
    end

    // Monitoreo de salidas
    initial begin
        $monitor("Time=%0t | key_in=%b | u_display_segments=%b | u_display_select=%b | u_mult_sign=%b | columna_o=%b | valid=%b | numero1_o=%b | numero2_o=%b | u_mult_ready=%b | u_mult_result=%d",
                 $time, key_in, u_display_segments, u_display_select, u_mult_sign, columna_o, valid, numero1_o, numero2_o, u_mult_ready, u_mult_result);
    end

    initial begin
        $dumpfile("Top_module_tb.vcd");
        $dumpvars(0, Top_module_tb);
    end

endmodule
