//Date: 11.09.2022
//Author: Johannes Pfau
//Description: Wishbone register file for PSoC audio IP

/*
 * MEMORY MAP:
 * - 0x0000: GPIO Direction Register
 *   - Bit 0-31: Direction for PAD i (0 = input)
 * - 0x0004: PAD Function Register
 *   - Bit 0-31: Function for PAD i (0 = gpio, 1 = special function)
 */
module io_wb_regfile #(
        parameter [15:0] sysinfo = 16'h0
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

        output reg[21:0] gpio_oe,
        output reg[21:0] gpio_fn
    );

    wire o_wb_stall = 1'b0;

    // read logic
    always @(posedge clk) begin
        wb_dat_i <= 'b0;
        if (wb_cyc_i && !wb_we_i) begin
            case (wb_adr_i[15:0])
                16'h0000: begin
                    wb_dat_i <= {10'b0, gpio_oe};
                end
                16'h0004: begin
                    wb_dat_i <= {10'b0, gpio_fn};
                end
                16'h0008: begin
                    // Chip HW ID:
                    wb_dat_i <= {16'hB50C, sysinfo};
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
            gpio_oe <= 'b0;
            gpio_fn <= 'b0;
        end else begin
            if (wb_cyc_i && wb_we_i && !o_wb_stall) begin
                case (wb_adr_i[15:0])
                    16'h0000: begin
                        if (wb_sel_i[2])
                            gpio_oe[21:16] <= wb_dat_o[21:16];
                        if (wb_sel_i[1])
                            gpio_oe[15:8] <= wb_dat_o[15:8];
                        if (wb_sel_i[0])
                            gpio_oe[7:0] <= wb_dat_o[7:0];
                    end
                    16'h0004: begin
                        if (wb_sel_i[2])
                            gpio_fn[21:16] <= wb_dat_o[21:16];
                        if (wb_sel_i[1])
                            gpio_fn[15:8] <= wb_dat_o[15:8];
                        if (wb_sel_i[0])
                            gpio_fn[7:0] <= wb_dat_o[7:0];
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