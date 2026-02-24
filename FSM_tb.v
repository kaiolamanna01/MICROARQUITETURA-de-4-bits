module FSM_tb;

    reg clk;
    reg rst;
    reg [1:0] mnm;
    reg ula_ack;
    reg wr_ack;
    reg pc_ack;
    reg ri_ack;

    wire ena_pc;
    wire ena_ri;
    wire ena_wr;
    wire sel_r0_rd;
    wire sel_addr_data;
    wire sel_ldr_ula;
    wire ena_ula;

    // Instancia a FSM
    FSM uut (
        .clk(clk),
        .rst(rst),
        .mnm(mnm),
        .ula_ack(ula_ack),
        .wr_ack(wr_ack),
        .pc_ack(pc_ack),
        .ri_ack(ri_ack),
        .ena_pc(ena_pc),
        .ena_ri(ena_ri),
        .ena_wr(ena_wr),
        .sel_r0_rd(sel_r0_rd),
        .sel_addr_data(sel_addr_data),
        .sel_ldr_ula(sel_ldr_ula),
        .ena_ula(ena_ula)
    );

    // Clock 10ns período (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Inicialização
        rst = 1;
        mnm = 2'b00;
        ula_ack = 0;
        wr_ack = 0;
        pc_ack = 0;
        ri_ack = 0;

        // Release reset após 20ns
        #20;
        rst = 0;

        // Forçar pc_ack para permitir transição PC -> FETCH
        #10;
        pc_ack = 1;

        // Simular estado FETCH com mnm = 00 e ri_ack = 1 para ir para LDR
        #10;
        ri_ack = 1;
        mnm = 2'b00;

        // Simular estado LDR esperando wr_ack para ir para PC
        #20;
        wr_ack = 0;
        #30;
        wr_ack = 1;

        // Simular PC novamente, exigir pc_ack para ir FETCH
        #10;
        pc_ack = 0;
        #10;
        pc_ack = 1;

        // FETCH com mnm=10 e ri_ack=1 para ir ARIT
        #10;
        mnm = 2'b10;
        ri_ack = 1;

        // ARIT espera ula_ack
        #10;
        ula_ack = 0;
        #20;
        ula_ack = 1;

        // WR_RD espera wr_ack
        #10;
        wr_ack = 0;
        #20;
        wr_ack = 1;

        // LOGIC com mnm=01 e ri_ack=1 para ir LOGIC
        #10;
        mnm = 2'b01;
        ri_ack = 1;
        ula_ack = 0;
        #20;
        ula_ack = 1;

        // WR_R0 espera wr_ack
        #10;
        wr_ack = 0;
        #20;
        wr_ack = 1;

        // Voltar para PC
        #30;

        // Finalizar simulação
        $stop;
    end

    // Monitorar sinais para debug
    initial begin
        $display("Time clk rst pc_ack ri_ack mnm ula_ack wr_ack state ena_pc ena_ri ena_wr sel_r0_rd sel_addr_data sel_ldr_ula ena_ula");
        $monitor("%0t %b %b %b %b %b %b %b %b %b %b %b %b %b %b",
            $time, clk, rst, pc_ack, ri_ack, mnm, ula_ack, wr_ack,
            ena_pc, ena_ri, ena_wr, sel_r0_rd, sel_addr_data, sel_ldr_ula, ena_ula);
    end

endmodule
