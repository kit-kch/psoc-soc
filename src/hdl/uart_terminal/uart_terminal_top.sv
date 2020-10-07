/**

This module provides UART Access to set and read two bytes meant to emulate FPGA board switches and LED.

The full functionality is given by the remote_terminal_control module from POC:

https://github.com/VLSI-EDA/PoC/blob/master/src/comm/remote/remote_terminal_control.vhdl

We only changed the behaviour of the byte set for the switches to just override the value with the byte provided on the UART.
The default behavior of the POC module performs an XOR which makes more difficult to understand which byte  to send to reach a particular value of 
the switches.


*/
module uart_terminal_top #(
    parameter CLOCKS_PER_BAUD=868 // Default value for 100 Mhz - See one or the rx/tx uart lite file for other values
    
    ) (

    input   wire            clk, // Default to 100 MHZ
    input   wire            reset, // Synchronous to clk

    // UART
    output  wire            uart_tx, // TX Line for this module - Connect to external RX 
    input   wire            uart_rx, // RX Line for this module - Connect to external TX

    // Emulated LED (inputs to be read by UART)
    input   wire    [7:0]   leds,

    // Emulated Switches (outputs to be set by UART)
    output  wire    [7:0]   switches
);


    // UART
    // The Uart module a little "strange" with initial values set in code not in reset blocks...still works so let's live with this.
    //-----------------

    //-- TX
    wire        uart_tx_busy;
    wire [6:0]  uart_tx_data; // Use only 7 bits of the TX byte because the remote_control module only outputs 7 bits
    wire        uart_tx_data_valid;
    txuartlite #(.CLOCKS_PER_BAUD(CLOCKS_PER_BAUD)) uart_tx_I (clk, uart_tx_data_valid, {1'b0,uart_tx_data}, uart_tx, uart_tx_busy);

    //-- RX
    wire        uart_rx_data_available;
    wire [7:0]  uart_rx_data;
    rxuartlite  #(.CLOCKS_PER_BAUD(CLOCKS_PER_BAUD)) uart_rx_I (
        .i_clk(clk),
        .i_uart_rx(uart_rx),
        .o_wr(uart_rx_data_available), 
        .o_data(uart_rx_data)
    );


    // Remote Control
    //---------------------

    remote_terminal_control
        #(
        .RESET_COUNT(8),
        .PULSE_COUNT(8),
        .SWITCH_COUNT(8),
        .LIGHT_COUNT(8),
        .DIGIT_COUNT(8)
        )
    terminal_I (
        .clk(clk),
        .rst(reset),
        // UART Connectivity (only 7 bits of data)
        .idat(uart_rx_data[6:0]),
        .istb(uart_rx_data_available),
        
        .odat(uart_tx_data),
        .ordy(!uart_tx_busy),
        .oput(uart_tx_data_valid),

        // Control Outputs
        .resets(),
        .pulses(),
        .switches(switches),

        // Monitor Inputs
        .lights(leds),
        .digits(8'hAB)

    );



endmodule