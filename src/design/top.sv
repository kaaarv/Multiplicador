// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Multiplicador con signo (módulo principal)
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila

module top(
    input logic clk,
    input logic reset,
    output logic 

);
    //-------Variables temporales para el teclado:


    //-------Variables temporales para el multiplicador:


    //-------Variables temporales para los displays:


    //--------------------------------------------------------//

    //-------Instancia de los módulos del teclado:


    //-------Instancia de los módulos del multiplicador:
    multiplier_FSM u_multiplier_FSM(
        .clk(clk),
        .reset(reset),
        .valid(),        // SEÑAL DE CONTROL DESDE EL TECLADO O SU FSM
        .Qo_Qprev(),     // SEÑAL DESDE EL MULTIPLICADOR
        .load_M(),       // SEÑAL HACIA EL MULTIPLICADOR
        .load_Q(),       // SEÑAL HACIA EL MULTIPLICADOR
        .load_add(),     // SEÑAL HACIA EL MULTIPLICADOR
        .shift_all(),    // SEÑAL HACIA EL MULTIPLICADOR
        .ready()         // SEÑAL DE CONTROL HACIA SIGN_MAGNITUDE
    );

    multiplier u_multiplier(
        .clk(clk),
        .reset(reset),
        .load_M(),       // SEÑAL DESDE SU FSM
        .load_Q(),       // SEÑAL DESDE SU FSM
        .load_add(),     // SEÑAL DESDE SU FSM
        .shift_all(),    // SEÑAL DESDE SU FSM
        .num_1(),        // NÚMERO A MULTIPLICAR
        .num_2(),        // NÚMERO A MULTIPLICAR
        .Qo_Qprev(),     // SEÑAL HACIA SU FSM
        .mult_result()   // RESULTADO (HACIA SIGN_MAGNITUDE)
    );


    //-------Instancia de los módulos del display:
    binary_toBCD u_binary_toBCD(

    );

    display_clk u_display_clk(

    );

    display_code u_display_code(

    );

    sign_magnitude u_sign_magnitude(

    );
endmodule