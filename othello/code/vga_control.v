`timescale 1ns / 1ps

module vgac (vga_clk,clrn,d_in,row_addr,col_addr,rdn,r,g,b,hs,vs);   // vgac
    input     [7:0] d_in;       // rrrrrrrr_gggggggg_bbbbbbbb, pixel
    input            vga_clk;    // 25MHz
    input            clrn;
    output reg [8:0] row_addr;   // pixel ram row address, 480 (512) lines
    output reg [9:0] col_addr;   // pixel ram col address, 640 (1024) pixels
    output reg [2:0] r,g;      // red, green, blue colors, 8-bit for each
	 output reg [1:0] b;
    output reg       rdn;        // read pixel RAM (active low)
    output reg       hs,vs;      // horizontal and vertical synchronization
    // h_count: vga horizontal counter (0-799 pixels)
    reg [9:0] h_count;
    always @ (posedge vga_clk or negedge clrn) begin
        if (!clrn) begin
            h_count <= 10'h0;
        end else if (h_count == 10'd799) begin
            h_count <= 10'h0;
        end else begin 
            h_count <= h_count + 10'h1;
        end
    end
    // v_count: vga vertical counter (0-524 lines)
    reg [9:0] v_count;
    always @ (posedge vga_clk or negedge clrn) begin
        if (!clrn) begin
            v_count <= 10'h0;
        end else if (h_count == 10'd799) begin
            if (v_count == 10'd524) begin
                v_count <= 10'h0;
            end else begin
                v_count <= v_count + 10'h1;
            end
        end
    end
    // signals, will be latched for outputs
    wire  [9:0] row    =  v_count - 10'd35;       // pixel ram row address 
    wire  [9:0] col    =  h_count - 10'd143;      // pixel ram col address 
    wire        h_sync = (h_count > 10'd95);      //  96 -> 799
    wire        v_sync = (v_count > 10'd1);       //   2 -> 524
    wire        read   = (h_count > 10'd142) &&   // 143 -> 782 =
                         (h_count < 10'd783) &&   //              640 pixels
                         (v_count > 10'd34)  &&   //  35 -> 514 =
                         (v_count < 10'd515);     //              480 lines
    // vga signals
    always @ (posedge vga_clk) begin
        row_addr <=  row[8:0];                    // pixel ram row address
        col_addr <=  col;                         // pixel ram col address
        rdn      <= ~read;                        // read pixel (active low)
        hs       <=  h_sync;                      // horizontal synch
        vs       <=  v_sync;                      // vertical   synch
        r        <=  rdn ? 3'h0 : d_in[7:5];    // 8-bit red
        g        <=  rdn ? 3'h0 : d_in[4:2];    // 8-bit green
        b        <=  rdn ? 2'h0 : d_in[1:0];    // 8-bit blue
    end
endmodule
