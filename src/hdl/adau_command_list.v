`timescale 1ns/1ps

module adau_command_list(
        input clk,
        input reset,

        output reg [31:0] command,
        output command_valid,
        input spi_ready,

        output adau_init_done
    );

    reg [4:0] command_index;

    always @* begin
        case(command_index)
            // dummy writes to enable the SPI port
            0:  command = 32'h00_0000_00;
            1:  command = 32'h00_0000_00;
            2:  command = 32'h00_0000_00;

            // clock control:
            // - source from MCLK pin
            // - input clock frequency = 256 * sample rate
            // - enable core clock (This is required to be the first command.)
            3:  command = 32'h00_4000_01;

            // clock enable 0/1:
            // - enable all clocks
            4:  command = 32'h00_40f9_ff;
            5:  command = 32'h00_40fa_03;

            // serial port 0:
            // - sample rate from register R17/0x4017 (defaults to 48kHz)
            // - set LRCLK to 50% duty cycle
            // - SDATA changes when BCLK falls
            // - audio frames begin when LRCLK falls
            // - 2 channels per frame
            // - Set the ADAU to be the I2S slave
            6:  command = 32'h00_4015_00;

            // serial port 1:
            // - 48 bits per audio frame
            // - left channel first
            // - MSB first
            // - data starts one BCLK after the LRCLK edge
            7:  command = 32'h00_4016_40;

            // playback mixer left (mixer 3):
            // - mute right input to left playback channel
            // - unmute right input to right playback channel
            // - aux input gain = mute
            // - enable mixer 3
            8:  command = 32'h00_401c_21;

            // playback mixer right (mixer 4):
            // - unmute right input to right playback channel
            // - mute left input to right playback channel
            // - aux input gain = mute
            // - enable mixer 4
            9:  command = 32'h00_401e_41;

            // DAC control 0:
            // - stereo mode
            // - normal polarity
            // - disable de-emphasis filter
            // - enable both left and right DACs
            10: command = 32'h00_402a_03;

            // playback L/R mono output mixer (mixer 7)
            // - 0 dB gain on each input
            // - enable mixer 7
            11: command = 32'h00_4022_05;

            // playback headphone left volume control:
            // - volume = 0dB
            // - unmute left headphone channel
            // - enable left headphone output
            12: command = 32'h00_4023_e7;  // headphone enable, volume = 0db

            // playback headphone right volume control:
            // - volume = 0dB
            // - unmute right headphone channel
            // - enable right headphone output
            13: command = 32'h00_4024_e7;  // headphone enable, volume = 0db

            // playback power management:
            // - headphone bias control = normal operation
            // - dac bias control = normal operation
            // - playback channel bias control = normal operation
            // - enable playback right channel
            // - enable playback left channel
            14: command = 32'h00_4029_03;

            // serial input route control:
            // - route serial inputs left-0 and right-0 to left and right DACs
            15: command = 32'h00_40f2_01;  // serial input route control

            default: command = 32'h0;
        endcase
    end
    wire [4:0] command_count = 16;

    assign command_valid = command_index != command_count;
    assign adau_init_done = spi_ready && !command_valid;

    always @(posedge clk) begin
        if (reset)
            command_index <= 0;
        else if (spi_ready && command_valid)
            command_index <= command_index + 1;
    end
endmodule
