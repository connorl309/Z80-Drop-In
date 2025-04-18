set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

####################################################################################################################
#                                               CLOCK 100MHz                                                       #
####################################################################################################################
set_property PACKAGE_PIN D14 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]

####################################################################################################################
#                                               FT2232H Signals                                                    #
####################################################################################################################
#set_property -dict { PACKAGE_PIN "L13"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { RXD }]  ;               # IO_0_14                       Sch = FTDI-D0
#set_property -dict { PACKAGE_PIN "N13"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { TXD }]  ;               # IO_L6N_T0_D08_VREF_14         Sch = FTDI-D1
#set_property -dict { PACKAGE_PIN "L17"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { RTS }]  ;               # IO_L4P_T0_D04_14              Sch = FTDI-D2
#set_property -dict { PACKAGE_PIN "L18"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { CTS }]  ;               # IO_L4N_T0_D05_14              Sch = FTDI-D3
#set_property -dict { PACKAGE_PIN "M17"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { DATA[4] }]  ;               # IO_L7N_T1_D10_14              Sch = FTDI-D4
#set_property -dict { PACKAGE_PIN "M18"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { DATA[5] }]  ;               # IO_L8P_T1_D11_14              Sch = FTDI-D5
#set_property -dict { PACKAGE_PIN "M16"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { DATA[6] }]  ;               # IO_L7P_T1_D09_14              Sch = FTDI-D6
#set_property -dict { PACKAGE_PIN "N18"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { DATA[7] }]  ;               # IO_L8N_T1_D12_14              Sch = FTDI-D7

#set_property -dict { PACKAGE_PIN "P17"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { TXE_N }]    ;               # IO_L9P_T1_DQS_14              Sch = FTDI-TXE#
#set_property -dict { PACKAGE_PIN "P18"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { RXF_N }]    ;               # IO_L9N_T1_DQS_D13_14          Sch = FTDI-RXF#
#set_property -dict { PACKAGE_PIN "T18"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { WR_N  }]    ;               # IO_L10N_T1_D15_14             Sch = FTDI-WR#
#set_property -dict { PACKAGE_PIN "R18"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { RD_N  }]    ;               # IO_L10P_T1_D14_14             Sch = FTDI-RD#
#set_property -dict { PACKAGE_PIN "R14"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { CLKOUT}]    ;               # IO_L13P_T2_MRCC_14            Sch = FTDI-CLKOUT
#set_property -dict { PACKAGE_PIN "R12"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { OE_N  }]    ;               # IO_25_14                      Sch = FTDI-OE#
#set_property -dict { PACKAGE_PIN "L16"    IOSTANDARD LVCMOS33       SLEW FAST} [get_ports { SIWUA }]    ;               # IO_L3N_T0_DQS_EMCCLK_14       Sch = FTDI-SIWUA

