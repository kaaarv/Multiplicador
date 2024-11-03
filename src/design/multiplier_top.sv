module multiplier_top (
    input logic rst, clk, valid,
    input logic [7 : 0] num_1,
    input logic [7 : 0] num_2,
    output logic mult_sign, 
    output logic [15 : 0] mult_result 
);
    logic load_M;   
    logic load_Q;   
    logic reset_A;  
    logic reset_Qprev;  
    logic add_M;    
    logic subs_M;   
    logic shift_all;    
    logic mult_DONE;    
    logic sign;     
    logic [15 : 0] result;  
    logic [1 : 0] Qo_Qprev;  

    // Bloque secuencial que controla solo la salida final
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            mult_result <= 0;
            mult_sign <= 0;
        end else if (mult_DONE) begin
            mult_result <= result;
            mult_sign <= sign;
        end
    end
    
    multiplier u_multiplier(
        .clk(clk),
        .reset(rst),
        .load_M(load_M),       
        .load_Q(load_Q),        
        .reset_A(reset_A),  
        .reset_Qprev(reset_Qprev),
        .add_M(add_M),           
        .subs_M(subs_M),       
        .shift_all(shift_all),  
        .num_1(num_1),        
        .num_2(num_2),          
        .Qo_Qprev(Qo_Qprev),     
        .mult_result(result),
        .sign(sign)          
    );

    // Instancia del módulo FSM
    multiplier_FSM u_multiplier_FSM(
        .clk(clk),
        .reset(rst),
        .valid(valid),
        .Qo_Qprev(Qo_Qprev),
        .load_M(load_M),       
        .load_Q(load_Q),        
        .reset_A(reset_A),  
        .reset_Qprev(reset_Qprev),
        .add_M(add_M),           
        .subs_M(subs_M),       
        .shift_all(shift_all),  
        .mult_DONE(mult_DONE)
    );
endmodule
