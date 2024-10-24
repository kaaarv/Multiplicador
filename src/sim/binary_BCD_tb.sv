module binary_BCD_tb();
    // Entradas
    logic reset;
    logic [11:0] mult_result;
    logic valid;

    // Salidas
    logic [27:0] BCD_code;

    // Instancia del módulo a probar
    binary_BCD uut (
        .reset(reset),
        .mult_result(mult_result),
        .valid(valid),
        .BCD_code(BCD_code)
    );

    // Tarea para mostrar el código BCD
    task display_BCD;
        input [27:0] BCD;
        $display("BCD: %d%d%d%d", BCD[27:24], BCD[23:20], BCD[19:16], BCD[15:12]);
    endtask

    // Proceso de simulación
    initial begin
        // Crear archivo .vcd y empezar a volcar datos de señales
        $dumpfile("binary_BCD_tb.vcd");  // Nombre del archivo .vcd
        $dumpvars(0, binary_BCD_tb);  // Volcar todas las variables de este módulo

        // Inicializa las señales
        reset = 1;
        valid = 0;
        #10 reset = 0; // Quitar reset después de un tiempo
        
        // Prueba con diferentes números binarios
        // 1. Número: 45 (decimal)
        mult_result = 12'd45;
        valid = 1;
        #10;
        valid = 0;
        #50; // Espera para permitir la conversión
        $display("Numero en decimal: 45");
        display_BCD(BCD_code);
        
        // 2. Número: 123 (decimal)
        mult_result = 12'd123;
        valid = 1;
        #10;
        valid = 0;
        #50;
        $display("Numero en decimal: 123");
        display_BCD(BCD_code);

        // 3. Número: 999 (decimal)
        mult_result = 12'd999;
        valid = 1;
        #10;
        valid = 0;
        #50;
        $display("Numero en decimal: 999");
        display_BCD(BCD_code);

        // 4. Número: 2047 (decimal)
        mult_result = 12'd2047;
        valid = 1;
        #10;
        valid = 0;
        #50;
        $display("Numero en decimal: 2047");
        display_BCD(BCD_code);

        // 5. Número: 256 (decimal)
        mult_result = 12'd256;
        valid = 1;
        #10;
        valid = 0;
        #50;
        $display("Numero en decimal: 256");
        display_BCD(BCD_code);

        $finish;
    end
endmodule
