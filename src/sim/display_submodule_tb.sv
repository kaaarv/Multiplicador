module display_multiplexer_tb;
    logic clk;
    logic reset;
    logic [15:0] BCD_code;
    logic [6:0] segments;
    logic [3:0] display_select;

    // Instancia del módulo display_multiplexer
    display_multiplexer uut (
        .clk(clk),
        .reset(reset),
        .BCD_code(BCD_code),
        .segments(segments),
        .display_select(display_select)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Cambiar cada 5 unidades de tiempo
    end

    // Proceso de prueba
    initial begin
        // Crear archivo .vcd y empezar a volcar datos de señales
        $dumpfile("display_multiplexer_tb.vcd");  // Nombre del archivo .vcd
        $dumpvars(0, display_multiplexer_tb);  // Volcar todas las variables de este módulo

        // Inicializar señales
        reset = 1;
        BCD_code = 16'b0; // Inicializa en cero
        #10;
        reset = 0;

        // Proporcionar un BCD_code de prueba
        BCD_code = 16'b1000010100111001;

        // Ejecutar prueba por un tiempo para ver la salida
        #200; // Espera suficiente tiempo para varios ciclos de visualización

        // Mostrar valores en cada iteración
        $display("------------Prueba 1------------");
        display_all_values(BCD_code);
        #10000;

        reset = 1;
        BCD_code = 16'b0; // Inicializa en cero
        #10;
        reset = 0;

        // Proporcionar un BCD_code de prueba
        BCD_code = 16'b1001100101000101;

        // Ejecutar prueba por un tiempo para ver la salida
        #200; // Espera suficiente tiempo para varios ciclos de visualización

        // Mostrar valores en cada iteración
        $display("------------Prueba 2------------");
        display_all_values(BCD_code);
        #10;

        // Finalizar la simulación
        $finish;
    end

    // Tarea para mostrar todos los valores
    task display_all_values(input logic [15:0] BCD_code);  // Cambié el tamaño a 16 bits
        // Iterar sobre los valores de display_select válidos
        for (int i = 0; i < 4; i++) begin
            // Establecer display_select a los valores válidos
            //uut.display_select = i; // Cambia display_select a 0, 1, 2 y 3
            #100000; // Esperar un ciclo de reloj

            // Mostrar el estado actual
            $display("display_select = %b, segments = %b", uut.display_select, uut.segments);

            // Calcular y mostrar valores de MILES, CENTENAS, DECENAS y UNIDADES
            $display("MILES = %d, CENTENAS = %d, DECENAS = %d, UNIDADES = %d", uut.thousands, uut.hundreds, uut.tens, uut.units);
        end
    endtask

endmodule
