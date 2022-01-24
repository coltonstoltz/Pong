`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2021 11:33:03 AM
// Design Name: 
// Module Name: p2
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


module p2(
    input clk,
    input rst,
    input [9:0] ball_Pos_H,
    input [9:0] ball_Pos_V,
    output reg [9:0] p2_Pos_H,
    output reg [9:0] p2_Pos_V
    );
    
    reg [20:0] clk_div = 0;
    reg [9:0] delay_Reg_H1;
    reg [9:0] delay_Reg_V1;
    reg [9:0] delay_Reg_H2;
    reg [9:0] delay_Reg_V2;
    reg [9:0] delay_Reg_H3;
    reg [9:0] delay_Reg_V3;
    reg [9:0] delay_Reg_H4;
    reg [9:0] delay_Reg_V4;
    reg [9:0] delay_Reg_H5;
    reg [9:0] delay_Reg_V5;
    reg [9:0] delay_Reg_H6;
    reg [9:0] delay_Reg_V6;
    reg [9:0] delay_Reg_H7;
    reg [9:0] delay_Reg_V7;
    reg [9:0] delay_Reg_H8;
    reg [9:0] delay_Reg_V8;
    
    initial begin
        p2_Pos_H <= `RIGHT_GAME_BOUND - `PADDLE_WIDTH;
        p2_Pos_V <= 10'd230 + `V_OFFSET;
    end
    
    always @(posedge clk) begin
        clk_div <= clk_div + 1'b1;
    end
    
    always @(posedge clk_div[20]) begin
        if (rst) begin
            delay_Reg_H1 <= 0;
            delay_Reg_V1 <= 0;
            delay_Reg_H2 <= 0;
            delay_Reg_V2 <= 0;
            delay_Reg_H3 <= 0;
            delay_Reg_V3 <= 0;
            delay_Reg_H4 <= 0;
            delay_Reg_V4 <= 0;
            delay_Reg_H5 <= 0;
            delay_Reg_V5 <= 0;
            delay_Reg_H6 <= 0;
            delay_Reg_V6 <= 0;
            delay_Reg_H7 <= 0;
            delay_Reg_V7 <= 0;
            delay_Reg_H8 <= 0;
            delay_Reg_V8 <= 0;
        end
        else begin
            delay_Reg_H1 <= ball_Pos_H;
            delay_Reg_V1 <= ball_Pos_V;
            delay_Reg_H2 <= delay_Reg_H1;
            delay_Reg_V2 <= delay_Reg_V1;
            delay_Reg_H3 <= delay_Reg_H2;
            delay_Reg_V3 <= delay_Reg_V2;
            delay_Reg_H4 <= delay_Reg_H3;
            delay_Reg_V4 <= delay_Reg_V3;
            delay_Reg_H5 <= delay_Reg_H4;
            delay_Reg_V5 <= delay_Reg_V4;
            delay_Reg_H6 <= delay_Reg_H5;
            delay_Reg_V6 <= delay_Reg_V5;
            delay_Reg_H7 <= delay_Reg_H6;
            delay_Reg_V7 <= delay_Reg_V6;
            delay_Reg_H8 <= delay_Reg_H7;
            delay_Reg_V8 <= delay_Reg_V7;
        end
    end
    
    always @(posedge clk_div[20]) begin
        if (rst) begin
            p2_Pos_H <= `RIGHT_GAME_BOUND - `PADDLE_WIDTH;
            p2_Pos_V <= 10'd230 + `V_OFFSET;
        end
        else begin
            if ((delay_Reg_V8+`BALL_RADIUS) > (p2_Pos_V+`PADDLE_HEIGHT)) 
                p2_Pos_V <= p2_Pos_V + 10'd3;
            else if ((delay_Reg_V8-`BALL_RADIUS) < p2_Pos_V)
                p2_Pos_V <= p2_Pos_V - 10'd3;
            else
                p2_Pos_V <= p2_Pos_V;
        end
    end
endmodule
