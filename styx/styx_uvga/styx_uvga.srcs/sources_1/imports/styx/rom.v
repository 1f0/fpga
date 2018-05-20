
module rom (
	// wishbone slave interfaces
	input wire wbs_clk_i,
	input wire wbs_cyc_i,
	input wire wbs_stb_i,
	input wire [WB_ADDR_BITS-1:2] wbs_addr_i,
	input wire [WORD_BYTES-1:0] wbs_sel_i,
	input wire wbs_we_i,
	input wire [WORD_BITS-1:0] wbs_data_i,
	output reg [WORD_BITS-1:0] wbs_data_o,
	output reg wbs_ack_o
	);
	
	parameter
		ADDR_BITS = 12,  // device address length
		WB_ADDR_BITS = 32,  // wishbone address length
		HIGH_ADDR = 20'h00000,  // high address value, as the address length of wishbone is larger than device
		WORD_BYTES = 4;  // number of bytes per-word
	parameter
		BURST_CTI = 3'b010,
		BURST_BTE = 2'b00;
	localparam
		WORD_BITS = 8 * WORD_BYTES;  // 32
	
	// don't used anymore
	//wire [WORD_BITS-1:0] data [0:(1<<(ADDR_BITS-2))-1];
	//initial begin $readmemh("E:/VIVA/openmipssoc/opmips_rom_test/test2.data", data); end
	
	wire [WORD_BITS-1:0] data [0:(1<<(ADDR_BITS-2))-1];
	
	assign data[0  ] = 32'h3c011000;
	assign data[1  ] = 32'h34210003;
	assign data[2  ] = 32'h34020080;
	assign data[3  ] = 32'ha0220000;
	assign data[4  ] = 32'h3c011000;
	assign data[5  ] = 32'h34210001;
	assign data[6  ] = 32'h34020000;
	assign data[7  ] = 32'ha0220000;
	assign data[8  ] = 32'h3c011000;
	assign data[9  ] = 32'h34210000;
	assign data[10 ] = 32'h340200a2;
	assign data[11 ] = 32'ha0220000;
	assign data[12 ] = 32'h3c011000;
	assign data[13 ] = 32'h34210003;
	assign data[14 ] = 32'h34020003;
	assign data[15 ] = 32'ha0220000;
	assign data[16 ] = 32'h3c011000;
	assign data[17 ] = 32'h34210001;
	assign data[18 ] = 32'h34020001;
	assign data[19 ] = 32'ha0220000;
	assign data[20 ] = 32'h34030000;
	assign data[21 ] = 32'h206300aa;
	assign data[22 ] = 32'h3c011000;
	assign data[23 ] = 32'h34210000;
	assign data[24 ] = 32'ha0230000;
	assign data[25 ] = 32'h3c011000;
	assign data[26 ] = 32'h34240005;
	assign data[27 ] = 32'h24030000;
	assign data[28 ] = 32'h24050004;
	assign data[29 ] = 32'h24060000;
	assign data[30 ] = 32'h80820000;
	assign data[31 ] = 32'h30420001;
	assign data[32 ] = 32'h1040fffd;
	assign data[33 ] = 32'h00000000;
	assign data[34 ] = 32'h90220000;
	assign data[35 ] = 32'h20a5ffff;
	assign data[36 ] = 32'h00063200;
	assign data[37 ] = 32'h14a0fff8;
	assign data[38 ] = 32'h00c23025;
	assign data[39 ] = 32'h2402ffff;
	assign data[40 ] = 32'h10460003;
	assign data[41 ] = 32'hac660000;
	assign data[42 ] = 32'h0800001c;
	assign data[43 ] = 32'h20630004;
	assign data[44 ] = 32'h00000008;
	assign data[45 ] = 32'h00000000;
	
	wire [ADDR_BITS-1:2] addr_buf;
	wire wbs_cs, wbs_burst;
	assign
		addr_buf = (wbs_ack_o) ? wbs_addr_i[ADDR_BITS-1:2] + 1'h1 : wbs_addr_i[ADDR_BITS-1:2],
		wbs_cs = wbs_cyc_i & wbs_stb_i;
	
	always @(posedge wbs_clk_i) begin
		wbs_data_o <= data[addr_buf];
		wbs_ack_o <= 0;
		if (wbs_cs) begin
			if (wbs_ack_o)// && ~wbs_burst)
				wbs_ack_o <= 0;
			else
				wbs_ack_o <= 1;
		end
	end
	
endmodule