####################################################################################################################
#                                        DDR3       : MT41J128M16XX-125                                            #
#                                        Frequency  : 400 MHz                                                      #
#                                        Data Width : 16                                                           #
####################################################################################################################
#set_property -dict { PACKAGE_PIN "L4"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[0]}]     ;               # IO_L1N_T0_34                  Sch = DDR3-DQ0
#set_property -dict { PACKAGE_PIN "K3"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[1]}]     ;               # IO_L2P_T0_34                  Sch = DDR3-DQ1
#set_property -dict { PACKAGE_PIN "K2"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[2]}]     ;               # IO_L2N_T0_34                  Sch = DDR3-DQ2
#set_property -dict { PACKAGE_PIN "K6"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[3]}]     ;               # IO_L4P_T0_34                  Sch = DDR3-DQ3
#set_property -dict { PACKAGE_PIN "L6"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[4]}]     ;               # IO_L4N_T0_34                  Sch = DDR3-DQ4
#set_property -dict { PACKAGE_PIN "L5"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[5]}]     ;               # IO_L5P_T0_34                  Sch = DDR3-DQ5
#set_property -dict { PACKAGE_PIN "M4"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[6]}]     ;               # IO_L5N_T0_34                  Sch = DDR3-DQ6
#set_property -dict { PACKAGE_PIN "M6"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[7]}]     ;               # IO_L6P_T0_34                  Sch = DDR3-DQ7
#set_property -dict { PACKAGE_PIN "M2"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[8]}]     ;               # IO_L7N_T1_34                  Sch = DDR3-DQ8
#set_property -dict { PACKAGE_PIN "M1"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[9]}]     ;               # IO_L8P_T1_34                  Sch = DDR3-DQ9
#set_property -dict { PACKAGE_PIN "N1"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[10]}]    ;               # IO_L8N_T1_34                  Sch = DDR3-DQ10
#set_property -dict { PACKAGE_PIN "N5"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[11]}]    ;               # IO_L10P_T1_34                 Sch = DDR3-DQ11
#set_property -dict { PACKAGE_PIN "N4"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[12]}]    ;               # IO_L10N_T1_34                 Sch = DDR3-DQ12
#set_property -dict { PACKAGE_PIN "P2"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[13]}]    ;               # IO_L11P_T1_SRCC_34            Sch = DDR3-DQ13
#set_property -dict { PACKAGE_PIN "P1"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[14]}]    ;               # IO_L11N_T1_SRCC_34            Sch = DDR3-DQ14
#set_property -dict { PACKAGE_PIN "R2"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dq[15]}]    ;               # IO_L12P_T1_MRCC_34            Sch = DDR3-DQ15
#set_property -dict { PACKAGE_PIN "P5"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[0]}]   ;               # IO_L19N_T3_VREF_34            Sch = DDR3-A0
#set_property -dict { PACKAGE_PIN "P6"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[1]}]   ;               # IO_L19P_T3_34                 Sch = DDR3-A1
#set_property -dict { PACKAGE_PIN "T3"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[2]}]   ;               # IO_L18N_T2_34                 Sch = DDR3-A2
#set_property -dict { PACKAGE_PIN "R4"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[3]}]   ;               # IO_L18P_T2_34                 Sch = DDR3-A3
#set_property -dict { PACKAGE_PIN "V4"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[4]}]   ;               # IO_L17N_T2_34                 Sch = DDR3-A4
#set_property -dict { PACKAGE_PIN "V5"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[5]}]   ;               # IO_L17P_T2_34                 Sch = DDR3-A5
#set_property -dict { PACKAGE_PIN "V2"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[6]}]   ;               # IO_L16N_T2_34                 Sch = DDR3-A6
#set_property -dict { PACKAGE_PIN "V3"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[7]}]   ;               # IO_L16P_T2_34                 Sch = DDR3-A7
#set_property -dict { PACKAGE_PIN "U2"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[8]}]   ;               # IO_L15N_T2_DQS_34             Sch = DDR3-A8
#set_property -dict { PACKAGE_PIN "U3"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[9]}]   ;               # IO_L15P_T2_DQS_34             Sch = DDR3-A9
#set_property -dict { PACKAGE_PIN "U1"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[10]}]  ;               # IO_L14N_T2_SRCC_34            Sch = DDR3-A10
#set_property -dict { PACKAGE_PIN "T1"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[11]}]  ;               # IO_L14P_T2_SRCC_34            Sch = DDR3-A11
#set_property -dict { PACKAGE_PIN "T2"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[12]}]  ;               # IO_L13N_T2_MRCC_34            Sch = DDR3-A12
#set_property -dict { PACKAGE_PIN "R3"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_addr[13]}]  ;               # IO_L13P_T2_MRCC_34            Sch = DDR3-A13
#set_property -dict { PACKAGE_PIN "T6"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_ba[0]}]     ;               # IO_L22P_T3_34                 Sch = DDR3-BA0
#set_property -dict { PACKAGE_PIN "V6"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_ba[1]}]     ;               # IO_L20N_T3_34                 Sch = DDR3-BA1
#set_property -dict { PACKAGE_PIN "V7"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_ba[2]}]     ;               # IO_L20P_T3_34                 Sch = DDR3-BA2
#set_property -dict { PACKAGE_PIN "T5"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_ras_n}]     ;               # IO_L22N_T3_34                 Sch = DDR3-RAS
#set_property -dict { PACKAGE_PIN "R7"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_cas_n}]     ;               # IO_L23P_T3_34                 Sch = DDR3-CAS
#set_property -dict { PACKAGE_PIN "R6"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_we_n}]      ;               # IO_L23N_T3_34                 Sch = DDR3-WE
#set_property -dict { PACKAGE_PIN "M5"     IOSTANDARD LVCMOS15   SLEW FAST} [get_ports {ddr3_reset_n}]   ;               # IO_L6N_T0_VREF_34             Sch = DDR3-RESET
#set_property -dict { PACKAGE_PIN "U6"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_cke}]       ;               # IO_L24N_T3_34                 Sch = DDR3-CKE
#set_property -dict { PACKAGE_PIN "P7"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_odt}]       ;               # IO_25_34                      Sch = DDR3-ODT
#set_property -dict { PACKAGE_PIN "U7"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_cs_n}]      ;               # IO_24P_T3_34                  Sch = DDR3-CS#
#set_property -dict { PACKAGE_PIN "K4"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dm[0]}]     ;               # IO_L1P_T0_34                  Sch = DDR3-LDM
#set_property -dict { PACKAGE_PIN "M3"     IOSTANDARD SSTL15     SLEW FAST} [get_ports {ddr3_dm[1]}]     ;               # IO_L7P_T1_34                  Sch = DDR3-UDM
#set_property -dict { PACKAGE_PIN "K1"     IOSTANDARD DIFF_SSTL15 SLEW FAST} [get_ports {ddr3_dqs_p[0]}] ;               # IO_L3P_T0_DQS_34              Sch = DDR3-LDQS_P
#set_property -dict { PACKAGE_PIN "L1"     IOSTANDARD DIFF_SSTL15 SLEW FAST} [get_ports {ddr3_dqs_n[0]}] ;               # IO_L3N_T0_DQS_34              Sch = DDR3-LDQS_N
#set_property -dict { PACKAGE_PIN "N3"     IOSTANDARD DIFF_SSTL15 SLEW FAST} [get_ports {ddr3_dqs_p[1]}] ;               # IO_L9P_T1_DQS_34              Sch = DDR3-UDQS_P
#set_property -dict { PACKAGE_PIN "N2"     IOSTANDARD DIFF_SSTL15 SLEW FAST} [get_ports {ddr3_dqs_n[1]}] ;               # IO_L9N_T1_DQS_34              Sch = DDR3-UDQS_N
#set_property -dict { PACKAGE_PIN "R5"     IOSTANDARD DIFF_SSTL15 SLEW FAST} [get_ports {ddr3_ck_p[0]}]  ;               # IO_L21P_T3_DQS_34             Sch = DDR3-CK_P
#set_property -dict { PACKAGE_PIN "T4"     IOSTANDARD DIFF_SSTL15 SLEW FAST} [get_ports {ddr3_ck_n[0]}]  ;               # IO_L21N_T3_DQS_34             Sch = DDR3-CK_N

