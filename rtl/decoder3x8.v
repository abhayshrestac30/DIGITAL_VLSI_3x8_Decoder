// 3x8 Decoder built hierarchically from 1x2 decoders only.
//
// Hierarchical structure (7 x decoder1x2):
//
//   Stage 1:  A  -> dec3x8 selects upper/lower half -> e0 (A=0), e1 (A=1)
//   Stage 2:  B  -> two 1x2 decoders (en = e0, e1)   -> f0..f3
//   Stage 3:  C  -> four 1x2 decoders (en = f0..f3)  -> Y[0]..Y[7]
//
// Output mapping (EN, A, B, C):
//   A=0,B=0 -> Y[0:1],  A=0,B=1 -> Y[2:3],
//   A=1,B=0 -> Y[4:5],  A=1,B=1 -> Y[6:7]

module decoder3x8(
    input  wire A,
    input  wire B,
    input  wire C,
    input  wire EN,
    output wire [7:0] Y
);

    wire e0, e1;                    // stage 1 enables
    wire f0, f1, f2, f3;            // stage 2 enables

    // Stage 1: decode A
    decoder1x2 stg1 (
        .in(A),
        .en(EN),
        .y0(e0),
        .y1(e1)
    );

    // Stage 2: decode B (two 1x2 decoders)
    decoder1x2 stg2a (
        .in(B),
        .en(e0),
        .y0(f0),
        .y1(f1)
    );
    decoder1x2 stg2b (
        .in(B),
        .en(e1),
        .y0(f2),
        .y1(f3)
    );

    // Stage 3: decode C (four 1x2 decoders)
    decoder1x2 stg3_0 (.in(C), .en(f0), .y0(Y[0]), .y1(Y[1]));
    decoder1x2 stg3_1 (.in(C), .en(f1), .y0(Y[2]), .y1(Y[3]));
    decoder1x2 stg3_2 (.in(C), .en(f2), .y0(Y[4]), .y1(Y[5]));
    decoder1x2 stg3_3 (.in(C), .en(f3), .y0(Y[6]), .y1(Y[7]));

endmodule