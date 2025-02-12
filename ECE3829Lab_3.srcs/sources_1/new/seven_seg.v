`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: William Tyrrell
// 
// Create Date: 02/05/2023 03:36:22 PM
// Design Name: seven_seg William Tyrrell
// Module Name: seven_seg
// Project Name: ECE3829Lab_3
// Target Devices: Basys 3 development Board
// Tool Versions: 2020.1
// Description: 
// Drives the 4 seven segment displays on the Basys 3 Board. 
// Dependencies: 
// lab3_constraints.xdc
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seven_seg(
    input [3:0] dispA, //Display A
    input [3:0] dispB, //Display B
    input [3:0] dispC, //Display C
    input [3:0] dispD, //Display D
    input clk, //clock input
    input reset_n, //active low reset
    output reg [6:0] segments, //7 individual segments on the Display A,B,C,D,E,F,G (Cathode high)
    output reg [3:0] an //anode
    );

    //1 denotes segment as off
    //active low

    //parameters
    parameter zero = 7'b1000000, //zero
              one = 7'b1111001, //one
              two = 7'b0100100, //two
              three = 7'b0110000, //three
              four = 7'b0011001, //four
              five = 7'b0010010, //five
              six = 7'b0000010, //six
              seven = 7'b1111000, //seven
              eight = 7'b0000000, //eight
              nine = 7'b0010000, //nine
              ten = 7'b0100000, //lower case 'a' hexidecimal (ten)
              eleven = 7'b0000011, //lower case 'b' hexidecimal (eleven)
              twelve = 7'b1000110, //upper case 'C' hexidecimal (twelve)
              thirteen = 7'b0100001, //lower case 'd' hexidecimal (thirteen)
              fourteen = 7'b0000110, //upper case 'E' hexidecimal (fourteen)
              fifteen = 7'b0001110, //upper case 'F' hexidecimal (fifteen)
              Delay = 25000-1, //delay 1msec
              off = 7'b0000000; //all off


    //register statements
    reg [3:0]select = 4'b0000;
    reg [3:0]disp; //current value of 7 seg; needs register
    reg [15:0]counter; //need a counter 16 bit

    always @ (*) begin 
        if (reset_n == 1'b0) begin
            an =4'b1111;
            disp = off; //reset turns everything off
        end
        else begin
            case (select) //display selection
                4'b0001: begin
                    an = 4'b1110;
                    disp = dispD;
            end
                4'b0010: begin
                    an = 4'b1101;
                    disp = dispC;
            end
                4'b0100: begin
                    an = 4'b1011;
                    disp = dispB;
            end
            
                4'b1000: begin
                    an = 4'b0111;
                    disp = dispA;
                end
        endcase
    end 
    end

    always @ (*) begin //setting the right hex values to their correct segments as defined earlier in the parameters
        if (reset_n == 1'b0) begin
                segments = off;
        end
        else begin
            case (disp)
                4'h0 : segments = zero;
                4'h1 : segments = one;
                4'h2 : segments = two;
                4'h3 : segments = three;
                4'h4 : segments = four;
                4'h5 : segments = five;
                4'h6 : segments = six;
                4'h7 : segments = seven;
                4'h8 : segments = eight;
                4'h9 : segments = nine;
                4'hA : segments = ten;
                4'hB : segments = eleven;
                4'hC : segments = twelve;
                4'hD : segments = thirteen;
                4'hE : segments = fourteen;
                4'hF : segments = fifteen;
            endcase
        end 
    end 

    //counter cycle through displays
    always @ (posedge clk or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            counter <= 15'd0;
            select <= 4'b0001;
        end
        else if (counter == Delay) begin
            counter <= 15'd0;
            select <= {select[2:0], select[3]};
        end
        else begin
            counter <= counter + 15'd1;
        end
    end
endmodule