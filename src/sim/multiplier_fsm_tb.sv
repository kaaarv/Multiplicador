module multiplier_fsm_tb();
    logic clk;
    logic reset;
    logic valid;
    logic [1:0] Qo_Qprev;
    logic mult_DONE;
    
    // Señales de control
    logic load_M;
    logic load_Q;
    logic reset_A;
    logic reset_Qprev;
    logic add_M;
    logic subs_M;
    logic shift_all;

    // Instancia del DUT (multiplier_FSM)
    multiplier_FSM dut (
        .clk(clk),
        .reset(reset),
        .valid(valid),
        .Qo_Qprev(Qo_Qprev),
        .load_M(load_M),
        .load_Q(load_Q),
        .reset_A(reset_A),
        .reset_Qprev(reset_Qprev),
        .add_M(add_M),
        .subs_M(subs_M),
        .shift_all(shift_all),
        .mult_DONE(mult_DONE)
    );

    // Generar el reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  
    end

    // Inicializar señales y simular
    initial begin
        $dumpfile("multiplier_fsm_tb.vcd");
        $dumpvars(0, multiplier_fsm_tb);

        // Inicializar señales
        reset = 0;
        valid = 0;
        Qo_Qprev = 2'b00;

        // Reset del sistema
        reset = 1;
        #10;
        reset = 0;

        // Primera operación: Validar la operación y cambiar Qo_Qprev
        valid = 1;
        Qo_Qprev = 2'b01;
        #500;
        Qo_Qprev = 2'b10;
        #500;
        valid = 0;
        #20;

        // Segunda operación: Otro set de valores de Qo_Qprev
        valid = 1;
        Qo_Qprev = 2'b00; 
        #500;
        valid = 0;  
        #500;

        // Finalizar la simulación
        $finish;
    end

    // Monitoreo de señales en la terminal
    initial begin
        $monitor("Time: %0t | Qo_Qprev: %b | mult_DONE: %b | load_M: %b | load_Q: %b | reset_A: %b | reset_Qprev: %b | add_M: %b | subs_M: %b | shift_all: %b", 
                  $time, Qo_Qprev, mult_DONE, load_M, load_Q, reset_A, reset_Qprev, add_M, subs_M, shift_all);
    end
endmodule
