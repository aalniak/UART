`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2023 02:53:52 AM
// Design Name: 
// Module Name: top
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


module top(
input clk,
input prst,
input [7:0] input_data,
input start,
output [7:0] output_data
    );
parameter data_length = 8;
wire transfer_bit;
transmitter UART_Transmitter(.dtbt(input_data),.prst(prst),.clk(clk),.start(start),.serial_out(transfer_bit));
receiver UART_Receiver(.serial_in(transfer_bit),.clk(clk),.start(start),.prst(prst),.parallel_out(output_data));
endmodule
