`timescale 1 ns / 100 ps


module module_Debounce #(parameter N = 4) ( 
    input logic clk,
    input logic n_reset,
    input logic [3:0] key_in,
    output logic [3:0] debounced_key,
    output logic data_available
);

    logic [N-1:0] q_reg;          // Contador para el debouncing
    logic [3:0] stable_key;        // Clave estable
    logic [3:0] prev_key;          // Para detectar cambios
    logic stable;                  // Bandera de estabilidad

    always_ff @(posedge clk or negedge n_reset) begin
        if (!n_reset) begin
            q_reg <= 0;
            debounced_key <= 4'b0000;
            data_available <= 0;
            stable_key <= 4'b0000;
            prev_key <= 4'b0000;
            stable <= 0;
        end else begin
            if (key_in == stable_key) begin
                if (q_reg < {N{1'b1}}) begin
                    q_reg <= q_reg + 1;
                end else begin
                    if (!stable) begin
                        debounced_key <= stable_key;
                        data_available <= 1; // Indica que hay datos disponibles
                        stable <= 1; // Estable
                    end
                end
            end else begin
                q_reg <= 0;                // Reiniciar el contador
                stable_key <= key_in;      // Actualizar la clave estable
                stable <= 0;               // Reiniciar la estabilidad
                data_available <= 0;       // No hay datos disponibles
            end
        end
    end

    // Siempre que se detecte un nuevo valor, se resetea el anterior
    always_ff @(posedge clk) begin
        if (debounced_key != stable_key) begin
            prev_key <= debounced_key;
        end
    end

endmodule

