`timescale 1ns / 1ps

module vga_clk(input clk,
					input [15:0]key,
					input vidon,
					input [9:0] hc,vc,
					output [2:0] red,
					output [2:0] green,
					output [1:0] blue
    );
	reg point;
	wire K,E;
	wire [2:0] red1,red2,red3,red4,green1,green2,green3,green4;
	wire [1:0] blue1,blue2,blue3,blue4;
	always@(*)begin//小数点显示
		if(vidon == 1&& hc>690&&hc<694&&vc>132&&vc<136)begin
			point = 1;
		end
		else point = 0;
	end
	assign K = (key[7:0]==8'h2b)?1:0;//释放F时，keep，保持计数
	assign E = (key[7:0]==8'h29)?1:0;//释放E时, end，重新计时
	assign red = red1|red2|red3|red4|{3{point}};
	assign blue = blue1|blue2|blue3|blue4|{2{point}};
	assign green = green1|green2|green3|green4|{3{point}};
	wire [9:0]x=700,y=50,x1=630,x2=570,x3=510;
	wire [6:0] one,ten,hundred,thd;//个十百千位数据，CLOCK模块与segdis模块间数据传输线
	CLOCK C1(.reset(K),.keep(E),.clk(clk),.one(one),.ten(ten),.hundred(hundred),.thd(thd));
	seg7dis  C2(.x(x),.y(y),.red(red1),.green(green1),.blue(blue1),.num(one),.hc(hc),.vc(vc),.vidon(vidon)),//七段码转显示RGB信号
				C3(.x(x1),.y(y),.red(red2),.green(green2),.blue(blue2),.num(ten),.hc(hc),.vc(vc),.vidon(vidon)),
				C4(.x(x2),.y(y),.red(red3),.green(green3),.blue(blue3),.num(hundred),.hc(hc),.vc(vc),.vidon(vidon)),
				C5(.x(x3),.y(y),.red(red4),.green(green4),.blue(blue4),.num(thd),.hc(hc),.vc(vc),.vidon(vidon));				
endmodule
