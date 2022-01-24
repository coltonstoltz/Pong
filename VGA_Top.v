`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2021 04:02:43 PM
// Design Name: 
// Module Name: VGA_Top
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
`define H_Max               10'd799
`define V_Max               10'd524
`define H_Sync_Count        10'd96
`define V_Sync_Count        10'd2
`define H_Visible_Lower     10'd144
`define H_Visible_Upper     10'd784
`define V_Visible_Lower     10'd35
`define V_Visible_Upper     10'd515
`define div_clk             4'd4

module VGA_Top(
    input clk_25MHz,
    input rst,
    input [11:0] pixel_in,
//    input [3:0] div_clk,
//    input [9:0] H_Max,
//    input [9:0] V_Max,
//    input [9:0] H_Sync_Count,
//    input [9:0] V_Sync_Count,
//    input [9:0] H_Visible_Lower,
//    input [9:0] H_Visible_Upper,
//    input [9:0] V_Visible_Lower,
//    input [9:0] V_Visible_Upper,
    output HS,
    output VS,
    output [9:0] h_count,
    output [9:0] v_count,
    output [11:0] pixel_out
    );
    
//    wire clk_25MHz;
//    wire [9:0] h_count;
//    wire [9:0] v_count;
    wire h_full;
    wire image_active;
    wire [11:0] pixel;    
    
    //Clk_Divider Clk_Divider(clk_100MHz, rst, 10'd4, clk_25MHz);
    //clk_wiz_0 Clk_Div(clk_25MHz, rst, clk_100MHz);
    Counter H_Counter(clk_25MHz, rst, 1'b1, 10'd799, h_count, h_full);
    Counter V_Counter(clk_25MHz, rst, h_full, 10'd524, v_count);
    Comparator H_Comp(h_count, 10'd96, HS);
    Comparator V_Comp(v_count, 10'd2, VS);
    Display_Comparator Disp_Comp(h_count, v_count, 10'd144, 10'd784, 10'd35, 10'd515, image_active);
    //Image_Generator Im_Gen(h_count, v_count, clk_25MHz, rst, pixel);
    Mux Mux(12'b0, pixel_in, image_active, pixel_out);

endmodule
