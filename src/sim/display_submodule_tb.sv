module display_multiplexer_tb;
    logic clk;
    logic reset;
    logic [15:0] BCD_code;
    logic [6:0] segments;
    logic [3:0] display_select;

    display_multiplexer uut (
        .clk(clk),
        .reset(reset),
        .BCD_code(BCD_code),
        .segments(segments),
        .display_select(display_select)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        $dumpfile("display_multiplexer_tb.vcd");
        $dumpvars(0, display_multiplexer_tb);

        reset = 1;
        BCD_code = 16'b0;
        #10;
        reset = 0;

        BCD_code = 16'b1000010100111001;

        #200;

        $display("------------Prueba 1------------");
        display_all_values(BCD_code);
        #10000;

        reset = 1;
        BCD_code = 16'b0;
        #10;
        reset = 0;

        BCD_code = 16'b1001100101000101;

        #200; 

        $display("------------Prueba 2------------");
        display_all_values(BCD_code);
        #10;

        $finish;
    end

    task display_all_values(input logic [15:0] BCD_code); 
        for (int i = 0; i < 4; i++) begin
            #100000;

            $display("display_select = %b, segments = %b", uut.display_select, uut.segments);

            $display("MILES = %d, CENTENAS = %d, DECENAS = %d, UNIDADES = %d", uut.thousands, uut.hundreds, uut.tens, uut.units);
        end
    endtask
endmodule