####################################################################################################################
#                                              QSPI - FLASH                                                        #
####################################################################################################################
#set_property -dict { PACKAGE_PIN "M13"    IOSTANDARD LVCMOS33    SLEW FAST} [get_ports { SPI_CS_N }]     ;              # IO_L6P_T0_FCS_B_14            Sch = SPI_CS_N
#set_property -dict { PACKAGE_PIN "K17"    IOSTANDARD LVCMOS33    SLEW FAST} [get_ports { SPI_DQ[0] }]    ;              # IO_L1P_T0_D00_MOSI_14         Sch = SPI_DQ0
#set_property -dict { PACKAGE_PIN "K18"    IOSTANDARD LVCMOS33    SLEW FAST} [get_ports { SPI_DQ[1] }]    ;              # IO_L1N_T0_D01_DIN_14          Sch = SPI_DQ1
#set_property -dict { PACKAGE_PIN "L14"    IOSTANDARD LVCMOS33    SLEW FAST} [get_ports { SPI_DQ[2] }]    ;              # IO_L2P_T0_D02_14              Sch = SPI_DQ2
#set_property -dict { PACKAGE_PIN "M15"    IOSTANDARD LVCMOS33    SLEW FAST} [get_ports { SPI_DQ[3] }]    ;              # IO_L2N_T0_D03_14              Sch = SPI_DQ3
#set_property -dict { PACKAGE_PIN "C8"     IOSTANDARD LVCMOS33    SLEW FAST} [get_ports { SPI_SCK }]      ;              # CCLK_0                        Sch = SPI_SCK

