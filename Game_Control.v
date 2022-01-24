`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2021 11:36:52 AM
// Design Name: 
// Module Name: Game_Control
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


module Game_Control(
    input clk,
    input rst,
    input player_Scored,
    input cpu_Scored,
    input [31:0] data,
    output reg [2:0] player_Score,
    output reg [2:0] cpu_Score,
    output reg player_Win,
    output reg cpu_Win
    );
    
    wire player_Edge;
    wire cpu_Edge;
    
    or(player_Edge, player_Scored, rst);
    or(cpu_Edge, cpu_Scored, rst);
    
    initial begin
        player_Score <= 3'b0;
        cpu_Score <= 3'b0;
        player_Win <= 1'b0;
        cpu_Win <= 1'b0;
    end
       
    always @(posedge player_Edge) begin
        if (rst) begin
            player_Score <= 3'b0;
            player_Win <= 1'b0;
        end
        else if (player_Score < 3'b011) begin
            player_Score <= player_Score + 1'b1;
            player_Win <= 1'b0;
        end
        else begin
            player_Win <= 1'b1;
        end
    end
    
    always @(posedge cpu_Edge) begin
        if (rst) begin
            cpu_Score <= 3'b0;
            cpu_Win <= 1'b0;
        end
        else if (cpu_Score < 3'b011) begin
            cpu_Score <= cpu_Score + 1'b1;
            cpu_Win <= 1'b0;
        end
        else begin
            cpu_Win <= 1'b1;
        end
    end
    
endmodule
