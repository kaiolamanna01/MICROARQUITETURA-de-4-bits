module contador_tb ();
    
    reg clk;
    reg rst;
    reg ena;
    wire [7:0]addr_bus;
    wire ack;

    contador dut(.clk(clk),.rst(rst),.ena(ena),.addr_bus(addr_bus),.ack(ack));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;

        #20;
        rst = 0;

        $display("addr_bus = %b  |  ack = %d",addr_bus,ack);
        #20;


        $display("addr_bus = %b  |  ack = %d",addr_bus,ack);
        #20;


        $display("addr_bus = %b  |  ack = %d",addr_bus,ack);
        #20;


        $display("addr_bus = %b  |  ack = %d",addr_bus,ack);
        #20;
        
        $stop;
        $finish;
    end
endmodule