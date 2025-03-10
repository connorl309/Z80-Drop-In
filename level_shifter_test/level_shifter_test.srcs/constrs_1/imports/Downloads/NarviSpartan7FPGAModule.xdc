set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

####################################################################################################################
#                                               CLOCK 100MHz                                                       #
####################################################################################################################

####################################################################################################################
#                                               FT2232H Signals                                                    #
####################################################################################################################


####################################################################################################################
#                                        DDR3       : MT41J128M16XX-125                                            #
#                                        Frequency  : 400 MHz                                                      #
#                                        Data Width : 16                                                           #
####################################################################################################################

####################################################################################################################
#                                              QSPI - FLASH                                                        #
####################################################################################################################

####################################################################################################################
#                                              LED                                                                 #
####################################################################################################################

###################################################################################################################
#                                               Header P4                                                         #
###################################################################################################################
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[8]}]
set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[7]}]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[0]}]
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[6]}]
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[5]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[1]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[2]}]
set_property -dict {PACKAGE_PIN D6 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[4]}]
set_property -dict {PACKAGE_PIN E6 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[3]}]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports BUSRQ]
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports RESET2]
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports RFSH]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports M1]
set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[10]}]
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[9]}]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports WAIT2]
set_property -dict {PACKAGE_PIN H3 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports BUSAK]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports WR]
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports RD]

###################################################################################################################
#                                               Header P5                                                         #
###################################################################################################################
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports NMI]
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports HALT]
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {D[5]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[15]}]
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports CLK]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[11]}]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[12]}]
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[13]}]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {A[14]}]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {D[3]}]
set_property -dict {PACKAGE_PIN C10 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {D[7]}]
set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {D[0]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports MREQ]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports IORQ]
set_property -dict {PACKAGE_PIN T12 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {D[1]}]
set_property -dict {PACKAGE_PIN T13 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports INT2]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {D[2]}]


set_property IOSTANDARD LVCMOS33 [get_ports {D[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[4]}]

set_property PACKAGE_PIN J16 [get_ports {D[15]}]
set_property PACKAGE_PIN H13 [get_ports {D[14]}]
set_property PACKAGE_PIN H14 [get_ports {D[13]}]
set_property PACKAGE_PIN H16 [get_ports {D[12]}]
set_property PACKAGE_PIN H17 [get_ports {D[11]}]
set_property PACKAGE_PIN K14 [get_ports {D[10]}]
set_property PACKAGE_PIN J15 [get_ports {D[9]}]
set_property PACKAGE_PIN J13 [get_ports {D[8]}]
set_property PACKAGE_PIN G15 [get_ports {D[6]}]
set_property PACKAGE_PIN E16 [get_ports {D[4]}]
set_property SLEW FAST [get_ports {A[11]}]
set_property SLEW FAST [get_ports {D[15]}]
set_property SLEW FAST [get_ports {D[14]}]
set_property SLEW FAST [get_ports {D[13]}]
set_property SLEW FAST [get_ports {D[12]}]
set_property SLEW FAST [get_ports {D[11]}]
set_property SLEW FAST [get_ports {D[10]}]
set_property SLEW FAST [get_ports {D[9]}]
set_property SLEW FAST [get_ports {D[8]}]
set_property SLEW FAST [get_ports {D[6]}]
set_property SLEW FAST [get_ports {D[4]}]
