//Date: 01.07.2025
//Author: Johannes Pfau
//Description: PSoC IC IOBank 0

module iobank1(
        // CLOCK
        output clk,
        output arstn,

        // JTAG
        output jtag_tck,
        output jtag_tdi,
        input jtag_tdo,
        output jtag_tms,

        // XIP
        input xip_csn,
        input xip_clk,
        output xip_sdi,
        input xip_sdo,

        // Final IOs, as connected to pads
        inout[9:0] pads
    );

    (* keep *) sg13g2_IOPadIn     u_pad_jtag_tck (.pad(pads[0]), .p2c(jtag_tck));
    (* keep *) sg13g2_IOPadIn     u_pad_jtag_tdi (.pad(pads[1]), .p2c(jtag_tdi));
    (* keep *) sg13g2_IOPadOut4mA u_pad_jtag_tdo (.pad(pads[2]), .c2p(jtag_tdo));
    (* keep *) sg13g2_IOPadIn     u_pad_jtag_tms (.pad(pads[3]), .p2c(jtag_tms));

    (* keep *) sg13g2_IOPadOut4mA u_pad_xip_csn  (.pad(pads[4]), .c2p(xip_csn));
    (* keep *) sg13g2_IOPadOut4mA u_pad_xip_clk  (.pad(pads[5]), .c2p(xip_clk));
    (* keep *) sg13g2_IOPadIn     u_pad_xip_sdi  (.pad(pads[6]), .p2c(xip_sdi));
    (* keep *) sg13g2_IOPadOut4mA u_pad_xip_sdo  (.pad(pads[7]), .c2p(xip_sdo));

    (* keep *) sg13g2_IOPadIn     u_pad_clk      (.pad(pads[8]), .p2c(clk));
    (* keep *) sg13g2_IOPadIn     u_pad_arstn    (.pad(pads[9]), .p2c(arstn));



    (* keep *) sg13g2_IOPadIOVdd u_pad_vddio_0 () ;
    (* keep *) sg13g2_IOPadIOVdd u_pad_vddio_1 () ;
    (* keep *) sg13g2_IOPadIOVss u_pad_gndio_0 () ;
    (* keep *) sg13g2_IOPadIOVss u_pad_gndio_1 () ;

    (* keep *) sg13g2_IOPadVdd u_pad_vdd_0 () ;
    (* keep *) sg13g2_IOPadVdd u_pad_vdd_1 () ;
    (* keep *) sg13g2_IOPadVss u_pad_gnd_0 () ;
    (* keep *) sg13g2_IOPadVss u_pad_gnd_1 () ;

endmodule
