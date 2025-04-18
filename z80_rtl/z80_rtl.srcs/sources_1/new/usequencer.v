`timescale 1ns / 1ps
`include "decode.v"
`include "fsm.v"

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/24/2025 07:14:14 PM
// Design Name:
// Module Name: usequencer
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



module usequencer(
    input clk,
    input [7:0] flags,
    input [7:0] IR,

    // External control signals
    input ext_wait, // This is latched on opposite clock edge than the others I believe
    input ext_int,
    input ext_nmi,
    input ext_reset, //TODO: Figure out how we're handling resets
    input ext_busrq,

    output ext_m1,
    output ext_rfsh,
    output ext_busack,
    output ext_mreq,
    output ext_iorq,
    output ext_rd,
    output ext_wr,
    output reg ext_halt,

    output [49:0] m_signals,
    output [`TSIGNALS:0] t_signals,
    output jump_pc,

    output IX, IY
    );

    // External control signal latches
    reg wait_latch = 1; // wait is a keyword so I can't call it wait lol
    reg int = 1;
    reg nmi = 1;
    reg reset = 1;
    reg busrq = 1;

    reg mreq = 1;
    reg iorq = 1;
    reg rd = 1;
    reg wr = 1;

    // T-State signals
    reg [6:0] t_state = 0;
    wire [6:0] next_j_bits;
    wire [6:0] next_t_state;

    fsm t_cs(t_state, t_signals);
    
    //intermediate signal logic
    reg temp_mreq, temp_iorq, temp_rd, temp_wr;
    

    // Set signals to high impedence during bus grant
    assign ext_mreq = t_signals[`BUSACK] ? 1'bz : temp_mreq;
    assign ext_iorq = t_signals[`BUSACK] ? 1'bz : temp_iorq;
    assign ext_rd   = t_signals[`BUSACK] ? 1'bz : temp_rd;
    assign ext_wr   = t_signals[`BUSACK] ? 1'bz : temp_wr;

    
    // Decode logic

    wire [249:0] exec_sigs;
    wire [1:0] PLA_idx_w;
    wire [24:0] m_states;
    wire [2:0] max_m_cycles_w;
    wire [1:0] f_stall;
    wire [4:0] inst_next_m;
    wire next_IX_pref, next_IY_pref;
    wire no_int;
    wire cc_met;

    reg [2:0] m_cycle_ctr = 3'b0;
    reg [2:0] max_m_cycles = 3'b0;
    reg [1:0] PLA_idx = 2'b0;
    reg [1:0] IX_pref = 2'b0;
    reg [1:0] IY_pref = 2'b0;
    
    reg iff1 = 0;
    reg iff2 = 0;

    decode dec(IR, PLA_idx, IX_pref[1], IY_pref[1], exec_sigs, nmi, PLA_idx_w, m_states,
                     max_m_cycles_w, f_stall, next_IX_pref, next_IY_pref, no_int);

    upcoming_m_cycles umc(t_signals[`CS_SET], m_states, exec_sigs, m_cycle_ctr,
                      inst_next_m, m_signals);


    assign ext_m1 = !t_signals[`M1_HIGH];
    assign ext_rfsh = t_signals[`BUSACK] ? 1'bz : !t_signals[`RFSH];
    assign ext_busack = !t_signals[`BUSACK];

    assign IX = IX_pref[1];
    assign IY = IY_pref[1];

    wire [1:0] stall;
    assign stall = f_stall | {m_signals[`STALL_2], m_signals[`STALL_1]};

    assign next_j_bits[6:3] = t_signals[`J6:`J3];

    assign next_j_bits[2] = t_signals[`J2] | (t_signals[`COND1] & stall[1]);
    assign next_j_bits[1] = t_signals[`J1] | (t_signals[`COND1] &
                                              (stall[0] | (cc_met & m_signals[`CONDSTALL])));
    assign next_j_bits[0] = t_signals[`J0] | (t_signals[`COND0] & wait_latch);

    wire [6:0] next_m;

    next_m_cycle_logic next_m_logic(int, nmi, busrq, inst_next_m, m_cycle_ctr,
                                    max_m_cycles, iff1, no_int, next_m);

    assign next_t_state = t_signals[`LAST_T] ? next_m : next_j_bits;


    wire [2:0] condition;


    // Chooses from y, y-4, NZ, and Z based on EXEC signals
    assign condition = m_signals[`MUX_EXEC_COND_1] ?
        (m_signals[`MUX_EXEC_COND_0] ? 3'b001 : 3'b000) :
        (m_signals[`MUX_EXEC_COND_0] ? (IR[5:3]-4) : IR[5:3]);

    flag_logic fl(flags, condition, cc_met);

    
    assign jump_pc = m_signals[`PC_CONDLD] && cc_met && t_signals[`INC_PC];

    //reg temp_mreq, temp_iorq, temp_rd, temp_wr;

    always @(*) begin
        if (t_signals[`MREQ_R] && ~clk) begin
            temp_mreq = 0;
        end else if (t_signals[`MREQ_S_FE] && ~clk) begin
            temp_mreq = 1;
        end else begin
            temp_mreq = mreq;
        end
    
        if (t_signals[`IORQ_R] && ~clk) begin
            temp_iorq = 0;
        end else if (t_signals[`IORQ_S_FE] && ~clk) begin
            temp_iorq = 1;
        end else begin
            temp_iorq = iorq;
        end
    
        if (t_signals[`RD_R] && ~clk) begin
            temp_rd = 0;
        end else if (t_signals[`RD_S_FE] && ~clk) begin
            temp_rd = 1;
        end else begin
            temp_rd = rd;
        end
    
        if (t_signals[`WR_R] && ~clk) begin
            temp_wr = 0;
        end else if (t_signals[`WR_S_FE] && ~clk) begin
            temp_wr = 1;
        end else begin
            temp_wr = wr;
        end
    end
    

    always @(posedge clk) begin
        // Update input latches
        int <= ext_int;
        nmi <= ext_nmi;
        reset <= ext_reset;
        busrq <= ext_busrq;

        #20 t_state <= next_t_state;

        // Update output latches only if not waiting
        if(!(t_signals[`COND0] && !wait_latch)) begin
            if(t_signals[`MREQ_S_RE])
                mreq <= 1;

            if(t_signals[`IORQ_S_RE])
                iorq <= 1;

            if(t_signals[`RD_S_RE])
                rd <= 1;

            if(t_signals[`RD_R_RE])
                rd <= 0;

            if(t_signals[`WR_S_RE])
                wr <= 1;

            if(t_signals[`WR_R_RE])
                wr <= 0;
        end
        
        if(t_signals[`MREQ_R])
            mreq <= 0;
        else if(t_signals[`MREQ_S_FE])
            mreq <= 1;

        if(t_signals[`IORQ_R])
            iorq <= 0;
        else if(t_signals[`IORQ_S_FE])
            iorq <= 1;

        if(t_signals[`RD_R])
            rd <= 0;
        else if(t_signals[`RD_S_FE])
            rd <= 1;

        if(t_signals[`WR_R])
            wr <= 0;
        else if(t_signals[`WR_S_FE])
            wr <= 1;
        

        if(t_signals[`CS_SET]) begin
            m_cycle_ctr <= 0;
            max_m_cycles <= max_m_cycles_w;
            IX_pref[0] <= next_IX_pref;
            IY_pref[0] <= next_IY_pref;

        end

        if(t_signals[`EXEC])
            m_cycle_ctr <= m_cycle_ctr + 1;

        if((m_cycle_ctr == max_m_cycles) && t_signals[`LAST_T]) begin
            PLA_idx <= 0;
            IX_pref <= IX_pref << 1;
            IY_pref <= IY_pref << 1;
        end

        if(t_signals[`LAST_T]) begin
            PLA_idx <= PLA_idx_w;
        end

        if(m_signals[`DEC_MCTR_CC] & !cc_met)
            max_m_cycles = max_m_cycles - 1;

        if(m_signals[`DEC2_MCTR_CC] & !cc_met)
            max_m_cycles = max_m_cycles - 2;

        if(m_signals[`INT_FF_RESET]) begin
            iff1 <= 0;
            iff2 <= 0;
        end

        if(m_signals[`INT_FF_SET]) begin
            iff1 <= 1;
            iff2 <= 1;
        end

        if(m_signals[`PCMUX] == `PCMUX_NMI) begin
            iff1 <= 0;
            iff2 <= iff1;
        end

        if(m_signals[`IFF2_TO_IFF1]) begin
            iff1 <= iff2;
        end
       

    end

    always @(negedge clk) begin
        // Wait is updated on neg edge because it's special
        wait_latch <= ext_wait;

        // Update output latches
        
        


        if(t_signals[`HALT_R] || m_signals[`HALT_SIG])
            ext_halt <= 0;
    end



