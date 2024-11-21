// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Subsistema de captura de datos
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila

module module_Debounce (
    input logic clk,               
    input logic [3:0] filas_in,    // Entrada de 4 bits (información sobre la fila)
    output logic enable            // Señal de habilitación, activada cuando el dato está estabilizado
);

    // Registro de desplazamiento de 16 bits para almacenar los valores de fila
    logic [15:0] filas_reg;

    // Proceso secuencial para desplazar los bits de la fila en cada flanco positivo del reloj
    always @(posedge clk) begin
        filas_reg <= {filas_in, filas_reg[15:4]}; // Desplaza los bits y añade filas_in en los 4 MSB
        
    end



    // Lógica combinacional para determinar si la fila está estabilizada
    always_ff @(posedge clk) begin
        enable = (filas_reg[15:12] == filas_reg[11:8]) &&
                 (filas_reg[11:8] == filas_reg[7:4]) &&
                 (filas_reg[7:4] == filas_reg[3:0]);
    end

endmodule
