set IO_LENGTH 180
set BONDPAD_SIZE 70

# sg13g2_io.lef defines sg13g2_ioSite for the sides, but no corner site
make_fake_io_site -name sg13g2_ioCSite -width $IO_LENGTH -height $IO_LENGTH

# Create IO Rows
make_io_sites \
    -horizontal_site sg13g2_ioSite \
    -vertical_site sg13g2_ioSite \
    -corner_site sg13g2_ioCSite \
    -offset $BONDPAD_SIZE

######## Place Pads ########
place_pads -row IO_EAST \
    io/iob1/u_pad_vddio_0 \
    io/iob1/u_pad_gndio_0 \
    io/iob1/u_pad_jtag_tck \
    io/iob1/u_pad_jtag_tdi \
    io/iob1/u_pad_jtag_tdo \
    io/iob1/u_pad_jtag_tms \
    io/iob1/u_pad_xip_csn \
    io/iob1/u_pad_xip_clk \
    io/iob1/u_pad_xip_sdi \
    io/iob1/u_pad_xip_sdo

place_pads -row IO_WEST \
    io/iob1/u_pad_vddio_1 \
    io/iob1/u_pad_gndio_1 \
    io/iob1/u_pad_clk \
    io/iob1/u_pad_arstn \
    {io/iob0/pad\[0\].inst} \
    {io/iob0/pad\[1\].inst} \
    {io/iob0/pad\[2\].inst} \
    {io/iob0/pad\[3\].inst} \
    {io/iob0/pad\[4\].inst} \
    {io/iob0/pad\[5\].inst}

place_pads -row IO_NORTH \
    io/iob1/u_pad_vdd_0 \
    io/iob1/u_pad_gnd_0 \
    {io/iob0/pad\[6\].inst} \
    {io/iob0/pad\[7\].inst} \
    {io/iob0/pad\[8\].inst} \
    {io/iob0/pad\[9\].inst} \
    {io/iob0/pad\[10\].inst} \
    {io/iob0/pad\[11\].inst} \
    {io/iob0/pad\[12\].inst}


place_pads -row IO_SOUTH \
    io/iob1/u_pad_vdd_1 \
    io/iob1/u_pad_gnd_1 \
    {io/iob0/pad\[13\].inst} \
    {io/iob0/pad\[14\].inst} \
    {io/iob0/pad\[15\].inst} \
    {io/iob0/pad\[16\].inst} \
    {io/iob0/pad\[17\].inst} \
    {io/iob0/pad\[18\].inst} \
    {io/iob0/pad\[19\].inst}


# Place corners
place_corners sg13g2_Corner

# Place IO fill
set iofill {sg13g2_Filler10000
            sg13g2_Filler4000
            sg13g2_Filler2000
            sg13g2_Filler1000
            sg13g2_Filler400
            sg13g2_Filler200} ;
place_io_fill -row IO_NORTH {*}$iofill
place_io_fill -row IO_SOUTH {*}$iofill
place_io_fill -row IO_WEST {*}$iofill
place_io_fill -row IO_EAST {*}$iofill

# Place the bondpads
place_bondpad -bond bondpad_70x70 io/iob1/u_pad_* -offset "5.0 -$BONDPAD_SIZE.0"
place_bondpad -bond bondpad_70x70 io/iob0/*.inst -offset "5.0 -$BONDPAD_SIZE.0"

# Connect ring signals
connect_by_abutment

remove_io_rows