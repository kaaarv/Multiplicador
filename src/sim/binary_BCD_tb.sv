module binary_BCD_tb();
    logic reset;
    logic [15:0] mult_result;  
    logic valid;

    logic [15:0] BCD_code; 

    binary_BCD uut (
        .reset(reset),
        .mult_result(mult_result),
        .valid(valid),
        .BCD_code(BCD_code)
    );

    task display_BCD;
        input [15:0] BCD; 
        $display("BCD: %d%d%d%d", BCD[15:12], BCD[11:8], BCD[7:4], BCD[3:0]);
    endtask

    initial begin
        $dumpfile("binary_BCD_tb.vcd");  
        $dumpvars(0, binary_BCD_tb); 

        reset = 1;
        valid = 0;
        #10 reset = 0;
        
        mult_result = 16'd45; 
        valid = 1;
        #10;
        valid = 0;
        #50;
        $display("Numero en decimal: 45");
        display_BCD(BCD_code);
        
        mult_result = 16'd123; 
        valid = 1;
        #10;
        valid = 0;
        #50;
        $display("Numero en decimal: 123");
        display_BCD(BCD_code);

        mult_result = 16'd999;
        valid = 1;
        #10;
        valid = 0;
        #50;
        $display("Numero en decimal: 999");
        display_BCD(BCD_code);

        mult_result = 16'd2047;
        valid = 1;
        #10;
        valid = 0;
        #50;
        $display("Numero en decimal: 2047");
        display_BCD(BCD_code);

        mult_result = 16'd256; 
        valid = 1;
        #10;
        valid = 0;
        #50;
        $display("Numero en decimal: 256");
        display_BCD(BCD_code);

        $finish;
    end
endmodule
