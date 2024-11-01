`timescale 1 ns / 100 ps

module Top_module_tb;

    // Señales de prueba
    logic clk;
    logic rst;
    logic [3:0] key_in;
    logic data_available;
    logic [3:0] dato_o;

    // Instancia del módulo top
    Top_module uut (
        .clk(clk),
        .rst(rst),
        .key_in(key_in),
        .data_available(data_available),
        .dato_o(dato_o)
    );

    // Generación del reloj a 27 MHz
    always #18.518 clk = ~clk;

    // Monitor de cambios en data_available para reducir la cantidad de mensajes
    logic data_available_prev;
    always @(posedge clk) begin
        if (data_available && !data_available_prev) begin
            $display("Tiempo: %0t ns | data_available: %b | key_in: %b | dato_o: %d",
                     $time, data_available, key_in, dato_o);
        end
        data_available_prev <= data_available;
    end

    initial begin
        // Configuración del dump de la simulación
        $dumpfile("Top_module_tb.vcd");
        $dumpvars(0, Top_module_tb);
        
        // Inicialización de señales
        clk = 0;
        rst = 0;
        key_in = 4'b0000;
        data_available_prev = 0;

        // Activación de reset
        #37 rst = 1;
        
        // Ciclo de prueba con diferentes teclas
        #100 key_in = 4'b1110; // Primera tecla
        #300000 key_in = 4'b1101; // Segunda tecla después de un tiempo para procesar el debounce
        #300000 key_in = 4'b1011; // Tercera tecla después de un tiempo para procesar el debounce
        #300000 key_in = 4'b0111; // Cuarta tecla después de un tiempo para procesar el debounce

        // Prueba adicional de reset para observar el comportamiento
        #37 rst = 0;
        #37 rst = 1;
        
        // Espera para que el debounce y el divisor de frecuencia procesen las señales correctamente
        #300000;

        // Nueva tecla para verificar debounce y flujo de datos
        #100 key_in = 4'b1011;
        #300000;

        // Finalización de la simulación
        #100000;
        $finish;
    end

endmodule

