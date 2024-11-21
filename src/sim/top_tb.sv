// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Multiplicador con signo (testbench)
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila.

`timescale 1 ns / 100 ps

module Top_module_tb;
    logic clk;
    logic rst;
    logic [3:0] key_in;
    logic dat_ready;
    logic signo;
    logic [6:0] u_display_segments;
    logic [3:0] u_display_select;
    logic u_mult_sign;
    logic [15:0] u_mult_result;

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
        .u_mult_result(u_mult_result)
    );

    // Generación de reloj principal a 27 MHz
    initial begin
        clk = 0;
        forever #18.5 clk = ~clk;  // Periodo de 37 ns (aprox. 27 MHz)
    end

    initial begin
        signo = 0;
        rst = 0;
        dat_ready = 1'b0;
        key_in = 4'b1111;
        #20000;
        rst = 1;
        #5;
        
        // Primera tecla presionada - Fila 1
        key_in = 4'b1110;  // Simula la activación de la fila 1
        #200000;
        dat_ready = 1'b1;
        #200000;
        dat_ready = 1'b0;
        #200000; 

        // Segunda tecla presionada - Fila 2
        key_in = 4'b1101;  // Simula la activación de la fila 2
        #200000;
        dat_ready = 1'b1;
        #200000;
        dat_ready = 1'b0;
        #200000;

        // Tercera tecla presionada - Fila 3
        key_in = 4'b1011;  // Simula la activación de la fila 3
        #200000;
        dat_ready = 1'b1;
        #200000;
        dat_ready = 1'b0;
        #200000;

        // Cuarta tecla presionada 
        key_in = 4'b1110;  // Simula la activación de la fila 1
        #400000;
        dat_ready = 1'b1;
        #400000;
        dat_ready = 1'b0;

        #66680000;
        $finish;
    end

    // Monitoreo de salidas
    initial begin
        $monitor("Time=%0t | u_display_segments=%b | u_display_select=%b | u_mult_sign=%b | u_mult_result=%d",
                 $time, u_display_segments, u_display_select, u_mult_sign, u_mult_result);
    end

    initial begin
        $dumpfile("Top_module_tb.vcd");
        $dumpvars(0, Top_module_tb);
    end

endmodule
