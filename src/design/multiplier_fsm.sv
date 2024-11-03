module multiplier_FSM (
    input logic clk, 
    input logic reset, 
    input logic valid,
    input logic [1 : 0] Qo_Qprev,
    output logic load_M, 
    output logic load_Q, 
    output logic reset_A, 
    output logic reset_Qprev, 
    output logic add_M, 
    output logic subs_M, 
    output logic shift_all,
    output logic mult_DONE
);
    integer counter;
    logic done;

    typedef enum logic [1 : 0]{ 
        IDLE,
        INIT,
        DECIDE,
        SHIFT
    } state_t;
    state_t current_state, next_state;

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            current_state <= IDLE;
            counter <= 0;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        load_M <= 0;
        load_Q <= 0;
        reset_A <= 0;
        reset_Qprev <= 0;
        add_M <= 0;
        subs_M <= 0;
        shift_all <= 0;

        case(current_state)
            IDLE: begin
                if(valid && !done) begin
                    counter <= 0;
                    next_state <= INIT;
                end else begin
                    next_state <= IDLE;
                end
            end

            INIT: begin
                load_M <= 1;
                load_Q <= 1;
                reset_A <= 1;
                reset_Qprev <= 1;
                next_state <= DECIDE;
            end

            DECIDE: begin
                if(Qo_Qprev == 2'b01) begin
                    add_M <= 1;
                end else if(Qo_Qprev == 2'b10) begin
                    subs_M <= 1;
                end
                next_state <= SHIFT;
            end

            SHIFT: begin
                if(counter < 8) begin
                    shift_all <= 1;
                    counter <= counter + 1;
                end

                if(counter >= 8) begin
                    done <= 1;
                    next_state <= IDLE;
                end else begin
                    next_state <= DECIDE;
                    done <= 0;
                end
            end

            default: begin
                next_state <= IDLE;
            end
        endcase
    end

    assign mult_DONE = done;
endmodule