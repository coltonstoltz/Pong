`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2021 11:11:16 AM
// Design Name: 
// Module Name: Vect_Mem_2
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


module Vect_Mem_2(
    input clk,
    input rst,
    output reg [2:0] vect_out
    );
    
    reg [2:0] counter;
    reg [22:0] clk_div;
    reg [2:0] Mem [5:0];
    
    initial begin
        Mem[3'b000] <= 3'b111; // -1
        Mem[3'b001] <= 3'b110; // -2
        Mem[3'b010] <= 3'b101; // -3
        Mem[3'b011] <= 3'b010; // 2
        Mem[3'b100] <= 3'b001; // 1 
        Mem[3'b101] <= 3'b010; // 2
        Mem[3'b110] <= 3'b011; // 3
        clk_div <= 0;
    end
    
    always @(posedge clk)
        clk_div <= clk_div + 1'b1;
    
    always @(posedge clk_div[22]) begin
        if (rst) 
            counter <= 2'b00;
        else begin
            counter <= counter + 1'b1; 
            vect_out <= Mem[counter];
        end
    end
endmodule
