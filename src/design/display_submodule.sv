module display_multiplexer(
    input logic clk,
    input logic reset,
    input logic [15 : 0] BCD_code,                      // Resultado en BCD
    output logic [6 : 0] segments,                      // Código para los displays
    output logic [3 : 0] display_select                 // Indica el display activo
);
    logic [3 : 0] units, tens, hundreds, thousands;     // Almacena las cada cifra del BCD
    logic [1 : 0] current_display = 2'b0;               // Código del display activo
    logic [19 : 0] refresh_counter = 19'b0;             // Contador de refresco

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
        extract_bcd(BCD_code);
    end

    always_comb begin
        case(current_display)
            2'b00: begin
                display_select = 4'b1110;                   // Activa el display de unidades
                segments = display_to_segments(units);      // Cambia al dígito de las unidades
            end
            2'b01: begin
                display_select = 4'b1101;                   // Activa el display de decenas
                segments = display_to_segments(tens);       // Cambia al dígito de las decenas
            end
            2'b10: begin
                display_select = 4'b1011;                   // Activa el display de centenas
                segments = display_to_segments(hundreds);   // Cambia al dígito de las centenas
            end
            2'b11: begin
                display_select = 4'b0111;                   // Activa el display de miles
                segments = display_to_segments(thousands);  // Cambia al dígito de los miles
            end
            default: begin
                display_select = 4'b1111; 
                segments = 7'b0000000; 
            end
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

    task automatic extract_bcd(input logic [27:0] BCD_code);
        units = BCD_code[3 : 0];
        tens = BCD_code[7 : 4];
        hundreds = BCD_code[11 : 8];
        thousands = BCD_code[15 : 12];
    endtask
endmodule
