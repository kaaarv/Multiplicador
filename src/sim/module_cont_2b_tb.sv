`timescale 1ns/1ps

module module_cont_2b_tb;


    logic clk;
    logic rst;
    logic stop;
    logic [1:0] cont_out;

    
    module_cont_2b uut (
        .clk (clk),
        .rst (rst),
        .stop (stop),
        .cont_out (cont_out)
    );


    initial begin
        
        clk = 0;
        rst = 1;
        stop = 0;

        //#30 rst = 0;

        //#30 rst = 1;

        #30 stop = 1;

        #120 stop = 0;

        #160 rst = 0;

        #170 stop = 1;

        #180 rst = 1;

        #200 stop = 0;

        #1000;
        $finish;
    end

    always begin
        clk = ~ clk;
        #10;
    end

    // Dumps de la simulación para visualización en GTKWAVE
    initial begin
        $dumpfile("module_cont_2b_tb.vcd");
        $dumpvars(0, module_cont_2b_tb);
    end

endmodule
