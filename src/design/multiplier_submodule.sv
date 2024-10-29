module multiplier_submodule (
    input logic clk,
    input logic [7 : 0] A, 
    input logic [7 : 0] B, 
    input logic start_mult, shift, add_multiplicand, subtract_multiplicand
    output logic [15 : 0] mult,
    output logic done,
    output logic sign
);
    logic [7 : 0] = M;
    logic [7 : 0] = Q;
    logic [7 : 0] = A;
    logic Q_prev;

    always_ff @(posedge clk) begin
        if (start_mult) begin
            register [8 : 1] = B;

            if (add_multiplicand)
            register[16 : 9] = register[16 : 9] + A;

            else if(subtract_multiplicand)
            register[16 : 9] = register[16 : 9] - A;
        end

        if (shift) begin
            register = register >>> 1;
        end
    end

    assign mult = register [15 : 0];
    assign sign = register [16];
endmodule