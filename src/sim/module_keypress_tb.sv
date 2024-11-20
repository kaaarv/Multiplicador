`timescale 1ns/1ps

module module_keypress_tb;

    logic [1 : 0] dato_codc_i;
    logic [3 : 0] posf_i;
    logic [1 : 0] dato_codf_o;
    
    module_keypress uut (
        .dato_codc_i(dato_codc_i),
        .posf_i(posf_i),
        .dato_codf_o(dato_codf_o)
    );

    initial begin
        $monitor("Time=%0t | dato_codc_i=%b | posf_i=%b | dato_codf_o=%b", 
                 $time, dato_codc_i, posf_i, dato_codf_o);

        // Prueba para cada valor de dato_codc_i con los valores válidos de posf_i
        for (int i = 0; i < 4; i++) begin
            dato_codc_i = i[1:0];
            #10 posf_i = 4'b1111; #10;
            #10 posf_i = 4'b1110; #10;
            #10 posf_i = 4'b1101; #10;
            #10 posf_i = 4'b1011; #10;
            #10 posf_i = 4'b0111; #10;
        end
        
        // Prueba del caso por defecto
        dato_codc_i = 2'b10; 
        posf_i = 4'b0000; 
        #10;
        
        $finish;
    end

    // Dumps para visualización en GTKWAVE
    initial begin
        $dumpfile("module_keypress_tb.vcd");
        $dumpvars(0, module_keypress_tb);
    end

endmodule
