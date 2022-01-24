`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2021 10:47:14 AM
// Design Name: 
// Module Name: PS2_Rx
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


module PS2_Rx(
    input clk100MHz,
    input rst,
    input PS2_Clk,
    input PS2_Data,
    output [31:0] data,
    output RX_Done
);
    // Possible States
//    localparam IDLE = 1'b0, 
//               RX   = 1'b1;
               
//    reg state, nextState;
    reg [7:0] internal_PS2_Reg_Cur = 0;
    reg [7:0] internal_PS2_Reg_Prev = 0;
    reg [31:0] internal_Data = 0;
    reg [3:0] bit_Count = 0;
    reg rx_Done = 0;
    reg start_Bit;
    reg parity_Bit;
    reg stop_Bit;
//    reg [7:0] dataCur = 0;
//    reg [7:0] dataPrev = 0;
    //  Used for 'debouncing' PS2_Clk signal
    reg [19:0] clk_Filter_Reg;
    wire [19:0] clk_Filter_Next;
    reg filtered_Clk_Value;
    wire filtered_Clk_Next;
    //wire neg_Edge_PS2_Clk;
    
    //  Used for 'debouncing' PS2_Data signal
    reg [19:0] data_Filter_Reg;
    wire [19:0] data_Filter_Next;
    reg filtered_Data_Value;
    wire filtered_Data_Next;
    
    //  PS2_Clk Debouncing Circuit
    always @(posedge clk100MHz, posedge rst) begin
        if (rst) begin
            clk_Filter_Reg <= 0;
            filtered_Clk_Value <= 0;
            //internal_Data <= 0;
            //rx_Done <= 0;
        end
        else begin
            clk_Filter_Reg <= clk_Filter_Next;
            filtered_Clk_Value <= filtered_Clk_Next;
        end
    end
    
    assign clk_Filter_Next = {PS2_Clk, clk_Filter_Reg[19:1]};
    
    assign filtered_Clk_Next = (clk_Filter_Reg == 20'b1111_1111_1111_1111_1111) ? 1'b1 : 
                               (clk_Filter_Reg == 20'b0000_0000_0000_0000_0000) ? 1'b0 :
                               filtered_Clk_Value;
                               
    //assign neg_Edge_PS2_Clk = filtered_Clk_Value & ~filtered_Clk_Next;
    //  End of PS2_Clk Debouncing Circuit
    
    
    //  PS2_Data Debouncing Circuit
    always @(posedge clk100MHz, posedge rst) begin
        if (rst) begin
            data_Filter_Reg <= 0;
            filtered_Data_Value <= 0;
        end
        else begin
            data_Filter_Reg <= data_Filter_Next;
            filtered_Data_Value <= filtered_Data_Next;
        end
    end
    
    assign data_Filter_Next = {PS2_Data, data_Filter_Reg[19:1]};
    
    assign filtered_Data_Next = (data_Filter_Reg == 20'b1111_1111_1111_1111_1111) ? 1'b1 : 
                                (data_Filter_Reg == 20'b0000_0000_0000_0000_0000) ? 1'b0 :
                                filtered_Data_Value;
    //  End of PS2_Data Debouncing Circuit
    
    //  PS2 Register
    always @(negedge filtered_Clk_Value) begin
        //RX_Done <= rx_Done;
        case(bit_Count)
            0  : begin
                start_Bit  <= filtered_Data_Value;
                rx_Done  <= 0;
            end
            1  : internal_PS2_Reg_Cur[0]  <= filtered_Data_Value;
            2  : internal_PS2_Reg_Cur[1]  <= filtered_Data_Value;
            3  : internal_PS2_Reg_Cur[2]  <= filtered_Data_Value;
            4  : internal_PS2_Reg_Cur[3]  <= filtered_Data_Value;
            5  : internal_PS2_Reg_Cur[4]  <= filtered_Data_Value;
            6  : internal_PS2_Reg_Cur[5]  <= filtered_Data_Value;
            7  : internal_PS2_Reg_Cur[6]  <= filtered_Data_Value;
            8  : internal_PS2_Reg_Cur[7]  <= filtered_Data_Value;
            9  : parity_Bit  <= filtered_Data_Value;
            10 : begin
                stop_Bit  <= filtered_Data_Value;
                rx_Done  <= 1;
            end
        endcase 
        
        if (bit_Count >= 10)
            bit_Count <= 0;
        else
            bit_Count <= bit_Count + 1;
    end
    
    always @(posedge rx_Done, posedge rst) begin
        //if (internal_PS2_Reg_Cur != internal_PS2_Reg_Prev) begin
        if (rst) 
            internal_Data <= 0;
        else begin
            internal_Data[31:16]  <= internal_Data[23:8];
            internal_Data[15:8]   <= internal_PS2_Reg_Prev;
            internal_Data[7:0]    <= internal_PS2_Reg_Cur;
            internal_PS2_Reg_Prev <= internal_PS2_Reg_Cur; 
        end
         
    end
    
    assign data = (rst) ? 32'b0 : internal_Data;
    assign RX_Done = rx_Done;
    
    /*
    //  Current State Logic
    always @(posedge clk100MHz, posedge rst) begin
        if (rst) begin
            //bit_Count <= 0;
            //internal_PS2_Reg <= 0;
            //rx_done <= 0;
            state <= IDLE;
        end
        else
            state <= nextState;
    end
    //  Next State Logic
    always @(*) begin
        case(state)
            IDLE : begin
                //rx_done <= 0;
                if (neg_Edge_PS2_Clk) begin
                    internal_PS2_Reg[bit_Count] = PS2_Data;
                    bit_Count = bit_Count + 1'b1;
                    nextState = RX;
                end
                else begin
                    internal_PS2_Reg = internal_PS2_Reg;
                    bit_Count = bit_Count;
                    nextState <= IDLE;
                end
            end
            RX   : begin
                if (neg_Edge_PS2_Clk) begin
                    if (bit_Count < 10) begin
                        internal_PS2_Reg[bit_Count] = PS2_Data;
                        bit_Count = bit_Count + 1'b1;
                        nextState = RX;
                    end
                    else begin
                        internal_PS2_Reg = internal_PS2_Reg;
                        bit_Count = 0;
                        nextState = IDLE;
                    end
                end 
            end
        endcase
    end
    //  FSM Outputs
    always @(negedge neg_Edge_PS2_Clk) begin
        case(state)
            IDLE : begin
                internal_Data <= internal_Data;
                rx_done <= 0;
            end
            RX   : begin
                if (bit_Count < 10) begin
                    rx_done <= 0;
                    internal_Data <= internal_Data;
                end
                else begin
                    rx_done <= 1;
                    if (bit_Count >= 10) begin
                        dataCur <= internal_PS2_Reg[8:1];
                        dataPrev <= dataCur;
                        internal_Data[31:16] <= {internal_Data[23:8], dataPrev, dataCur};
                    end
                    else
                        internal_Data = internal_Data;
                end
            end
        endcase
    end
    assign data = internal_Data;
    */
    
    
    /*
    //  Current State Logic
    always @(posedge clk100MHz) begin
        case(state)
            IDLE : begin
                bit_Count <= 0;
                internal_PS2_Reg[bit_Count] <= PS2_Data; //  Sample PS2_Data
            end
            RX   : begin
                bit_Count <= bit_Count + 1'b1;
                internal_PS2_Reg[bit_Count] <= PS2_Data;
            end //  Sample PS2_Data
        endcase
    end
    //  Next State Logic
    always @(*) begin
        case(state)
            IDLE : begin
                if (PS2_Data == 1'b0)
                    nextState = RX;
                else 
                    nextState = IDLE;
            end
            RX   : begin
                if (bit_Count < 10)
                    nextState = RX;
                else
                    nextState = IDLE;
            end
        endcase
    end
    //  FSM Outputs
    always @(*) begin
        case(state)
            IDLE : data = internal_PS2_Reg;
            RX   : ;
        endcase
    end
    */
endmodule
