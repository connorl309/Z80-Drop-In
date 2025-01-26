`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2025 10:56:41 AM
// Design Name: 
// Module Name: uart
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


module uart(
    input clk,
    input reset,
  
    input rx,
    output reg tx,
    
    output reg [7:0] rx_fifo,
    output rx_fifo_wr,
    input rx_fifo_full,
    
    input [7:0] tx_fifo,
    output tx_fifo_rd,
    input tx_fifo_empty,
    
    output [1:0] rx_state,
    output [1:0] tx_state,
    output reg [15:0] rx_delay_left,
    output reg [15:0] tx_delay_left,
    output reg [3:0] rx_bits_left,
    output reg [3:0] tx_bits_left
    );
    
    parameter UART_BAUD = 115200;
    parameter UART_CLK_FREQ = 100000000;
    
    localparam FSM_IDLE = 0;
    localparam FSM_READ = 1;
    localparam FSM_WRITE = 2;
    localparam FSM_STOP = 3;
    reg [1:0] rx_fsm_state = 0;
    reg [1:0] tx_fsm_state = 0;
    
    assign rx_state = rx_fsm_state;
    assign tx_state = tx_fsm_state;
    
    localparam DELAY = (UART_CLK_FREQ / UART_BAUD) / 2;
    
    parameter UART_BIT_LENGTH = 8;
    
    assign rx_fifo_wr = !rx_fifo_full && rx_fsm_state == FSM_WRITE;
    
    // Receive
    // Wait for start, read into a buffer, tell fifo to store
    always @(posedge clk) begin
        if (reset) begin
            rx_fsm_state <= FSM_IDLE;
        end else begin
            case (rx_fsm_state)
                FSM_IDLE: begin
                    rx_bits_left <= UART_BIT_LENGTH;
                    rx_delay_left <= DELAY * 3;
                    rx_fsm_state <= rx == 0 ? FSM_READ : FSM_IDLE;
                end
                FSM_READ: begin
                    if (rx_delay_left == 0) begin
                        rx_fifo[UART_BIT_LENGTH - rx_bits_left] <= rx;
                        rx_bits_left <= rx_bits_left - 1;
                    end
                    rx_delay_left <= rx_delay_left == 0 ? DELAY * 2 : rx_delay_left - 1;
                    rx_fsm_state <= rx_bits_left > 0 ? FSM_READ : FSM_WRITE;
                end
                FSM_WRITE: begin
                    rx_fsm_state <= FSM_STOP;
                    rx_delay_left <= DELAY * 2;
                end
                FSM_STOP: begin
                    rx_fsm_state <= rx_delay_left == 0 ? FSM_IDLE : FSM_STOP;
                    rx_delay_left <= rx_delay_left - 1;
                end
            endcase
        end
    end
    
    reg [7:0] tx_fifo_buffer = 0;
    assign tx_fifo_rd = tx_fsm_state == FSM_IDLE && !tx_fifo_empty;
    
    // Transmit
    // Wait for fifo to have something, write the buffer
    always @(posedge clk) begin
        case (tx_fsm_state)
            FSM_IDLE: begin
                tx_fsm_state <= tx_fifo_empty == 1 ? FSM_IDLE : FSM_READ;
                tx_bits_left <= UART_BIT_LENGTH;
                tx_delay_left <= DELAY * 2;
                tx <= tx_fifo_empty;
            end
            FSM_READ: begin
                tx_fifo_buffer <= tx_fifo;
                tx_fsm_state <= FSM_WRITE;
                tx_delay_left <= tx_delay_left - 1;
            end
            FSM_WRITE: begin
                if (tx_delay_left == 0) begin
                    tx <= tx_bits_left == 0 ? 1 : tx_fifo_buffer[UART_BIT_LENGTH - tx_bits_left];
                    tx_bits_left <= tx_bits_left - 1;
                end
                tx_delay_left <= tx_delay_left == 0 ? DELAY * 2 : tx_delay_left - 1;
                tx_fsm_state <= tx_bits_left == 0 && tx_delay_left == 0 ? FSM_STOP : FSM_WRITE;
            end
            FSM_STOP: begin
                tx_fsm_state <= tx_delay_left == 0 ? FSM_IDLE : FSM_STOP;
                tx <= 1;
                tx_delay_left <= tx_delay_left - 1;
            end
            default: begin
                tx <= 1;
                tx_fsm_state <= FSM_IDLE;
            end
        endcase
    end
    
    
endmodule
