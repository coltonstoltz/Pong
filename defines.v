`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2021 09:00:39 AM
// Design Name: 
// Module Name: defines
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
`define V_OFFSET 10'd35
`define H_OFFSET 10'd144
`define VERTICAL_LOWER_BOUND 10'd515
`define VERTICAL_UPPER_BOUND 10'd35
`define HORIZONTAL_LEFT_BOUND 10'd144
`define HORIZONTAL_RIGHT_BOUND 10'd784
`define LEFT_GAME_BOUND 10'd20 + `HORIZONTAL_LEFT_BOUND
`define RIGHT_GAME_BOUND `HORIZONTAL_RIGHT_BOUND - 10'd20

`define SQUARE_OFFSET 9'd5
`define PLAYER_DIGIT_1_H 9'd260 + `H_OFFSET
`define PLAYER_DIGIT_2_H 9'd240 + `H_OFFSET
`define DIGIT_V          9'd30 + `V_OFFSET
`define CPU_DIGIT_1_H    9'd360 + `H_OFFSET
`define CPU_DIGIT_2_H    9'd390 + `H_OFFSET
`define MIDDLE_V         9'd230 + `V_OFFSET

`define HOR_VISUAL_START 12'd144
`define HOR_THIRD        12'd213
`define VER_VISUAL_START 12'd35
`define VER_THIRD        12'd160
`define PIX_NINTH        12'd455

`define PADDLE_WIDTH 10'd10
`define PADDLE_HEIGHT 10'd40
`define PADDLE_HALF_HEIGHT `PADDLE_HEIGHT >> 1'b1
`define BALL_RADIUS 10'd10

//module defines(

//    );
//endmodule
