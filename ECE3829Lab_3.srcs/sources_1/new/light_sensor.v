`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: William Tyrrell
// 
// Create Date: 02/13/2023 08:26:18 PM
// Design Name: light_sensor William Tyrrell
// Module Name: light_sensor
// Project Name: ECE3829Lab_3
// Target Devices: 2020.1
// Tool Versions: 
// Description: 
// light sensor module to connect to the top module
// Dependencies: 
// lab3_constraints.xdc
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module light_sensor
#( parameter TERM_COUNT = 10_000_000,
    parameter SIZE = 32)
    (  //Port Paramter
    input clk,
    input reset_n,
    input JA2, //SD0
    output reg JA0, //Chip Select
    output reg JA3, //sclk or sck
    output reg [7:0] Reading //8 bit number for the light sensor reading
    );

    //Registers
    reg [1:0]newstate;
    reg [32:0]counter; //needed for 1 second delay 
    reg [4:0]sclk_counter; //chip select counter 5 bits
    reg [7:0]toofast; //because its updating too fast place holder register

    //Wires
    wire rising_edge;
    wire falling_edge;
    
    //Local Parameters
    localparam C_RISE_EDGE = 0;
    localparam C_FALL_EDGE = 5;
    localparam RESET = 2'b00;
    localparam WAIT = 2'b01;
    localparam READ = 2'b10;
    
    //Assign statements
    assign rising_edge = (counter == C_RISE_EDGE) ? 1'b1 : 1'b0;
    assign falling_edge = (counter == C_FALL_EDGE) ? 1'b1 : 1'b0;


    //clock frequency divider
    always @ (posedge clk) begin        
        if (counter >= 10 && newstate == READ) begin //reset the counter if it reaches 10 and its in READ
            counter <= 0;
        end
        else begin
            counter <= counter + 1; //increment counter
        end
    end
    
    always @ (posedge clk) begin 
        if (reset_n == 0) begin
            newstate <= RESET; //reset state on reset_n
        end       
       case (newstate)
            RESET : begin  //A reset state to initialize the interface on power up
                JA0 <= 1; //when Chip select is high
                newstate <= WAIT;
            end
            WAIT : begin //A wait state for 1 sec state to control the sampling time and reset clk freq divider
                if (counter >= TERM_COUNT) begin
                    //Reading <= 0;
                    sclk_counter <= 0; 
                    newstate <= READ; 
                end
            end
            READ : begin //read
                JA0 <= 0; //Bring CS low nothing happens when it's high. 
                if (rising_edge) begin //look for the falling or rising edge of sclk bring sclk high if rising and 0 if falling also increment it
                    JA3 <= 1;
                end
                else if (falling_edge) begin
                    JA3 <= 0;
                    sclk_counter <= sclk_counter + 1;
                end    
                if (sclk_counter >= 4 && sclk_counter <= 11 && rising_edge) begin //begin to read the samples
                    if (JA0 == 1) begin //if CS high, there's no readings
                        Reading <= 0;
                    end
                    if (JA0 == 0) begin // if CS is low fill the temporary register.
                        toofast <= {toofast[6:0], JA2}; 
                    end
                end
                if (sclk_counter >= 16) begin //using sclk delay for displaying it to the seven segment
                    Reading <= toofast;
                    newstate <= RESET;
                end 
            end
        endcase
    end
endmodule