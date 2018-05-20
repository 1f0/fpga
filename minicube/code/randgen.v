`timescale 1ns / 1ps
//生成魔方的随机状态
module randGen(input clk,pulse,clk1000,
					output reg [71:0] randdat//储存随机魔方状态机状态
    );
	initial begin//初始化状态机
		randdat[11:0] <= 12'b001001001001;
		randdat[35:12] <= 24'b010010_011011_100100_101101;
		randdat[59:36] <= 24'b010010_011011_100100_101101;
		randdat[71:60] <= 12'b110_110_110_110;
	end
	reg [9:0] seed,rand;//随机种子，随机数
	reg randop;
	always@(posedge clk) begin//随机种子从计数器获得
		if(seed<999) seed <= seed + 1;
		else seed <= 1;
	end
	always@(posedge clk1000)begin
		if(pulse == 0)begin
			rand <= (rand*101+37)%1000;//线性同余法获得随机数
			randop <=rand%3;
		end
		else rand <= seed;//玩家按键时更新随机种子
	end
	always@(posedge clk1000)
		if(randop==0)begin//逆时针旋转正前面
				randdat[23:21] <= randdat[47:45];
				randdat[47:45] <= randdat[44:42];
				randdat[44:42] <= randdat[20:18];
				randdat[20:18] <= randdat[23:21];
				randdat[11:6]<={randdat[50:48],randdat[26:24]};
				{randdat[50:48],randdat[26:24]}<={randdat[62:60],randdat[65:63]};
				{randdat[62:60],randdat[65:63]}<={randdat[17:15],randdat[41:39]};
				{randdat[17:15],randdat[41:39]}<=randdat[11:6];
		end
		else if(randop==1)begin//逆时针旋转上面
				randdat[2:0]  	<= randdat[5:3];
				randdat[5:3]  	<=randdat[11:9];
				randdat[11:9] 	<=randdat[8:6];
				randdat[8:6]  	<=randdat[2:0];
				randdat[35:30]	<=randdat[29:24];
				randdat[29:24] <=randdat[23:18];
				randdat[23:18] <=randdat[17:12];
				randdat[17:12]	<=randdat[35:30];
		end
		else begin//逆时针旋转右面
				randdat[26:24] <= randdat[29:27];
				randdat[29:27] <= randdat[53:51];
				randdat[53:51]	<=randdat[50:48];
				randdat[50:48]	<=randdat[26:24];
				{randdat[11:9],randdat[5:3]}   <= {randdat[32:30],randdat[56:54]};
				{randdat[32:30],randdat[56:54]}<={randdat[71:69],randdat[65:63]};
				{randdat[71:69],randdat[65:63]}<={randdat[47:45],randdat[23:21]};
				{randdat[47:45],randdat[23:21]}<={randdat[11:9],randdat[5:3]};
		end
endmodule
