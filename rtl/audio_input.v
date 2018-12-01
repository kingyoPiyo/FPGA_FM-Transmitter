/*============================================================================*/
/*
 * @file    audio_input.v
 * @brief   ADC Wrapper
 * @note    
 * @date    2018/06/06
 * @author  kingyo
 */
/*============================================================================*/
module audio_input (
	input			i_clk,
	input			i_rst_n,
	input			i_analog_l,
	input			i_analog_r,
	output			o_cmpdac_l,
	output			o_cmpdac_r,
	output	[9:0]	o_adcdt_l,
	output	[9:0]	o_adcdt_r
	);

	
	deltaSigmaADC ADC_L (
		.i_clk ( i_clk ),
		.i_rst_n ( i_rst_n ),
		.i_cmpans ( i_analog_l ),
		.o_cmpdac ( o_cmpdac_l ),
		.o_adc_dt ( o_adcdt_l[9:0] ),
		.o_adc_dt_en (  )
	);
	
	deltaSigmaADC ADC_R (
		.i_clk ( i_clk ),
		.i_rst_n ( i_rst_n ),
		.i_cmpans ( i_analog_r ),
		.o_cmpdac ( o_cmpdac_r ),
		.o_adc_dt ( o_adcdt_r[9:0] ),
		.o_adc_dt_en (  )
	);
	
endmodule