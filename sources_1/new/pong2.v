`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2024 10:46:15 PM
// Design Name: 
// Module Name: pong2
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


module pongAnimation(
    input wire clk,
    input wire reset,
    input wire video_on,
    input wire [1:0] p1,
    input wire [1:0] p2,
    input wire BOT,
    input wire [15:0] x, 
    input wire [15:0] y,
    output reg [23:0] graph_rgb
);



reg [10:0] BALL_LX = 635, BALL_RX = 645, BALL_BY = 350, BALL_TY = 360, LPB = 300, LPT = 420, RPT = 420, RPB = 300;
wire on_ball, on_lpaddle, on_rpaddle, refresh;

reg [10:0] BALL_XV = 5, BALL_YV = 2;
reg [3:0] score_track;
reg [31:0] ref_track = 0;

`define maxX 1280 //resolution
`define maxY 720
`define pH 120 //paddle height
`define lplx 59  //left paddle left x
`define lprx 65 //left paddle right x
`define rplx 1215 //right paddle right x
`define rprx 1221 //right paddle right x
`define refresh_rate 719

 localparam RED = 24'b1111_1111_0000_0000_0000_0000;
 localparam GREEN = 24'b0000_0000_0000_0000_1111_1111;
 localparam BLUE = 24'b0000_0000_1111_1111__0000_0000;
 localparam BLACK = 24'b0000_0000_0000_0000_0000_0000;
 localparam WHITE = 24'b1111_1111_1111_1111_1111_1111;
 
 localparam bhor_v = 5;
 localparam bhor_nv = -5;
 localparam bvert_v = 2;
 localparam bvert_nv = -2;
 localparam pvert_v = 5;

    
/*always @(posedge clk, posedge reset) begin
if (reset) // reset all
    begin
        score <= 4'b1000;
        RpaddleYReg <= 0;
        LpaddleYReg <= 0;
        ballXReg <= 0;
        ballYReg <= 0;
        moveX <= 10'b0000000100;
        moveY <= 10'b0000000100;
    end
else begin // move all
        LpaddleYReg <= LpaddleYNext;
        RpaddleYReg <= RpaddleYNext;
        ballXReg <= ballXNext;
        ballYReg <= ballYNext;
        moveX <= moveXNext;
        moveY <= moveYNext;
    end
end*/

//check where we are at
assign on_ball = (x >= BALL_LX) && (x <= BALL_RX) && (y >= BALL_BY) && (y <= BALL_TY);
assign on_lpaddle = (x >= `lplx) && (x <= `lprx) && (y >= LPB) && (y <= LPT);
assign on_rpaddle = (x >= `rplx) && (x <= `rprx) && (y >= RPB) && (y <= RPT);
assign refresh = (x == 1279);

//need to change  this lol
always@(posedge refresh) begin
    if(reset) begin
        score_track <= 4'b1000;
        LPT <= 420;
        RPT <= 420;
        RPB <= 300;
        LPB <= 300;
        BALL_LX <= 635;
        BALL_RX <= 645;
        BALL_BY <= 350;
        BALL_TY <= 360;
    end
    if(ref_track == `refresh_rate && (!reset)) begin
        ref_track <= 0;
        //check for button presses and move the paddles accordingly
        if(p1[0] && (LPT < 720)) begin
            LPT <= LPT + pvert_v;
            LPB <= LPB + pvert_v;
        end
        else if(p1[1] && (LPB > 0)) begin
            LPT <= LPT - pvert_v;
            LPB <= LPB - pvert_v;
        end
        
        if(BOT) begin
            if((RPB + 60) > BALL_BY) begin
                if(RPB> 0) begin
                    RPT <= RPT - pvert_v;
                    RPB <= RPB - pvert_v;
                end
            end
            else if((RPB + 60) < BALL_BY) begin
                if(RPT < 720) begin
                    RPT <= RPT + pvert_v;
                    RPB <= RPB + pvert_v;
                end
            end
        end
        else begin
            if(p2[0] && (RPT < 720)) begin
                RPT <= RPT + pvert_v;
                RPB <= RPB + pvert_v;
            end
            else if(p2[1] && (RPB > 0)) begin
                RPT <= RPT - pvert_v;
                RPB <= RPB - pvert_v;
            end
        end
        
        //check for y collisions and move the ball accordingly
        if(BALL_TY == 720) begin
            BALL_YV = bvert_nv;
            BALL_TY <= BALL_TY + bvert_nv;
            BALL_BY <= BALL_BY + bvert_nv;
            end
        else if(BALL_BY == 0) begin
            BALL_YV = bvert_v;
            BALL_TY <= BALL_TY + bvert_v;
            BALL_BY <= BALL_BY + bvert_v;
        end
        else begin
            BALL_BY <= BALL_BY + BALL_YV;
            BALL_TY <= BALL_TY + BALL_YV;
        end
        
        //check for x collision, and score/move the ball accordingly
        if(BALL_LX == `lprx) begin
            if(BALL_BY <= LPT && BALL_TY >= LPB) begin
                BALL_XV <= bhor_v;
                BALL_LX <= BALL_LX + bhor_v;
                BALL_RX <= BALL_RX + bhor_v;
            end
            else begin
                score_track = score_track + 1;
                BALL_LX <= 635;
                BALL_RX <= 645;
            end
        end   
        else if(BALL_RX == `rplx) begin
            if(BALL_BY <= RPT && BALL_TY >= RPB) begin
                BALL_XV <= bhor_nv;
                BALL_LX <= BALL_LX + bhor_nv;
                BALL_RX <= BALL_RX + bhor_nv;
            end
            else begin
                score_track = score_track - 1;
                BALL_LX <= 635;
                BALL_RX <= 645;
            end
        end
        else begin
            BALL_LX <= BALL_LX + BALL_XV;
            BALL_RX <= BALL_RX + BALL_XV;
        end
    end
    else begin
        ref_track <= ref_track + 1;
    end
end

always@(*) begin
    if(~video_on) begin
        graph_rgb = BLACK;
    end
    else begin
        if(on_ball)
            graph_rgb = BLUE;
        else if(on_lpaddle)
            graph_rgb = RED;
        else if(on_rpaddle)
            graph_rgb = GREEN;
        else
            graph_rgb = WHITE;
    end
end

endmodule