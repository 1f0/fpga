`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:35:15 09/05/2015
// Design Name:   single_cycle_cpu_io
// Module Name:   E:/Sum/PRO2-tri/test_addi.v
// Project Name:  PRO
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: single_cycle_cpu_io
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_addi;

	// Inputs
	reg clk;
	reg clrn;
	reg [31:0] inst;
	reg [31:0] d_f_mem;

	// Outputs
	wire [31:0] pc;
	wire [31:0] m_addr;
	wire [31:0] d_t_mem;
	wire write;
	wire io_rdn;
	wire io_wrn;
	wire rvram;
	wire wvram;
	wire torv;
	wire mode;

	// Instantiate the Unit Under Test (UUT)
	single_cycle_cpu_io uut (
		.clk(clk), 
		.clrn(clrn), 
		.pc(pc), 
		.inst(inst), 
		.m_addr(m_addr), 
		.d_f_mem(d_f_mem), 
		.d_t_mem(d_t_mem), 
		.write(write), 
		.io_rdn(io_rdn), 
		.io_wrn(io_wrn), 
		.rvram(rvram), 
		.wvram(wvram), 
		.torv(torv), 
		.mode(mode)
	);
	reg[31:0] test;
	initial begin
		// Initialize Inputs
		clk = 0;
		clrn = 1;
		inst = 0;
		d_f_mem = 0;
		#20;
		inst = 32'h2041FFFC;
		#20;
		inst = 32'hAC410000;
		
		// Wait 100 ns for global reset to finish
		#100;
		test = 32'h2+32'hFFFF_FFFC;
		// Add stimulus here

	end

   always #10  clk = ~clk;
	reg test_clk=1;
	always @(posedge clk)begin
		test_clk = ~test_clk;
	end
	reg test_clk2=1;
	always @(posedge test_clk)begin
		test_clk2 = ~test_clk2;
	end
endmodule

