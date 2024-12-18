// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Subsistema de despliegue en displays de 7 segmentos
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila

module display_code(
    input logic clk,
    input logic reset, valid_BCD,
    input logic [15 : 0] BCD_code,                  
    output logic [6 : 0] segments,                   
    output logic [3 : 0] display_select           
);
    logic [3 : 0] units, tens, hundreds, thousands;   
    logic [1 : 0] current_display = 2'b0;         
    logic [19 : 0] refresh_counter = 19'b0;     

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            refresh_counter <= 0;
            current_display <= 0;
        end else if(valid_BCD)begin
            refresh_counter <= refresh_counter + 1;

            if(refresh_counter == 167) begin
                refresh_counter <= 0;

                if(current_display < 3) begin
                    current_display <= current_display + 1;
                end else begin
                    current_display <= 0;
                end
            end
        end
    end

    always_comb begin
        extract_bcd(BCD_code);
    end

    always_comb begin
        case(current_display)
            2'b00: begin
                display_select = 4'b0001;                   // Activa el display de unidades
                segments = display_to_segments(units);      // Cambia al dígito de las unidades
            end
            2'b01: begin
                display_select = 4'b0010;                   // Activa el display de decenas
                segments = display_to_segments(tens);       // Cambia al dígito de las decenas
            end
            2'b10: begin
                display_select = 4'b0100;                   // Activa el display de centenas
                segments = display_to_segments(hundreds);   // Cambia al dígito de las centenas
            end
            2'b11: begin
                display_select = 4'b1000;                   // Activa el display de miles
                segments = display_to_segments(thousands);  // Cambia al dígito de los miles
            end
            default: begin
                display_select = 4'b0000; 
                segments = 7'b0000000; 
            end
        endcase
    end

    function [6:0] display_to_segments(input logic [3 : 0] digit);
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

    task automatic extract_bcd(input logic [15 : 0] BCD_code);
        units = BCD_code[3 : 0];
        tens = BCD_code[7 : 4];
        hundreds = BCD_code[11 : 8];
        thousands = BCD_code[15 : 12];
    endtask
endmodule
