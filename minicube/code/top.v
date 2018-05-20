`timescale 1ns / 1ps

module top(	input clk,
				input sw,//高低八位数码管显示
				input PS2C,PS2D,//键盘输入
				input [3:0] btn,//按键
				output [2:0] vgaRed,
				output [2:0] vgaGreen,
				output [1:0] vgaBlue,
				output Hsync,
				output [7:0]LED,
				output Vsync
    );
	wire clr;
	wire[15:0]key;
	assign clr = btn[3];
	assign LED = (sw)?key[7:0]:key[15:8];//LED显示键盘扫描码
	wire clk25,clk1000;//25mHz,10Hz时钟
	clk25 U1(.clk(clk),.clk25(clk25),.clk1000(clk1000));//分时
	keyboard U2(.clr(clr),.clk25(clk25),.PS2C(PS2C),.PS2D(PS2D),.key(key));//键盘输入获得扫描码
	wire pulse;//按键释放脉冲
	wire [71:0] dat,randdat;//魔方状态机储存数据，随机魔方状态机数据
	randGen U3(.clk(clk),.clk1000(clk1000),.randdat(randdat),.pulse(pulse));//随机状态生成模块
	Input U4(.clk(clk),.key(key),.dat(dat),.randdat(randdat),.pulse(pulse));//主输入模块，改变魔方方块颜色
	wire vidon;//显示使能信号
	wire [9:0] hc,vc;//行、列计数器
	vga_640x480 U7(.clr(clr),.clk(clk25),.hsync(Hsync),.vsync(Vsync),.vidon(vidon),.hc(hc),.vc(vc));//行列同步信号计数器
	wire [2:0] kRed,kGreen,cRed,cGreen,tRed,tGreen;//各显示模块RGB信号
	wire [1:0] kBlue,cBlue,tBlue;//各显示模块RGB信号
	vga_ker U8(.dat(dat),.vidon(vidon),.vc(vc),.hc(hc),.red(kRed),.green(kGreen),.blue(kBlue));//魔方显示模块
	vga_clk U9(.key(key),.clk(clk1000),.vidon(vidon),.vc(vc),.hc(hc),.red(cRed),.green(cGreen),.blue(cBlue));//时钟显示模块
	assign vgaBlue = cBlue|kBlue|tBlue;//显示模块信号或运算
	assign vgaRed = cRed|kRed|tRed;
	assign vgaGreen = cGreen|kGreen|tGreen;
	wire [7:0] M;//RAM数据输出
	wire [17:0]rom_addr;//RAM地址
	wire [7:0] dina;//输入数据
	wire wea;//写or读使能
	assign wea = 0;
	vga_tip UA(.M(M),.rom_addr(rom_addr),.vidon(vidon),.vc(vc),.hc(hc),.red(tRed),.green(tGreen),.blue(tBlue));//操作提示显示模块
	tip UB(.addra(rom_addr),.clka(clk25),.douta(M),.wea(wea),.dina(dina));//IP核RAM
	
endmodule
