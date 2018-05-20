`timescale 1ns / 1ps
module vga_tip(input vidon,
					input [9:0]hc,vc,
					input [7:0] M,
					input [7:0]sw,
					output [15:0]rom_addr,
					output reg [2:0] red,green,
					output reg [1:0]blue
    );//显示200x140大小的图像
	parameter hbp = 10'b0010010000;
	parameter vbp = 10'b0000011111;
	parameter W = 200;//图像宽
	parameter H = 140;//图像高
	wire[10:0]C1,R1,xpix,ypix;
	wire[16:0]rom_addr1,rom_addr2;
	reg spriteon,R,G,B;
	assign C1 = 400;
	assign R1 = 300;
	assign ypix = vc - vbp - R1;
	assign xpix = hc - hbp - C1;
	assign rom_addr1 = ypix*200;
	assign rom_addr2 =rom_addr1+{8'b00000000,xpix};//RAM地址计算
	assign rom_addr = rom_addr2[15:0];
	always@(*)begin//在图像显示区域内
		if((hc>=C1+hbp)&&(hc<C1+hbp+W)&&(vc>=R1+vbp)&&(vc<R1+vbp+H))
			spriteon = 1;
		else
			spriteon = 0;
	end
	always@(*)begin//读取RAM相应数据
		red = 0;green = 0; blue = 0;
		if((spriteon == 1)&&(vidon==1))begin
			red = M[7:5];
			green=M[4:2];
			blue=M[1:0];
		end
	end
endmodule
