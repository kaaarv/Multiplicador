`timescale 1 ns / 100 ps


module module_DeBounce (
    input logic clk,              // Reloj
    input logic n_reset,         // Reset activo bajo
    input logic button_in,       // Entrada del botón
    output logic DB_out          // Salida debounce
);

// Parámetro ajustado para un retardo de aproximadamente 15 ms
parameter N = 4; // Número de bits para el contador

// Variables internas
logic [N-1:0] q_reg;        // Contador
logic DFF1, DFF2;           // Flip-flops para la entrada del botón

// Actualización de flip-flops de entrada
always_ff @ (posedge clk or negedge n_reset) begin
    if (!n_reset) begin
        DFF1 <= 1'b0;
        DFF2 <= 1'b0;
        q_reg <= {N{1'b0}};
        DB_out <= 1'b0; // Inicializar salida
    end else begin
        DFF1 <= button_in;
        DFF2 <= DFF1;
        
        // Contador de debounce
        if (DFF1 != DFF2) begin
            q_reg <= {N{1'b0}}; // Reiniciar contador si hay cambio
        end else if (q_reg < {N{1'b1}}) begin
            q_reg <= q_reg + 1; // Incrementar contador
        end
        
        // Control de salida
        if (q_reg == {N{1'b1}}) begin
            DB_out <= DFF2; // Actualizar DB_out solo si el contador ha llegado al máximo
        end
    end
end

endmodule
