module module_control (
    input logic clk,
    input logic rst,
    input logic dat_ready, //Definir en los constr
    input logic [3:0] dato,
    output logic [7:0] numero1, numero2,
    output logic valid 
);

    typedef enum logic [3:0] {S0, S1, S2, S3, S4} statetype;
    statetype state, nextstate;

    //S. Internas 
    logic [3:0] unidades1, unidades2, decenas1, decenas2;

    //Redistro de estados
    always_ff @(posedge clk or negedge rst) begin
        
        if (!rst) begin
            state <= S0;
            valid <= '0;
        end

        else if (dat_ready) begin
            state <= nextstate;
        end
    end


    //logica de siguiente estado
    always_comb begin 
        case (state)
            S0: nextstate = S1;
            S1: nextstate = S2;
            S2: nextstate = S3;
            S3: nextstate = S4;
            S4: nextstate = S0; //Muy probablemente sea innecesario
            default: nextstate = S0;
        endcase
        
    end
    

    //Logica de salida
    always_comb begin 
        case (state)
            S0: begin
                valid = 0;
                unidades1 = dato; 
            end

            S1: begin
                valid = 0;
                decenas1 = dato;
            end

            S2: begin
                valid = 0;
                unidades2 = dato;  
            end

            S3: begin
                valid = 0;
                decenas2 = dato; 
            end

            S4: begin
                valid = 1;
                numero1 = (decenas1 << 3) + (decenas1 << 1) + unidades1;
                numero2 = (decenas2 << 3) + (decenas2 << 1) + unidades2;
            end 

            default: begin
                valid = 0;
                unidades1 = '0;
                decenas1 = '0;
                unidades2 = '0;
                decenas2 = '0;
            end
        endcase
        
    end

endmodule