endmodule



module next_m_cycle_logic(
    input int,
    input nmi,
    input busrq,
    input [4:0] inst_next_m,
    input [2:0] m_cycle_ctr,
    input [2:0] max_m_cycles,
    input iff1,
    input no_interrupt,

    output reg [6:0] next_m
    );

    always @(*)
    begin
        if (!busrq)
            next_m = 7'd70; // Bus Request
        else if ((m_cycle_ctr == max_m_cycles) & !nmi & !no_interrupt)
            next_m = 7'd71; // Non-maskable interrupt
        else if ((m_cycle_ctr == max_m_cycles) & !int & iff1 & !no_interrupt)
            next_m = 7'd69; // Maskable interrupt
        else if (m_cycle_ctr != max_m_cycles)
            next_m = inst_next_m;
        else
            next_m = 7'd0; // Opcode Fetch
    end
endmodule


module upcoming_m_cycles(
    input cs_set,
    input [24:0] m_states,
    input [249:0] exec_signals,
    input [2:0] index,
    output [4:0] next_m_state,
    output [49:0] curr_exec_signals
    );

    reg [4:0] m_state_array [4:0];
    reg [49:0] exec_array [4:0];

    assign next_m_state = m_state_array[index+1];
    assign curr_exec_signals = exec_array[index];

    // Negative edge so we don't change outputs until decode is stable
    always @(negedge cs_set) begin
        // There is probably a better way to do this but I am a bit simple
        m_state_array[0] <= m_states[4:0];
        m_state_array[1] <= m_states[9:5];
        m_state_array[2] <= m_states[14:10];
        m_state_array[3] <= m_states[19:15];
        m_state_array[4] <= m_states[24:20];

        exec_array[0] <= exec_signals[49:0];
        exec_array[1] <= exec_signals[99:50];
        exec_array[2] <= exec_signals[149:100];
        exec_array[3] <= exec_signals[199:150];
        exec_array[4] <= exec_signals[249:200];
    end
endmodule

module flag_logic(
    input [7:0] flags,
    input [2:0] condition,
    output reg is_met
    );

    always @* begin
        case(condition)
            3'b000: is_met <= !flags[6];    // non-zero
            3'b001: is_met <= flags[6];     // zero
            3'b010: is_met <= !flags[0];    // no carry
            3'b011: is_met <= flags[0];     // carry
            3'b100: is_met <= !flags[2];    // odd parity
            3'b101: is_met <= flags[2];     // even parity
            3'b110: is_met <= !flags[7];    // positive
            3'b111: is_met <= flags[7];     // negative
        endcase
    end
endmodule

