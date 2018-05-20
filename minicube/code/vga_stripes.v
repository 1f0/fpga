`timescale 1ns / 1ps
module vga_ker(
					input vidon,
					input [71:0] dat,
					input [9:0] hc,vc,
					output reg [2:0] red,
					output reg [2:0] green,
					output reg[1:0] blue
    );
	always@(*) begin//在魔方各方块区域内显示相应数据
		if(vidon == 1 && 300<hc && hc<340 && 100<vc && vc<140)begin
			red <= {3{dat[0]}};
			green <= {3{dat[1]}};
			blue <= {2{dat[2]}};
		end
		else if(vidon == 1 && 350<hc && hc<390 && 100<vc && vc<140)begin
			red <= {3{dat[3]}};
			green <= {3{dat[4]}};
			blue <= {2{dat[5]}};
		end
		else if(vidon == 1 && 300<hc && hc<340 && 150<vc && vc<190)begin
			red <= {3{dat[6]}};
			green <= {3{dat[7]}};
			blue <= {2{dat[8]}};
		end
		else if(vidon == 1 && 350<hc && hc<390 && 150<vc && vc<190)begin
			red <= {3{dat[9]}};
			green <= {3{dat[10]}};
			blue <= {2{dat[11]}};
		end
//
		else if(vidon == 1 && 200<hc && hc<240 && 200<vc && vc<240)begin
			red <= {3{dat[12]}};
			green <= {3{dat[13]}};
			blue <= {2{dat[14]}};
		end
		else if(vidon == 1 && 250<hc && hc<290 && 200<vc && vc<240)begin
			red <= {3{dat[15]}};
			green <= {3{dat[16]}};
			blue <= {2{dat[17]}};
		end
		else if(vidon == 1 && 300<hc && hc<340 && 200<vc && vc<240)begin
			red <= {3{dat[18]}};
			green <= {3{dat[19]}};
			blue <= {2{dat[20]}};
		end
		else if(vidon == 1 && 350<hc && hc<390 && 200<vc && vc<240)begin
			red <= {3{dat[21]}};
			green <= {3{dat[22]}};
			blue <= {2{dat[23]}};
		end
		else if(vidon == 1 && 400<hc && hc<440 && 200<vc && vc<240)begin
			red <= {3{dat[24]}};
			green <= {3{dat[25]}};
			blue <= {2{dat[26]}};
		end
		else if(vidon == 1 && 450<hc && hc<490 && 200<vc && vc<240)begin
			red   <= {3{dat[27]}};
			green <= {3{dat[28]}};
			blue  <= {2{dat[29]}};
		end
		else if(vidon == 1 && 500<hc && hc<540 && 200<vc && vc<240)begin
			red   <= {3{dat[30]}};
			green <= {3{dat[31]}};
			blue  <= {2{dat[32]}};
		end
		else if(vidon == 1 && 550<hc && hc<590 && 200<vc && vc<240)begin
			red   <= {3{dat[33]}};
			green <= {3{dat[34]}};
			blue  <= {2{dat[35]}};
		end
//
		else if(vidon == 1 && 200<hc && hc<240 && 250<vc && vc<290)begin
			red <= {3{dat[36]}};
			green <= {3{dat[37]}};
			blue <= {2{dat[38]}};
		end
		else if(vidon == 1 && 250<hc && hc<290 && 250<vc && vc<290)begin
			red <= {3{dat[39]}};
			green <= {3{dat[40]}};
			blue <= {2{dat[41]}};
		end
		else if(vidon == 1 && 300<hc && hc<340 && 250<vc && vc<290)begin
			red <= {3{dat[42]}};
			green <= {3{dat[43]}};
			blue <= {2{dat[44]}};
		end
		else if(vidon == 1 && 350<hc && hc<390 && 250<vc && vc<290)begin
			red <= {3{dat[45]}};
			green <= {3{dat[46]}};
			blue <= {2{dat[47]}};
		end
		else if(vidon == 1 && 400<hc && hc<440 && 250<vc && vc<290)begin
			red <= {3{dat[48]}};
			green <= {3{dat[49]}};
			blue <= {2{dat[50]}};
		end
		else if(vidon == 1 && 450<hc && hc<490 && 250<vc && vc<290)begin
			red   <= {3{dat[51]}};
			green <= {3{dat[52]}};
			blue  <= {2{dat[53]}};
		end
		else if(vidon == 1 && 500<hc && hc<540 && 250<vc && vc<290)begin
			red   <= {3{dat[54]}};
			green <= {3{dat[55]}};
			blue  <= {2{dat[56]}};
		end
		else if(vidon == 1 && 550<hc && hc<590 && 250<vc && vc<290)begin
			red   <= {3{dat[57]}};
			green <= {3{dat[58]}};
			blue  <= {2{dat[59]}};
		end
//
		else if(vidon == 1 && 300<hc && hc<340 && 300<vc && vc<340)begin
			red <= {3{dat[60]}};
			green <= {3{dat[61]}};
			blue <= {2{dat[62]}};
		end
		else if(vidon == 1 && 350<hc && hc<390 && 300<vc && vc<340)begin
			red <= {3{dat[63]}};
			green <= {3{dat[64]}};
			blue <= {2{dat[65]}};
		end
		else if(vidon == 1 && 300<hc && hc<340 && 350<vc && vc<390)begin
			red <= {3{dat[66]}};
			green <= {3{dat[67]}};
			blue <= {2{dat[68]}};
		end
		else if(vidon == 1 && 350<hc && hc<390 && 350<vc && vc<390)begin
			red <= {3{dat[69]}};
			green <= {3{dat[70]}};
			blue <= {2{dat[71]}};
		end
//
		else begin
			red <= 0;
			green <= 0;
			blue <= 0;
		end
	end
endmodule


