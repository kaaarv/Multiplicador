module top(
    input logic clk,
    input logic rst,
    input logic [3 : 0] dipswitch,
    output logic [6 : 0] segments,                   
    output logic [3 : 0] display_select,
    output logic sign
);
    logic [15 : 0] numero;
    logic valid = 1'd1;
    logic [15 : 0] magnitud;
    logic mult_sign_magnitude_ready;
    logic BCD_ready;
    logic [15 : 0] BCD_code;
    logic clk_display;

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

    clk_displays U_clk_displays (
        .clk(clk),
        .reset(rst),
        .clk_display(clk_display)
    );

    display_multiplexer U_display_multiplexer (
        .clk (clk_display),
        .reset (rst),
        .valid_BCD(BCD_ready),
        .BCD_code (BCD_code),
        .segments(segments),
        .display_select(display_select)
    );
endmodule