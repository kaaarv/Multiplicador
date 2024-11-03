module multiplier(
    input logic clk, reset, load_M, load_Q, reset_A, reset_Qprev, 
    input logic add_M, subs_M, shift_all,
    input logic [7 : 0] num_1,
    input logic [7 : 0] num_2,
    output logic [1 : 0] Qo_Qprev, 
    output logic [15 : 0] mult_result,
    output logic sign
);
    logic [7 : 0] M;
    logic [7 : 0] Q;
    logic [7 : 0] A;
    logic Q_prev;

    // Regulador e inicializador
    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            M <= 0;
            Q <= 0;
            A <= 0;
            Q_prev <= 0;
        end else begin
            M <= load_M ? num_1 : M;
            Q <= load_Q ? num_2 : Q;
            A <= reset_A ? 8'b0 : A;
            Q_prev <= reset_Qprev ? 1'b0 : Q_prev;

            // condición ? valor_si_verdadero : valor_si_falso;
        end
    end

    // Suma o resta de M a A
    always_ff @(posedge clk) begin
        if(add_M) begin
            A <= A + M;
        end else if(subs_M) begin 
            A <= A - M;
        end
    end

    // Corrimiento (Shift)
    always_ff @(posedge clk) begin
        if(shift_all) begin
            Q_prev <= Q[0];
            Q <= Q >> 1;
            Q[7] <= A[0];
            A <= A >>> 1;
        end
    end

    assign Qo_Qprev = {Q[0], Q_prev};
    assign mult_result = {1'b0, A[6 : 0], Q[7 : 0]};
    assign sign = A[7];
endmodule