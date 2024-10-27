`timescale 1ns / 1ps

module display_multiplexer_tb;

    // Señales de entrada y salida
    logic clk;   
    logic reset;           
    logic [27 : 0] BCD_code;     // Usamos BCD_code en lugar de sum_result  
    logic [6 : 0] segments;        
    logic [3 : 0] display_select;

    // Instancia del módulo a probar
    display_multiplexer uut (
        .clk(clk),
        .reset(reset),
        .BCD_code(BCD_code),     // Asignamos BCD_code
        .segments(segments),
        .display_select(display_select)
    );

    // Generación del reloj: Periodo de 10 unidades de tiempo (simuladas)
    always #5 clk = ~clk; 

    // Bloque inicial para la simulación
    initial begin
        // Inicializa las señales
        clk = 0;
        reset = 1;
        BCD_code = 28'b0;

        // Generar archivo VCD para análisis
        $dumpfile("display_multiplexer.vcd");
        $dumpvars(0, display_multiplexer_tb);

        // Desactiva el reset después de 10 unidades de tiempo
        #10 reset = 0;

        // Prueba 1: Valor máximo (1998)
        BCD_code = 28'b0001100110011000000000000000;   // BCD para 1998                   
        #100000;  // Tiempo para procesar

        // Mostrar resultados de la prueba 1
        $display("Prueba 1: 1998");
        display_all_values(BCD_code);

        // Prueba 2: Valor 930
        BCD_code = 28'b0000100100110000000000000000;   // BCD para 930                    
        #100000;  // Tiempo para procesar

        // Mostrar resultados de la prueba 2
        $display("Prueba 2: 930");
        display_all_values(BCD_code);

        // Finaliza la simulación
        $finish;
    end

    // Tarea para mostrar todos los valores de los displays
    task display_all_values(input logic [27:0] BCD_code);
        // Iterar sobre los valores de display_select válidos
        logic [3:0] valid_selects [0:3]; // Arreglo de valores válidos
        valid_selects[0] = 4'b1110;
        valid_selects[1] = 4'b1101;
        valid_selects[2] = 4'b1011;
        valid_selects[3] = 4'b0111;

        for (int i = 0; i < 4; i++) begin
            // Establecer display_select a un valor válido
            uut.display_select = valid_selects[i]; // Cambia para 1110, 1101, 1011 y 0111
            #1; // Esperar un ciclo de reloj

            // Mostrar el estado actual
            $display("display_select = %b, segments = %b", display_select, segments);

            // Calcular y mostrar valores de MILES, CENTENAS, DECENAS y UNIDADES
            case (valid_selects[i]) // Cambié esto para usar valid_selects en lugar de uut.display_select
                4'b1110: $display("MILES = %d, CENTENAS = %d, DECENAS = %d, UNIDADES = %d", uut.thousands, uut.hundreds, uut.tens, uut.units);
                4'b1101: $display("MILES = %d, CENTENAS = %d, DECENAS = %d, UNIDADES = %d", uut.thousands, uut.hundreds, uut.tens, uut.units);
                4'b1011: $display("MILES = %d, CENTENAS = %d, DECENAS = %d, UNIDADES = %d", uut.thousands, uut.hundreds, uut.tens, uut.units);
                4'b0111: $display("MILES = %d, CENTENAS = %d, DECENAS = %d, UNIDADES = %d", uut.thousands, uut.hundreds, uut.tens, uut.units);
            endcase
        end
    endtask
endmodule
