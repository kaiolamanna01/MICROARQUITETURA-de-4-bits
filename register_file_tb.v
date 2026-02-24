module register_file_tb();

    parameter DATA_WIDTH = 4;
    parameter ADDR_WIDTH = 2;
    parameter REG_COUNT = 4;

    reg clk;
    reg wr_en;
    reg [ADDR_WIDTH-1:0] wr_addr;
    reg [DATA_WIDTH-1:0] wr_data;
    reg [ADDR_WIDTH-1:0] rd_addr1;
    reg [ADDR_WIDTH-1:0] rd_addr2;
    wire [DATA_WIDTH-1:0] rd_data1;
    wire [DATA_WIDTH-1:0] rd_data2;
    wire wr_ack;

    // Instancia o DUT
    register_file #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .REG_COUNT(REG_COUNT)
    ) dut (
        .clk(clk),
        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .rd_addr1(rd_addr1),
        .rd_addr2(rd_addr2),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2),
        .wr_ack(wr_ack)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Task para escrita
    task write_reg(input [ADDR_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] data);
    begin
        wr_en = 1;
        wr_addr = addr;
        wr_data = data;
        @(posedge clk);
        // Verifica wr_ack aqui, no clock que wr_en estava ativo
        if (!wr_ack)
            $display("ERRO: wr_ack não foi ativado após escrita no endereço %0d com dado %b", addr, data);
        else
            $display("SUCESSO: escrita em [%0d] = %b (wr_ack = %b)", addr, data, wr_ack);
        wr_en = 0;
        @(posedge clk);
        end
    endtask


    // Task para leitura
    task read_regs(input [1:0] addr1, input [1:0] addr2, input [3:0] expected1, input [3:0] expected2);
        begin
            rd_addr1 = addr1;
            rd_addr2 = addr2;
            #1; // leitura combinacional
            if (rd_data1 !== expected1)
                $display("ERRO: leitura em [%0d] = %b (esperado %b)", addr1, rd_data1, expected1);
            else
                $display("SUCESSO: leitura em [%0d] = %b", addr1, rd_data1);

            if (rd_data2 !== expected2)
                $display("ERRO: leitura em [%0d] = %b (esperado %b)", addr2, rd_data2, expected2);
            else
                $display("SUCESSO: leitura em [%0d] = %b", addr2, rd_data2);
        end
    endtask

    // Estímulos
    initial begin
        wr_en = 0;
        wr_addr = 0;
        wr_data = 0;
        rd_addr1 = 0;
        rd_addr2 = 0;

        @(posedge clk); // Espera o clock inicial

        // Escrita em todos os registradores
        write_reg(2'd0, 4'b1010);
        write_reg(2'd1, 4'b1100);
        write_reg(2'd2, 4'b0011);
        write_reg(2'd3, 4'b1111);

        // Leitura cruzada
        read_regs(2'd0, 2'd1, 4'b1010, 4'b1100);
        read_regs(2'd2, 2'd3, 4'b0011, 4'b1111);

        // Teste de leitura após tentativa de escrita sem `wr_en`
        wr_en = 0;
        wr_addr = 2'd1;
        wr_data = 4'b0000;
        @(posedge clk);

        read_regs(2'd1, 2'd2, 4'b1100, 4'b0011); // valor deve permanecer inalterado

        $display("Fim da simulação.");
        #10 $finish;
    end

endmodule
