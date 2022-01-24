`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2021 04:00:41 PM
// Design Name: 
// Module Name: Display_Comparator
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


module Display_Comparator(
    input [9:0] h_count,
    input [9:0] v_count,
    input [9:0] h_lower,
    input [9:0] h_upper,
    input [9:0] v_lower,
    input [9:0] v_upper,
    output out
    );
    
    assign out = (h_count >= h_lower & h_count < h_upper) & (v_count >= v_lower & v_count < v_upper);
    
endmodule
