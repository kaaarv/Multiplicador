`timescale 1ns/1ps

module module_control_tb;

    // Señales del DUT
    logic clk;
    logic rst;
    logic dat_ready;
    logic [3:0] dato;
    logic signo;
    logic [7:0] numero1, numero2;
    logic valid, signo1, signo2;

    // Instancia del DUT
    module_control uut (
        .clk(clk),
        .rst(rst),
        .dat_ready(dat_ready),
        .dato(dato),
        .signo(signo),
        .numero1_o(numero1),
        .numero2_o(numero2),
        .valid(valid)
    );

    // Generador de reloj
    always #5 clk = ~clk;

    // Procedimiento principal
    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 0;
        dat_ready = 0;
        dato = 4'b0000;
        signo = 0;

        // Reseteo
        #10;
        rst = 1;

        // Secuencia de entrada
        @(posedge clk);
        #1 dato = 4'b0000; signo = 0; dat_ready = 1; // Decenas del primer número
        @(posedge clk);
        #1 dat_ready = 0; // Desactiva dat_ready temporalmente

        @(posedge clk);
        #1 dato = 4'b0111; signo = 0; dat_ready = 1; // Unidades del primer número
        @(posedge clk);
        #1 dat_ready = 0;

        @(posedge clk);
        #1 dato = 4'b0000; signo = 1; dat_ready = 1; // Decenas del segundo número
        @(posedge clk);
        #1 dat_ready = 0;

        @(posedge clk);
        #1 dato = 4'b0111; signo = 0; dat_ready = 1; // Unidades del segundo número
        @(posedge clk);
        #1 dat_ready = 0;

        // Espera a que el sistema valide los números
        wait(valid == 1);

        // Muestra resultados
        //$display("Numero 1 completo: %0d, Signo: %s", numero1, (signo1 ? "-" : "+"));
        //$display("Numero 2 completo: %0d, Signo: %s", numero2, (signo2 ? "-" : "+"));

         // Muestra resultados en binario (sin complemento a 2)
        $display("Numero 1 en complemento a 2: %08b", numero1);
        $display("Numero 2 en complemento a 2: %08b", numero2);

        

        // Finaliza simulación
        #10;
        $finish;
    end

    initial begin
        $dumpfile("module_control_tb.vcd");
        $dumpvars(0, module_control_tb);
    end

endmodule

