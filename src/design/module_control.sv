//Resumen de estados:
// Estado S0: Captura las decenas del primer número y asigna el signo
// Estado S1: Captura las unidades del primer número
// Estado S2: Captura las decenas del segundo número y asigna el signo
// Estado S3: Captura las unidades del segundo número
// Estado S4: Ensambla los números y activa la señal de validación
`timescale 1 ns / 100 ps
module module_control (
    input logic clk,
    input logic rst,
    input logic dat_ready,       // Señal de disponibilidad de datos
    input logic [3:0] dato,      // Dato de entrada
    input logic signo,           // Signo del número actual. Puede ser un boton
    output logic [7:0] numero1_o, numero2_o, // Salida de los números ensamblados
    output logic valid           // Señal de validación
);

    typedef enum logic [2:0] {S0, S1, S2, S3, S4} statetype;
    statetype state, nextstate;

    // Señales internas
    logic [3:0] unidades1, unidades2, decenas1, decenas2;
    logic [7:0] numero1, numero2;
    logic signo1, signo2;


    // Señales para detección de flanco ascendente
    logic dat_ready_d, dat_ready_rise;

    // Registro de estados y detección de flanco ascendente
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            dat_ready_d <= 0;
        end else begin
            dat_ready_d <= dat_ready;
        end
    end

    assign dat_ready_rise = dat_ready & ~dat_ready_d;

    // Registro de estados controlado por el flanco ascendente de dat_ready
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= S0;
            valid <= 0;
            signo1 <= 0;
            signo2 <= 0;
        end else if (dat_ready_rise) begin
            state <= nextstate;
        end
    end

    // Lógica de siguiente estado
    always_comb begin
        case (state)
            S0: nextstate = S1;
            S1: nextstate = S2;
            S2: nextstate = S3;
            S3: nextstate = S4;
            S4: nextstate = S0;
            default: nextstate = S0;
        endcase
    end


// Lógica de salida de la FSM
always_comb begin
    valid = 0;
    case (state)
        S0: begin
            valid = 0;
            decenas1 = dato; // Utiliza el registro sincronizado
            signo1 = signo;
        end

        S1: begin
            valid = 0;
            unidades1 = dato;
        end

        S2: begin
            valid = 0;
            decenas2 = dato; // Utiliza el registro sincronizado
            signo2 = signo;  
        end

        S3: begin
            valid = 0;
            unidades2 = dato; 
        end

        S4: begin
            valid = 1;
            numero1 = (decenas1 << 3) + (decenas1 << 1) + unidades1;
            numero2 = (decenas2 << 3) + (decenas2 << 1) + unidades2;
        end
    endcase
end

    // Lógica de ajuste de signo
    always_comb begin
        numero1_o = (signo1) ? ~numero1 + 1 : numero1; // Complemento a dos si signo1 es 1
        numero2_o = (signo2) ? ~numero2 + 1 : numero2; // Complemento a dos si signo2 es 1
    end

endmodule