// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Subsistema multiplicador con el algoritmo de Booth
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila

module multiplier(
    input logic clk,
    input logic reset,
    input logic load_M,
    input logic load_Q,
    input logic load_add,
    input logic shift_all,
    input logic signed [7 : 0] num_1,
    input logic signed [7 : 0] num_2,
    output logic [1 : 0] Qo_Qprev,
    output logic signed [15 : 0] mult_result
);
    logic [7 : 0] M;
    logic [7 : 0] adder_sub_out;
    logic [16 : 0] shift;
    logic [7 : 0] HQ;
    logic [7 : 0] LQ;
    logic Q_prev;

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            M <= 0;
        end else if(load_M) begin
            M <= num_1;
        end else begin
            M <= M;
        end
    end

    always_comb begin
        if(Qo_Qprev == 2'b01) begin
            adder_sub_out = HQ + M;
        end else if(Qo_Qprev == 2'b10) begin
            adder_sub_out = HQ - M;     
        end else begin
            adder_sub_out = 0;
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            shift <= 0;
        end else if(shift_all) begin
            shift <= $signed(shift) >>> 1;
        end else begin
            if(load_Q) begin
                shift [8 : 1] <= num_2;
            end
            if(load_add) begin
                shift [16 : 9] <= adder_sub_out;
            end
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            HQ <= 0;
            LQ <= 0;
            Q_prev <= 0;
        end else begin
            HQ <= shift[16 : 9];
            LQ <= shift[8 : 1];
            Q_prev <= shift[0];
            mult_result <= {HQ, LQ};
            Qo_Qprev <= {LQ[0], Q_prev};
        end
    end
endmodule