####################################################################################################################
#                                              LED                                                                 #
####################################################################################################################
#set_property -dict  { PACKAGE_PIN "G13"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {LED}];                          # IO_0_15                       Sch = LED

###################################################################################################################
#                                               Header P4                                                         #
###################################################################################################################
set_property -dict  { PACKAGE_PIN "A14"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[0]}];                        # IO_L2N_T0_AD8N_15             Sch = GPIO_1_N
set_property -dict  { PACKAGE_PIN "B14"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[1]}];                        # IO_L2P_T0_AD8P_15             Sch = GPIO_1_P
set_property -dict  { PACKAGE_PIN "B2"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[2]}];                        # IO_L11N_T1_SRCC_35            Sch = GPIO_2_N
set_property -dict  { PACKAGE_PIN "C2"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[3]}];                        # IO_L11P_T1_SRCC_35            Sch = GPIO_2_P
set_property -dict  { PACKAGE_PIN "A15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[4]}];                        # IO_L3N_T0_DQS_AD1N_15         Sch = GPIO_3_N
set_property -dict  { PACKAGE_PIN "B15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[5]}];                        # IO_L3P_T0_DQS_AD1P_15         Sch = GPIO_3_P
set_property -dict  { PACKAGE_PIN "A16"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[6]}];                        # IO_L4N_T0_15                  Sch = GPIO_4_N
set_property -dict  { PACKAGE_PIN "B16"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[7]}];                        # IO_L4P_T0_15                  Sch = GPIO_4_P
#set_property -dict  { PACKAGE_PIN "A17"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[8]}];                        # IO_L7N_T1_AD2N_15             Sch = GPIO_5_N
#set_property -dict  { PACKAGE_PIN "B17"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[9]}];                        # IO_L7P_T1_AD2P_15             Sch = GPIO_5_P
#set_property -dict  { PACKAGE_PIN "A7"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[10]}];                       # IO_L1N_T0_AD4N_35             Sch = GPIO_6_N
#set_property -dict  { PACKAGE_PIN "A8"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[11]}];                       # IO_L1P_T0_AD4P_35             Sch = GPIO_6_P
#set_property -dict  { PACKAGE_PIN "B5"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[12]}];                       # IO_L2N_T0_AD12N_35            Sch = GPIO_7_N
#set_property -dict  { PACKAGE_PIN "C5"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[13]}];                       # IO_L2P_T0_AD12P_35            Sch = GPIO_7_P
#set_property -dict  { PACKAGE_PIN "A4"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[14]}];                       # IO_L9N_T1_DQS_AD7N_35         Sch = GPIO_8_N
#set_property -dict  { PACKAGE_PIN "A5"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[15]}];                       # IO_L9P_T1_DQS_AD7P_35         Sch = GPIO_8_P
#set_property -dict  { PACKAGE_PIN "J3"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[16]}];                       # IO_L19N_T3_VREF_35            Sch = GPIO_9_N
#set_property -dict  { PACKAGE_PIN "J4"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[17]}];                       # IO_L19P_T3_35                 Sch = GPIO_9_P
#set_property -dict  { PACKAGE_PIN "B1"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[18]}];                       # IO_L12N_T1_MRCC_35            Sch = GPIO_10_N
#set_property -dict  { PACKAGE_PIN "C1"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[19]}];                       # IO_L12P_T1_MRCC_35            Sch = GPIO_10_P
#set_property -dict  { PACKAGE_PIN "D1"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[20]}];                       # IO_L14N_T2_SRCC_35            Sch = GPIO_11_N
#set_property -dict  { PACKAGE_PIN "E1"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[21]}];                       # IO_L14P_T2_SRCC_35            Sch = GPIO_11_P
#set_property -dict  { PACKAGE_PIN "C7"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[22]}];                       # IO_L3N_T0_DQS_AD5N_35         Sch = GPIO_12_N
#set_property -dict  { PACKAGE_PIN "D7"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[23]}];                       # IO_L3P_T0_DQS_AD5P_35         Sch = GPIO_12_P
#set_property -dict  { PACKAGE_PIN "A6"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[24]}];                       # IO_L4N_T0_35                  Sch = GPIO_13_N
#set_property -dict  { PACKAGE_PIN "B7"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[25]}];                       # IO_L4P_T0_35                  Sch = GPIO_13_P
#set_property -dict  { PACKAGE_PIN "D6"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[26]}];                       # IO_L5N_T0_AD13N_35            Sch = GPIO_14_N
#set_property -dict  { PACKAGE_PIN "E6"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[27]}];                       # IO_L5P_T0_AD13P_35            Sch = GPIO_14_P
#set_property -dict  { PACKAGE_PIN "D5"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[28]}];                       # IO_L6N_T0_VREF_35             Sch = GPIO_15_N
#set_property -dict  { PACKAGE_PIN "E5"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[29]}];                       # IO_L6P_T0_35                  Sch = GPIO_15_P
#set_property -dict  { PACKAGE_PIN "B4"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[30]}];                       # IO_L7N_T1_AD6N_35             Sch = GPIO_16_N
#set_property -dict  { PACKAGE_PIN "C4"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[31]}];                       # IO_L7P_T1_AD6P_35             Sch = GPIO_16_P
#set_property -dict  { PACKAGE_PIN "B3"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[32]}];                       # IO_L8N_T1_AD14N_35            Sch = GPIO_17_N
#set_property -dict  { PACKAGE_PIN "C3"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[33]}];                       # IO_L8P_T1_AD14P_35            Sch = GPIO_17_P
#set_property -dict  { PACKAGE_PIN "E4"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[34]}];                       # IO_L13N_T2_MRCC_35            Sch = GPIO_18_N
#set_property -dict  { PACKAGE_PIN "F4"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[35]}];                       # IO_L13P_T2_MRCC_35            Sch = GPIO_18_P
#set_property -dict  { PACKAGE_PIN "A2"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[36]}];                       # IO_L10N_T1_AD15N_35           Sch = GPIO_19_N
#set_property -dict  { PACKAGE_PIN "A3"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[37]}];                       # IO_L10P_T1_AD15P_35           Sch = GPIO_19_P
#set_property -dict  { PACKAGE_PIN "A13"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[38]}];                       # IO_L1N_T0_AD0N_15             Sch = GPIO_20_N
#set_property -dict  { PACKAGE_PIN "B13"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[39]}];                       # IO_L1P_T0_AD0P_15             Sch = GPIO_20_P
#set_property -dict  { PACKAGE_PIN "C14"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[40]}];                       # IO_L6N_T0_VREF_15             Sch = GPIO_21_N
#set_property -dict  { PACKAGE_PIN "C13"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[41]}];                       # IO_L6P_T0_15                  Sch = GPIO_21_P
#set_property -dict  { PACKAGE_PIN "D2"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[42]}];                       # IO_L16N_T2_35                 Sch = GPIO_22_N
#set_property -dict  { PACKAGE_PIN "E2"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[43]}];                       # IO_L16P_T2_35                 Sch = GPIO_22_P
#set_property -dict  { PACKAGE_PIN "D12"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[44]}];                       # IO_L5N_T0_AD9N_15             Sch = GPIO_23_N
#set_property -dict  { PACKAGE_PIN "E12"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[45]}];                       # IO_L5P_T0_AD9P_15             Sch = GPIO_23_P
#set_property -dict  { PACKAGE_PIN "E3"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[46]}];                       # IO_L15N_T2_DQS_35             Sch = GPIO_24_N
#set_property -dict  { PACKAGE_PIN "F3"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[47]}];                       # IO_L15P_T2_DQS_35             Sch = GPIO_24_P
#set_property -dict  { PACKAGE_PIN "A11"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[48]}];                       # IO_L14N_T2_SRCC_16            Sch = GPIO_25_N
#set_property -dict  { PACKAGE_PIN "B11"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[49]}];                       # IO_L14P_T2_SRCC_16            Sch = GPIO_25_P
#set_property -dict  { PACKAGE_PIN "F5"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[50]}];                       # IO_L17N_T2_35                 Sch = GPIO_26_N
#set_property -dict  { PACKAGE_PIN "G5"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[51]}];                       # IO_L17P_T2_35                 Sch = GPIO_26_P
#set_property -dict  { PACKAGE_PIN "F1"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[52]}];                       # IO_L18N_T2_35                 Sch = GPIO_27_N
#set_property -dict  { PACKAGE_PIN "F2"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[53]}];                       # IO_L18P_T2_35                 Sch = GPIO_27_P
#set_property -dict  { PACKAGE_PIN "A9"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[54]}];                       # IO_L12N_T1_MRCC_16            Sch = GPIO_28_N
#set_property -dict  { PACKAGE_PIN "A10"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[55]}];                       # IO_L12P_T1_MRCC_16            Sch = GPIO_28_P
#set_property -dict  { PACKAGE_PIN "H2"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[56]}];                       # IO_L20N_T3_35                 Sch = GPIO_29_N
#set_property -dict  { PACKAGE_PIN "H3"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[57]}];                       # IO_L20P_T3_35                 Sch = GPIO_29_P
#set_property -dict  { PACKAGE_PIN "G1"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[58]}];                       # IO_L21N_T3_DQS_35             Sch = GPIO_30_N
#set_property -dict  { PACKAGE_PIN "G2"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[59]}];                       # IO_L21P_T3_DQS_35             Sch = GPIO_30_P
#set_property -dict  { PACKAGE_PIN "H4"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[60]}];                       # IO_L22N_T3_35                 Sch = GPIO_31_N
#set_property -dict  { PACKAGE_PIN "H5"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[61]}];                       # IO_L22P_T3_35                 Sch = GPIO_31_P
#set_property -dict  { PACKAGE_PIN "J1"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[62]}];                       # IO_L23N_T3_35                 Sch = GPIO_32_N
#set_property -dict  { PACKAGE_PIN "J2"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[63]}];                       # IO_L23P_T3_35                 Sch = GPIO_32_P
#set_property -dict  { PACKAGE_PIN "G6"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[64]}];                       # IO_L24N_T3_35                 Sch = GPIO_33_N
#set_property -dict  { PACKAGE_PIN "H6"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P4[65]}];                       # IO_L24P_T3_35                 Sch = GPIO_33_P

