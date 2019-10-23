    `timescale 1ns/1ps

    module adau_spi_master
    (input clk,
    input reset,

    input [31:0] data_in,
    input valid,
    output ready,

    output cdata,
    output cclk,
    output reg clatch_n);

    // CLK runs at 120MHz. We use a counter to generate a pulse every 6
    // CLKs. If we toggle CCLK on each pulse we get a 10MHz signal -
    // the maximum CCLK frequency.
    localparam CCLK_DIVIDER = 6;
    localparam DIVIDER_BITS = $clog2(CCLK_DIVIDER);
    reg [CCLK_DIVIDER-1:0] divider;
    wire divider_tick = divider == (CCLK_DIVIDER - 1);

    // 2 states per bit (clock high, clock low) times 32 bits per
    // transfer gives 64 states. We need another wait state after
    // pulling CLATCH_N high, so we respect the minimum pulse width on that
    // signal. Finally, we need an idle state, where READY is asserted.
    // Therefore, during a transfer, our FSM steps through these states
    // in order:
    localparam BIT_31_CLOCK_LOW  = 0;
    localparam BIT_31_CLOCK_HIGH = 1;
    localparam BIT_30_CLOCK_LOW  = 2;
    // ...
    localparam BIT_0_CLOCK_HIGH = 62;
    localparam CLATCH_N_GOING_HIGH = 63;  // AKA BIT_0_CLOCK_LOW
    localparam WAITING_FOR_CLATCH_N = 64;
    localparam IDLE = 65;

    reg [6:0] state;
    reg ready;

    // The clock is low in even states and high in odd states. The only
    // exception is IDLE - we need to force the clock low there. If we
    // didn't do this, the clock would be high while IDLE, and low in
    // the next state. Since the minimum IDLE duration is one CLK
    // period, the minimum CCLK pulse width might be violated.
    assign cclk = state[0] && (state != IDLE);

    // This shift register holds the data to be transferred. The MSB is
    // sent first, so we connect it to CDATA and shift to the left.
    reg [31:0] shiftreg;
    assign cdata = shiftreg[31];

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            state <= IDLE;
            clatch_n <= 1;
            divider <= 0;
            ready <= 0;
        end else begin
            if (state == IDLE) begin
                ready <= 1;
                if (ready && valid) begin
                    state <= 0;
                    shiftreg <= data_in;
                    clatch_n <= 0;
                    ready <= 0;
                end
            end else begin
                if (divider_tick)
                    divider <= 0;
                else
                    divider <= divider + 1;

                if (divider_tick) begin
                    state <= state + 1;
                    if (cclk)  // CCLK about to fall?
                        shiftreg <= {shiftreg[30:0], 1'b0};
                    if (state == CLATCH_N_GOING_HIGH)
                        clatch_n <= 1;
                end
            end
        end
    end
    endmodule
