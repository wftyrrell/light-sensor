`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: William Tyrrell
// 
// Create Date: 02/13/2023 08:23:35 PM
// Design Name: clock_gen William Tyrrell
// Module Name: clock_gen
// Project Name: ECE3829Lab_3
// Target Devices: Basys 3 development Board
// Tool Versions: 2020.1 
// Description: 
// clock generator for the light sensor project to remove metastability
// Dependencies: 
// lab3_constraints.xdc, clk_mmcm
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_gen(
    input clk, //input clock
    input btnC,//reset signal
    output clk_10Mhz, //output clock 10Mhz
    output reg locked_dd //output locked
    );

    reg locked_d; //d flipflop
    wire sync_locked;

    //Two stage Synchronizer w/o a reset to remove Metastability
    always @ (posedge clk_10Mhz) begin
        locked_d <= sync_locked;
        locked_dd <= locked_d;
    end

    //Clock Wizard Instanciation for 10MHz output clk
    clk_mmcm_wiz clk_mmcm_wizi
    (
        //Clock out ports
        .clk_10Mhz(clk_10Mhz), //output clk_10Mhz
        //Status and Control signals
        .reset(btnC), //input reset
        .locked(sync_locked), //output locked
        //Clock in ports
        .clk_in1(clk)); // input clk_in1

    //

endmodule