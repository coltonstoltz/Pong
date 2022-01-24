`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2021 03:57:26 PM
// Design Name: 
// Module Name: Counter
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


module Counter(
    input clk,
    input rst,
    input enable,
    input [9:0] count,
    output [9:0] out,
    output full);
    
    reg [9:0] internal_counter;
    
    always @(posedge clk) begin
        if (rst) begin
            internal_counter <= 10'b0;
            //full <= 1'b0;
        end
        else begin
            // Enable set
            if (enable) begin
                // Counting up
                if (internal_counter < count) begin
                    internal_counter <= internal_counter + 1'b1;
                    //full <= 1'b0;
                end
                // Resetting counter after reaching limit
                else begin
                    internal_counter <= 10'b0;
                    //full <= 1'b1;
                end
            end
            // Enable not set
            else begin
                internal_counter <= internal_counter;
                //full <= 1'b0;
            end
        end
    end
    
    assign out = internal_counter;
    assign full = (internal_counter >= 10'd799) ? 1'b1: 1'b0;
    
endmodule
