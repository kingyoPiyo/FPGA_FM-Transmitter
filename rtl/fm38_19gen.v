/*============================================================================*/
/*
 * @file    fm38_19gen.v
 * @brief   Pilot and carrier Generator
 * @note    
 * @date    2018/06/06
 * @author  kingyo
 */
/*============================================================================*/
module fm38_19kHz_gen (
    input           i_clk,  // 50MHz
    input           i_rst_n,
    output          o_38kHz,
    output          o_19kHz
    );
    
    
    reg     [11:0]  cnt1;
    reg             r38;
    reg             r19;
    
    wire            cnt_clr;
    
    assign cnt_clr = (cnt1 == 12'd657); // 50MHz / 38kHz / 2 - 1
    assign o_38kHz = r38;
    assign o_19kHz = r19;
    
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            cnt1 <= 12'd0;
            r38 <= 1'b0;
            r19 <= 1'b0;
        end
        else if (cnt_clr) begin
            cnt1 <= 12'd0;
            r38 <= ~r38;
            if (~r38) begin
                r19 <= ~r19;
            end
        end else begin
            cnt1 <= cnt1 + 12'd1;
        end
    end
    
endmodule
