`timescale 1ns / 1ps

module tb_top;

    reg clk;
    reg rst;
    reg [3:0] dipswitch;
    integer i;

    logic [6:0] segments;
    logic [3:0] display_select;
    logic sign;

    top U_top (
        .clk(clk),
        .rst(rst),
        .dipswitch(dipswitch),
        .segments(segments),
        .display_select(display_select),
        .sign(sign)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        rst = 0;
        dipswitch = 4'b0000;

        $dumpfile("top_tb.vcd");
        $dumpvars(0, tb_top);   

        rst = 1;
        #10 rst = 0; 

        #10 dipswitch = 4'b0001; // Número 1
        #16670000; // Esperar 16.67 ms

        #10 dipswitch = 4'b0010; // Número 2
        #16670000; // Esperar 16.67 ms

        #10 dipswitch = 4'b0100; // Número 4
        #16670000; // Esperar 16.67 ms

        #10 dipswitch = 4'b1000; // Número 8
        #16670000; // Esperar 16.67 ms


        #10 dipswitch = 4'b1111; // Número 15
        #16670000; // Esperar 16.67 ms

        $finish;
    end

    initial begin
        $monitor("Time = %0t, dipswitch = %b, segments = %b, display_select = %b, sign = %b",
                 $time, dipswitch, segments, display_select, sign); // Monitorear también el signo
    end

    always begin
        #1;
    end
endmodule