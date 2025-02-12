`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: William Tyrrell
// 
// Create Date: 02/14/2023 06:10:49 PM
// Design Name: top_lab3 William Tyrrell
// Module Name: top_lab3
// Project Name: ECE3829lab_3
// Target Devices: Basys 3 Development Board
// Tool Versions: 2020.1
// Description: 
// Top module of the Ligth Sensor module
// Dependencies: 
// lab3_contraints.xdc
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_lab3(
    input clk, //Clock input
    input btnC, //Center Button
    input JA2, //SPI Input
    output JA3, //SCLK
    output JA0, //Chip Select
    output [6:0] seg, //Seven-segment Display
    output [3:0] an //4 anodes
    );

    //Parameters
    //WPI ID 75 last 2 digits oonly
    parameter [3:0] wpiA = 4'd7; 
    parameter [3:0] wpiB = 4'd5;

    //Wires
    wire clk_10Mhz;
    wire reset_n;
    wire [7:0] Reading; //8-bit number

    //Seven Segment Display 
    seven_seg seven_seg_segi
    (
        .dispA(wpiA),
        .dispB(wpiB),
        .dispC(Reading[7:4]),
        .dispD(Reading[3:0]),
        .clk(clk_10Mhz),
        .reset_n(reset_n),
        .segments(seg),
        .an(an));

    //Clock Gen instantiation
    clock_gen clock_geni
    (
    .clk(clk),
    .btnC(btnC),
    .clk_10Mhz(clk_10Mhz),
    .locked_dd(reset_n));

    //Light Sensor
    light_sensor #(.TERM_COUNT(10_000_000), .SIZE(32)) light_sensori
    (
    .clk(clk_10Mhz),
    .reset_n(reset_n),
    .JA2(JA2),
    .JA0(JA0),
    .JA3(JA3),
    .Reading(Reading));

endmodule