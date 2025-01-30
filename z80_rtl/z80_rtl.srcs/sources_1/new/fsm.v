`timescale 1ns/1ps
`include "z80_defines.v"

module fsm(
    input [6:0] STATE,
    output reg [`TSIGNALS:0] SIGNALS
);

    always @(*) begin
        SIGNALS = 0;
        case(STATE)
            7'd0: begin
                // state 0
                //gatepc, mreqr, rdr, M1_HIGH
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`RD_R] = 1;
                SIGNALS[`M1_HIGH] = 1;
                //j = 30
                SIGNALS[`JBITS] = 7'd30;
            end
            7'd1: begin
                // state 1 - marh, MREQR, RDR
                SIGNALS[`GATE_MARH] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`RD_R] = 1;
                //j = 18
                SIGNALS[`JBITS] = 7'd18;
            end
            7'd2: begin
                // state 2 - marl, mreqr, rdr, stall
                SIGNALS[`GATE_MARL] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`RD_R] = 1;
                SIGNALS[`COND1] = 1; //check for stall
                //j = 20
                SIGNALS[`JBITS] = 7'd20;
            end
            7'd3: begin
                // state 3 - marh, mreqr, gatemdrh
                SIGNALS[`GATE_MARH] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`GATE_MDRH] = 1;
                //j = 40
                SIGNALS[`JBITS] = 7'd40;
            end
            7'd4: begin
                // state 4 - marl, mreqr, gatemdrl, stall
                SIGNALS[`GATE_MARL] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`GATE_MDRL] = 1;
                SIGNALS[`COND1] = 1; //check for stall
                //j = 42
                SIGNALS[`JBITS] = 7'd42;

            end
            7'd5: begin
                // state 5 - gatepc, mreqr, rdr, stall
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`RD_R] = 1;
                SIGNALS[`COND1] = 1; //check for stall
                //j = 24
                SIGNALS[`JBITS] = 7'd24;
            end
            7'd6: begin
                // state 6 - gatepc, mreqr, rdr,
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`RD_R] = 1;
                //j = 28
                SIGNALS[`JBITS] = 7'd28;
            end
            7'd7: begin
                // state 7 - marl, iorqrre, rdrre
                SIGNALS[`GATE_MARL] = 1;
                SIGNALS[`IORQ_R] = 1;
                SIGNALS[`RD_R_RE] = 1;
                //j = 15
                SIGNALS[`JBITS] = 7'd15;
            end
            7'd8: begin
                // state 8 - gatemdrl, marl, iorqrre, wrrre
                SIGNALS[`GATE_MDRL] = 1;
                SIGNALS[`GATE_MARL] = 1;
                SIGNALS[`IORQ_R] = 1;
                SIGNALS[`WR_R_RE] = 1;
                //j = 37
                SIGNALS[`JBITS] = 7'd37;

            end
            7'd9: begin
                // state 9 - gatespinc, mreqr, gatemdrh
                SIGNALS[`GATE_SP_INC] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`GATE_MDRH] = 1;
                //j = 48
                SIGNALS[`JBITS] = 7'd48;
            end
            7'd10: begin
                // state 10 - gatespinc, mreqr, gatemdrl, stall
                SIGNALS[`GATE_SP_INC] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`GATE_MDRL] = 1;
                SIGNALS[`COND1] = 1; //check for stall
                //j = 46
                SIGNALS[`JBITS] = 7'd46;
            end
            7'd11: begin
                // state 11 - spdec, mreqr, rdr, stall
                SIGNALS[`GATE_SP_DEC] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`RD_R] = 1;
                SIGNALS[`COND1] = 1; //check for stall
                //j = 58
                SIGNALS[`JBITS] = 7'd58;
            end
            7'd12: begin
                // state 12 - spdec, mreqr, rdr
                SIGNALS[`GATE_SP_DEC] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`RD_R] = 1;
                //j = 56
                SIGNALS[`JBITS] = 7'd56;
            end
            7'd13: begin
                // state 13 - stall
                SIGNALS[`COND1] = 1; //check for stall
                //j = 64
                SIGNALS[`JBITS] = 7'd64;
            end
            7'd14: begin
                // state 14 - gatepc, mreqr, rdr, mdrtemp
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`RD_R] = 1;
                SIGNALS[`MDR_TEMP] = 1;
                //j = 62
                SIGNALS[`JBITS] = 7'd62;
            end
            7'd15: begin
                // state 15 - marl
                SIGNALS[`GATE_MARL] = 1;
                //j = 16
                SIGNALS[`JBITS] = 7'd16;
            end
            7'd16: begin
                // state 16 - marl, wait
                SIGNALS[`GATE_MARL] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 16
                SIGNALS[`JBITS] = 7'd16;
            end
            7'd17: begin
                // state 17 - ldmdrl, marl, iorqsfe, rdsfe, exec, lastt
                SIGNALS[`LD_MDRL] = 1;
                SIGNALS[`GATE_MARL] = 1;
                SIGNALS[`IORQ_S_FE] = 1;
                SIGNALS[`RD_S_FE] = 1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd18: begin
                // state 18 - marh, wait
                SIGNALS[`GATE_MARH] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 18
                SIGNALS[`JBITS] = 7'd18;
            end
            7'd19: begin
                // state 19 - marh, mdrh in, mreqsfe, rdsfe, exec, lastt
                SIGNALS[`GATE_MARH] = 1;
                SIGNALS[`LD_MDRH] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`RD_S_FE] = 1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd20: begin
                // state 20 - marl, wait
                SIGNALS[`GATE_MARL] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 20
                SIGNALS[`JBITS] = 7'd20;
            end
            7'd21: begin
                // state 21 - marl, mdrl in, mreqsfe, rdsfe, exec, lastt
                SIGNALS[`GATE_MARL] = 1;
                SIGNALS[`LD_MDRL] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`RD_S_FE] = 1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd22: begin
                // state 22 - marl
                SIGNALS[`GATE_MARL] = 1;
                //j = 20
                SIGNALS[`JBITS] = 7'd20;
            end
            7'd23: begin
                // state 23 - marl
                SIGNALS[`GATE_MARL] = 1;
                //j = 41
                SIGNALS[`JBITS] = 7'd41;
            end
            7'd24: begin
                // state 24 - gatepc, wait
                SIGNALS[`GATE_PC] = 1;
                //j = 24
                SIGNALS[`JBITS] = 7'd24;
            end
            7'd25: begin
                // state 25 - gatepc, INC_PC, ld mdrh, exec, mreqsfe, rdsfe, lastt
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`INC_PC] = 1;
                SIGNALS[`LD_MDRH] = 1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`RD_S_FE] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd26: begin
                // state 26 - gatepc
                SIGNALS[`GATE_PC] = 1;
                //j = 24
                SIGNALS[`JBITS] = 7'd24;
            end
            7'd27: begin
                // state 27 - spinc
                SIGNALS[`GATE_SP_INC] = 1;
                //j = 56
                SIGNALS[`JBITS] = 7'd56;
            end
            7'd28: begin
                // state 28 - gatepc, wait
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 28
                SIGNALS[`JBITS] = 7'd28;
            end
            7'd29: begin
                // state 29 - gate pc, ldpc, ldmdrl, exec, mreqsfe, rdsfe, lastt
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`INC_PC] = 1;
                SIGNALS[`LD_MDRL] = 1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`RD_S_FE] = 1;
            end
            7'd30: begin
                // state 30 - mreqsre, rdsre, ldir, gatepc, M1_HIGH, wait
                SIGNALS[`MREQ_S_RE] = 1;
                SIGNALS[`RD_S_RE] = 1;
                SIGNALS[`LD_IR] = 1;
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`M1_HIGH] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 30
                SIGNALS[`JBITS] = 7'd30;
            end
            7'd31: begin
                // state 31 - rfsh, mreqr, csset, fstall
                SIGNALS[`RFSH] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`CS_SET] = 1;
                SIGNALS[`COND1] = 1; //check for fstall
                //j = 32
                SIGNALS[`JBITS] = 7'd32;
            end
            7'd32: begin
                // state 32 - RFSH, MREQsfe, exec, ldpc, lastt
                SIGNALS[`RFSH] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`INC_PC] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd33: begin
                // state 33 - rfsh, mreqsfe, exec, ldpc, lastt
                SIGNALS[`RFSH] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`INC_PC] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd34: begin
                // state 34 - rfsh
                SIGNALS[`RFSH] = 1;
                //j = 32
                SIGNALS[`JBITS] = 7'd32;
            end
            7'd35: begin
                // state 35 - gatepc, M1_HIGH, mreqsre, rdsre
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`M1_HIGH] = 1;
                SIGNALS[`MREQ_S_RE] = 1;
                SIGNALS[`RD_S_RE] = 1;
                //j = 45
                SIGNALS[`JBITS] = 7'd45;
            end
            7'd36: begin
                // state 36 - rfsh
                SIGNALS[`RFSH] = 1;
                //j - 34
                SIGNALS[`JBITS] = 7'd34;
            end
            7'd37: begin
                // state 37 - marl,
                SIGNALS[`GATE_MARL] = 1;
                //j = 38
                SIGNALS[`JBITS] = 7'd38;
            end
            7'd38: begin
                // state 38 - marl,  wait
                SIGNALS[`GATE_MARL] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 38
                SIGNALS[`JBITS] = 7'd38;
            end
            7'd39: begin
                // state 39 - marl, iorqsfe, wrsfe, exec, lastt
                SIGNALS[`GATE_MARL] = 1;
                SIGNALS[`IORQ_S_FE] = 1;
                SIGNALS[`WR_S_FE] = 1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd40: begin
                // state 40 - marl, wrr, wait
                SIGNALS[`GATE_MARL] = 1;
                SIGNALS[`WR_R] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 40
                SIGNALS[`JBITS] = 7'd40;
            end
            7'd41: begin
                // state 41 - marl, mreqsfe, wrsfe, exec, lastt
                SIGNALS[`GATE_MARL] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`WR_S_FE] = 1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd42: begin
                // state 42 - marh, wrr, wait
                SIGNALS[`GATE_MARH] = 1;
                SIGNALS[`WR_R] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 42
                SIGNALS[`JBITS] = 7'd42;
            end
            7'd43: begin
                // state 43 - marh, mreqsfe, wrsfe, exec, lastt
                SIGNALS[`GATE_MARH] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`WR_S_FE] = 1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd44: begin
                // state 44 - marl
                SIGNALS[`GATE_MARL] = 1;
                //j = 23
                SIGNALS[`JBITS] = 7'd23;
            end
            7'd45: begin
                // state 45 - rfsh, mreqr, csset, NMI_JANK
                SIGNALS[`RFSH] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`CS_SET] = 1;
                SIGNALS[`NMI_JANK] = 1;
                //j = 67
                SIGNALS[`JBITS] = 7'd67;
            end
            7'd46: begin
                // state 46 - spdec, wait
                SIGNALS[`GATE_SP_DEC] = 1;
                //j = 46
                SIGNALS[`JBITS] = 7'd46;
            end
            7'd47: begin
                // state 47 - spdec, ldsp, spmux = 1, exec, lastt, mreqsfe, rdsfe
                SIGNALS[`GATE_SP_DEC] = 1;
                SIGNALS[`LD_SP] = 1;
                SIGNALS[`SP_MUX] = 1'b1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`RD_S_FE] = 1;
            end
            7'd48: begin
                // state 48 - spdec, wait
                SIGNALS[`GATE_SP_DEC] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 48
                SIGNALS[`JBITS] = 7'd48;
            end
            7'd49: begin
                // state 49 - spdec, ldsp, spmux = 1, exec, lastt, mreqsfe, rdsfe
                SIGNALS[`GATE_SP_DEC] = 1;
                SIGNALS[`LD_SP] = 1;
                SIGNALS[`SP_MUX] = 1'b1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`RD_S_FE] = 1;
            end
            7'd50: begin
                // state 50 - spdec
                SIGNALS[`GATE_SP_DEC] = 1;
                //j = 48
                SIGNALS[`JBITS] = 7'd48;
            end
            7'd51: begin
                // state 51 - rfsh, mreqsfe, exec, lastt
                SIGNALS[`RFSH] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd52: begin
                // state 52 - gatepc, M1_HIGH
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`M1_HIGH] = 1;
                //j = 53
                SIGNALS[`JBITS] = 7'd53;
            end
            7'd53: begin
                // state 53 - gatepc, iorqsfe, M1_HIGH
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`IORQ_S_FE] = 1;
                SIGNALS[`M1_HIGH] = 1;
                //j = 54
                SIGNALS[`JBITS] = 7'd54;
            end
            7'd54: begin
                // state 54 - gatepc, iorqrre, M1_HIGH, ldir, wait
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`IORQ_R] = 1;
                SIGNALS[`M1_HIGH] = 1;
                SIGNALS[`LD_IR] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 54
                SIGNALS[`JBITS] = 7'd54;
            end
            7'd55: begin
                // state 55 - rfsh, mreqr, csset
                SIGNALS[`RFSH] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`CS_SET] = 1;
                //j = 51
                SIGNALS[`JBITS] = 7'd51;
            end
            7'd56: begin
                // state 56 - gatespinc, wrr, wait
                SIGNALS[`GATE_SP_INC] = 1;
                SIGNALS[`WR_R] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 56
                SIGNALS[`JBITS] = 7'd56;
            end
            7'd57: begin
                // state 57 - spink, ldsp, spmux = 0, exec, lastt, mreqsfe, wrsfe
                SIGNALS[`GATE_SP_INC] = 1;
                SIGNALS[`LD_SP] = 1;
                SIGNALS[`SP_MUX] = 1'b0;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`WR_S_FE] = 1;
            end
            7'd58: begin
                // state 58 - gatespinc, wrr, wait
                SIGNALS[`GATE_SP_INC] = 1;
                SIGNALS[`WR_R] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 58
                SIGNALS[`JBITS] = 7'd58;
            end
            7'd59: begin
                // state 59 - spinc, ldsp, spmux = 0, exec, lastt, mreqsfe, wrsfe
                SIGNALS[`GATE_SP_INC] = 1;
                SIGNALS[`LD_SP] = 1;
                SIGNALS[`SP_MUX] = 1'b0;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`WR_S_FE] = 1;
            end
            7'd60: begin
                // state 60 - gatespinc
                SIGNALS[`GATE_SP_INC] = 1;
                //j = 27
                SIGNALS[`JBITS] = 7'd27;
            end
            7'd61: begin
                // state 61 -MDRtemp, rfsh
                SIGNALS[`MDR_TEMP] = 1;
                SIGNALS[`RFSH] = 1;
                //j = 33
                SIGNALS[`JBITS] = 7'd33;
            end
            7'd62: begin
                // state 62 - mreqsre, rdsre, ldir, gatepc, wait
                SIGNALS[`MREQ_S_RE] = 1;
                SIGNALS[`RD_S_RE] = 1;
                SIGNALS[`LD_IR] = 1;
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`COND0] = 1; //check for wait
                //j = 62
                SIGNALS[`JBITS] = 7'd62;
            end
            7'd63: begin
                // state 63 - rfsh, mreqr, csset
                SIGNALS[`RFSH] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`CS_SET] = 1;
                //j = 61
                SIGNALS[`JBITS] = 7'd61;
            end
            7'd64: begin
                // state 64
                //j = 65
                SIGNALS[`JBITS] = 7'd65;
            end
            7'd65: begin
                // state 65 - exec, lastt
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd66: begin
                // state 66
                //j = 64
                SIGNALS[`JBITS] = 7'd64;
            end
            7'd67: begin
                // state 67 - rfsh, mreqsfe, exec, lastt
                SIGNALS[`RFSH] = 1;
                SIGNALS[`MREQ_S_FE] = 1;
                SIGNALS[`EXEC] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd68: begin
                // state 68
                //j = 66
                SIGNALS[`JBITS] = 7'd66;
            end
            7'd69: begin
                // state 69 - gatepc, M1_HIGH, halt_r
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`M1_HIGH] = 1;
                SIGNALS[`HALT_R] = 1;
                //j = 52
                SIGNALS[`JBITS] = 7'd52;
            end
            7'd70: begin
                // state 70 - busack, lastt
                SIGNALS[`BUSACK] = 1;
                SIGNALS[`LAST_T] = 1;
            end
            7'd71: begin
                // state 71 - gatepc, M1_HIGH, rdr, mreqr, iff12iff2, haltr
                SIGNALS[`GATE_PC] = 1;
                SIGNALS[`M1_HIGH] = 1;
                SIGNALS[`RD_R] = 1;
                SIGNALS[`MREQ_R] = 1;
                SIGNALS[`IFF1_R_TO_IFF2] = 1;
                SIGNALS[`HALT_R] = 1;
                //j = 35
                SIGNALS[`JBITS] = 7'd35;

            end
            default: begin
                // nothing happens
            end
        endcase
    end

endmodule
