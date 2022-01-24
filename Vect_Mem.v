`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2021 01:57:05 PM
// Design Name: 
// Module Name: Vect_Mem
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


module Vect_Mem(
    input clk,
    input rst,
    output reg [2:0] x_vect_out,
    output reg [2:0] y_vect_out
    );
    
    reg [3:0] counter_1;
    reg [3:0] counter_2;
    reg [20:0] clk_div;
    reg [5:0] Mem [15:0];
    
    initial begin
        Mem[4'b0000] <= 3'b001; // 1
        Mem[4'b0001] <= 3'b010; // 2
        Mem[4'b0010] <= 3'b101; // -3
        Mem[4'b0011] <= 3'b110; // -2
        Mem[4'b0100] <= 3'b010; // 2
        Mem[4'b0101] <= 3'b110; // -2
        Mem[4'b0110] <= 3'b111; // -1
        Mem[4'b0111] <= 3'b011; // 3
        Mem[4'b1000] <= 3'b001; // 1
        Mem[4'b1001] <= 3'b011; // 3
        Mem[4'b1010] <= 3'b110; // -2
        Mem[4'b1011] <= 3'b011; // 2
        Mem[4'b1100] <= 3'b110; // -2
        Mem[4'b1101] <= 3'b011; // 2
        Mem[4'b1110] <= 3'b101; // -3
        Mem[4'b1111] <= 3'b111; // -1
        clk_div <= 0;
        counter_1 <= 4'b0000;
        counter_2 <= 4'b1111;
    end
    
    always @(posedge clk)
        clk_div <= clk_div + 1'b1;
    
    always @(posedge clk_div[20]) begin
        if (rst) begin
            counter_1 <= 4'b0000;
            counter_2 <= 4'b1111;
        end
        else begin
            counter_1 <= counter_1 + 1'b1; 
            counter_2 <= counter_2 - 1'b1;
            x_vect_out <= Mem[counter_1];
            y_vect_out <= Mem[counter_2];
        end
    end
endmodule
