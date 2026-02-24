module rom_8x256 (
    input wire [7:0] addr,   // Barramento de endereços de 8 bits
    output reg [7:0] data    // Barramento de dados de 8 bits
);

// Define o conteúdo da ROM
reg [7:0] rom [0:255];

initial begin
    // Exemplo: carregar alguns dados
    // rom[0] = 8'hAA;
    // rom[1] = 8'hBB;
    // rom[2] = 8'hCC; // O restante será 0 por padrão
    $readmemh("rom.txt", rom);
    
end


//LDR    R1=4   	   0001 0100 14
//LDR    R2=1    	   0010 0001 21
//ADD    R3=R1+R2    1011 0110 86
//AND    r0,R1,R2	   0101 0110 56
//OR     R0,R1,r2    0100 0110 46
//NAND   R0,R1,R2	   0111 0110 76
//XOR    R0,R1,R2    0110 0110 66
//SUB    R3,R1,R2    1111 0110 F6


always @(*) begin
    data = rom[addr];
end

endmodule
