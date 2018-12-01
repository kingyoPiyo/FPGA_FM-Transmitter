/*============================================================================*/
/*
 * @file    reg_map.v
 * @brief   Register Map
 * @note    
 * @date    2018/06/06
 * @author  kingyo
 */
/*============================================================================*/
module reg_map (
	input 				i_clk,
	input				i_rst_n,
	input		[15:0]	i_addr,
	input		[15:0]	i_wdata,
	input				i_wen,
	output	reg	[15:0]	o_q,
	
	output	reg	[15:0]	o_reg0000,
	output	reg	[15:0]	o_reg0002,
	output	reg	[15:0]	o_reg0004,
	output	reg	[15:0]	o_reg0006
	);
	
	wire	[15:0]	tmp_rdata;

	////
	always @(posedge i_clk or negedge i_rst_n) begin
		if (~i_rst_n)
			o_reg0000 <= 16'h0000;
		else if (decode_0x0000 && i_wen)
			o_reg0000 <= i_wdata[15:0];
	end

	always @(posedge i_clk or negedge i_rst_n) begin
		if (~i_rst_n)
			o_reg0002 <= 16'h0000;
		else if (decode_0x0002 && i_wen)
			o_reg0002 <= i_wdata[15:0];
	end

	always @(posedge i_clk or negedge i_rst_n) begin
		if (~i_rst_n)
			o_reg0004 <= 16'h0000;
		else if (decode_0x0004 && i_wen)
			o_reg0004 <= i_wdata[15:0];
	end

	always @(posedge i_clk or negedge i_rst_n) begin
		if (~i_rst_n)
			o_reg0006 <= 16'h0000;
		else if (decode_0x0006 && i_wen)
			o_reg0006 <= i_wdata[15:0];
	end
	////


	/* Address Decoder Result */
	wire	decode_0x0000;
	wire	decode_0x0002;
	wire	decode_0x0004;
	wire	decode_0x0006;

	/* Address Decoder */
	assign	decode_0x0000 = (i_addr[15:0] == 16'h0000) ? 1'b1 : 1'b0;
	assign	decode_0x0002 = (i_addr[15:0] == 16'h0002) ? 1'b1 : 1'b0;
	assign	decode_0x0004 = (i_addr[15:0] == 16'h0004) ? 1'b1 : 1'b0;
	assign	decode_0x0006 = (i_addr[15:0] == 16'h0006) ? 1'b1 : 1'b0;

	assign tmp_rdata[15:0] = 	(decode_0x0000) ? o_reg0000 :
								(decode_0x0002) ? o_reg0002 :
								(decode_0x0004) ? o_reg0004 :
								(decode_0x0006) ? o_reg0006 :
								16'd0;

	always @(posedge i_clk or negedge i_rst_n) begin
		if (~i_rst_n) begin
			o_q[15:0] <= 16'h0000;
		end else if (~i_wen) begin
			o_q[15:0] <= tmp_rdata[15:0];
		end
	end

endmodule
