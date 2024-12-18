// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Subsistema de captura de datos
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila

module module_keypress (

    input logic [1 : 0] dato_codc_i,
    input logic [3 : 0] posf_i, //Nota mental: definir en los constr

    output logic [1 : 0] dato_codf_o,
    output logic [3 : 0] columna_o  //Nota mental: definir en los constr
);

logic [3 : 0] column;
logic [1 : 0] fila;

always_comb begin 

    case (dato_codc_i) 
        2'b00 : column = 4'b1110;
        2'b01 : column = 4'b1101;
        2'b10 : column = 4'b1011;
        2'b11 : column = 4'b0111; 
        default: column = 4'b1110;
    endcase

end

always_comb begin 
    
    case (posf_i)
        4'b1110 : fila = 2'b00;
        4'b1101 : fila = 2'b01;
        4'b1011 : fila = 2'b10;
        4'b0111 : fila = 2'b11;
        default: fila = 2'b00; 
    endcase
end

assign dato_codf_o = fila;
assign columna_o = column;

endmodule
