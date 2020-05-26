/*============================================================================*/
/*
 * @file    fmSigMix.v
 * @brief   FM signal mixer and modulator
 * @note    
 * @date    2018/06/06
 * @author  kingyo
 */
/*============================================================================*/
module fmSigMix (
    input           i_clk,      // CLK 50MHz
    input           i_clk_rf,   // CLK 250MHz
    input           i_rst_n,
    
    input   [ 9:0]   i_audio_l,
    input   [ 9:0]   i_audio_r,
    
    input   [15:0]  i_audio_gain,
    input   [15:0]  i_pilot_gain,
    input   [31:0]  i_rf_freq,
    
    output  [31:0]  o_rf_mod_sig
    );

    wire    [26:0]  rf_mod;
    wire    [ 9:0]  mpx_data;
    wire            sw38kHz;
    wire            sw19kHz;
    reg     [31:0]  r_rf_mod_sig;
    
    /* 38kHz 19kHz Generator */
    fm38_19kHz_gen fm38_19kHz_gen_inst (
        .i_clk ( i_clk ),
        .i_rst_n ( i_rst_n ),
        .o_38kHz ( sw38kHz ),
        .o_19kHz ( sw19kHz )
    );
    
    /* MUX(38kHz) */
    assign mpx_data = sw38kHz ? i_audio_l[9:0] : i_audio_r[9:0];
    assign rf_mod[26:0] = (sw19kHz * {i_pilot_gain[15:0], 1'b0}) + (mpx_data[9:0] * i_audio_gain[15:0]); // 17 + 26bit = 27bit
    
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            r_rf_mod_sig <= 32'd0;
        end else begin
            r_rf_mod_sig <= i_rf_freq[31:0] + rf_mod[26:0];
        end
    end
    
    assign o_rf_mod_sig = r_rf_mod_sig;
    
endmodule
