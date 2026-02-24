module ula (
    input wire clk,         // clock
    input wire ena,      // habilitação da operação
    input wire rst,
    input wire [3:0]  a,           // operando A
    input wire [3:0]  b,           // operando B
    input wire [3:0]  sel,         // {mnm,wr_addr_mnm}
    output reg  [3:0]  result,      // resultado da ULA
    output reg         ula_ack      // handshake: sobe por 1 ciclo
);

    always @(negedge clk or posedge rst) begin  // ADICIONE "or posedge rst"
        if (rst) begin
            result <= 4'b0000;
            ula_ack <= 1'b0;
        end
        else if (ena) begin
            casex (sel)
                4'b0100: result <= a | b;
                4'b0101: result <= a & b;
                4'b0110: result <= a ^ b;
                4'b0111: result <= ~(a & b);
                4'b10xx: result <= a + b;
                4'b11xx: result <= a - b;
                default: result <= 4'b0000;
            endcase
            ula_ack <= 1'b1;
        end else begin
            ula_ack <= 1'b0;
        end
end

endmodule