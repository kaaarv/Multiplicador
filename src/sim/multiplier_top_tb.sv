// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Subsistema multiplicador (TB) con el algoritmo de Booth
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila

module tb_multiplier_top;
    logic clk;
    logic reset;
    logic start;
    logic signed [7:0] num_1;
    logic signed [7:0] num_2;
    logic mult_ready;
    logic signed [15:0] mult;

    multiplier_top uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .num_1(num_1),
        .num_2(num_2),
        .mult_ready(mult_ready),
        .mult(mult)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("multiplier_top.vcd");
        $dumpvars(0, tb_multiplier_top);
        
        // Inicialización de señales
        clk = 0;
        reset = 1;
        start = 0;
        num_1 = 0;
        num_2 = 0;
        
        #10 reset = 0;
        
        // --------------Primera multiplicación:
        #10 
        num_1 = 8'd0;
        num_2 = 8'd37;
        #15
        start = 1;

        // Esperamos hasta que el multiplicador esté listo
        wait (mult_ready);
        #5 $display("Resultado 1: %0d * %0d = %0d", num_1, num_2, mult);
        #100
        
        // --------------Segunda multiplicación:
        reset = 1;
        start = 0;
        #15
        reset = 0;
        #15
        num_1 = 8'd53;
        num_2 = 8'd46;
        #15
        start = 1;

        wait (mult_ready);
        #5 $display("Resultado 2: %0d * %0d = %0d", num_1, num_2, mult);
        #100

        // ---------------Tercera multiplicación: -8 * -2
        reset = 1;
        start = 0;
        #15
        reset = 0;
        #15
        num_1 = 8'd99;
        num_2 = 8'd97;
        #15
        start = 1;

        wait (mult_ready);
        #5 $display("Resultado 3: %0d * %0d = %0d", num_1, num_2, mult);
        #100

        // Finalizamos la simulación
        #10 $finish;
    end
endmodule