/*============================================================================*/
/*
 * @file    fm_tx_top.v
 * @brief   MAX10(10M02) based FM Transmitter Top Module
 * @note    
 * @date    2018/06/06
 * @author  kingyo
 */
/*============================================================================*/
module fm_tx (
	input		mco50m,
	input		rst_n,
	input		uart_mosi,
	output		uart_miso,
	output		led_onb,
	output		rf_out,
	output		osc_oe,
	
	input		analog_L,
	output		analog_L_cmp,
	
	input		analog_R,
	output		analog_R_cmp,
	
	output		o_ser,
	output		o_srclk,
	output		o_rclk
	);
	
	
	wire	[15:0]	addr;
	wire	[15:0]	wdata;
	wire			wen;
	wire	[31:0]	reg0000_2;
	wire	[15:0]	reg0004;
	wire	[15:0]	reg0006;
	wire	[15:0]	reg_q;
	wire			clk50m;
	wire			clk1m;
	wire			clk_rfnco;	
	wire	[31:0]	rf_mod_sig;	// 250MHz
	wire	[9:0]	audio_l;
	wire	[9:0]	audio_r;

	assign osc_oe = 1'b1;
	assign led_onb = 1;
	
	
	/* PLL */
	PLL	PLL_inst (
		.areset ( 1'b0 ),
		.inclk0 ( mco50m ),
		.c0 ( clk50m ),
		.c1 ( clk_rfnco ),
		.c2 ( clk1m ),
		.locked (  )
	);
	
	
	/* UART < = > Register I/F */
	uart2reg_if uart2reg_if (
		.i_clk ( clk50m ),
		.i_rst_n ( rst_n ),
		.i_rdata ( reg_q ),
		.i_uart_mosi ( uart_mosi ),
		.o_rwaddr ( addr ),
		.o_wdata ( wdata ),
		.o_wen ( wen ),
		.o_uart_miso ( uart_miso )
	);
	
	
	/* Register Map (FF) */
	reg_map reg_map_inst (
		.i_clk ( clk50m ),
		.i_rst_n ( rst_n ),
		.i_addr ( addr[15:0] ),
		.i_wdata ( wdata[15:0] ),
		.i_wen ( wen ),
		.o_q ( reg_q ),
		.o_reg0000 ( reg0000_2[15:0] ),
		.o_reg0002 ( reg0000_2[31:16] ),
		.o_reg0004 ( reg0004[15:0] ),
		.o_reg0006 ( reg0006[15:0] )
	);
	
	
	/* Audio Signal Input */
	audio_input audio_input_inst (
		.i_clk ( clk50m ),
		.i_rst_n ( rst_n ),
		.i_analog_l ( analog_L ),
		.i_analog_r ( analog_R ),
		.o_cmpdac_l ( analog_L_cmp ),
		.o_cmpdac_r ( analog_R_cmp ),
		.o_adcdt_l ( audio_l ),
		.o_adcdt_r ( audio_r )
	);
	
	
	/* FM signal Mix */
	fmSigMix fmSigMix_inst (
		.i_clk ( clk50m ),			// 50MHz
		.i_clk_rf ( clk_rfnco ),	// 250MHz
		.i_rst_n ( rst_n ),
		.i_audio_l ( audio_l ),
		.i_audio_r ( audio_r ),
		.i_audio_gain ( reg0004 ),
		.i_pilot_gain ( reg0006 ),
		.i_rf_freq ( reg0000_2 ),
		.o_rf_mod_sig ( rf_mod_sig )
	);
	
	
	/* NCO Module (RF Gen) */
	nco_tx nco_tx_inst (
		.i_clk ( clk_rfnco ),
		.i_rst_n ( rst_n ),
		.i_addr ( rf_mod_sig ),
		.i_en ( 1'b1 ),
		.o_sig ( rf_out )
	);
	
	/* Bar LED Driver */
	barLedDrv barLedDrv_inst (
		.i_clk ( clk50m ),		// 50MHz
		.i_rst_n ( rst_n ),

		.o_ser ( o_ser ),		// shift data
		.o_srclk ( o_srclk ),	// shift clk(posedge)
		.o_rclk ( o_rclk ),		// Latch CLK(posedge)

		.i_audioLv_L ( audio_l ),
		.i_audioLv_R ( audio_r )
	);

endmodule
