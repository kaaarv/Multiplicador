module tb_multiplier();
    // Entradas
    logic clk;
    logic reset;
    logic load_M;
    logic load_Q;
    logic reset_A;
    logic reset_Qprev;
    logic add_M;
    logic subs_M;
    logic shift_all;
    logic [7:0] num_1;
    logic [7:0] num_2;
    integer i;

    // Salidas
    logic [1:0] Qo_Qprev; 
    logic [15:0] mult_result;
    logic sign;

    // Instancia del multiplicador
    multiplier uut (
        .clk(clk),
        .reset(reset),
        .load_M(load_M),
        .load_Q(load_Q),
        .reset_A(reset_A),
        .reset_Qprev(reset_Qprev),
        .add_M(add_M),
        .subs_M(subs_M),
        .shift_all(shift_all),
        .num_1(num_1),
        .num_2(num_2),
        .Qo_Qprev(Qo_Qprev),
        .mult_result(mult_result),
        .sign(sign)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Genera un ciclo de reloj de 10 unidades de tiempo
    end

    // Proceso de prueba
    initial begin
        // Inicializar señales
        reset = 1;
        load_M = 0;
        load_Q = 0;
        reset_A = 0;
        reset_Qprev = 0;
        add_M = 0;
        subs_M = 0;
        shift_all = 0;
        num_1 = 8'b0;
        num_2 = 8'b0;

        // Esperar un ciclo de reloj
        #10;
        
        // Desactivar el reset
        reset = 0;

        // Prueba de 8 iteraciones

        // Cargar los números en cada iteración
        num_1 = 8'b00001111; // Ejemplo de valores para M (15()
        num_2 = 8'b00000101; // Mantener Q constante (5)

        // Cargar M y Q
        load_M = 1; // Cargar M
        #50
        load_M = 0; // Desactivar load_M
        
        load_Q = 1; // Cargar Q
        #50
        load_Q = 0; // Desactivar load_Q

        // Inicializar A
        reset_A = 1;
        #50
        reset_A = 0;

        reset_Qprev = 1;
        #50
        reset_Qprev = 0;

        for (i = 0; i < 8; i++) begin
            // Verificar Qo_Qprev antes de sumar
            $display("Iteracion %0d: Antes de sumar: Qo_Qprev = %b", i, Qo_Qprev);
            if (Qo_Qprev == 2'b01) begin
                add_M = 1; // Realizar suma
                #15
                add_M = 0; // Desactivar suma
            end else begin
                add_M = 0;
            end

            // Verificar Qo_Qprev antes de restar
            $display("Iteracion %0d: Antes de restar: Qo_Qprev = %b", i, Qo_Qprev);
            if (Qo_Qprev == 2'b10) begin
                subs_M = 1; // Realizar resta
                #15
                subs_M = 0; // Desactivar resta
            end else begin
                subs_M = 0;
            end

            // Realizar un último desplazamiento
            shift_all = 1; // Desplazar
            #15
            shift_all = 0; // Desactivar desplazamiento
        end

        // Terminar la simulación
        #50;
        $finish;
    end

    // Monitorear señales
    initial begin
        $monitor("Time: %0t | Iteración: %0d | M: %b | Q: %b | A: %b | Qo_Qprev: %b | mult_result: %b | sign: %b", 
                 $time, i, uut.M, uut.Q, uut.A, Qo_Qprev, mult_result, sign);
    end

endmodule
