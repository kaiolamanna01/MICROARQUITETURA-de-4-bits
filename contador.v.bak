module contador(
    input  wire        clk,
    input  wire        rst,
    input  wire        ena,
    output reg  [7:0]  addr_bus,
    output reg         ack      //sinal de handshaking
);

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            addr_bus <= 8'b0;
            ack    <= 1'b0;
        end else if (ena) begin
            addr_bus <= addr_bus + 1;
            ack    <= 1'b1;     // sobe quando o PC atualiza
        end else begin
            ack    <= 1'b0;     // ack desativado nos outros ciclos
        end
    end

endmodule
