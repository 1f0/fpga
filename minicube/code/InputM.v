`timescale 1ns / 1ps

module Input(input clk,
				input [71:0]randdat,
				input [15:0] key,
				output reg pulse,
				output reg [71:0] dat
    );
	reg[3:0] i;
	wire [2:0]rand;

	reg [2:0]tmp;
	reg [5:0]tmp2;
	initial begin
		dat[11:0] <= 12'b001001001001;//初始化
		dat[35:12] <= 24'b010010_011011_100100_101101;
		dat[59:36] <= 24'b010010_011011_100100_101101;
		dat[71:60] <= 12'b110_110_110_110;
	end
	always@(posedge clk)begin//释放按键时，pulse产生上升沿
		if(key[15:8]==8'hf0)begin
			pulse<=1;
		end
		else pulse <= 0;
	end
	always@(posedge pulse)begin
		if(key[7:0]==8'h15)begin//Q键释放
				dat[23:21] <= dat[47:45];
				dat[47:45] <= dat[44:42];
				dat[44:42] <= dat[20:18];
				dat[20:18] <= dat[23:21];
				dat[11:6]<={dat[50:48],dat[26:24]};
				{dat[50:48],dat[26:24]}<={dat[62:60],dat[65:63]};
				{dat[62:60],dat[65:63]}<={dat[17:15],dat[41:39]};
				{dat[17:15],dat[41:39]}<=dat[11:6];
			end
		else if(key[7:0]==8'h1d)begin//W键释放
				dat[2:0]  	<= dat[5:3];
				dat[5:3]  	<=dat[11:9];
				dat[11:9] 	<=dat[8:6];
				dat[8:6]  	<=dat[2:0];
				dat[35:30]	<=dat[29:24];
				dat[29:24] <=dat[23:18];
				dat[23:18] <=dat[17:12];
				dat[17:12]	<=dat[35:30];
			end/
		else if(key[7:0]==8'h24)begin//E键释放
				dat[26:24] <= dat[29:27];
				dat[29:27] <= dat[53:51];
				dat[53:51]	<=dat[50:48];
				dat[50:48]	<=dat[26:24];
				{dat[11:9],dat[5:3]}   <= {dat[32:30],dat[56:54]};
				{dat[32:30],dat[56:54]}<={dat[71:69],dat[65:63]};
				{dat[71:69],dat[65:63]}<={dat[47:45],dat[23:21]};
				{dat[47:45],dat[23:21]}<={dat[11:9],dat[5:3]};
			end
		else if(key[7:0]==8'h2b)begin//F键释放，复位
			dat[11:0] <= 12'b001001001001;
			dat[35:12] <= 24'b010010_011011_100100_101101;
			dat[59:36] <= 24'b010010_011011_100100_101101;
			dat[71:60] <= 12'b110_110_110_110;
		end
		else if(key[7:0]==8'h1c)begin//A键释放
				dat[23:21] <= dat[20:18];
				dat[47:45] <= dat[23:21];
				dat[44:42] <= dat[47:45];
				dat[20:18] <= dat[44:42];
				dat[11:6]<={dat[17:15],dat[41:39]};
				{dat[50:48],dat[26:24]}<=dat[11:6];
				{dat[62:60],dat[65:63]}<={dat[50:48],dat[26:24]};
				{dat[17:15],dat[41:39]}<={dat[62:60],dat[65:63]};
		end
		else if(key[7:0]==8'h1b)begin//S键释放
				dat[2:0]  	<= dat[8:6];
				dat[5:3]  	<=dat[2:0];
				dat[11:9] 	<=dat[5:3];
				dat[8:6]  	<=dat[11:9];
				dat[35:30]	<=dat[17:12];
				dat[29:24] <=dat[35:30];
				dat[23:18] <=dat[29:24];
				dat[17:12]	<=dat[23:18];
			end//i,ur
		else if(key[7:0]==8'h23)begin//D键释放
				dat[26:24] <= dat[50:48];
				dat[29:27] <= dat[26:24];
				dat[53:51]	<=dat[29:27];
				dat[50:48]	<=dat[53:51];
				{dat[11:9],dat[5:3]}   <= {dat[47:45],dat[23:21]};
				{dat[32:30],dat[56:54]}<={dat[11:9],dat[5:3]};
				{dat[71:69],dat[65:63]}<={dat[32:30],dat[56:54]};
				{dat[47:45],dat[23:21]}<={dat[71:69],dat[65:63]};
			end//r
		else if(key[7:0]==8'h2d)begin//R键释放，随机化魔方
			dat<=randdat;
		end
	end
endmodule
