module wb_sram (
	input wire clk,  // main clock, should be faster then bus clock
	input wire rst,  // synchronous reset
	// SRAM interfaces
	output wire sram_ce_n,
	output reg sram_oe_n,
	output reg sram_we_n,
	output wire [ADDR_BITS-1:2] sram_addr,
	input wire [47:0] sram_din,
	output reg [47:0] sram_dout,
	// wishbone slave interfaces
	input wire wbs_clk_i,
	input wire wbs_cyc_i,
	input wire wbs_stb_i,
	input wire [31:2] wbs_addr_i,
	input wire [3:0] wbs_sel_i,
	input wire wbs_we_i,
	input wire [31:0] wbs_data_i,
	output reg [31:0] wbs_data_o,
	output reg wbs_ack_o
	);
	
	parameter
		ADDR_BITS = 22,  // address length for PSRAM
		HIGH_ADDR = 10'h000;  // high address value, as the address length of wishbone is larger than device
	
	wire cs;
	assign
		cs = wbs_cyc_i & wbs_stb_i & wbs_addr_i[31:ADDR_BITS] == HIGH_ADDR;
	
	/*reg state = 0;
	reg next_state = 0;
	
	always @(*)begin
	   next_state = 0;
	   case(state)
	       0:begin
	           if(we)
	               next_state = 1;
	           else
	               next_state = 0;
	       end
	       1:begin
	           next_state = 0;
	       end
	   endcase
	end

	always@(posedge wbs_clk_i)begin
	   if(rst)state <= 0;//pure read
	   else state <= next_state;
	end
	*/

	
	assign
		sram_ce_n = ~cs,
		//sram_oe_n = wbs_we_i,
		//sram_we_n = ~wbs_we_i,
		sram_addr = wbs_addr_i[ADDR_BITS-1:2];
		//sram_dout = {16'b0, wbs_data_i};
	/*
	always @(posedge wbs_clk_i or negedge wbs_clk_i) begin		
		//read first
		if(wbs_clk_i) begin
		  sram_oe_n <= 1'b0;
		  sram_we_n <= 1'b1;
		end
		else begin //then decide whether to write
		  sram_oe_n = wbs_we_i;
		  sram_we_n = ~wbs_we_i;
		  sram_dout[47:32] <= 8'b0;
          sram_dout[31:24] <= wbs_sel_i[3]?wbs_data_i[31:24]:sram_din[31:24];
          sram_dout[23:16] <= wbs_sel_i[2]?wbs_data_i[23:16]:sram_din[23:16];
          sram_dout[15:08] <= wbs_sel_i[1]?wbs_data_i[15:08]:sram_din[15:08];
          sram_dout[07:00] <= wbs_sel_i[0]?wbs_data_i[07:00]:sram_din[07:00];
		end
	end
	*/
	
	always@(posedge wbs_clk_i)begin
	   sram_we_n <= 1'b1;
	   sram_oe_n <= 1'b0;
	   sram_dout <= 0;
	   wbs_ack_o <= 0;
	   if(~rst && cs) begin
	       if(wbs_we_i)begin
	           sram_we_n <= 1'b0;
	           sram_dout[47:32] <= 8'b0;
               sram_dout[31:24] <= wbs_sel_i[3]?wbs_data_i[31:24]:sram_din[31:24];
               sram_dout[23:16] <= wbs_sel_i[2]?wbs_data_i[23:16]:sram_din[23:16];
               sram_dout[15:08] <= wbs_sel_i[1]?wbs_data_i[15:08]:sram_din[15:08];
               sram_dout[07:00] <= wbs_sel_i[0]?wbs_data_i[07:00]:sram_din[07:00];
	       end
	       else begin
	           wbs_data_o <= sram_din[31:0];
	       end
	       wbs_ack_o <= 1;
	  end
	end
    

    /*
    always@(posedge wbs_clk_i)begin
		sram_oe_n <= wbs_we_i;
        sram_we_n <= ~wbs_we_i;
        
        sram_dout[31:24] <= wbs_sel_i[3]?wbs_data_i[31:24]:{8{1'bz}};
        sram_dout[23:16] <= wbs_sel_i[2]?wbs_data_i[23:16]:{8{1'bz}};
        sram_dout[15:08] <= wbs_sel_i[1]?wbs_data_i[15:08]:{8{1'bz}};
        sram_dout[07:00] <= wbs_sel_i[0]?wbs_data_i[07:00]:{8{1'bz}};
        
        wbs_data_o <= 0;
        wbs_ack_o <= 0;
        if (~rst && cs) begin
            wbs_data_o <= sram_din[31:0];
            wbs_ack_o <= 1;
        end
    end	
	*/
	
endmodule
