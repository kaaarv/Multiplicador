module prueba (
    input clk,
    input rst,
    input logic [3 : 0] dipswitch,
    output logic [15 : 0] numero_out
);
    
    logic [15:0] numero;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            numero <= 15'b0;
        end

        else begin
            numero <= {12'b0, dipswitch};
        end

    end
    
    assign numero_out = numero;

endmodule