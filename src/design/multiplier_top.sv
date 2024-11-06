// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Subsistema multiplicador (TOP) con el algoritmo de Booth
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila

module multiplier_top (
    input logic clk,
    input logic reset,
    input logic start,
    input logic signed [7 : 0] num_1,
    input logic signed [7 : 0] num_2,
    output logic mult_ready,
    output logic signed [15:0] mult
);
    logic [1 : 0] Qo_Qprev;
    logic load_M;
    logic load_Q;
    logic load_add;
    logic shift_all;
    logic signed [15 : 0] mult_result_value;

    multiplier_FSM u_multiplier_FSM(
        .clk(clk),
        .reset(reset),
        .valid(start),
        .Qo_Qprev(Qo_Qprev),
        .load_M(load_M),
        .load_Q(load_Q),
        .load_add(load_add),
        .shift_all(shift_all),
        .ready(mult_ready)
    );

    multiplier u_multiplier(
        .clk(clk),
        .reset(reset),
        .num_1(num_1),
        .num_2(num_2),
        .load_M(load_M),
        .load_Q(load_Q),
        .load_add(load_add),
        .shift_all(shift_all),
        .Qo_Qprev(Qo_Qprev),
        .mult_result(mult_result_value)
    );

    assign mult = mult_result_value;
endmodule