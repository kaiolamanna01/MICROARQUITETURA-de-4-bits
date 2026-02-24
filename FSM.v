module FSM (
    input wire clk,
    input wire rst,
    input wire [1:0] mnm,
    input wire ula_ack,
    input wire wr_ack,
    input wire pc_ack,
    input wire ri_ack,
    output reg ena_pc,
    output reg ena_ri,
    output reg ena_wr,
    output reg sel_r0_rd,
    output reg sel_addr_data,
    output reg sel_ldr_ula,
    output reg ena_ula,
	 output wire [2:0] estado
);


    localparam
        PC     = 3'd0,
        FETCH  = 3'd1,
        LDR    = 3'd2,
        ARIT   = 3'd3,
        LOGICA = 3'd4,
        WR_RD  = 3'd5,
        WR_R0  = 3'd6;

    reg [2:0] state, next_state;
	 
	 assign estado = state;



    // Registro de estado
    always @(posedge clk) begin  // posedge
        if (rst)
            state <= FETCH;
        else
            state <= next_state;	
    end

    // Próximo estado
    always @(*) begin
                case (state)
            PC:    
                next_state = (pc_ack) ? FETCH : PC;

            FETCH: begin
                if (ri_ack) begin
                    case (mnm)
                        2'b00: next_state = LDR;
                        2'b01: next_state = LOGICA;
                        2'b10: next_state = ARIT;
                        2'b11: next_state = ARIT;
                        default: next_state = FETCH;
                    endcase
                end else begin
                    next_state = FETCH;
                end
            end

            LDR:     next_state = (wr_ack) ? PC : LDR;
				
            ARIT:    next_state = (ula_ack) ? WR_RD : ARIT;
				
            LOGICA:  next_state = (ula_ack) ? WR_R0 : LOGICA;
				
            WR_RD:   next_state = (wr_ack) ? PC : WR_RD;
				
            WR_R0:   next_state = (wr_ack) ? PC : WR_R0;

            default: next_state = FETCH;
        endcase
    end

    always @(*) begin
			  ena_pc = 0;
			  ena_ri = 0;
			  ena_wr = 0;
			  sel_r0_rd = 0;
			  sel_addr_data = 0;
			  sel_ldr_ula = 0;
			  ena_ula = 0;

        case (state)
            PC: begin
               ena_pc = 1;
            end

            FETCH: begin
					ena_ri = 1;
            end

            LDR: begin
					ena_wr = 1;
					sel_r0_rd = 1;
					sel_ldr_ula = 1;
            end

            ARIT: begin
					ena_ula = 1;
					sel_addr_data = 1;
            end

            LOGICA: begin
					ena_ula = 1;
					sel_addr_data = 1;
            end

            WR_RD: begin
					ena_wr = 1;
					sel_r0_rd = 1;
					sel_addr_data = 1;
            end

            WR_R0: begin
					ena_wr = 1;
					sel_addr_data = 1;
            end
        endcase
    end
	 
endmodule