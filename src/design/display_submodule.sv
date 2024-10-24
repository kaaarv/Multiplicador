module display_multiplexer(
    input logic clk,
    input logic reset,
    input logic [11:0] BCD_code,                      // Resultado en BCD
    input logic sign,                                 // Signo del valor
    output logic [6:0] segments,                      // Código para los displays
    output logic [3:0] display_select                 // Indica el display activo
);
    logic [3:0] units, tens, hundreds, thousands;     // Almacena las cada cifra del BCD
    logic [1:0] current_display = 2'b0;               // Código del display activo
    logic [19:0] refresh_counter = 19'b0;             // Contador de refresco

    always_comb begin
        units = BCD_code[15 : 12];         // Extrae las unidades
        tens = BCD_code[19 : 16];          // Extrae las decenas
        hundreds = BCD_code[23 : 20];      // Extrae las centenas
        thousands = BCD_code[27 : 24];     // Extrae los miles
    end

    // Contador de refresco y selección de display
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            refresh_counter <= 0;
            current_display <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
            
            if (refresh_counter == 10000) begin
                refresh_counter <= 0;
                current_display <= current_display + 1;
            end
        end
    end

    always_comb begin
        case(current_display)
            2'b00: display_select = 4'b1110;          // Display para unidades
            2'b01: display_select = 4'b1101;          // Display para decenas
            2'b10: display_select = 4'b1011;          // Display para centenas
            2'b11: display_select = 4'b0111;          // Display para miles
            default: display_select = 4'b1111; 
        endcase
    end
    
    always_comb begin                                 // Asigna el código para el display
        segments = 7'b0000000;
        case(display_select)
            4'b1110: segments = display_to_segments(units);
            4'b1101: segments = display_to_segments(tens);
            4'b1011: segments = display_to_segments(hundreds);
            4'b0111: segments = display_to_segments(thousands);
            default: segments = 7'b0000000;
        endcase
    end

    function [6:0] display_to_segments(input logic [3:0] digit);
        case(digit)
            4'd0: display_to_segments = 7'b1111110;
            4'd1: display_to_segments = 7'b0110000;
            4'd2: display_to_segments = 7'b1101101; 
            4'd3: display_to_segments = 7'b1111001;
            4'd4: display_to_segments = 7'b0110011; 
            4'd5: display_to_segments = 7'b1011011;
            4'd6: display_to_segments = 7'b1011111; 
            4'd7: display_to_segments = 7'b1110000;
            4'd8: display_to_segments = 7'b1111111; 
            4'd9: display_to_segments = 7'b1110011; 
            default: display_to_segments = 7'b0000000;
        endcase
    endfunction
endmodule
