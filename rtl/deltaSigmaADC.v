/*============================================================================*/
/*
 * @file    deltaSigmaADC.v
 * @brief   10bit Delta Sigma ADC
 * @note    
 * @date    2018/11/19
 * @author  kingyo
 */
/*============================================================================*/
module deltaSigmaADC (
    input           i_clk,      // 50MHz
    input           i_rst_n,    // RESET_N
    input           i_cmpans,   // LVDS INPUT
    output          o_cmpdac,   // Compare Base Level
    output  [9:0]   o_adc_dt,   // ADC Result
    output          o_adc_dt_en // data enable(48828.125kHz)
    );
    
    reg             delta;
    reg     [9:0]   adc_dt;
    reg     [9:0]   sigma_cnt;
    reg     [9:0]   sigma;
    reg             data_en;
    
    /* delta sampling */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            delta <= 1'b0;
        end else begin
            delta <= i_cmpans;
        end
    end
    assign o_cmpdac = delta;
    
    /* sigma counter */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            adc_dt <= 10'd0;
            sigma_cnt <= 10'd0;
            sigma <= 10'd0;
            data_en <= 1'b0;
        end else begin
            sigma_cnt <= sigma_cnt + 10'd1;
            if (sigma_cnt == 10'd1023) begin
                adc_dt <= sigma;
                data_en <= 1'b1;
                sigma <= 10'd0;
            end else begin
              sigma <= sigma[9:0] + delta;
              data_en <= 1'b0;
            end
        end
    end
    assign o_adc_dt = adc_dt;
    assign o_adc_dt_en = data_en;

endmodule
    