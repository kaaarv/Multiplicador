module prueba (

    input logic [15:0] dipswitch,
    output logic [15:0] numero
);
assign [15:4] numero = 0;
assign [3:0] numero = [3:0] dipswitch;

endmodule