module top(
    input logic clk,
    input logic rst,
    input logic [3 : 0] dipswitch,
    output logic [6 : 0] segments,                   
    output logic [3 : 0] display_select  

);
    logic [15:0] numero;
    logic valid = 1'd1;
    logic [15:0] magnitud;
    logic sign;
    logic mult_sign_magnitude_ready;
    logic BCD_ready;
    logic BCD_code;

    prueba U_prueba(
        .dipswitch (dipswitch),
        .numero (numero)
    );

    sign_magnitude U_sign_magnitude (
        .clk (clk),
        .reset (rst),
        .valid (valid),
        .mult_result (numero),
        .magnitude (magnitud),
        .sign (sign),
        .mult_sign_magnitude_ready (mult_sign_magnitude_ready)
    );

    binary_BCD U_binary_BCD (
        .clk (clk),
        .reset (rst),
        .valid (mult_sign_magnitude_ready),
        .mult_result (magnitud),
        .BCD_ready (BCD_ready),
        .BCD_code (BCD_code)
    );

    display_submodule U_display_submodule (
        .clk (clk),
        .reset (rst),
        .valid_BCD(BCD_ready),
        .BCD_code (BCD_code),
        .segments(segments),
        .display_select(display_select)
    );



endmodule