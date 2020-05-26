/*============================================================================*/
/*
 * @file    uart2reg.v
 * @brief   UART to Register I/F
 * @note    
 * @date    2018/11/19
 * @author  kingyo
 */
/*============================================================================*/
module uart2reg_if (
    input           i_clk,
    input           i_rst_n,
    input   [15:0]  i_rdata,
    input           i_uart_mosi,
    
    output  [15:0]  o_rwaddr,
    output  [15:0]  o_wdata,
    output          o_wen,
    output          o_uart_miso
    );


    wire    [ 7:0]  uart_rx_data;
    wire    [ 7:0]  uart_tx_data;
    wire            dataen;
    reg             ReadByteCmp;
    reg     [ 3:0]  readByteCnt;
    reg     [ 3:0]  writeByteCnt;
    reg     [47:0]  uartReadBuf;
    reg     [47:0]  uartWriteBuf;
    reg     [15:0]  rwaddr;
    reg     [15:0]  wdata;

    reg             wen;
    reg             uart_tx_ready;
    reg     [ 3:0]  read_trg;       // delay
    wire            uartTxDataLatch_pls;
    wire            uartTxStart_pls;
    reg             uartTxBusy;
    reg             uartTxen;
    wire            tx_empty;

    /* Read Byte Counter */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n)
            readByteCnt <= 4'd0;
        else if (dataen)
            readByteCnt <= readByteCnt + 4'd1;
        else if (ReadByteCmp)
            readByteCnt <= 4'd0;
    end

    /* Uart ReadBuffer Control */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            uartReadBuf <= 48'd0;
            ReadByteCmp <= 0;
        end else if (dataen) begin
            if (readByteCnt == 4'd0)
                uartReadBuf[47:40] <= uart_rx_data;
            else if (readByteCnt == 4'd1)
                uartReadBuf[39:32] <= uart_rx_data;
            else if (readByteCnt == 4'd2)
                uartReadBuf[31:24] <= uart_rx_data;
            else if (readByteCnt == 4'd3)
                uartReadBuf[23:16] <= uart_rx_data;
            else if (readByteCnt == 4'd4)
                uartReadBuf[15:8] <= uart_rx_data;
            else if (readByteCnt == 4'd5) begin
                uartReadBuf[7:0] <= uart_rx_data;
                ReadByteCmp <= 1'b1;
            end
        end else begin
            ReadByteCmp <= 1'b0;
        end
    end

    /* MOSI decoder */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            wen <= 1'b0;
            rwaddr <= 16'd0;
            wdata <= 16'd0;
            read_trg <= 4'd0;
        end else if (ReadByteCmp) begin
            if (uartReadBuf[47:40] == 8'h01) begin
                /* Write CMD */
                wen <= 1'b1;
                rwaddr <= uartReadBuf[39:24];   // addr 16byte
                wdata <= uartReadBuf[23:8];     // data 16byte
                read_trg <= 4'b0001;
            end else if (uartReadBuf[47:40] == 8'h00) begin
                /* Read CMD */
                wen <= 1'b0;
                rwaddr <= uartReadBuf[39:24];   // addr 16byte
                read_trg <= 4'b0001;
            end
        end else begin
            read_trg <= { read_trg[2:0] , 1'b0 };
        end
    end

    assign uartTxDataLatch_pls = read_trg[2];
    assign uartTxStart_pls = read_trg[3];
    assign o_wen = wen;
    assign o_rwaddr = rwaddr;
    assign o_wdata = wdata;


    /* Write Byte Counter */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            writeByteCnt <= 4'd0;
            uartTxBusy <= 1'b0;
            uartTxen <= 1'b0;
        end else if (uartTxStart_pls) begin
            uartTxBusy <= 1'b1;
        end else if (uartTxBusy & tx_empty) begin
            uartTxen <= 1'b1;
        end else if (uartTxen) begin
            writeByteCnt <= writeByteCnt + 4'd1;
            uartTxen <= 1'b0;

            if (writeByteCnt == 4'd5) begin
                writeByteCnt <= 4'd0;
                uartTxBusy <= 1'b0;
            end

        end
    end


    /* Write Buffer latch */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            uartWriteBuf <= 48'd0;
        end else if (uartTxDataLatch_pls) begin
            uartWriteBuf[47:40] <= 8'hFF;   // status
            uartWriteBuf[39:24] <= i_rdata; // data
            uartWriteBuf[23:8] <= 16'h0000; // Reserved ( dummy )
            uartWriteBuf[7:0] <= 8'h0;      // sum ( dummy )
        end
    end

    /* tx Data Select */
    assign uart_tx_data =   (writeByteCnt == 4'd0) ? uartWriteBuf[47:40] :
                            (writeByteCnt == 4'd1) ? uartWriteBuf[39:32] :
                            (writeByteCnt == 4'd2) ? uartWriteBuf[31:24] :
                            (writeByteCnt == 4'd3) ? uartWriteBuf[23:16] :
                            (writeByteCnt == 4'd4) ? uartWriteBuf[15:8]  :
                            uartWriteBuf[7:0];
    
    uart_rx uart_rx_inst (
        .i_clk ( i_clk ),
        .i_rst_n ( i_rst_n ),
        .i_uart_mosi ( i_uart_mosi ),
        .o_data ( uart_rx_data ),
        .o_dataen ( dataen )
    );
    
    uart_tx uart_tx_inst (
        .i_clk ( i_clk ),
        .i_rst_n ( i_rst_n ),
        .i_data ( uart_tx_data ),
        .i_txen ( uartTxen ),
        .o_uart_miso ( o_uart_miso ),
        .o_txempty ( tx_empty )
    );

endmodule
