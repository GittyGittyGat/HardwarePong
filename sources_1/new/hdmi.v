`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2024 03:43:37 PM
// Design Name: 
// Module Name: HDMI_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module HDMI_TOP(
    input clk,
    input reset,
    input [1:0] p1,
    input [1:0] p2,
    input BOT,
    output HDMI_HPD,
    output [2:0] TMDSp,
    output [2:0] TMDSn,
    output TMDSclkp,
    output TMDSclkn
    );
    
   assign HDMI_HPD = 1'b1;
   
    wire PixelClk;
    wire [15:0] row;
    wire [15:0] column;
    wire hsync, vsync;
    wire active;
    wire [23:0] rgb_wire;
    /*
    input wire reset,
    input wire clk,

    output reg [15:0] x,
    output reg [15:0] y,
    output reg hsync,
    output reg vsync,
    output reg active
    */
    clk_wiz_0 u0(.reset(reset), .clk_in1(clk), .clk_out1(PixelClk));
    TMDS_TIMING u1(.reset(reset), .clk(PixelClk), .x(column), .y(row), .hsync(hsync), .vsync(vsync), .active(active));
    rgb2dvi_0 u2(.vid_pData(rgb_wire), .vid_pHSync(hsync), .vid_pVSync(vsync), .vid_pVDE(active), .aRst(reset), .PixelClk(PixelClk), .TMDS_Clk_p(TMDSclkp), .TMDS_Clk_n(TMDSclkn), .TMDS_Data_p(TMDSp), .TMDS_Data_n(TMDSn));
    //pongAnimation u3(.clk(PixelClk), .reset(reset), .video_on(active), .p1(player1), .p2(player2), .pix_x(column), .pix_y(row), .graph_rgb(rgb_wire), .score(score));
    pongAnimation u3(.clk(PixelClk), .reset(reset), .video_on(active), .x(column), .y(row), .graph_rgb(rgb_wire), .p1(p1), .p2(p2), .BOT(BOT));
    /*

    input wire clk,
    input wire reset,
    input wire video_on,


    input wire [15:0] x, 
    input wire [15:0] y,
    output reg [23:0] graph_rgb
    */
    
    
endmodule