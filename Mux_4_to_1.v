`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2021 02:26:48 PM
// Design Name: 
// Module Name: Mux_4_to_1
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


module Mux_4_to_1(
    input [9:0] a, 
    input [9:0] b, 
    input [9:0] c, 
    input [9:0] d,
    input [1:0] sel,
    output reg [9:0] out
    );
    
    always @(a, b, c, d, sel) begin
        case (sel)
            2'b00 : out <= a;
            2'b01 : out <= b;
            2'b10 : out <= c;
            2'b11 : out <= d;
            default : out <= d;
        endcase
    end
endmodule
