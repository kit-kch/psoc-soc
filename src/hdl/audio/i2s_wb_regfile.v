//Date: 11.09.2022
//Author: Johannes Pfau
//Description: Wishbone register file for PSoC audio IP

/*
 * MEMORY MAP:
 * - 0x0000: Control register CTRL0
 *   - Bit 0: Reset (1 = active)
 *   - Bit 1: DAC mode: 0 = I2S output, 1 = Use builtin DAC
 *   - Bit 2: DAC enable
 *   - Bit 3: I2S enable
 * - 0x0004: Status register STAT0 (readonly)
 *   - Bit 0: FIFO is low (1 when Fifo count is less than FIFO_LOW)
 *   - Bit 1: FIFO empty (1 if FIFO is empty)
 *   - Bit 2: FIFO full (1 if FIFO is full)
 * - 0x0008: FIFO low threshold FIFO_LOW
 * - 0x000c: FIFO level FIFO_LEVEL (readonly)
 * - 0x0010: AUDIO_LEFT (write-only)
 *   - Bit 0-23: left audio sample
 *   - Bit 31: Set to 1 to write out all 48 bits of audio data
 * - 0x0014: AUDIO_RIGHT (write-only)
 *   - Bit 0-23: right audio sample
 *   - Bit 31: Set to 1 to write out all 48 bits of audio data
 */
module i2s_wb_regfile #(
        parameter FIFO_LEN_BITS = 4
    )(
        input clk,
        input rst,

        // wishbone signals
        input[3:0] wb_sel_i,
        input[31:0] wb_dat_o,
        input[31:0] wb_adr_i,
        input wb_stb_i,
        input wb_cyc_i,
        input wb_we_i,
        output reg[31:0] wb_dat_i,
        output reg wb_ack_o,


        // audio data
        output reg[47:0] audio_data,
        output reg audio_valid,

        // control signals
        input fifo_full,
        input fifo_empty,
        input fifo_low,
        input[FIFO_LEN_BITS:0] fifo_level,
        output[FIFO_LEN_BITS:0] fifo_threshold,
        input fifo_ready,
        output dac_mode,
        output dac_enable,
        output i2s_enable,
        output software_rst
    );

    // Stall if we can't write to FIFO this cycle
    // Note: If we're reading or writing other registers, the FIFO doesn't matter.
    // It's however easier and reduces logic complexity to always stall
    wire o_wb_stall = !fifo_ready;

    // registers
    reg[31:0] reg_ctrl0;
    assign software_rst = reg_ctrl0[0];
    assign dac_mode = reg_ctrl0[1];
    assign dac_enable = reg_ctrl0[2];
    assign i2s_enable = reg_ctrl0[3];

    reg[31:0] fifo_threshold_reg;
    assign fifo_threshold[FIFO_LEN_BITS:0] = fifo_threshold_reg[FIFO_LEN_BITS:0];

    // read logic
    always @(posedge clk) begin
        wb_dat_i <= 'b0;
        if (wb_cyc_i && !wb_we_i) begin
            case (wb_adr_i[15:0])
                16'h0000: begin
                    wb_dat_i <= reg_ctrl0;
                end
                16'h0004: begin
                    wb_dat_i <= {29'b0, fifo_full, fifo_empty, fifo_low};
                end
                16'h0008: begin
                    wb_dat_i <= fifo_threshold_reg;
                end
                16'h000c: begin
                    wb_dat_i <= {{32-FIFO_LEN_BITS-1{1'b0}}, fifo_level};
                end
                default: begin
                    wb_dat_i <= 32'h0000_0000;
                end
            endcase
        end
    end

    // write logic
    always @(posedge clk) begin
        if (rst) begin
            reg_ctrl0 <= 32'h00000000;
            audio_valid <= 1'b0;
            fifo_threshold_reg <= 32'h00000000;
        end else begin
            // reset every cycle, should be high for one cycle only
            audio_valid <= 1'b0;

            if (wb_cyc_i && wb_we_i && !o_wb_stall) begin
                case (wb_adr_i[15:0])
                    16'h0000: begin
                        if (wb_sel_i[0])
                            reg_ctrl0[7:0] <= wb_dat_o[7:0];
                    end
                    16'h0008: begin
                        if (wb_sel_i[3])
                            fifo_threshold_reg[31:24] <= wb_dat_o[31:24];
                        if (wb_sel_i[2])
                            fifo_threshold_reg[23:16] <= wb_dat_o[23:16];
                        if (wb_sel_i[1])
                            fifo_threshold_reg[15:8] <= wb_dat_o[15:8];
                        if (wb_sel_i[0])
                            fifo_threshold_reg[7:0] <= wb_dat_o[7:0];
                    end
                    16'h0010: begin
                        if (wb_sel_i[3])
                            audio_valid <= wb_dat_o[31];
                        if (wb_sel_i[2])
                            audio_data[23:16] <= wb_dat_o[23:16];
                        if (wb_sel_i[1])
                            audio_data[15:8] <= wb_dat_o[15:8];
                        if (wb_sel_i[0])
                            audio_data[7:0] <= wb_dat_o[7:0];
                    end
                    16'h0014: begin
                        if (wb_sel_i[3])
                            audio_valid <= wb_dat_o[31];
                        if (wb_sel_i[2])
                            audio_data[47:40] <= wb_dat_o[23:16];
                        if (wb_sel_i[1])
                            audio_data[39:32] <= wb_dat_o[15:8];
                        if (wb_sel_i[0])
                            audio_data[31:24] <= wb_dat_o[7:0];
                    end
                    default: begin
                        
                    end
                endcase
            end
        end
    end

    // Acknowledgement
    always @(posedge clk) begin
        if (rst) begin
            wb_ack_o <= 1'b0;
        end else begin
            wb_ack_o <= (wb_cyc_i) && (!o_wb_stall);
        end
    end

endmodule