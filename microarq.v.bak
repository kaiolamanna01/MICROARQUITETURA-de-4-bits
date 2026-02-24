module microarq (
    input  wire clk,
    input  wire rst,
    // Saidas displays 7-segmentos
	 output [6:0] disp_data_bus_lsb,
	 output [6:0] disp_data_bus_msb,
    output [6:0] disp_operand_A,
    output [6:0] disp_operand_B,
    output [6:0] disp_wr_data_ula,
    output [6:0] disp_estado
);
		 //new
	 wire rst_int;
	 assign rst_int = ~rst;

    wire [7:0] addr_bus;
    wire [7:0] data_bus;
    wire [3:0] rd_addr;

    wire [3:0] wr_data_ula;
    wire [3:0] wr_data_ldr;     
    wire [3:0] wr_data;

    wire [1:0] wr_addr_mnm;
    wire [1:0] wr_addr;

    wire [3:0] operando_A;
    wire [3:0] operando_B;
    wire [3:0] rd_addr_wr_data;

    wire [3:0] op_sel;
    wire [1:0] mnm;

    // sinais de controle
    wire sel_r0_rd;
    wire ena_pc, ena_ri, ena_wr, ena_ula;
    wire sel_addr_data, sel_ldr_ula;
    wire ula_ack, wr_ack, pc_ack, ri_ack;
    
    // Sinais para banco de registradores
    wire [1:0] rd_addr1_wr_data;  
    wire [1:0] rd_addr2_wr_data;  

    assign op_sel = {mnm, wr_addr_mnm};
    
    // leitura do banco
    assign rd_addr1_wr_data = rd_addr[3:2];  // Bits 3-2 = Ry
    assign rd_addr2_wr_data = rd_addr[1:0];  // Bits 1-0 = Rz

    // Saída de estado da FSM
    wire [2:0] estado;

    // sinais para decodificadores 7-seg
    wire [6:0] decod_operand_A_wire;
    wire [6:0] decod_operand_B_wire;
    wire [6:0] decod_wr_data_ula_wire;
    wire [6:0] decod_estado;	 
	 wire [6:0] decod_data_bus_high;
	 wire [6:0] decod_data_bus_low;
	 
	 wire [3:0] data_bus_msb = data_bus[7:4];
	 wire [3:0] data_bus_lsb = data_bus[3:0];
	

	
	 
    contador c1 (
        .clk(clk),
        .ena(ena_pc),
        .rst(rst_int),
        .addr_bus(addr_bus),
        .ack(pc_ack)
    );

    rom_8x256 mem (
        .addr(addr_bus),
        .data(data_bus)          
    );

    registro_inst inst (
        .clk(clk),
        .ena(ena_ri),
        .rst(rst_int),
        .data_in(data_bus),
        .mnm(mnm),
        .wr_addr_mnm(wr_addr_mnm),
        .rd_addr_wr_data(rd_addr_wr_data),
        .ack(ri_ack)
    );

    register_file banco (
        .clk(clk),
        .wr_en(ena_wr),
        .wr_data(wr_data),
        .wr_addr(wr_addr),
        .rd_addr1(rd_addr1_wr_data),  
        .rd_addr2(rd_addr2_wr_data),  
        .rd_data1(operando_A),
        .rd_data2(operando_B),
        .wr_ack(wr_ack)
    );

    ula ula_u (
        .a(operando_A),
        .b(operando_B),
        .sel(op_sel),
        .result(wr_data_ula),
        .ula_ack(ula_ack),
        .rst(rst_int),
        .clk(clk),
        .ena(ena_ula)
    );

    FSM fsm_u (
        .clk(clk),
        .rst(rst_int),
        .mnm(mnm),
        .ula_ack(ula_ack),
        .wr_ack(wr_ack),
        .pc_ack(pc_ack),
        .ri_ack(ri_ack),
        .ena_pc(ena_pc),
        .ena_ri(ena_ri),
        .ena_wr(ena_wr),
        .ena_ula(ena_ula),
        .sel_r0_rd(sel_r0_rd),
        .sel_addr_data(sel_addr_data),
        .sel_ldr_ula(sel_ldr_ula),
        .estado(estado)
    );

    mux2x1_2bit mux_wr_addr (
        .in1(wr_addr_mnm),
        .in0(2'b00),
        .sel(sel_r0_rd),
        .out(wr_addr)
    );

    demux1x2_4bit demux (
        .in(rd_addr_wr_data),
        .sel(sel_addr_data),
        .out0(wr_data_ldr), 
        .out1(rd_addr)          
    );
	 

    mux2x1_4bit mux_wr_data (
        .in0(wr_data_ula), 
        .in1(wr_data_ldr),      
        .sel(sel_ldr_ula),
        .out(wr_data)
    );

    decoder_3bit_7seg DECODER_STATE (
        .data_in(estado),
        .seg_out(decod_estado)
    );

    decoder_4bit_7seg DECODER_WR_DATA_ULA (
        .data_in(wr_data_ula),
        .seg_out(decod_wr_data_ula_wire)
    );

    decoder_4bit_7seg DECODER_OPERAND_A (
        .data_in(operando_A),
        .seg_out(decod_operand_A_wire)
    );

    decoder_4bit_7seg DECODER_OPERAND_B (
        .data_in(operando_B),
        .seg_out(decod_operand_B_wire)
    );

	decoder_4bit_7seg decoder_msb (
		 .data_in(data_bus_msb),
		 .seg_out(decod_data_bus_high)
	);

	decoder_4bit_7seg decoder_lsb (
		 .data_in(data_bus_lsb),
		 .seg_out(decod_data_bus_low)
	);


    assign disp_operand_A    = decod_operand_A_wire;
    assign disp_operand_B    = decod_operand_B_wire;
    assign disp_wr_data_ula  = decod_wr_data_ula_wire;
    assign disp_estado       = decod_estado;
	 assign disp_data_bus_lsb = decod_data_bus_low;
	 assign disp_data_bus_msb = decod_data_bus_high;

endmodule