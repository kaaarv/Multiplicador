// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Subsistema de despliegue en displays de 7 segmentos (signo y magnitud)
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila

module sign_magnitude(
    input logic clk, reset, valid,
    input logic [15 : 0] mult_result,
    output logic [15 : 0] magnitude,
    output logic sign, mult_sign_magnitude_ready
);
    logic mult_sign;
    logic [15 : 0] mult_magnitude;

    always_ff @(posedge clk or negedge reset) begin
        if(!reset) begin
            mult_sign <= 0;
            mult_magnitude <= 0;
            mult_sign_magnitude_ready <= 0;

        end else if(valid) begin
            mult_sign <= mult_result[15];

            if(mult_sign) begin
                mult_magnitude <= {1'b0, (~mult_result[14 : 0]) + 15'b1};

            end else begin
                mult_magnitude <= mult_result;
            end

            mult_sign_magnitude_ready <= 1;
        end
    end

    assign magnitude = mult_magnitude;
    assign sign = mult_sign;
endmodule
