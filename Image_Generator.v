`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2021 03:58:25 PM
// Design Name: 
// Module Name: Image_Generator
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
//`define VGA_DEBUG

`include "defines.v"

module Image_Generator(
    input clk,
    input rst,
    input [9:0] h_count,
    input [9:0] v_count,
    input [9:0] paddle_Pos_H,
    input [9:0] paddle_Pos_V,
    input [9:0] p2_Pos_H,
    input [9:0] p2_Pos_V,
    input [9:0] ball_Pos_H,
    input [9:0] ball_Pos_V,
    input [2:0] player_Score,
    input [2:0] cpu_Score,
    input player_Win,
    input cpu_Win,
    output [11:0] pixel
    );
    
    reg [2:0] vertical_Value = 0;
    reg [2:0] horizontal_Value = 0;
    reg [11:0] sec_Count = 0;
    reg [11:0] internal_value = 0;
    integer i;
    reg [19:0] NUM_PIXELS = 297600;
    reg [11:0] pixel_Reg1;
    reg [11:0] pixel_Reg2;
    reg [11:0] pixel_Reg3;
    reg [11:0] pixel_Reg4;
//    reg [11:0] pixel_Reg5;
    reg draw_Net = 1'b1;
    reg visible_V_Counter = 10'd0;
    reg [9:0] prev_V_Count;
    
    `ifndef VGA_DEBUG
    // Paddle and Ball Drawing
    always @(h_count, v_count) begin
        if ((h_count >= paddle_Pos_H & (h_count < paddle_Pos_H + `PADDLE_WIDTH)) &
           (v_count >= paddle_Pos_V & (v_count < paddle_Pos_V + `PADDLE_HEIGHT)) 
                                        | 
           (h_count >= (ball_Pos_H-`BALL_RADIUS) & h_count <= (ball_Pos_H+`BALL_RADIUS) & 
            v_count >= (ball_Pos_V-`BALL_RADIUS) & v_count <= (ball_Pos_V+`BALL_RADIUS)) 
                                        | 
           (h_count >= p2_Pos_H & (h_count < p2_Pos_H + `PADDLE_WIDTH) &
           v_count >= p2_Pos_V & (v_count < p2_Pos_V + `PADDLE_HEIGHT)))
            pixel_Reg1 <= 12'hFFF;
        else 
            pixel_Reg1 <= 12'd0;
    end
    
//    always @(h_count, v_count) begin
//        case ({player_Win, cpu_Win})
//            2'b00 : pixel_Reg5 <= 12'h0;
//            2'b01 : begin
//                if (v_count >= (0*`SQUARE_OFFSET+`MIDDLE_V) && v_count < (1*`SQUARE_OFFSET+`MIDDLE_V)) begin
                    
//                end
//            end 
//            2'b10 : begin
                