###################################################################################################################
#                                               Header P5                                                         #
###################################################################################################################
set_property -dict  { PACKAGE_PIN "F14"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[0]}];                        # IO_L13P_T2_MRCC_15            Sch = GPIO_34_P
set_property -dict  { PACKAGE_PIN "F15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[1]}];                        # IO_L13N_T2_MRCC_15            Sch = GPIO_34_N
set_property -dict  { PACKAGE_PIN "G16"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[2]}];                        # IO_L14P_T2_SRCC_15            Sch = GPIO_35_P
set_property -dict  { PACKAGE_PIN "G17"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[3]}];                        # IO_L14N_T2_SRCC_15            Sch = GPIO_35_N
set_property -dict  { PACKAGE_PIN "E14"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[4]}];                        # IO_L15P_T2_DQS_15             Sch = GPIO_36_P
set_property -dict  { PACKAGE_PIN "E15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[5]}];                        # IO_L15N_T2_DQS_15             Sch = GPIO_36_N
set_property -dict  { PACKAGE_PIN "D18"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[6]}];                        # IO_L11P_T1_SRCC_15            Sch = GPIO_37_P
set_property -dict  { PACKAGE_PIN "C18"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[7]}];                        # IO_L11N_T1_SRCC_15            Sch = GPIO_37_N
set_property -dict  { PACKAGE_PIN "F13"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[8]}];                        # IO_L17P_T2_15                 Sch = GPIO_38_P
set_property -dict  { PACKAGE_PIN "E13"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[9]}];                        # IO_L17N_T2_15                 Sch = GPIO_38_N
set_property -dict  { PACKAGE_PIN "H15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[10]}];                       # IO_L18P_T2_15                 Sch = GPIO_39_P
set_property -dict  { PACKAGE_PIN "G15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[11]}];                       # IO_L18N_T2_15                 Sch = GPIO_39_N
set_property -dict  { PACKAGE_PIN "K16"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[12]}];                       # IO_L19P_T3_15                 Sch = GPIO_40_P
set_property -dict  { PACKAGE_PIN "J16"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[13]}];                       # IO_L19N_T3_VREF_15            Sch = GPIO_40_N
set_property -dict  { PACKAGE_PIN "J13"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[14]}];                       # IO_L24P_T3_RS1_15             Sch = GPIO_41_P
set_property -dict  { PACKAGE_PIN "J14"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[15]}];                       # IO_L24N_T3_RS0_15             Sch = GPIO_41_N
#set_property -dict  { PACKAGE_PIN "R16"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[16]}];                       # IO_L14P_T2_SRCC_14            Sch = GPIO_42_P
#set_property -dict  { PACKAGE_PIN "R17"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[17]}];                       # IO_L14N_T2_SRCC_14            Sch = GPIO_42_N
#set_property -dict  { PACKAGE_PIN "N15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[18]}];                       # IO_L12P_T1_MRCC_14            Sch = GPIO_43_P
#set_property -dict  { PACKAGE_PIN "P16"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[19]}];                       # IO_L12N_T1_MRCC_14            Sch = GPIO_43_N
#set_property -dict  { PACKAGE_PIN "H18"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[20]}];                       # IO_L21P_T3_DQS_15             Sch = GPIO_44_P
#set_property -dict  { PACKAGE_PIN "G18"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[21]}];                       # IO_L21N_T3_DQS_15             Sch = GPIO_44_N
#set_property -dict  { PACKAGE_PIN "H13"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[22]}];                       # IO_L20P_T3_15                 Sch = GPIO_45_P
#set_property -dict  { PACKAGE_PIN "H14"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[23]}];                       # IO_L20N_T3_15                 Sch = GPIO_45_N
#set_property -dict  { PACKAGE_PIN "C17"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[24]}];                       # IO_L8P_T1_AD10P_15            Sch = GPIO_46_P
#set_property -dict  { PACKAGE_PIN "B18"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[25]}];                       # IO_L8N_T1_AD10N_15            Sch = GPIO_46_N
#set_property -dict  { PACKAGE_PIN "D16"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[26]}];                       # IO_L9P_T1_DQS_AD3P_15         Sch = GPIO_47_P
#set_property -dict  { PACKAGE_PIN "D17"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[27]}];                       # IO_L9N_T1_DQS_AD3N_15         Sch = GPIO_47_N
#set_property -dict  { PACKAGE_PIN "E16"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[28]}];                       # IO_L10P_T1_AD11P_15           Sch = GPIO_48_P
#set_property -dict  { PACKAGE_PIN "E17"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[29]}];                       # IO_L10N_T1_AD11N_15           Sch = GPIO_48_N
#set_property -dict  { PACKAGE_PIN "F18"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[30]}];                       # IO_L16P_T2_15                 Sch = GPIO_49_P
#set_property -dict  { PACKAGE_PIN "E18"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[31]}];                       # IO_L16N_T2_15                 Sch = GPIO_49_N
#set_property -dict  { PACKAGE_PIN "H16"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[32]}];                       # IO_L22P_T3_15                 Sch = GPIO_50_P
#set_property -dict  { PACKAGE_PIN "H17"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[33]}];                       # IO_L22N_T3_15                 Sch = GPIO_50_N
#set_property -dict  { PACKAGE_PIN "K14"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[34]}];                       # IO_L23P_T3_15                 Sch = GPIO_51_P
#set_property -dict  { PACKAGE_PIN "J15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[35]}];                       # IO_L23N_T3_15                 Sch = GPIO_51_N
#set_property -dict  { PACKAGE_PIN "R15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[36]}];                       # IO_L17P_T2_D30_14             Sch = GPIO_52_P
#set_property -dict  { PACKAGE_PIN "T15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[37]}];                       # IO_L17N_T2_D29_14             Sch = GPIO_52_N
#set_property -dict  { PACKAGE_PIN "C10"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[38]}];                       # IO_L11P_T1_SRCC_16            Sch = GPIO_53_P
#set_property -dict  { PACKAGE_PIN "C9"    IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[39]}];                       # IO_L11N_T1_SRCC_16            Sch = GPIO_53_N
#set_property -dict  { PACKAGE_PIN "C12"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[40]}];                       # IO_L13P_T2_MRCC_16            Sch = GPIO_54_P
#set_property -dict  { PACKAGE_PIN "C11"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[41]}];                       # IO_L13N_T2_MRCC_16            Sch = GPIO_54_N
#set_property -dict  { PACKAGE_PIN "V14"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[42]}];                       # IO_L20P_T3_D24_14             Sch = GPIO_55_P
#set_property -dict  { PACKAGE_PIN "V15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[43]}];                       # IO_L20N_T3_D23_14             Sch = GPIO_55_N
#set_property -dict  { PACKAGE_PIN "U12"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[44]}];                       # IO_L21P_T3_DQS_14             Sch = GPIO_56_P
#set_property -dict  { PACKAGE_PIN "V13"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[45]}];                       # IO_L21N_T3_DQS_D22_14         Sch = GPIO_56_N
#set_property -dict  { PACKAGE_PIN "T12"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[46]}];                       # IO_L22P_T3_D21_14             Sch = GPIO_57_P
#set_property -dict  { PACKAGE_PIN "T13"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[47]}];                       # IO_L22N_T3_D20_14             Sch = GPIO_57_N
#set_property -dict  { PACKAGE_PIN "R11"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[48]}];                       # IO_L23P_T3_D19_14             Sch = GPIO_58_P
#set_property -dict  { PACKAGE_PIN "T11"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[49]}];                       # IO_L23N_T3_D18_14             Sch = GPIO_58_N
#set_property -dict  { PACKAGE_PIN "U11"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[50]}];                       # IO_L24P_T3_D17_14             Sch = GPIO_59_P
#set_property -dict  { PACKAGE_PIN "V12"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[51]}];                       # IO_L24N_T3_D16_14             Sch = GPIO_59_N
#set_property -dict  { PACKAGE_PIN "P13"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[52]}];                       # IO_L19P_T3_D26_14             Sch = GPIO_60_P
#set_property -dict  { PACKAGE_PIN "R13"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[53]}];                       # IO_L19N_T3_D25_VREF_14        Sch = GPIO_60_N
#set_property -dict  { PACKAGE_PIN "U17"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[54]}];                       # IO_L15P_T2_DQS_RDWR_B_14      Sch = GPIO_61_P
#set_property -dict  { PACKAGE_PIN "U18"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[55]}];                       # IO_L15N_T2_DQS_DOUT_CSO_B_14  Sch = GPIO_61_N
#set_property -dict  { PACKAGE_PIN "P14"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[56]}];                       # IO_L11P_T1_SRCC_14            Sch = GPIO_62_P
#set_property -dict  { PACKAGE_PIN "P15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[57]}];                       # IO_L11N_T1_SRCC_14            Sch = GPIO_62_N
#set_property -dict  { PACKAGE_PIN "U15"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[58]}];                       # IO_L18P_T2_D28_14             Sch = GPIO_63_P
#set_property -dict  { PACKAGE_PIN "V16"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[59]}];                       # IO_L18N_T2_D27_14             Sch = GPIO_63_N
#set_property -dict  { PACKAGE_PIN "U16"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[60]}];                       # IO_L16P_T2_CSI_B_14           Sch = GPIO_64_P
#set_property -dict  { PACKAGE_PIN "V17"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[61]}];                       # IO_L16N_T2_D31_14             Sch = GPIO_64_N
#set_property -dict  { PACKAGE_PIN "M14"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[62]}];                       # IO_L5P_T0_D06_14              Sch = GPIO_65_P
#set_property -dict  { PACKAGE_PIN "N14"   IOSTANDARD LVCMOS33   SLEW FAST } [get_ports {P5[63]}];                       # IO_L5N_T0_D07_14              Sch = GPIO_65_N
set_property PACKAGE_PIN T14 [get_ports RESET]
set_property IOSTANDARD LVCMOS33 [get_ports RESET]

#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets CLK1]
