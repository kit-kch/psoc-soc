//Date: 01.07.2025
//Author: Johannes Pfau
//Description: PSoC IC IO Subsystem

module iomux(
        input[19:0] gpio_fn,
    
        output[19:0] gpio_i,
        output[19:0] fn_i,
        input[19:0] pad_i,

        input[19:0] gpio_o,
        input[19:0] fn_o,
        output[19:0] pad_o,

        input[19:0] gpio_oe,
        input[19:0] fn_oe,
        output[19:0] pad_oe
    );

    assign gpio_i = pad_i;
    assign fn_i = pad_i;

    genvar i;
    generate
        for (i = 0; i < 20; i = i + 1) begin : mux_loop
            assign pad_o[i] = (gpio_fn[i] == 1'b0) ? gpio_o[i] : fn_o[i];
            assign pad_oe[i] = (gpio_fn[i] == 1'b0) ? gpio_oe[i] : fn_oe[i];
        end
    endgenerate

endmodule