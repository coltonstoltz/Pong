`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2021 12:59:11 PM
// Design Name: 
// Module Name: Pong_Top
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
module Pong_Top(
    input CLK100MHZ,
    input RST,
    // VGA I/O
    output HS,
    output VS,
    output [11:0] PIXEL_2_SCREEN,
    // Keyboard I/O
    input PS2_CLK,
    input PS2_DATA,
    output [6:0] SEG,
    output [7:0] AN,
    output DP,
    output UART_TXD
    );
    
    wire CLK25MHZ;
    wire CLK50MHZ;
    wire [31:0] DATA;
    wire [9:0] PADDLE_POS_H;
    wire [9:0] PADDLE_POS_V;
    wire [9:0] P2_POS_H;
    wire [9:0] P2_POS_V;
    wire [9:0] BALL_POS_H;
    wire [9:0] BALL_POS_V;
    wire [2:0] X_RAND;
    wire [2:0] Y_RAND;
    wire PLAYER_SCORED;
    wire CPU_SCORED;
    wire [2:0] PLAYER_SCORE;
    wire [2:0] CPU_SCORE;
    wire PLAYER_WIN;
    wire CPU_WIN;
    wire RESTART_GAME_1;
    wire RESTART_GAME_2;
    wire START_MATCH;
    wire MATCH_ENDED;
    wire [11:0] PIXEL_IN;
    wire [9:0] H_COUNT;
    wire [9:0] V_COUNT;
    wire [11:0] PIXEL_OUT;
    wire RX_DONE;
    
    VGA_Top VGA_Tx(
        CLK25MHZ,
        RST,
        PIXEL_OUT,
        HS,
        VS, 
        H_COUNT,
        V_COUNT,
        PIXEL_2_SCREEN
    );
    
    Keyboard_Top Keyboard_Rx(
        CLK100MHZ,
        1'b0,
        PS2_CLK,
        PS2_DATA,
        SEG,
        AN,
        DP,
        UART_TXD,
        DATA,
        RX_DONE
    );
    
    Game_Control Controller(
        CLK100MHZ,
        RST,
        PLAYER_SCORED,
        CPU_SCORED,
        DATA,
        PLAYER_SCORE,
        CPU_SCORE,
        PLAYER_WIN,
        CPU_WIN
    );
    
    Paddle Paddle(
        (CLK50MHZ),
        RST,
        DATA,
        RX_DONE,
//        MATCH_ENDED,
//        START_MATCH,
        PADDLE_POS_H,
        PADDLE_POS_V        
    );
    
    Ball Ball(
        (CLK100MHZ), 
        RST,
        PADDLE_POS_H,
        PADDLE_POS_V,
        P2_POS_H,
        P2_POS_V,
        X_RAND,
        Y_RAND,
        PLAYER_WIN,
        CPU_WIN,
        BALL_POS_H,
        BALL_POS_V,
        PLAYER_SCORED,
        CPU_SCORED
    );
    
    p2 Paddle_2(
        (CLK100MHZ),
        RST,
        BALL_POS_H,
        BALL_POS_V,
        P2_POS_H,
        P2_POS_V
    );
    
    LFSR LFSR_X(
        CLK25MHZ,
        RST,
        X_RAND
    );
    
    LFSR LFSR_Y(
        CLK50MHZ,
        RST,
        Y_RAND
    );
    
//    Vect_Mem Rand_Vect(
//        CLK100MHZ,
//        RST,
//        X_RAND,
//        Y_RAND
//    );
    
    Image_Generator Image_Gen(
        CLK25MHZ,
        RST,
        H_COUNT,
        V_COUNT,
        PADDLE_POS_H,
        PADDLE_POS_V,
        P2_POS_H,
        P2_POS_V,
        BALL_POS_H,
        BALL_POS_V,
        PLAYER_SCORE,
        CPU_SCORE,
        PLAYER_WIN,
        CPU_WIN,
        PIXEL_OUT
    );
    
    clk_wiz_0 Clk_Div(
        CLK25MHZ,
        CLK50MHZ,
        RST,
        CLK100MHZ
    );
endmodule
