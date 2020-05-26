/*============================================================================*/
/*
 * @file    nco_tx.v
 * @brief   RF Generator (Simple DDS)
 * @note    
 * @date    2018/06/06
 * @author  kingyo
 */
/*============================================================================*/
module nco_tx (
    input           i_clk,
    input           i_rst_n,
    input   [31:0]  i_addr,
    input           i_en,
    output          o_sig
    );

    reg     [31:0]  acc;
    reg     [31:0]  add_val;

    /* addr val latch */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            add_val[31:0] <= 32'd0;
        end else begin
            add_val[31:0] <= i_addr[31:0];
        end
    end
    
    /* RF DDS Core */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            acc[31:0] <= 32'd0;
        end else if (~i_en) begin
            acc[31:0] <= 32'd0;
        end else begin
            acc[31:0] <= acc[31:0] + add_val[31:0];
        end
    end

    assign o_sig = acc[31];
    
endmodule
    