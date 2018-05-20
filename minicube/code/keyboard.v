`timescale 1ns / 1ps
module keyboard(input clk25,
					input clr,
					input PS2C,
					input PS2D,
					output [15:0] key
    );
	reg PS2Cf,PS2Df;
	reg [7:0]ps2c_filter,ps2d_filter;
	reg [10:0]shift1,shift2;//键盘扫描码低八位，高八位
	assign key = {shift2[8:1],shift1[8:1]};
	always@(posedge clk25 or posedge clr)
		begin if(clr==1)
			begin
				ps2c_filter<=0;
				ps2d_filter<=0;
				PS2Cf<=1;
				PS2Df<=1;
			end
		else
			begin
				ps2c_filter[7]<=PS2C;
				ps2c_filter[6:0]<=ps2c_filter[7:1];//移位操作
				ps2d_filter[7]<=PS2D;
				ps2d_filter[6:0]<=ps2d_filter[7:1];
				if(ps2c_filter==8'b11111111)//连续八个一，发送一个脉冲。
					PS2Cf<=1;
				else 
					if(ps2c_filter==8'b00000000)
						PS2Cf<=0;
					if(ps2d_filter==8'b11111111)
						PS2Df<=1;
					else
						if(ps2d_filter==8'b00000000)
							PS2Df<=0;
			end
		end
	always@(negedge PS2Cf or posedge clr)begin
		if(clr == 1)begin
			shift1<=0;
			shift2<=1;
		end
		else begin
			shift1<={PS2Df,shift1[10:1]};//移位操作
			shift2<={shift1[0],shift2[10:1]};//移位操作
		end
	end
endmodule
