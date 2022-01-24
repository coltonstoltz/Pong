`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2021 08:49:36 AM
// Design Name: 
// Module Name: Ball
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
`include "defines.v"

module Ball(
    input clk,
    input rst,
    input signed [9:0] paddle_Pos_H,
    input signed [9:0] paddle_Pos_V,
    input signed [9:0] p2_Pos_H,
    input signed [9:0] p2_Pos_V,
    input signed [2:0] x_rand,
    input signed [2:0] y_rand,
    input player_Win,
    input cpu_Win,
    output reg signed [9:0] ball_Pos_H,
    output reg signed [9:0] ball_Pos_V,
    output reg player_Scored,
    output reg cpu_Scored
    );
        
    reg signed [2:0] x_vector;
    reg signed [2:0] y_vector;
    reg [20:0] clk_div = 0;
    reg serve = 0;
    
    reg inv_X_Vector;
    reg inv_Y_Vector;
    
    initial begin
        cpu_Scored <= 1'b0;
        player_Scored <= 1'b0;
        ball_Pos_H <= ((`HORIZONTAL_RIGHT_BOUND - `HORIZONTAL_LEFT_BOUND) >> 10'd1) + `H_OFFSET;
        ball_Pos_V <= ((`VERTICAL_LOWER_BOUND - `VERTICAL_UPPER_BOUND) >> 10'd1) + `V_OFFSET;
    end
    
    always @(posedge clk) begin
        clk_div <= clk_div + 1'b1;
    end 
    
    always @(posedge clk_div[19]) begin
        if (rst) 
            x_vector <= x_rand;
        else if ((((ball_Pos_H-`BALL_RADIUS) <= (paddle_Pos_H+`PADDLE_WIDTH)) 
                                    &
           (((ball_Pos_V+`BALL_RADIUS) >= paddle_Pos_V) & ((ball_Pos_V-`BALL_RADIUS) <= (paddle_Pos_V+`PADDLE_HEIGHT))) & (x_vector[2] == 1'b1)) 
                                    |
           (((ball_Pos_H+`BALL_RADIUS) >= p2_Pos_H)
                                    &
           (((ball_Pos_V+`BALL_RADIUS) >= p2_Pos_V) & ((ball_Pos_V-`BALL_RADIUS) <= (p2_Pos_V+`PADDLE_HEIGHT))) & (x_vector[2] == 1'b0))) begin
            x_vector <= -(x_vector);
        end
        else if (((ball_Pos_H-`BALL_RADIUS) <= `LEFT_GAME_BOUND)
                                    |
                ((ball_Pos_H+`BALL_RADIUS) >= `RIGHT_GAME_BOUND)) begin
            x_vector <= x_rand;     
        end
        else if (x_vector == 3'b000)
            x_vector <= x_rand;
        else
            x_vector <= x_vector;
    end
    
    always @(posedge clk_div[19]) begin
        if (rst) 
            y_vector <= y_rand;
        else if ((((ball_Pos_V-`BALL_RADIUS) <= `VERTICAL_UPPER_BOUND) & (y_vector[2] == 1'b1)) 
                                        |
           (((ball_Pos_V+`BALL_RADIUS) >= `VERTICAL_LOWER_BOUND) & (y_vector[2] == 1'b0))) begin
            y_vector <= -(y_vector);
        end
        else if (((ball_Pos_H-`BALL_RADIUS) <= `LEFT_GAME_BOUND)
                                    |
                ((ball_Pos_H+`BALL_RADIUS) >= `RIGHT_GAME_BOUND)) begin
            y_vector <= y_rand;     
        end
        else if (y_vector == 3'b000)
            y_vector <= y_rand;
        else if ((ball_Pos_H-`BALL_RADIUS) <= (paddle_Pos_H+`PADDLE_WIDTH)) begin                                                       // Hitting left edge 
            if ((ball_Pos_V+`BALL_RADIUS) >= paddle_Pos_V && ((ball_Pos_V-`BALL_RADIUS) <= (paddle_Pos_V+`PADDLE_HEIGHT)))begin         // Ball hitting edge within paddle
                if (ball_Pos_V <= (paddle_Pos_V+`PADDLE_HALF_HEIGHT)) begin                                                             // Ball hitting upper half of paddle
                    if (y_vector[2] == 1'b1) begin                                                                                      // Ball already travelling up    
                        if (y_vector <= -3'd3)
                            y_vector <= y_vector;                                                                                       // y_vector maxed out in up direction
                        else
                            y_vector <= y_vector - 1'b1;                                                                                // Speeding up in up direction
                    end
                    else                                                                                                                // Ball already travelling down
                        y_vector <= ~(y_vector) + 1'b1;                                                                                 // Reverse y_vector
                end
                else if (ball_Pos_V >= (paddle_Pos_V+`PADDLE_HALF_HEIGHT)) begin                                                        // Ball hitting lower half of paddle
                    if (y_vector[2] == 1'b0) begin
                        if (y_vector >= 3'd3) 
                            y_vector <= y_vector;
                        else
                            y_vector <= y_vector + 1'b1;
                    end
                    else 
                        y_vector <= ~(y_vector) + 1'b1;
                end
            end
            else begin
                y_vector <= y_vector;
            end
        end
        else if ((ball_Pos_H+`BALL_RADIUS) >= (p2_Pos_H)) begin                                                                         // Hitting right edge
            if ((ball_Pos_V+`BALL_RADIUS) >= p2_Pos_V && ((ball_Pos_V-`BALL_RADIUS) <= (p2_Pos_V+`PADDLE_HEIGHT))) begin                // Ball hitting edge within p2
                if (ball_Pos_V <= (p2_Pos_V+`PADDLE_HALF_HEIGHT)) begin                                                                 // Ball hitting upper half of p2
                    if (y_vector[2] == 1'b1) begin                                                                                      // Ball already travelling up    
                        if (y_vector <= -3'd3)
                            y_vector <= y_vector;                                                                                       // y_vector maxed out in up direction
                        else
                            y_vector <= y_vector - 1'b1;                                                                                // Speeding up in up direction
                    end
                    else                                                                                                                // Ball already travelling down
                        y_vector <= ~(y_vector) + 1'b1;                                                                                 // Reverse y_vector
                end
                else if (ball_Pos_V >= (p2_Pos_V+`PADDLE_HALF_HEIGHT)) begin                                                            // Ball hitting lower half of p2
                    if (y_vector[2] == 1'b0) begin
                        if (y_vector >= 3'd3) 
                            y_vector <= y_vector;
                        else
                            y_vector <= y_vector + 1'b1;
                    end
                    else 
                        y_vector <= ~(y_vector) + 1'b1;
                end
            end
            else begin
                y_vector <= y_vector;
            end
        end
        else
            y_vector <= y_vector;
    end
    
    always @(posedge clk_div[19]) begin
        if (rst) begin
            serve <= 1'b1;
            cpu_Scored = 1'b0;
            player_Scored <= 1'b0;
        end
        else if ((ball_Pos_H-`BALL_RADIUS) <= `LEFT_GAME_BOUND) begin
            serve <= 1'b1;
            cpu_Scored <= 1'b1;
        end
        else if ((ball_Pos_H+`BALL_RADIUS) >= `RIGHT_GAME_BOUND) begin
            serve <= 1'b1;   
            player_Scored <= 1'b1;
        end
        else begin
            serve <= 1'b0;
            cpu_Scored <= 1'b0;
            player_Scored <= 1'b0;
        end
    end
    
    always @(negedge clk_div[20]) begin
        if (serve || player_Win || cpu_Win) begin
            ball_Pos_H <= ((`HORIZONTAL_RIGHT_BOUND - `HORIZONTAL_LEFT_BOUND) >> 10'd1) + `H_OFFSET;
            ball_Pos_V <= ((`VERTICAL_LOWER_BOUND - `VERTICAL_UPPER_BOUND) >> 10'd1) + `V_OFFSET;
        end
        else begin
            ball_Pos_H <= ball_Pos_H + x_vector;
            ball_Pos_V <= ball_Pos_V + y_vector;
        end
    end

endmodule
