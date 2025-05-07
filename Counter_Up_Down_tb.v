`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2025 20:50:36
// Design Name: 
// Module Name: Counter_Up_Down_tb
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


module tb_up_down_counter;

  reg Clock, Reset, Up;
  wire [3:0] CNT;

  // Instantiate DUT
  Up_Down_Counter dut (
    .CNT(CNT),
    .Clock(Clock),
    .Reset(Reset),
    .Up(Up)
  );

  // Generate clock (10ns period)
  initial Clock = 0;
  always #5 Clock = ~Clock;

  // Initialize waveform dumping
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_up_down_counter);
  end

  // Main test sequence
  initial begin
    $display("Time\tReset\tUp\tCNT");
    $monitor("%0t\t%b\t%b\t%04b", $time, Reset, Up, CNT);

    // Test 1: Reset
    Reset = 0; Up = 0;
    #12; // Slightly more than half cycle
    if (CNT !== 4'b0001) $error("Reset failed");
    
    // Test 2: Count up
    Reset = 1; Up = 1;
    repeat(4) @(posedge Clock);
    if (CNT !== 4'b1000) $error("Up count failed");
    
    // Test 3: Count down
    Up = 0;
    repeat(4) @(posedge Clock);
    if (CNT !== 4'b0001) $error("Down count failed");
    
    // Test 4: Change direction mid-count
    Up = 1;
    @(posedge Clock);
    Up = 0;
    repeat(2) @(posedge Clock);
    
    $display("All tests passed");
    $finish;
  end

  // Timeout
  initial begin
    #1000;
    $display("Error: Simulation timed out");
    $finish;
  end

endmodule
