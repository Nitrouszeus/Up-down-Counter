`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2025 16:08:01
// Design Name: 
// Module Name: Contador_Up_Down
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

module Top_Module (
    input clk_in,
    input Reset,
    input Up,
    output [3:0] CNT,
    output led 
);

    wire Clock;  // Divided clock
    
    // Instantiate clock divider
    Clock_Divider clk_div (
        .clk_in(clk_in),
        .clk_out(Clock),
        .led(led)
    );
    
    // Instantiate up/down counter
    Up_Down_Counter counter (
        .CNT(CNT),
        .Clock(Clock),
        .Reset(Reset),
        .Up(Up)
    );

endmodule

module Clock_Divider (
    input clk_in,
    output reg clk_out,
    output led 
);
    reg [25:0] count = 0;
    
    always @(posedge clk_in) begin
        count <= count + 1;
        if (count == 25_000_000) begin  // Changed to 25M for 1Hz output with 50MHz input
            count <= 0;
            clk_out <= ~clk_out;
        end 
    end 
    
    assign led = clk_out;
endmodule

module Up_Down_Counter (
    output reg [3:0] CNT,
    input wire Clock, 
    input wire Reset, 
    input wire Up
);
    reg [3:0] current_state, next_state;
    
    parameter C0 = 4'b0001,
              C1 = 4'b0010,
              C2 = 4'b0100,
              C3 = 4'b1000;
              
    always @(posedge Clock or negedge Reset) 
      begin: STATE_MEMORY
        if (!Reset)
            current_state <= C0;
        else 
            current_state <= next_state;
    end
    
    always @(current_state or Up) 
      begin: NEXT_STATE_LOGIC
        case (current_state)
            C0: next_state = Up ? C1 : C3;
            C1: next_state = Up ? C2 : C0;
            C2: next_state = Up ? C3 : C1;
            C3: next_state = Up ? C0 : C2;
            default: next_state = C0;
        endcase
    end
    
    always @(current_state) begin: OUTPUT_LOGIC
        case (current_state)
            C0: CNT = 4'b0001;
            C1: CNT = 4'b0010;
            C2: CNT = 4'b0100;
            C3: CNT = 4'b1000;
            default: CNT = 4'b0001;
        endcase
    end
endmodule

