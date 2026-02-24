module decoder_3bit_7seg (
    input wire [2:0] data_in,
    output reg [6:0] seg_out
);

    // Tabela de decodificação COMBINACIONAL
    always @(*) begin
        case(data_in)
            3'b000: seg_out = 7'b1000000; // 0
            3'b001: seg_out = 7'b1111001; // 1
            3'b010: seg_out = 7'b0100100; // 2
            3'b011: seg_out = 7'b0110000; // 3
            3'b100: seg_out = 7'b0011001; // 4
            3'b101: seg_out = 7'b0010010; // 5
            3'b110: seg_out = 7'b0000010; // 6
            3'b111: seg_out = 7'b1111000; // 7
            default: seg_out = 7'b1111111; // Apagado
        endcase
    end

endmodule