module sign_magnitude_tb;

    logic clk, reset, valid;
    logic [15:0] mult_result;
    logic [15:0] magnitude;
    logic sign, mult_sign_magnitude_ready;

    sign_magnitude uut (
        .clk(clk),
        .reset(reset),
        .valid(valid),
        .mult_result(mult_result),
        .magnitude(magnitude),
        .sign(sign),
        .mult_sign_magnitude_ready(mult_sign_magnitude_ready)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_sign_magnitude.vcd");
        $dumpvars(0, sign_magnitude_tb);
        
        clk = 0;
        reset = 1;
        valid = 0;
        mult_result = 16'h0000;
        
        #10 
        reset = 1;
        valid = 0;
        #10
        reset = 0;

        #10 mult_result = 16'b1111101100100000;
        #10 valid = 1;
        #20 $display("Test 1: mult_result = %0d, magnitude = %0d, sign = %b", $signed(mult_result), magnitude, sign);

        #10 
        reset = 1;
        valid = 0;
        #10
        reset = 0;
        #10 mult_result = 16'b0010000001111100; 
        #10 valid = 1;
        #20 $display("Test 2: mult_result = %0d, magnitude = %0d, sign = %b", $signed(mult_result), magnitude, sign);

        #10 
        reset = 1;
        valid = 0;
        #10
        reset = 0;
        #10 mult_result = 16'b1101100110110111;
        #10 valid = 1;
        #20 $display("Test 3: mult_result = %0d, magnitude = %0d, sign = %b", $signed(mult_result), magnitude, sign);

        #10 
        reset = 1;
        valid = 0;
        #10
        reset = 0;
        #10 mult_result = 16'b0000000001011001;
        #10 valid = 1;
        #20 $display("Test 4: mult_result = %0d, magnitude = %0d, sign = %b", $signed(mult_result), magnitude, sign);

        #30 $finish;
    end
endmodule