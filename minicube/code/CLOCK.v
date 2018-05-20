`timescale 1ns / 1ps
module CLOCK(input clk,
				input reset,keep,
				output reg [6:0]one,ten,hundred,thd//个十百千位
    );
	reg [13:0] second=0;
	reg [4:0] bcd1=0,bcd2=0,bcd3=0,bcd4;
	always@(posedge clk)//计时器
		if(second == 9999||reset)
			second <= 0;
		else if(keep==0) second <= second + 1;
	always@(*)begin//二进制转BCD码
		bcd1= second%10;
		bcd2= (second%100-bcd1)/10;
		bcd4= second/1000;
		bcd3= second/100-bcd4*10;
	end
	always@(*)begin//BCD码转七段码
		case(bcd1)
			0:one<= 7'b0111111; //0
			1:one<= 7'b0000110; //1
			2:one<= 7'b1011011; //2
			3:one<= 7'b1001111; //3
			4:one<= 7'b1100110; //4
			5:one<= 7'b1101101; //5
			6:one<= 7'b1111101; //6
			7:one<= 7'b0000111; //7
			8:one<= 7'b1111111; //8
			9:one<= 7'b1101111; //9
		endcase
	end
	always@(*)begin
		case(bcd2)
			0:ten<= 7'b0111111; //0
			1:ten<= 7'b0000110; //1
			2:ten<= 7'b1011011; //2
			3:ten<= 7'b1001111; //3
			4:ten<= 7'b1100110; //4
			5:ten<= 7'b1101101; //5
			6:ten<= 7'b1111101; //6
			7:ten<= 7'b0000111; //7
			8:ten<= 7'b1111111; //8
			9:ten<= 7'b1101111; //9
		endcase
	end
	always@(*)begin
		case(bcd3)
			0:hundred<= 7'b0111111; //0
			1:hundred<= 7'b0000110; //1
			2:hundred<= 7'b1011011; //2
			3:hundred<= 7'b1001111; //3
			4:hundred<= 7'b1100110; //4
			5:hundred<= 7'b1101101; //5
			6:hundred<= 7'b1111101; //6
			7:hundred<= 7'b0000111; //7
			8:hundred<= 7'b1111111; //8
			9:hundred<= 7'b1101111; //9
		endcase
	end
	always@(*)begin
		case(bcd4)
			0:thd<= 7'b0111111; //0
			1:thd<= 7'b0000110; //1
			2:thd<= 7'b1011011; //2
			3:thd<= 7'b1001111; //3
			4:thd<= 7'b1100110; //4
			5:thd<= 7'b1101101; //5
			6:thd<= 7'b1111101; //6
			7:thd<= 7'b0000111; //7
			8:thd<= 7'b1111111; //8
			9:thd<= 7'b1101111; //9
		endcase
	end
endmodule


