`timescale 1ns/1ps

module module_divisor_tb;

    parameter COUNT = 13500;

    logic clk;
    logic rst;
    logic prd_out;

    // Instancia del módulo bajo prueba (module_divisor)
    module_divisor # (.COUNT(COUNT)) uut (
        .clk (clk),
        .rst (rst),
        .prd_out (prd_out)
    );


    initial begin
        
        clk = 0;
        rst = 1;

        #20;

        rst = 0;

        #20

        rst = 1;

        # 2000000;
        $finish;
    end

    always begin
        clk = ~ clk;
        #18;
    end

    // Dumps de la simulación para visualización en GTKWAVE
    initial begin
        $dumpfile("module_divisor_tb.vcd");
        $dumpvars(0, module_divisor_tb);
    end

endmodule
