module module_cont_2b (

    input logic clk,
    input logic rst,
    input logic stop,

    output logic [1 : 0] cont_out //contador de 2 bits
);

    logic [1 : 0] cont = 0;
    
    always_ff @( posedge clk ) begin 

        if (!rst) begin
            cont <= 0;
        end

        else if (cont == 3) begin
            cont <= 0;
        end
        
        else if (stop) begin
            cont <= cont + 1;
        end

        else if (!stop) begin
            cont <= cont;
        end

    end

    assign cont_out = cont;

endmodule