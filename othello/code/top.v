`timescale 1ns / 1ps
module GEM(
    input [7:1] sw,
    output reg [7:0] Led,
    input        clk, clrn,	     
    input        ps2_clk, ps2_data,
    output [2:0] vgaRed, vgaGreen, 
    output [1:0] vgaBlue,
    output       hs, vs,           
    output MemOE,
    output MemWR,
    output RamAdv,
    output RamCE,
    output RamClk, 
    output RamCRE,
    output RamLB,
    output RamUB, 
    output RamWait,
    output [25:0] MemAdr,
    inout  [15:0] MemDB
);
    wire         font_dot;
    wire  [31:0] inst,pc,d_t_mem,cpu_mem_a,d_f_mem;
    wire         write,read,io_rdn,io_wrn,wvram,rvram,ready,overflow;
    wire   [7:0] key_data;
	 
	 assign MemOE = 0;//nrd=0
    assign MemWR = 1;//nwr
    assign RamAdv = 0;
    assign RamCE = 0;
    assign RamClk = 0;
    assign RamCRE = 0;
    assign RamLB = 0;//n
    assign RamUB = 0;//n
    assign RamWait = 0;

	 always @(posedge clk)begin
		case(sw[7:6])
			0:Led <= inst[7:0];
			1:Led <= inst[15:8];
			2:Led <= inst[23:16];
			3:Led <= inst[31:24];
	 endcase
	 end
    reg vga_clk = 1, sys_clk = 1;
    always @(posedge clk)begin
        sys_clk<=~sys_clk;
    end
    always @(posedge sys_clk) begin
        vga_clk <= ~vga_clk;
    end
	 reg clk_cpu = 0;
	 always @(posedge vga_clk)begin
        clk_cpu <= ~clk_cpu;
	 end

	 wire torv;
    wire  [12:0] vga_cram_addr = (char_row<<6) + (char_row<<4) + char_col;
    reg    [6:0] char_ram [0:4799];
	 wire   [6:0] ascii = char_ram[vga_cram_addr];
	 wire  [31:0] d_from_char = {25'h0,char_ram[cpu_mem_a[14:2]]};
	 wire w_video = wvram&&(~torv);
    always @(posedge sys_clk) begin
        if (wvram&&torv) begin
            char_ram[cpu_mem_a[14:2]] <= d_t_mem[6:0];
        end
    end

	 wire [14:0] graph_adr;
    wire  [8:0] row_addr;          // pixel ram row addr, 480 (512) lines
    wire  [9:0] col_addr;          // pixel ram col addr, 640 (1024) pixels
    wire        vga_rdn;           // in vgac, rd_a = {row[8:0],col[9:0]}
    wire  [7:0] font_pixel = font_dot? 8'h1d : 8'h00; //Green/Black
	 reg   [7:0] video_pixel;
	 wire  [7:0] vga_pixel = ((mode==0)^(sw[1]==1'b1))?font_pixel:video_pixel;
	 assign graph_adr = sw[2]?(col_addr>=240&&col_addr<400&&row_addr>=180&&row_addr<300
	 ?(row_addr-180)*160+(col_addr-240):0
	 ):row_addr[8:2]*160+col_addr[9:2];
    vgac vga_8  (vga_clk,clrn,vga_pixel,row_addr,col_addr,vga_rdn,
                 vgaRed, vgaGreen,vgaBlue,hs,vs);
    wire   [5:0] char_row = row_addr[8:3];                 // char row
    wire   [2:0] font_row = row_addr[2:0];                 // font row
    wire   [6:0] char_col = col_addr[9:3];                 // char col
    wire   [2:0] font_col = col_addr[2:0];                 // font col
	 wire mode;
    // font_table 128 x 8 x 8 x 1
    wire [12:0] ft_a = {ascii,font_row,font_col};          // ascii,row,col
    font_table ft (ft_a,font_dot);
    // ps2_keyboard
    ps2_keyboard kbd (vga_clk,clrn,ps2_clk,ps2_data,io_rdn,key_data,ready,
                      overflow);
    // cpu
    single_cycle_cpu_io cpu (vga_clk,clrn,pc,inst,cpu_mem_a,d_f_mem,
                             d_t_mem,write,io_rdn,io_wrn,rvram,wvram,torv,mode);
	 wire [31:0] douta;
    assign d_f_mem = io_rdn?(rvram?d_from_char:douta):{23'h0,ready,key_data};
	 
	 // instruction memory
    imem_mdl imem (clrn,pc,inst,MemAdr,MemDB,clk_cpu);
	 wire [7:0] vdata;
	 wire [14:0] vga_adr = sys_clk?graph_adr:cpu_mem_a[16:2];
	 always @(posedge clk)begin
		if(sys_clk) video_pixel <= vdata;
	 end
	 wire wea1 = sys_clk?0:w_video&(~vga_clk);
	 vram_c graph_vram(
		.clka(~clk),
		.wea(wea1),
		.dina(d_t_mem[7:0]),
		.addra(vga_adr),
		.douta(vdata)
	 );
	 // data ram
	 RAM_B data_ram (
		.clka(~clk), // input clka
		.wea(write), // input [0 : 0] wea
		.addra(cpu_mem_a[11:2]), // input [9 : 0] addra
		.dina(d_t_mem), // input [31 : 0] dina
		.douta(douta) // output [31 : 0] douta
	 );
endmodule
