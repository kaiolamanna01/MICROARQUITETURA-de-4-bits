`timescale 1ns/1ps

module microarq_tb;

    reg clk;
    reg rst;

    wire [6:0] disp_operand_A;
    wire [6:0] disp_operand_B;
    wire [6:0] disp_wr_data_ula;
    wire [6:0] disp_estado;
	 wire [6:0] disp_data_bus_msb;
    wire [6:0] disp_data_bus_lsb;
	 
	 wire rst_int;
	 assign rst_int = ~rst;

    // Instancia o DUT
    microarq dut (
        .clk(clk),
        .rst(rst_int),
		  .disp_data_bus_msb(disp_data_bus_msb), 
		  .disp_data_bus_lsb(disp_data_bus_lsb),  
        .disp_operand_A(disp_operand_A),
        .disp_operand_B(disp_operand_B),
        .disp_wr_data_ula(disp_wr_data_ula),
        .disp_estado(disp_estado)
    );

    // Clock de 10ns
    always #5 clk = ~clk;
	 

    initial begin
        $display("INICIANDO TESTE ");

        clk = 0;
        rst = 1;

        // Reset
        #20 rst = 0;


		  #1500;

        $display("FIM TESTE");
        $stop;
    end

endmodule
