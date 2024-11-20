`timescale 1 ns / 100 ps

module Top_module_tb;

    // Señales de testbench
    logic clk;
    logic rst;
    logic [3:0] key_in;
    logic dat_ready;
    logic signo ;

    logic data_available;
    logic [3:0] columna_o;
    logic [3:0] dato_o;
    logic valid;
    logic [7:0] numero1_o,numero2_o;
   
    
    // Instancia del módulo `Top_module`
    Top_module DUT (
        .clk(clk),
        .rst(rst),
        .key_in(key_in),
        .dat_ready(dat_ready),
        .signo(signo),
        .data_available(data_available),
        .columna_o(columna_o),
        .numero1_o(numero1_o),
        .numero2_o(numero2_o),
        .dato_o(dato_o),
        .valid(valid) 
    );

    // Generación de reloj principal a 27 MHz
    initial begin
        clk = 0;
        forever #18.5 clk = ~clk;  // Periodo de 37 ns (aprox. 27 MHz)
    end

    // Proceso de simulación
    initial begin
        // Inicialización
        signo = 0;
        rst = 0;
        dat_ready = 1'b0;
        key_in = 4'b1111; // Sin teclas presionadas al inicio
        #20000; 
        // Activación de reset
        #10000 rst = 1;
        
        // Primera tecla presionada - Fila 1
        key_in = 4'b1110;  // Simula la activación de la fila 1
        #200000;
        dat_ready = 1'b1;
        #200000;
        dat_ready = 1'b0;
        #200000;            // Espera de tiempo para procesar
            

        // Segunda tecla presionada - Fila 2
        key_in = 4'b1101;  // Simula la activación de la fila 2
        #200000;
        dat_ready = 1'b1;
        #200000;
        dat_ready = 1'b0;
        #200000;            // Espera de tiempo para procesar
           

        // Tercera tecla presionada - Fila 3
        key_in = 4'b1011;  // Simula la activación de la fila 3
        #200000;
        dat_ready = 1'b1;
        #200000;
        dat_ready = 1'b0;
        #200000;            // Espera de tiempo para procesar
            

        // Cuarta tecla presionada 
        key_in = 4'b1110;  // Simula la activación de la fila 1
        #400000;
        dat_ready = 1'b1;
        #400000;
        dat_ready = 1'b0;
        #200000;            // Espera de tiempo para procesar
           
        //end
        # 250000;
        // Finalizar simulación
        $finish;
    end

    // Monitoreo de salidas
    //initial begin
      //  $monitor("Time=%0t | rst=%b | key_in=%b | data_available=%b | dato_o=%h",
        //         $time, rst, key_in, data_available, dato_o);
    //end

    initial begin
        $dumpfile("Top_module_tb.vcd");
        $dumpvars(0, Top_module_tb);
    end

endmodule