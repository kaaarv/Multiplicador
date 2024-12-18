// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Subsistema de captura de datos
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila

module module_dato (

    input logic clk,
    input logic rst,
    input logic dato_listo_i,
    input logic [1 : 0] dato_codc_i,
    input logic [1 : 0] dato_codf_i,

    //output logic signo_o,
    output logic [3 : 0] dato_o //Numero en binario de la tecla presionada
    
);

    logic [3 : 0] pos; //Numero de posicion de la tecla
    //logic signo;
    logic [3 : 0] dato; //para identificar errores

    always_ff @( posedge clk ) begin 

        if (!rst) begin
            pos <= 4'd14; //para identificar errores
            //signo <= 0;
        end

        else if (!dato_listo_i) begin
            pos [3 : 2] <= dato_codc_i;
            pos [1 : 0] <= dato_codf_i;
            
        end

        //else if (dato_listo_i) begin
          //  pos  <= 4'd0;
            
            
        //end
    end

    always_comb begin 
        case (pos)
                0 : dato = 4'd1;
                1 : dato = 4'd4;
                2 : dato = 4'd7;
                4 : dato = 4'd2;
                5 : dato = 4'd5;
                6 : dato = 4'd8;
                8 : dato = 4'd3;
                9 : dato = 4'd6;
                10 : dato = 4'd9;
                7 : dato = 4'd0;
                //12 : signo = 1;
                default: dato = dato; // mantiene el valor actual
            endcase
    end
    assign dato_o = dato; //Se niega unicamente para probarlo con los leds de la fpga
    //assign signo_o = signo;

endmodule
