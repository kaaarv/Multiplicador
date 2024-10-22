module multiplier_FSM (
    input logic clk, reset, valid,
    input logic [15 : 0] mult, 
    output logic start_mult, shift, add_multiplicand, subtract_multiplicand
)
    typedef enum logic [1 : 0]{     //Codificación de los estados según Q0 y Q-1
        S_00,
        S_01,
        S_10,
        S_11
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            current_state <= S_00;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        start_mult = 0;
        shift = 0;
        add_multiplicand = 0;
        subtract_multiplicand = 0;

        case(current_state) 
        S_00: begin
            start_mult = 1;
            shift = 1;
            add_multiplicand = 0;
            subtract_multiplicand = 0;

            if({mult[1], mult[0]} == 2'b01) begin
                next_state = S_01;
            end else if({mult[1], mult[0]} == 2'b10) begin
                next_state = S_10;
            end else if({mult[1], mult[0]} == 2'b11) begin
                next_state = S_11;
            end else begin
                next_state = current_state;
            end
        end

        S_01: begin
            start_mult = 1;
            shift = 1;
            add_multiplicand = 1;
            subtract_multiplicand = 0;

            if({mult[1], mult[0]} == 2'b00) begin
                next_state = S_00;
            end else if({mult[1], mult[0]} == 2'b10) begin
                next_state = S_10;
            end else if({mult[1], mult[0]} == 2'b11) begin
                next_state = S_11;
            end else begin
                next_state = current_state;
            end
        end

        S_10: begin
            start_mult = 1;
            shift = 1;
            add_multiplicand = 0;
            subtract_multiplicand = 1;

            if({mult[1], mult[0]} == 2'b00) begin
                next_state = S_00;
            end else if({mult[1], mult[0]} == 2'b01) begin
                next_state = S_01;
            end else if({mult[1], mult[0]} == 2'b11) begin
                next_state = S_11;
            end else begin
                next_state = current_state;
            end
        end

        S_11: begin
            start_mult = 1;
            shift = 1;
            add_multiplicand = 0;
            subtract_multiplicand = 0;

            if({mult[1], mult[0]} == 2'b00) begin
                next_state = S_00;
            end else if({mult[1], mult[0]} == 2'b10) begin
                next_state = S_10;
            end else if({mult[1], mult[0]} == 2'b01) begin
                next_state = S_01;
            end else begin
                next_state = current_state;
            end
        end
        endcase
    end

endmodule