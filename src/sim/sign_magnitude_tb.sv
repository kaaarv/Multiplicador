module sign_magnitude_tb;

    // Señales para instanciar el módulo sign_magnitude
    logic clk, reset, valid;
    logic [15:0] mult_result;
    logic [15:0] magnitude;
    logic sign, mult_sign_magnitude_ready;

    // Instanciar el módulo sign_magnitude
    sign_magnitude uut (
        .clk(clk),
        .reset(reset),
        .valid(valid),
        .mult_result(mult_result),
        .magnitude(magnitude),
        .sign(sign),
        .mult_sign_magnitude_ready(mult_sign_magnitude_ready)
    );

    // Generar señal de reloj
    always #5 clk = ~clk;

    // Procedimiento de prueba
    initial begin
        // Iniciar el archivo .vcd para volcar señales
        $dumpfile("tb_sign_magnitude.vcd");
        $dumpvars(0, sign_magnitude_tb);
        
        // Inicializar señales
        clk = 0;
        reset = 1;
        valid = 0;
        mult_result = 16'h0000;
        
        // Soltar el reset después de un ciclo de reloj
        #10 
        reset = 1;
        valid = 0;
        #10
        reset = 0;

        // Test 1: Número negativo (-0x1234 en complemento a dos)
        #10 mult_result = 16'b1111101100100000;  // -4660 en complemento a dos
        #10 valid = 1;
        #20 $display("Test 1: mult_result = %0d, magnitude = %0d, sign = %b", $signed(mult_result), magnitude, sign);

        // Test 2: Número positivo (0x207C)
        #10 
        reset = 1;
        valid = 0;
        #10
        reset = 0;
        #10 mult_result = 16'b0010000001111100;  // 8316 en decimal
        #10 valid = 1;
        #20 $display("Test 2: mult_result = %0d, magnitude = %0d, sign = %b", $signed(mult_result), magnitude, sign);

        // Test 3: Otro número negativo
        #10 
        reset = 1;
        valid = 0;
        #10
        reset = 0;
        #10 mult_result = 16'b1101100110110111;  // -9801 en complemento a dos
        #10 valid = 1;
        #20 $display("Test 3: mult_result = %0d, magnitude = %0d, sign = %b", $signed(mult_result), magnitude, sign);

        // Test 4: Número positivo pequeño
        #10 
        reset = 1;
        valid = 0;
        #10
        reset = 0;
        #10 mult_result = 16'b0000000001011001;  // 89 en decimal
        #10 valid = 1;
        #20 $display("Test 4: mult_result = %0d, magnitude = %0d, sign = %b", $signed(mult_result), magnitude, sign);

        // Finalizar la simulación
        #30 $finish;
    end

endmodule
