module prueba (
    input logic [3 : 0] dipswitch,
    output logic [15 : 0] numero
);
    assign numero = {12'b0, dipswitch};

endmodule