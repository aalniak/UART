`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 05:05:53 PM
// Design Name: 
// Module Name: transmitter
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


module transmitter(
input prst,
input clk,
input [7:0] dtbt ,  //Data to be transmitted
input start,
output reg serial_out     //Transmitted data
);
parameter data_length = 8;
parameter dummy_period = 5;
reg [2:0] State;
reg [2:0] Idle_State = 3'b000;
reg [2:0] Start_State = 3'b001;
reg [2:0] Data_Sending_State = 3'b010;
reg [2:0] End_State = 3'b011;

initial begin
State<=Idle_State;
counter <= 0;
data_counter <=0;
end

reg [10:0] counter; 
reg [10:0] data_counter;


always@(posedge clk)
begin
case(State)
    
    Idle_State: begin
        if (start==1'b1)
                State<=Start_State;
        else begin
                State<=Idle_State;
                serial_out<=1'b1;
         end
                 end
    
    
    Start_State: begin
        if (counter<dummy_period)
           begin
               serial_out<=1'b1;
               counter<=counter+1;
               State<=Start_State;
           end
        else begin
            counter<=0;
            serial_out<=1'b0;
            State<=Data_Sending_State;
            end
            end
       
       
     Data_Sending_State: begin
     serial_out<= dtbt[data_counter];
        if (counter<dummy_period-1)
            begin
                        
                counter<=counter+1;
                
                State<=Data_Sending_State;
               
        end
        else
        begin
            if (data_counter < data_length) begin
                serial_out <= dtbt[data_counter];
                data_counter <= data_counter+1;
                State<=Data_Sending_State;
                counter <=0;
            end
            else
            begin
            counter<=0;
            State<=End_State;
            end
            end
         end
        
      End_State: begin
        if (counter<dummy_period)
        begin
            
            serial_out<=1'b1;
            State<=End_State;
        end
        else
        begin
            if (prst) begin
            counter<=0;
            State<=Idle_State;
            end
            else
            State<=End_State;
        end
        end
    
endcase
end
endmodule
