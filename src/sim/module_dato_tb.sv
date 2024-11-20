`timescale 1ns / 1ps

module module_dato_tb;

    logic clk;
    logic rst;
    logic dato_listo_i;
    logic [1:0] dato_codc_i;
    logic [1:0] dato_codf_i;
    
    logic [3:0] dato_o;

    module_dato uut (
        .clk(clk),
        .rst(rst),
        .dato_listo_i(dato_listo_i),
        .dato_codc_i(dato_codc_i),
        .dato_codf_i(dato_codf_i),
        .dato_o(dato_o)
    );

    // Generación de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Proceso de prueba
    initial begin
        $display("Inicio de prueba de module_dato");

        // Inicialización
        rst = 0;
        dato_listo_i = 0;
        dato_codc_i = 2'b00;
        dato_codf_i = 2'b00;
        #10; 
        
        // Liberar reset
        rst = 1;
        #10;

        // Activar dato_listo_i
        dato_listo_i = 1;

        // Comprobación de combinaciones específicas
        // Caso 1: 00 00 -> dato_o debe ser 1
        dato_codc_i = 2'b00;
        dato_codf_i = 2'b00;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        // Caso 2: 00 01 -> dato_o debe ser 2
        dato_codf_i = 2'b01;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        // Caso 3: 00 10 -> dato_o debe ser 3
        dato_codf_i = 2'b10;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        // Caso 4: 00 11 -> dato_o debe ser 15
        dato_codf_i = 2'b11;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        // Caso 5: 01 00 -> dato_o debe ser 4
        dato_codc_i = 2'b01;
        dato_codf_i = 2'b00;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        // Caso 6: 01 01 -> dato_o debe ser 5
        dato_codf_i = 2'b01;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        // Caso 7: 01 10 -> dato_o debe ser 6
        dato_codf_i = 2'b10;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        // Caso 8: 01 11 -> dato_o debe ser 15
        dato_codf_i = 2'b11;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        // Caso 9: 10 00 -> dato_o debe ser 7
        dato_codc_i = 2'b10;
        dato_codf_i = 2'b00;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        // Caso 10: 10 01 -> dato_o debe ser 8
        dato_codf_i = 2'b01;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        // Caso 11: 10 10 -> dato_o debe ser 9
        dato_codf_i = 2'b10;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        // Caso 12: 10 11 -> dato_o debe ser 15
        dato_codf_i = 2'b11;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        //Caso 13: 11 00 -> 15
        dato_codc_i = 2'b11;
        dato_codf_i = 2'b00;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        //Caso 14: 11 01 -> 0
        dato_codf_i = 2'b01;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        //Caso 15: 11 10 -> 15
        dato_codf_i = 2'b10;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);

        //Caso 16: 11 11 -> 15
        dato_codf_i = 2'b11;
        #10;
        $display("dato_codc_i = %b, dato_codf_i = %b, dato_o = %d", dato_codc_i, dato_codf_i, dato_o);


        // Desactivar dato_listo_i
        dato_listo_i = 0;
        #10;
        $display("Dato no listo nuevamente, dato_o = %d", dato_o);
        
        // Prueba de reset mientras dato_listo_i está activo
        dato_listo_i = 1;
        dato_codc_i = 2'b10; // Caso específico para reset
        dato_codf_i = 2'b01; // Valor de codificación
        #10;
        rst = 0; // Activa reset
        #10;
        rst = 1; // Desactiva reset
        #10;
        
        $display("Fin de prueba de module_dato");
        $finish;
    end

    // Dumps de la simulación para visualización en GTKWAVE
    initial begin
        $dumpfile("module_dato_tb.vcd");
        $dumpvars(0, module_dato_tb);
    end

endmodule
