/*============================================================================*/
/*
 * @file    barLedDrv.v
 * @brief   74HC595 Bar LED Driver
 * @note    
 * @date    2018/08/02
 * @author  kingyo
 */
/*============================================================================*/
module barLedDrv (
    input           i_clk,      // 50MHz
    input           i_rst_n,
    
    output  reg     o_ser,      // shift data
    output          o_srclk,    // shift clk(posedge)
    output  reg     o_rclk,     // Latch CLK(posedge)
    
    input   [9:0]   i_audioLv_L,
    input   [9:0]   i_audioLv_R
    );
    
    reg     [23:0]  sfr_data;
    reg     [ 5:0]  sfr_cnt;
    reg     [25:0]  pls_1s;
    wire            ld;
    wire    [11:0]  barBitR;
    wire    [11:0]  barBitL;


    /* Audio level => bar LED */
    wire    [11:0]  barLed_L;
    wire    [ 9:0]  barSig_L;
    assign barSig_L = i_audioLv_L;
    assign barLed_L = barSig_L < 10'd512 ? 12'b000000000000 : 
               barSig_L < 10'd554 ? 12'b000000000001 :
               barSig_L < 10'd596 ? 12'b000000000011 :
               barSig_L < 10'd638 ? 12'b000000000111 :
               barSig_L < 10'd680 ? 12'b000000001111 :
               barSig_L < 10'd722 ? 12'b000000011111 :
               barSig_L < 10'd764 ? 12'b000000111111 :
               barSig_L < 10'd806 ? 12'b000001111111 :
               barSig_L < 10'd848 ? 12'b000011111111 :
               barSig_L < 10'd890 ? 12'b000111111111 :
               barSig_L < 10'd932 ? 12'b001111111111 :
               barSig_L < 10'd974 ? 12'b011111111111 :
               12'b111111111111;

    wire    [11:0]  barLed_R;
    wire    [ 9:0]  barSig_R;
    assign barSig_R = i_audioLv_R;
    assign barLed_R = barSig_R < 10'd512 ? 12'b000000000000 : 
               barSig_R < 10'd554 ? 12'b000000000001 :
               barSig_R < 10'd596 ? 12'b000000000011 :
               barSig_R < 10'd638 ? 12'b000000000111 :
               barSig_R < 10'd680 ? 12'b000000001111 :
               barSig_R < 10'd722 ? 12'b000000011111 :
               barSig_R < 10'd764 ? 12'b000000111111 :
               barSig_R < 10'd806 ? 12'b000001111111 :
               barSig_R < 10'd848 ? 12'b000011111111 :
               barSig_R < 10'd890 ? 12'b000111111111 :
               barSig_R < 10'd932 ? 12'b001111111111 :
               barSig_R < 10'd974 ? 12'b011111111111 :
               12'b111111111111;

    /* Peak hold */
    reg     [9:0]   peakLv_L;
    reg     [9:0]   peakLv_R;
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            peakLv_L <= 10'd0;
            peakLv_R <= 10'd0;
        end else begin
            if (peakLv_L < barSig_L) begin
                peakLv_L <= barSig_L;
            end else begin
                if (plssig1s) begin
                    if (peakLv_L > 0) begin
                        peakLv_L <= peakLv_L - 10'd1;   // Auto slow down
                    end
                end
            end

            if (peakLv_R < barSig_R) begin
                peakLv_R <= barSig_R;
            end else begin
                if (plssig1s) begin
                    if (peakLv_R > 0) begin
                        peakLv_R <= peakLv_R - 10'd1;   // Auto slow down
                    end
                end
            end
        end
    end

    /* peak Level LED */
    wire    [11:0]  pbarLed_L;
    assign pbarLed_L = peakLv_L < 10'd512 ? 12'b000000000000 : 
               peakLv_L < 10'd554 ? 12'b000000000001 :
               peakLv_L < 10'd596 ? 12'b000000000010 :
               peakLv_L < 10'd638 ? 12'b000000000100 :
               peakLv_L < 10'd680 ? 12'b000000001000 :
               peakLv_L < 10'd722 ? 12'b000000010000 :
               peakLv_L < 10'd764 ? 12'b000000100000 :
               peakLv_L < 10'd806 ? 12'b000001000000 :
               peakLv_L < 10'd848 ? 12'b000010000000 :
               peakLv_L < 10'd890 ? 12'b000100000000 :
               peakLv_L < 10'd932 ? 12'b001000000000 :
               peakLv_L < 10'd974 ? 12'b010000000000 :
               12'b100000000000;

    wire    [11:0]  pbarLed_R;
    assign pbarLed_R = peakLv_R < 10'd512 ? 12'b000000000000 : 
               peakLv_R < 10'd554 ? 12'b000000000001 :
               peakLv_R < 10'd596 ? 12'b000000000010 :
               peakLv_R < 10'd638 ? 12'b000000000100 :
               peakLv_R < 10'd680 ? 12'b000000001000 :
               peakLv_R < 10'd722 ? 12'b000000010000 :
               peakLv_R < 10'd764 ? 12'b000000100000 :
               peakLv_R < 10'd806 ? 12'b000001000000 :
               peakLv_R < 10'd848 ? 12'b000010000000 :
               peakLv_R < 10'd890 ? 12'b000100000000 :
               peakLv_R < 10'd932 ? 12'b001000000000 :
               peakLv_R < 10'd974 ? 12'b010000000000 :
               12'b100000000000;

    /* mix now val and peak hold level */
    assign barBitL = barLed_L | pbarLed_L;
    assign barBitR = barLed_R | pbarLed_R;

    /* create serial clock */
    reg sfr_clk_ff;
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            sfr_clk_ff <= 1'b0;
        end else begin
            sfr_clk_ff <= ~sfr_clk_ff;
        end
    end
    assign o_srclk = sfr_clk_ff;
    
    /* 1s pulse gen */
    wire plssig1s;
    assign plssig1s = (pls_1s == 26'd500000 - 1);   // 1kHz
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            pls_1s <= 26'd0;
        end else if (plssig1s) begin
            pls_1s <= 26'd0;
        end else begin
            pls_1s <= pls_1s + 26'd1;
        end
    end

    /* send shift data */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            sfr_data <= 24'd0;
            o_ser <= 1'b0;
            sfr_cnt <= 6'd0;
            o_rclk <= 1'b0;
        end else if (ld) begin
            sfr_data <= {barBitR[3], barBitR[6], barBitR[2], barBitR[5], barBitR[1], barBitR[4],
                        barBitR[0], barBitR[11], barBitL[3], barBitR[10], barBitL[2], barBitR[9],
                        barBitL[1], barBitR[8], barBitL[0], barBitL[11], barBitL[7], barBitL[10], 
                        barBitL[6], barBitL[9], barBitL[5], barBitL[8], barBitL[4], barBitR[7]};
            sfr_cnt <= 6'd0;
            o_rclk <= 1'b1;
            
        end else if (sfr_clk_ff) begin
            o_ser <= sfr_data[23];
            sfr_data[23:0] <= {sfr_data[22:0], 1'b0};   // Left Shift
            sfr_cnt <= sfr_cnt + 6'd1;
            o_rclk <= 1'b0;
        end
    end
    assign ld = (sfr_cnt == 6'd24);
    
endmodule
    