module module_Debounce (
    input logic clk,               
    input logic [3:0] filas_in,    // Entrada de 4 bits (información sobre la fila)
    output logic enable            // Señal de habilitación, activada cuando el dato está estabilizado
);

    // Registro de desplazamiento de 4 bits para almacenar los valores de fila
    logic [3:0][3:0] filas_reg;

    // Proceso secuencial para desplazar los bits de la fila en cada flanco positivo del reloj
    always @(posedge clk) begin
        filas_reg <= {filas_in, filas_reg[3:1]}; // Desplaza los bits
    end

    // Señales auxiliares para almacenar cada bit de filas_reg
    logic filas_reg_3, filas_reg_2, filas_reg_1, filas_reg_0;

    // Asignamos los valores de cada bit de filas_reg a variables auxiliares
    assign filas_reg_3 = filas_reg[3];
    assign filas_reg_2 = filas_reg[2];
    assign filas_reg_1 = filas_reg[1];
    assign filas_reg_0 = filas_reg[0];

    // Lógica combinacional para determinar si la fila está estabilizada
    //always_comb begin
      //  enable = (filas_reg_3 & ~filas_reg_2 & ~filas_reg_1 & ~filas_reg_0); 
    //end

    always_comb begin
    enable = (filas_reg[3] == filas_reg[2]) &&
             (filas_reg[2] == filas_reg[1]) &&
             (filas_reg[1] == filas_reg[0]);
end

endmodule
