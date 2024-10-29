typedef struct {
    logic load_M;
    logic load_Q;
    logic reset_A;
    logic reset_Qprev;
    logic add_A;
    logic subs_A;
    logic shift_all;
} mult_control_t;

module multiplier_FSM (
    input logic clk, reset, valid,
    input logic [1 : 0] Qo_Qprev,
    output logic mult_DONE,
    output mult_control_t mult_control
)
    logic [3 : 0] N;
    logic done;

    typedef enum logic [1 : 0]{     //Codificación de los estados según Q0 y Q-1
        IDLE,
        INIT,
        DECIDE,
        SHIFT
    } state_t;
    state_t current_state, next_state;

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            current_state <= IDLE;
            N <= 4'd8;
            done <= 'b0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        case(current_state)
        IDLE: begin
        end

        INIT: begin
        end

        DECIDE: begin
        end

        SHIFT: begin
        end

        default: begin
            next_state = IDLE;
        end
        endcase
    end

    assign mult_DONE = done;

endmodule