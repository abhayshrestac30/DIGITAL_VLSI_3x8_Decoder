// 1x2 Decoder with enable
// en=1:  y0 = ~in, y1 = in
// en=0:  both outputs 0

module decoder1x2(
    input  wire in,
    input  wire en,
    output wire y0,
    output wire y1
);
    assign y0 = en & ~in;
    assign y1 = en & in;
endmodule