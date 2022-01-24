`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2021 01:18:23 PM
// Design Name: 
// Module Name: Paddle
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
`include "defines.v"

module Paddle(
    input clk,
    input rst,
    input [31:0] data,
    input RX_Done,
//    input match_Ended,
//    output reg start_Match,
    output reg [9:0] paddle_Pos_H,
    output reg [9:0] paddle_Pos_V
    );
    
    reg [20:0] clk_div = 0;
    
    initial begin
//        start_Match <= 1'b0;
        paddle_Pos_H <= `LEFT_GAME_BOUND;
        paddle_Pos_V <= 10'd230 + `V_OFFSET;
    end
    
    always @(posedge clk) begin
        clk_div <= clk_div + 1'b1;
    end
    
    always @(posedge clk_div[20], posedge rst) begin
        if (rst) begin
            paddle_Pos_V <= 10'd230 + `V_OFFSET;
            paddle_Pos_H <= `LEFT_GAME_BOUND;
        end
//        else if (match_Ended) begin
//            case(data[7:0])
//                8'h29 : begin
//                    start_Match <= 1'b1;
//                    paddle_Pos_V <= 10'd230 + `V_OFFSET;
//                    paddle_Pos_H <= `LEFT_GAME_BOUND + `H_OFFSET;
//                end
//                default : begin 
//                    start_Match <= 1'b0;
//                    paddle_Pos_V <= 10'd230 + `V_OFFSET;
//                    paddle_Pos_H <= `LEFT_GAME_BOUND + `H_OFFSET;
//                end
//            endcase
//        end
        else begin
//            start_Match <= 1'b0;
            casez(data[15:0])
                16'h7272 : begin
                    if ((paddle_Pos_V + `PADDLE_HEIGHT) < `VERTICAL_LOWER_BOUND)
                        paddle_Pos_V <= paddle_Pos_V +10'd10;
                    else
                        paddle_Pos_V <= paddle_Pos_V;
                end
                16'h7575 : begin
                    if (paddle_Pos_V > `VERTICAL_UPPER_BOUND)
                        paddle_Pos_V <= paddle_Pos_V - 10'd10;
                    else
                        paddle_Pos_V <= paddle_Pos_V;
                end
                16'h7572 : begin
                    if ((paddle_Pos_V + `PADDLE_HEIGHT) < `VERTICAL_LOWER_BOUND)
                        paddle_Pos_V <= paddle_Pos_V +10'd10;
                    else
                        paddle_Pos_V <= paddle_Pos_V;
                end
                16'h7275 : begin
                    if (paddle_Pos_V > `VERTICAL_UPPER_BOUND)
                        paddle_Pos_V <= paddle_Pos_V - 10'd10;
                    else
                        paddle_Pos_V <= paddle_Pos_V;
                end
                16'hF0?? : begin
                    paddle_Pos_V <= paddle_Pos_V;
                end
                default : paddle_Pos_V <= paddle_Pos_V;
            endcase
        end
    end
    
endmodule
