// ------------Tecnológico de Costa Rica-----------
// Escuela de Ingeniería Electrónica: Diseño Lógico

// Subsistema multiplicador (FSM) con el algoritmo de Booth
// Pablo Elizondo Espinoza
// Eduardo Tencio Solano
// Karina Quiros Avila

module multiplier_FSM (
    input logic clk, 
    input logic reset, 
    input logic valid,
    input logic [1 : 0] Qo_Qprev,
    output logic load_M, 
    output logic load_Q, 
    output logic load_add,
    output logic shift_all,
    output reg ready
);
    logic [3 : 0] counter;

    typedef enum logic [2 : 0]{ 
        IDLE = 3'b000,
        INIT = 3'b001,
        DECIDE = 3'b010,
        SUBSTRACT = 3'b011, 
        ADD = 3'b100,
        SHIFT = 3'b101,
        CHECK = 3'b110
    } state_t;
    state_t current_state, next_state;

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            counter <= 0;
        end else if(shift_all) begin
            counter <= counter + 1;
        end

    end

    always_comb begin
        case(current_state)
            IDLE: begin
                if(valid) begin
                    next_state = INIT;
                end else begin
                    next_state = current_state;
                end
            end

            INIT: begin
                next_state = DECIDE;
            end

            DECIDE: begin
                if(Qo_Qprev == 2'b00 || Qo_Qprev == 2'b11) begin
                    next_state = SHIFT;
                end else if(Qo_Qprev == 2'b01) begin
                    next_state = ADD;
                end else if(Qo_Qprev == 2'b10) begin
                    next_state = SUBSTRACT;
                end else begin
                    next_state = current_state;
                end
            end

            SUBSTRACT: begin
                next_state = SHIFT;
            end

            ADD: begin
                next_state = SHIFT;
            end

            SHIFT: begin
                if( counter < 9) begin
                    next_state = DECIDE;
                end else if(counter == 9) begin
                    next_state = CHECK;
                end else begin
                    next_state = current_state;
                end
            end

            CHECK: begin
                if(reset) begin
                    next_state = IDLE;
                end else begin
                    next_state = current_state;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    always_comb begin
        load_add = 0;
        load_M = 0;
        load_Q = 0;
        shift_all = 0;
        ready = 0;

        case(current_state)
            IDLE: begin  
            end

            INIT: begin
                load_M = 1;
                load_Q = 1;
                load_add = 1;
            end

            DECIDE: begin
            end

            SUBSTRACT: begin
                load_add = 1;
            end

            ADD: begin
                load_add = 1;
            end

            SHIFT: begin 
                shift_all = 1;
            end

            CHECK: begin 
                ready = 1;
            end
        endcase
    end
endmodule