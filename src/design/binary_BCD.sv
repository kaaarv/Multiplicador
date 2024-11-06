module binary_BCD(
    input logic reset,
    input logic [15 : 0] mult_result,
    input logic valid,
    output logic BCD_ready,
    output logic [15 : 0] BCD_code 
);
    logic [31 : 0] shift_reg;
    logic ready;
    integer i;

    always_ff @(posedge reset or posedge valid) begin
        if (reset) begin
            shift_reg <= 32'b0;
            ready <= 1'b0;
        end else if (valid) begin
            shift_reg = {16'b0, mult_result};

            for(i = 0; i < 16; i++) begin
                if(shift_reg[19 : 16] > 4)
                    shift_reg[19 : 16] = shift_reg[19 : 16] + 3;
                if(shift_reg[23 : 20] > 4)
                    shift_reg[23 : 20] = shift_reg[23 : 20] + 3;
                if(shift_reg[27 : 24] > 4)
                    shift_reg[27 : 24] = shift_reg[27 : 24] + 3;
                if(shift_reg[31 : 28] > 4)
                    shift_reg[31 : 28] = shift_reg[31 : 28] + 3;

                shift_reg = shift_reg << 1;
            end

            ready = 1'b1;
        end
    end

    assign BCD_code = shift_reg[31 : 16];
    assign BCD_ready = ready;
endmodule
