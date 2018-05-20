`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:38:35 01/31/2015 
// Design Name: 
// Module Name:    seg7dis 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module seg7dis(input [9:0]x,y,//显示数字的左上角坐标
					input vidon,
					input [9:0] hc,vc,
					input [6:0] num,
					output reg [2:0] red,
					output reg [2:0] green,
					output reg[1:0] blue
    );
	parameter width = 10;//每一段数码管的宽度
	parameter len1 =42;//两边数码管的长度
	parameter len2 =28;//中间数码管的长度
	//a,b,c,d,e,f,g各部分的矩形
	always@(*) begin
		if(vidon == 1 && 1+x+width<hc && hc<x+width+len2-1 && y<vc && vc<y+width)begin
			red <= {3{num[0]}};
			green <= {3{num[0]}};
			blue <= {2{num[0]}};
		end
		else if(vidon == 1 && x+width+len2+1<hc && hc<x+2*width+len2 && y<vc && vc<y+len1-1)begin
			red <=   {3{num[1]}};
			green <= {3{num[1]}};
			blue <=  {2{num[1]}};
		end	
		else if(vidon == 1 && x+width+len2+1<hc && hc<x+2*width+len2 && y+len1+1<vc && vc<y+2*len1)begin
			red <=   {3{num[2]}};
			green <= {3{num[2]}};
			blue <=  {2{num[2]}};
		end
		else if(vidon == 1 && 1+x+width<hc && hc<x+width+len2-1 && y+2*len1-5<vc && vc<y+2*len1+5)begin
			red <=   {3{num[3]}};
			green <= {3{num[3]}};
			blue <=  {2{num[3]}};
		end
		else if(vidon == 1 && x<hc && hc<x+width && y+len1+1<vc && vc<y+2*len1-1)begin
			red <=   {3{num[4]}};
			green <= {3{num[4]}};
			blue <=  {2{num[4]}};
		end
		else if(vidon == 1 && x<hc && hc<x+width && y+1<vc && vc<y+len1-1)begin
			red <=   {3{num[5]}};
			green <= {3{num[5]}};
			blue <=  {2{num[5]}};
		end	
		else if(vidon == 1 && x+width+1<hc && hc<x+width+len2-1 && y+len1-5<vc && vc<y+len1+5)begin
			red <=   {3{num[6]}};
			green <= {3{num[6]}};
			blue <=  {2{num[6]}};
		end
		else begin
			red<=0;
			green<=0;
			blue<=0;
		end
	end
endmodule
