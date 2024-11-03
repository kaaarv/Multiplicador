module multiplier_top_tb;
    // Declaración de señales para el test bench
    logic clk;
    logic rst;
    logic valid;
    logic [7:0] num_1;
    logic [7:0] num_2;
    logic mult_sign;
    logic [15:0] mult_result;

    // Instanciar el módulo a probar
    multiplier_top u_multiplier_top (
        .rst(rst),
        .clk(clk),
        .valid(valid),
        .num_1(num_1),
        .num_2(num_2),
        .mult_sign(mult_sign),
        .mult_result(mult_result)
    );

    // Generar un reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Cambiar el reloj cada 5 unidades de tiempo
    end

    // Inicializar señales y aplicar estímulos
    initial begin

        // Iniciar el archivo VCD
        $dumpfile("multiplier_top_tb.vcd"); // Nombre del archivo VCD
        $dumpvars(0, multiplier_top_tb); // Registrar todas las señales del test bench

        // Inicializar
        rst = 1;
        valid = 0;
        num_1 = 8'b0;
        num_2 = 8'b0;

        // Aplicar reset
        #20 rst = 0; // Liberar el reset después de 20 unidades de tiempo

        // Prueba 1: Multiplicar 3 (0000_0011) por 4 (0000_0100)
        num_1 = 8'b00000011;
        num_2 = 8'b00000100;
        valid = 1; // Habilitar la señal de validación

        // Esperar a que la multiplicación termine
        wait(u_multiplier_top.mult_DONE); // Cambiar mult_done por mult_DONE
        #10; // Tiempo de espera adicional

        // Verificar el resultado
        if (mult_result !== 12) begin
            $display("Error: Resultado incorrecto. Esperado: 12, Obtenido: %0d", mult_result);
        end else begin
            $display("Prueba 1: %d * %d = %d, Signo: %b", num_1, num_2, mult_result, mult_sign);
        end

        // Reiniciar para la siguiente prueba
        rst = 1;
        valid = 0;
        num_1 = 8'b0;
        num_2 = 8'b0;
        #20 rst = 0;

        // Prueba 2: Multiplicar 5 (0000_0101) por 6 (0000_0110)
        num_1 = 8'b00000101;
        num_2 = 8'b00000110;
        valid = 1; // Habilitar la señal de validación

        // Esperar a que la multiplicación termine
        wait(u_multiplier_top.mult_DONE); // Cambiar mult_done por mult_DONE
        #10; // Tiempo de espera adicional

        // Verificar el resultado
        if (mult_result !== 30) begin
            $display("Error: Resultado incorrecto. Esperado: 30, Obtenido: %0d", mult_result);
        end else begin
            $display("Prueba 2: %d * %d = %d, Signo: %b", num_1, num_2, mult_result, mult_sign);
        end

        // Finalizar la simulación
        #10;
        $finish;
    end
endmodule
