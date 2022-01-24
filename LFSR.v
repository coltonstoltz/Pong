`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2021 01:45:15 PM
// Design Name: 
// Module Name: LFSR
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


module LFSR(
    input clk,
    input rst,
    output [2:0] out
    );
    
    reg [15:0] temp = 16'b0011_1100_1111_0101;
    
    always @(posedge clk) begin
        if (rst)
            temp <= 16'b0011_1100_1111_0101;
        else begin
            temp <= {temp[14:0], (temp[1] ^ temp[3] ^ temp[5] ^ temp[6])};
        end
    end
    
    assign out = temp[15:13];
endmodule
