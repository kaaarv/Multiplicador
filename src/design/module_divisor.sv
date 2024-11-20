module module_divisor # (

    parameter COUNT = 13500 

) (

    input logic clk,
    input logic rst,

    output logic prd_out //periodo salida
);

    localparam WIDTH_COUNT = $clog2(COUNT); //Cantidad de bits para representar el numero
    
    logic [WIDTH_COUNT - 1 : 0] clk_counter = 0;//Contador
    logic prd_new = 0;

    always_ff @( posedge clk ) begin 
        
        if (!rst) begin
            prd_new <= 0;
            clk_counter <= 0;
        end

        else if (clk_counter == COUNT -1) begin
            prd_new <= ~prd_new;
            clk_counter <= 0;
        end

        else begin
            clk_counter <= clk_counter + 1;
        end
    end

    assign prd_out = prd_new;

endmodule