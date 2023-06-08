`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 08:30:31 PM
// Design Name: 
// Module Name: receiver
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


module receiver(
input clk,
input start,
input serial_in,
input prst,
output reg [data_length-1:0] parallel_out
    );
parameter data_length = 8;
parameter dummy_period = 5;
reg [data_length-1:0] temp_output;
reg [10:0] counter;   
reg [10:0] data_counter;
initial begin
data_counter<=0;
counter <= 0;
temp_output <= 0;
parallel_out<=0;
State <= Idle_State;
end
reg [2:0] State;
reg [2:0] Idle_State = 3'b000;
reg [2:0] Start_State = 3'b001;
reg [2:0] Receive_State = 3'b010;
reg [2:0] End_State = 3'b011;

always@(posedge clk)
begin
case(State)

    Idle_State: begin
    if (start)
        State <= Start_State;
    else
        State <= Idle_State;
 
    end
    
    
    Start_State: begin
    if(counter < dummy_period) begin
        if (!serial_in) begin //Buradaki dummy periodun ne alakasý var onu çöz aga
            State <= Receive_State;
            counter <= 0; end
        else begin
            State<= Start_State;
            counter<=counter+1; end
                                end
    else begin
        counter<=0;
        State <= Start_State;
       end
    end
    
    
    Receive_State: begin
        temp_output[data_counter]<= serial_in;
        if (counter < dummy_period-1) begin
            counter <= counter+1;
            State <= Receive_State;
            end
        else 
            begin
            counter <=0;
            if (data_counter<data_length) begin
                data_counter <= data_counter+1;
                State<=Receive_State;
                end
            else
            begin
                data_counter <= 0;
                State<=End_State;
                 parallel_out <= temp_output;
            end
            end
    
    end
    
    
    End_State: begin
        if (prst) begin
            State <= Idle_State;
            counter <=0;
            data_counter<=0;
            parallel_out<= 0;
            temp_output<=0;
            end
        else
            State<=End_State;
           
    
    
    
    
    
    
    end


endcase
end
endmodule
