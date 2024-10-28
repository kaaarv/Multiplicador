module module_dato (

    input logic clk,
    input logic rst,
    input logic dato_listo_i,
    input logic [1 : 0] dato_codc_i,
    input logic [1 : 0] dato_codf_i,

    output logic [3 : 0] dato_o //Numero en binario de la tecla presionada
    
);

    logic [3 : 0] pos; //Numero de posicion de la tecla
    logic [3 : 0] dato = 4'd15; 

    always_ff @( posedge clk ) begin 

        if (!rst) begin
            pos <= 0;
        end

        else if (dato_listo_i) begin
            pos [3 : 2] <= dato_codc_i;
            pos [1 : 0] <= dato_codf_i;
            
        end
    end

    always_comb begin 
        case (pos)
                0 : dato <= 4'd1;
                1 : dato <= 4'd2;
                2 : dato <= 4'd3;
                4 : dato <= 4'd4;
                5 : dato <= 4'd5;
                6 : dato <= 4'd6;
                8 : dato <= 4'd7;
                9 : dato <= 4'd8;
                10 : dato <= 4'd9;
                13 : dato <= 4'd0;
                default: dato <= 4'd15; // Indica error en la logica secuencial
            endcase
    end
    assign dato_o = dato;

endmodule