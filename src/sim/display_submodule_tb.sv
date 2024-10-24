module tb_display_multiplexer;

    logic clk;
    logic reset;
    logic [11:0] sum_result;          // Entrada: resultado binario de 12 bits
    logic [6:0] segments;             // Salida: código de segmentos para display de 7 segmentos
    logic [3:0] display_select;       // Salida: selecciona cuál display se muestra (unidades, decenas, centenas, miles)

    // Instanciamos el módulo bajo prueba (DUT)
    display_multiplexer dut (
        .clk(clk),
        .reset(reset),
        .sum_result(sum_result),
        .segments(segments),
        .display_select(display_select)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;    // Ciclo de reloj de 10 unidades de tiempo
    end

    // Proceso de simulación
    initial begin
        $dumpfile("display_multiplexer.vcd"); // Archivo VCD para ver la simulación
        $dumpvars(0, tb_display_multiplexer); // Volcar todas las variables del testbench

        // Inicializamos las señales
        reset = 1;
        sum_result = 12'b0;
        #10 reset = 0;   // Desactivamos reset

        // Caso 1: 9801 (en binario: 12'b1001100011001)
        sum_result = 12'b100110001001;
        #20;
        $display("Test 1: sum_result = 9801");
        $display("Unidades: %0d, Decenas: %0d, Centenas: %0d, Miles: %0d", dut.units, dut.tens, dut.hundreds, dut.thousands);

        // Caso 2: 567 (en binario: 12'b1000110111)
        sum_result = 12'b1000110111;
        #20;
        $display("Test 2: sum_result = 567");
        $display("Unidades: %0d, Decenas: %0d, Centenas: %0d, Miles: %0d", dut.units, dut.tens, dut.hundreds, dut.thousands);

        // Caso 3: 34 (en binario: 12'b00100010)
        sum_result = 12'b00100010;
        #20;
        $display("Test 3: sum_result = 34");
        $display("Unidades: %0d, Decenas: %0d, Centenas: %0d, Miles: %0d", dut.units, dut.tens, dut.hundreds, dut.thousands);

        // Caso 4: 5 (en binario: 12'b00000101)
        sum_result = 12'b00000101;
        #20;
        $display("Test 4: sum_result = 5");
        $display("Unidades: %0d, Decenas: %0d, Centenas: %0d, Miles: %0d", dut.units, dut.tens, dut.hundreds, dut.thousands);

        $finish;
    end
endmodule
