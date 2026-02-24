module demux1x2_4bit (
    input wire [3:0] in,
    input wire sel,
    output wire [3:0] out0, // wr_data_ldr (sel=0)
    output wire [3:0] out1  // rd_addr (sel=1)
);

    assign out0 = sel ? 4'b0000 : in;

    assign out1 = sel ? in  : 4'b0000;

endmodule