//            end 
//            2'b11 : pixel_Reg5 <= 12'h0; 
//            default : pixel_Reg5 <= 12'h0; 
//        endcase
//    end
    
    //  This block draws the player's score
    always @(h_count, v_count) begin
        case(player_Score)
            3'b000 : begin
                if (v_count >= (0*`SQUARE_OFFSET+`DIGIT_V) && v_count < (1*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (1*`SQUARE_OFFSET+`DIGIT_V) && v_count < (2*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                                                            ||
                       (h_count >= (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H)))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (2*`SQUARE_OFFSET+`DIGIT_V) && v_count < (3*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                                                            ||
                       (h_count >= (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H)))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (3*`SQUARE_OFFSET+`DIGIT_V) && v_count < (4*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                                                            ||
                       (h_count >= (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H)))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (4*`SQUARE_OFFSET+`DIGIT_V) && v_count < (5*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                                                            ||
                       (h_count >= (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H)))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (5*`SQUARE_OFFSET+`DIGIT_V) && v_count < (6*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                                                            ||
                       (h_count >= (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H)))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (6*`SQUARE_OFFSET+`DIGIT_V) && v_count < (7*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else
                    pixel_Reg2 <= 12'h0;
            end
            3'b001 : begin
                if (v_count >= (0*`SQUARE_OFFSET+`DIGIT_V) && v_count < (1*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (2*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (1*`SQUARE_OFFSET+`DIGIT_V) && v_count < (2*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (2*`SQUARE_OFFSET+`DIGIT_V) && v_count < (3*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (2*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (3*`SQUARE_OFFSET+`DIGIT_V) && v_count < (4*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (2*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (4*`SQUARE_OFFSET+`DIGIT_V) && v_count < (5*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (2*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (5*`SQUARE_OFFSET+`DIGIT_V) && v_count < (6*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (2*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (6*`SQUARE_OFFSET+`DIGIT_V) && v_count < (7*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (0*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else
                    pixel_Reg2 <= 12'h0;
            end
            3'b010 : begin
                if (v_count >= (0*`SQUARE_OFFSET+`DIGIT_V) && v_count < (1*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (1*`SQUARE_OFFSET+`DIGIT_V) && v_count < (2*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                                                            ||
                       (h_count >= (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H)))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (2*`SQUARE_OFFSET+`DIGIT_V) && v_count < (3*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (3*`SQUARE_OFFSET+`DIGIT_V) && v_count < (4*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (2*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (4*`SQUARE_OFFSET+`DIGIT_V) && v_count < (5*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (2*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (5*`SQUARE_OFFSET+`DIGIT_V) && v_count < (6*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (0*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (6*`SQUARE_OFFSET+`DIGIT_V) && v_count < (7*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (0*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else
                    pixel_Reg2 <= 12'h0;
            end
            3'b011 : begin
                if (v_count >= (0*`SQUARE_OFFSET+`DIGIT_V) && v_count < (1*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (1*`SQUARE_OFFSET+`DIGIT_V) && v_count < (2*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                                                            ||
                       (h_count >= (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H)))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (2*`SQUARE_OFFSET+`DIGIT_V) && v_count < (3*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (3*`SQUARE_OFFSET+`DIGIT_V) && v_count < (4*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (4*`SQUARE_OFFSET+`DIGIT_V) && v_count < (5*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (5*`SQUARE_OFFSET+`DIGIT_V) && v_count < (6*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                                                            ||
                       (h_count >= (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (4*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H)))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else if (v_count >= (6*`SQUARE_OFFSET+`DIGIT_V) && v_count < (7*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H) && h_count < (3*`SQUARE_OFFSET+`PLAYER_DIGIT_1_H))
                        pixel_Reg2 <= 12'hFFF;
                    else
                        pixel_Reg2 <= 12'h0;
                end
                else
                    pixel_Reg2 <= 12'h0;
            end
            default : pixel_Reg2 <= 12'h0; 
        endcase
    end
    
    //  This block draws the CPU score
    always @(h_count, v_count) begin
        case(cpu_Score)
            3'b000 : begin
                if (v_count >= (0*`SQUARE_OFFSET+`DIGIT_V) & v_count < (1*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (1*`SQUARE_OFFSET+`DIGIT_V) & v_count < (2*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                                                            |
                       (h_count >= (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H)))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (2*`SQUARE_OFFSET+`DIGIT_V) & v_count < (3*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                                                            |
                       (h_count >= (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H)))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (3*`SQUARE_OFFSET+`DIGIT_V) & v_count < (4*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                                                            |
                       (h_count >= (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H)))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (4*`SQUARE_OFFSET+`DIGIT_V) & v_count < (5*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                                                            |
                       (h_count >= (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H)))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (5*`SQUARE_OFFSET+`DIGIT_V) & v_count < (6*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                                                            |
                       (h_count >= (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H)))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (6*`SQUARE_OFFSET+`DIGIT_V) & v_count < (7*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else
                    pixel_Reg3 <= 12'h0;
            end
            3'b001 : begin
                if (v_count >= (0*`SQUARE_OFFSET+`DIGIT_V) & v_count < (1*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (2*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (1*`SQUARE_OFFSET+`DIGIT_V) & v_count < (2*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (2*`SQUARE_OFFSET+`DIGIT_V) & v_count < (3*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (2*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (3*`SQUARE_OFFSET+`DIGIT_V) & v_count < (4*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (2*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (4*`SQUARE_OFFSET+`DIGIT_V) & v_count < (5*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (2*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (5*`SQUARE_OFFSET+`DIGIT_V) & v_count < (6*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (2*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (6*`SQUARE_OFFSET+`DIGIT_V) & v_count < (7*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (0*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else
                    pixel_Reg3 <= 12'h0;
            end
            3'b010 : begin
                if (v_count >= (0*`SQUARE_OFFSET+`DIGIT_V) & v_count < (1*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (1*`SQUARE_OFFSET+`DIGIT_V) & v_count < (2*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                                                            |
                       (h_count >= (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H)))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (2*`SQUARE_OFFSET+`DIGIT_V) & v_count < (3*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (3*`SQUARE_OFFSET+`DIGIT_V) & v_count < (4*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (2*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (4*`SQUARE_OFFSET+`DIGIT_V) & v_count < (5*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (2*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (5*`SQUARE_OFFSET+`DIGIT_V) & v_count < (6*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (0*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (6*`SQUARE_OFFSET+`DIGIT_V) & v_count < (7*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (0*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else
                    pixel_Reg3 <= 12'h0;
            end
            3'b011 : begin
                if (v_count >= (0*`SQUARE_OFFSET+`DIGIT_V) & v_count < (1*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (1*`SQUARE_OFFSET+`DIGIT_V) & v_count < (2*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                                                            |
                       (h_count >= (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H)))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (2*`SQUARE_OFFSET+`DIGIT_V) & v_count < (3*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (3*`SQUARE_OFFSET+`DIGIT_V) & v_count < (4*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (4*`SQUARE_OFFSET+`DIGIT_V) & v_count < (5*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (5*`SQUARE_OFFSET+`DIGIT_V) & v_count < (6*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if ((h_count >= (0*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                                                            |
                       (h_count >= (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (4*`SQUARE_OFFSET+`CPU_DIGIT_1_H)))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else if (v_count >= (6*`SQUARE_OFFSET+`DIGIT_V) & v_count < (7*`SQUARE_OFFSET+`DIGIT_V)) begin
                    if (h_count >= (1*`SQUARE_OFFSET+`CPU_DIGIT_1_H) & h_count < (3*`SQUARE_OFFSET+`CPU_DIGIT_1_H))
                        pixel_Reg3 <= 12'hFFF;
                    else
                        pixel_Reg3 <= 12'h0;
                end
                else
                    pixel_Reg3 <= 12'h0;
            end
            default : pixel_Reg3 <= 12'h0; 
        endcase
    end

    //  This block draws the net
    always @(h_count, v_count) begin : Draw_Net
        if (((h_count >= ((`HORIZONTAL_RIGHT_BOUND - `HORIZONTAL_LEFT_BOUND) >> 10'd1) + `H_OFFSET - 12'd10))
                                                &&
           (h_count <= (((`HORIZONTAL_RIGHT_BOUND - `HORIZONTAL_LEFT_BOUND) >> 10'd1) + `H_OFFSET + 12'd10))
                                                &&
           (((v_count >= `VERTICAL_UPPER_BOUND) && (v_count <= (`VERTICAL_UPPER_BOUND+10'd20))) // First Net Square
                                                ||
           ((v_count >= (`VERTICAL_UPPER_BOUND+10'd40)) && (v_count <= (`VERTICAL_UPPER_BOUND+10'd60))) // Second Net Square
                                                ||
           ((v_count >= (`VERTICAL_UPPER_BOUND+10'd80)) && (v_count <= (`VERTICAL_UPPER_BOUND+10'd100)))  
                                                ||
           ((v_count >= (`VERTICAL_UPPER_BOUND+10'd120)) && (v_count <= (`VERTICAL_UPPER_BOUND+10'd140)))
                                                ||
           ((v_count >= (`VERTICAL_UPPER_BOUND+10'd160)) && (v_count <= (`VERTICAL_UPPER_BOUND+10'd180)))
                                                ||
           ((v_count >= (`VERTICAL_UPPER_BOUND+10'd200)) && (v_count <= (`VERTICAL_UPPER_BOUND+10'd220)))     
                                                ||
           ((v_count >= (`VERTICAL_UPPER_BOUND+10'd240)) && (v_count <= (`VERTICAL_UPPER_BOUND+10'd260)))                       
                                                ||
           ((v_count >= (`VERTICAL_UPPER_BOUND+10'd280)) && (v_count <= (`VERTICAL_UPPER_BOUND+10'd300)))  
                                                ||                
           ((v_count >= (`VERTICAL_UPPER_BOUND+10'd320)) && (v_count <= (`VERTICAL_UPPER_BOUND+10'd340)))  
                                                ||              
           ((v_count >= (`VERTICAL_UPPER_BOUND+10'd360)) && (v_count <= (`VERTICAL_UPPER_BOUND+10'd380)))  
                                                || 
           ((v_count >= (`VERTICAL_UPPER_BOUND+10'd400)) && (v_count <= (`VERTICAL_UPPER_BOUND+10'd420)))  
                                                ||                                              
           ((v_count >= (`VERTICAL_UPPER_BOUND+10'd440)) && (v_count <= (`VERTICAL_UPPER_BOUND+10'd460))))) begin
            pixel_Reg4 <= 12'hFFF;
        end
        else
            pixel_Reg4 <= 12'h0;
    end : Draw_Net
    //  End of drawing net
    
    assign pixel = pixel_Reg1 | pixel_Reg2 | pixel_Reg3 | pixel_Reg4;
    
    `endif // VGA_DEBUG
    
    `ifdef VGA_DEBUG
    
    always @(posedge clk) begin
        // Horizontal Value
        if (h_count >= `HOR_VISUAL_START & h_count < (`HOR_THIRD+`HOR_VISUAL_START))
            horizontal_Value <= 3'd1;
        else if (h_count >= (`HOR_THIRD+`HOR_VISUAL_START) & h_count < (`HOR_THIRD*2+`HOR_VISUAL_START))
            horizontal_Value <= 3'd2;
        else if (h_count >= (`HOR_THIRD*2+`HOR_VISUAL_START) & h_count < (`HOR_THIRD*3+`HOR_VISUAL_START))
            horizontal_Value <= 3'd3;
        else 
            horizontal_Value <= 3'd0;
        // Vertical Value
        if (v_count >= `VER_VISUAL_START & v_count < (`VER_THIRD+`VER_VISUAL_START))
            vertical_Value <= 3'd1;
        else if (v_count >= (`VER_THIRD+`VER_VISUAL_START) & v_count < (`VER_THIRD*2+`VER_VISUAL_START))
            vertical_Value <= 3'd2;
        else if (v_count >=(`VER_THIRD*2+`VER_VISUAL_START) & v_count < (`VER_THIRD*3+`VER_VISUAL_START))
            vertical_Value <= 3'd3;
        else
            vertical_Value <= 3'd0;
    end
    
    always @(posedge clk) begin
        if (v_count == 0 & h_count == 0 & sec_Count < 12'd240)
            sec_Count <= sec_Count + 1;
        else if (v_count == 0 & h_count == 0 & sec_Count >= 12'd240)
            sec_Count <= 0;
    end
    
    assign pixel = (sec_Count > 12'd120) ? 12'h000 : `PIX_NINTH * horizontal_Value * vertical_Value;
    
    `endif // VGA_DEBUG
    
endmodule
