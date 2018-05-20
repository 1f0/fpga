`timescale 1ns / 1ps

module clk25(input clk,
				output reg clk25 = 0,
				output reg clk1000
    );
	reg rec = 0;//flag used in clk25
	reg [30:0] count;
	always@(negedge clk)begin//clk25 = clk/4
		if(rec == 0) begin
			rec <= 1;
		end
		else begin
			clk25 <= ~clk25;
			rec <= 0;
		end
	end
	always@(negedge clk25)begin
		if(count<1250000) count = count +1;//通过计数进行延迟，25mHz->10Hz
		else begin
			clk1000 = ~clk1000;
			count = 0;
		end
	end
endmodule
