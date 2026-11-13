// Self-checking testbench for the hierarchical 3x8 decoder.
// Verifies: all 8 decode combinations (EN=1), enable off, and
//           combinational enable behaviour.

module decoder3x8_tb;

    reg         A, B, C, EN;
    wire [7:0]  Y;

    integer     errors = 0;

    decoder3x8 uut (
        .A(A), .B(B), .C(C), .EN(EN), .Y(Y)
    );

    task check;
        input [2:0] abc;
        input [7:0] exp;
        input [8*40-1:0] msg;
        begin
            {A, B, C} = abc;
            #1;
            if (Y !== exp) begin
                $error("%0t FAIL: %s (Y=%b exp=%b)", $time, msg, Y, exp);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("decoder3x8.vcd");
        $dumpvars(0, decoder3x8_tb);

        EN = 1;

        // ------------------------------------------------------------
        // Scenario 1: all 8 input combinations with EN=1
        check(3'd0, 8'b0000_0001, "000 -> Y0");
        check(3'd1, 8'b0000_0010, "001 -> Y1");
        check(3'd2, 8'b0000_0100, "010 -> Y2");
        check(3'd3, 8'b0000_1000, "011 -> Y3");
        check(3'd4, 8'b0001_0000, "100 -> Y4");
        check(3'd5, 8'b0010_0000, "101 -> Y5");
        check(3'd6, 8'b0100_0000, "110 -> Y6");
        check(3'd7, 8'b1000_0000, "111 -> Y7");

        // ------------------------------------------------------------
        // Scenario 2: enable off -> all outputs 0
        EN = 0;
        check(3'd0, 8'h00, "EN=0, 000 -> all 0");
        check(3'd3, 8'h00, "EN=0, 011 -> all 0");
        check(3'd7, 8'h00, "EN=0, 111 -> all 0");

        // ------------------------------------------------------------
        // Scenario 3: enable toggles combinationally, outputs follow
        EN = 1;
        check(3'd5, 8'b0010_0000, "EN=1, 101 -> Y5");
        EN = 0;
        #1;
        if (Y !== 8'h00) begin
            $error("%0t FAIL: EN drop should clear all outputs (Y=%b)", $time, Y);
            errors = errors + 1;
        end

        // ------------------------------------------------------------
        if (errors == 0)
            $display("PASS: all test cases passed");
        else
            $display("FAIL: %0d error(s)", errors);
        $finish;
    end

endmodule