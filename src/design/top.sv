// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Multiplicador con signo (módulo principal)
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila

module top(
    input logic clk,
    input logic reset,
    output logic u_mult_sign,
    output logic [6 : 0] u_display_segments,
    output logic [3 : 0] u_display_select
);
    //-------Variables temporales para el teclado:


    //-------Variables temporales para el multiplicador:
    logic u_load_M; 
    logic u_load_Q;
    logic u_load_add;
    logic u_shift_all;
    logic u_mult_ready;
    logic [1 : 0] u_Qo_Qprev;
    logic [15 : 0] u_mult_result;


    //-------Variables temporales para los displays:
    logic [15 : 0] u_mult_magnitude;
    logic [15 : 0] u_BCD_code;
    logic u_mult_sign_magnitude_ready;
    logic u_clk_display;
    logic u_BCD_ready;


    //--------------------------------------------------------//

    //-------Instancia de los módulos del teclado:


    //-------Instancia de los módulos del multiplicador:
    multiplier_FSM u_multiplier_FSM(
        .clk(clk),
        .reset(reset),
        .valid(),                    // SEÑAL DE CONTROL DESDE EL TECLADO O SU FSM          <<<
        .Qo_Qprev(u_Qo_Qprev),       // SEÑAL DESDE EL MULTIPLICADOR
        .load_M(u_load_M),           // SEÑAL HACIA EL MULTIPLICADOR
        .load_Q(u_load_Q),           // SEÑAL HACIA EL MULTIPLICADOR
        .load_add(u_load_add),       // SEÑAL HACIA EL MULTIPLICADOR
        .shift_all(u_shift_all),     // SEÑAL HACIA EL MULTIPLICADOR
        .ready(u_mult_ready)         // SEÑAL DE CONTROL HACIA SIGN_MAGNITUDE
    );

    multiplier u_multiplier(
        .clk(clk),
        .reset(reset),
        .load_M(u_load_M),           // SEÑAL DESDE SU FSM
        .load_Q(u_load_Q),           // SEÑAL DESDE SU FSM
        .load_add(u_load_add),       // SEÑAL DESDE SU FSM
        .shift_all(u_shift_all),     // SEÑAL DESDE SU FSM
        .num_1(),                    // NÚMERO A MULTIPLICAR                                <<<
        .num_2(),                    // NÚMERO A MULTIPLICAR                                <<<
        .Qo_Qprev(u_Qo_Qprev),       // SEÑAL HACIA SU FSM
        .mult_result(u_mult_result)  // RESULTADO (HACIA SIGN_MAGNITUDE)
    );


    //-------Instancia de los módulos del display:
    binary_toBCD u_binary_toBCD(
        .clk(clk),
        .reset(reset),
        .mult_result(u_mult_magnitude),         // MAGNITUD DESDE SIGN_MAGNITUDE
        .valid(u_mult_sign_magnitude_ready),    // SEÑAL DE CONTROL DESDE SIGN_MAGNITUDE
        .BCD_ready(u_BCD_ready),                // SEÑAL DE CONTROL HACIA DISPLAY_CODE
        .BCD_code(u_BCD_code)                   // CÓDIGO BCD HACIA DISPLAY_CODE
    );

    display_clk u_display_clk(
        .clk(clk),
        .reset(reset),
        .clk_display(u_clk_display)             // RELOJ PARA EL DISPLAY (HACIA DISPLAY_CODE)
    );

    display_code u_display_code(
        .clk(u_clk_display)                     // RELOJ DESDE DISPLAY_CLK
        .reset(reset),
        .valid_BCD(u_BCD_ready),                // SEÑAL DE CONTROL DESDE BINARY_TOBCD
        .BCD_code(u_BCD_code),                  // CÓDIGO BCD DESDE BINARY_TOBCD
        .segments(u_display_segments),          // SALIDA (CÓDIGO PARA LOS DISPLAYS)
        .display_select(u_display_select)       // SALIDA (CÓDIGO DE DISPLAY ENCENDIDO)
    );

    sign_magnitude u_sign_magnitude(
        .clk(clk),
        .reset(reset),
        .valid(u_mult_ready),                                        // SEÑAL DE CONTROL DESDE MULTIPLIER_FSM
        .mult_result(u_mult_result)                                  // RESULTADO DESDE EL MULTIPLICADOR
        .magnitude(u_mult_magnitude),                                // MAGNITUD HACIA BINARY_TOBCD
        .sign(u_mult_sign),                                          // SALIDA (SIGNO DEL RESULTADO)
        .mult_sign_magnitude_ready(u_mult_sign_magnitude_ready)      // SEÑAL DE CONTROL HACIA BINARY_TOBCD
    );
endmodule