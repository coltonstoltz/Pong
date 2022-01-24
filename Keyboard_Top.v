`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2021 07:05:03 PM
// Design Name: 
// Module Name: Keyboard_Top
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


module Keyboard_Top(
    input CLK100MHZ,
    input RST,
    input PS2_CLK,
    input PS2_DATA,
    output [6:0] SEG,
    output [7:0] AN,
    output DP,
    output UART_TXD,
    output [31:0] DATA,
    output RX_DONE,
    output space_Pressed
    );
    
    wire [31:0] data;
    reg CLK50MHZ = 0;
    reg [19:0] count = 0;
    wire CLK95HZ;
    //wire PS2_2_PADDLE;
    //reg clk_div;
    
    always @(posedge CLK100MHZ)
        CLK50MHZ <= ~CLK50MHZ;
        
    always @(posedge CLK100MHZ)
        count <= count + 1'b1;
        
    assign CLK95HZ = (count[19]) ? 1'b1 : 1'b0;
    
    
    PS2_Rx PS2_Rx(
      CLK50MHZ, 
      RST, 
      PS2_CLK, 
      PS2_DATA, 
      data[31:0],
      RX_DONE
    );
    
    SevenSegmentDisplay Display(
      CLK100MHZ, 
      data[31:0], 
      DP, 
      AN[7:0], 
      SEG[6:0]
    );
                                                     
    assign DATA = data;
    
endmodule
