// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
// Date        : Sat Jan 25 12:34:48 2025
// Host        : UwU running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top bd_tb_uart_fifo_generator_0_0 -prefix
//               bd_tb_uart_fifo_generator_0_0_ USB_Serial_Test_fifo_generator_1_0_sim_netlist.v
// Design      : USB_Serial_Test_fifo_generator_1_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s50csga324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "USB_Serial_Test_fifo_generator_1_0,fifo_generator_v13_2_10,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_10,Vivado 2024.1" *) 
(* NotValidForBitStream *)
module bd_tb_uart_fifo_generator_0_0
   (clk,
    rst,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 core_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME core_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0" *) input clk;
  input rst;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) input [7:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [7:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;

  wire clk;
  wire [7:0]din;
  wire [7:0]dout;
  wire empty;
  wire full;
  wire rd_en;
  wire rst;
  wire wr_en;
  wire NLW_U0_almost_empty_UNCONNECTED;
  wire NLW_U0_almost_full_UNCONNECTED;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_empty_UNCONNECTED;
  wire NLW_U0_prog_full_UNCONNECTED;
  wire NLW_U0_rd_rst_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_valid_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire NLW_U0_wr_rst_busy_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [9:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [9:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [9:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "1" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "10" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "8" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "8" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "spartan7" *) 
  (* C_FULL_FLAGS_RST_VAL = "0" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "1" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "0" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "6" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "4" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "1" *) 
  (* C_PRELOAD_REGS = "0" *) 
  (* C_PRIM_FIFO_TYPE = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "1022" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "1021" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "10" *) 
  (* C_RD_DEPTH = "1024" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "10" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "0" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "10" *) 
  (* C_WR_DEPTH = "1024" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "10" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  bd_tb_uart_fifo_generator_0_0_fifo_generator_v13_2_10 U0
       (.almost_empty(NLW_U0_almost_empty_UNCONNECTED),
        .almost_full(NLW_U0_almost_full_UNCONNECTED),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(clk),
        .data_count(NLW_U0_data_count_UNCONNECTED[9:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(NLW_U0_prog_empty_UNCONNECTED),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(1'b0),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[9:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(NLW_U0_rd_rst_busy_UNCONNECTED),
        .rst(rst),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(1'b0),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(NLW_U0_valid_UNCONNECTED),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(1'b0),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[9:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(NLW_U0_wr_rst_busy_UNCONNECTED));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
VRufLWT3xuzTvQKo8VrgeA7TQuqzWEYy/B1VZF2gTA62OnYpyvfz/jYVlv8uQmDxe/ByRttr4gwP
tNck8lOlu04WorDYZXBY99Iv+CD1MRsK+y6klNIUbRWjkWmJ0jF7xfzo5v6+6GlaIHD1nYWB0BGS
XKOLLgkxdDTc9QzwJD4=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
uL+N2Y0N0Nss4UIbL4YgwYw1dJAEJxw9VgIJekBqgLF5Hu0OvgBycKBL3tx4bMFtXLoBUh2ZjpPa
Go57AlryR20NeXp3+hoQeboPP11E649UsEN94qUxaPWE5/ujAWzWT8PMJfk3CAspcIaP3XsDNcxF
vPCbKLRNyWvSzyiofwOXgxNNgLi38SzcrWZtPo/eMELIxeVE3bkV2B7I60W9KI1gXiOj3SjPTDnx
EMAbJCwmbwCkTXljtuzvIRTsGb9QIurgASMwg4IWmb9DS6EbeVgoWu9ePD+YKuN3LcW87KSgmC3y
Mirx3ScsFGRfcOAUOLlOQxU4qqE1ZAjtBAua1w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
ngggZ4AaOolK7F7zeqf8LCxDCGfbvArfgDzbRvoxE+aIi2H2/ZgHbrcaf1Km1cW+38j2kTOpZ5BU
JUI2G5HZNfsoiLXjFbOMvQQqByNzlhCZjrS3N725Cznvy/nQpUy+kW4iA6DQZKnpdC2s18Suxi5p
XtgDcUzCh62ABICOpz8=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
FzAmLTVxyHRqX0WAddlPopAH/5r3ExgkeVujmhMcJXHbjZ+OKAHOMXTsnwDh03EpZ2Dn+0UPeR9J
JML3A+MQGMuUUzy/4d/lj5rriSnTu0eRK0uK6Gl8vjL08vO3UKb6wGj/w9CP45OWOkbMNgZzJkAl
ulPX0OUqymWYOn3WVAtIlaQ0dmpONV8p6Ixe9p5wlEtvy+7JjUPwaVnKlLjKSAaYD07OqMK+IOEP
5oYs2BscpZ3YKlKVJkoU493L7szHHn2LhSUrMld33nLuWIO6WPdo2u2pTnWXl/J1BzNaK1VaLx4R
H7VhIvgYcSlzCrtbQuNHKFtDPGhXjeA41TS29g==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Oad6Ezs+KRRjlYrAkExu4Kft2T1qNa0HGt8W7O1ByK1ecBs0TGWt/sS3pnt6d6jWuqvsWhrmcGsU
TD7Z+IY65xRZ4IJfgngZD8v540FOGMuFUS31UWxcC7CI6qOo20Q0Irtoxrqm01u5p3tI87ApsE8S
lc2lQ5dh54cGYlRfmo5mYTw6WSHyyVYmoh9npUliD4eNVIKUqnBo1kmYzicnKe8ewFKTEWpjdMeZ
/4YxF/NRZzHTA3GIsnjcgOHia68T/NJJ+zQmoNwxerZWWoacU1EU0IHxET3y4fS/u0Af8OJhkGQf
jI0jGobNLRYYufemCxL6333z0oAno0RiPZlavA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LVIUY1x0cEHel3aUfppGw9v6zvpZmh/zrCgsFGWLi8t0vWUC/ikETYOpuFw/0f9L2t8c6tQj/BSQ
wjvzq42gFgtW+CFBjgHAVUBDHhzlv/GKUM/2Vq36bMg9H5f44nJH+7mDDGVPf2PyYZRkAosFPUpA
wRqTC/g2mQ0mMY/gZGQRrs+/VY69Ze9sjoEiEXuwkb/+/VjXgHCxiCzG4cKf0ZiQ+rePhqJqB7FK
IJ+6LHriZD474qtFLq3fOZ9mrqOgN7iBQlc66dO9E0RmZZZsWtQQzZ4q1c2pzvsjDdJyWe0mTlwa
QGVmYElSvL9in5WwDxoKM+2J7vco8OIexLgbJg==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Qf9CPkJTDS6nRjzJ66HoyvpTqtDB4QY3Hy9peOp3xA39ggAvytqhHhiPv35dCRWSCdAyO1u2m+O7
/knms947I+MYTpHHfukyZsBbLho0jRq3cSXe9e6VE+4Dt40wryd91cmi93qmeUxg+vf0F91ug50P
gJ4oGYP71ANEq1UaGqGHgVK0ZsY6jTyc0x25eh+fnXg6vElSbqcptvyGMOBVT/g+gDKIheN40WzZ
Tday7b7o8j+UecVazn9OG8lGmgEQH+ilZfelpEFOBKoEc7YS6kKJ1yiX5nxRMJalTuojq5mhxebk
EsmPJe45gdIAuAmBpw3iLddcx52Arew1xpNY9w==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
H+d/6javaSRU2swARkzTIL8p3itaD4ohPxaTAeOjHpt7R9NIiNpHJvUFWkpZ02WVRAGHIw8Kujz3
6qQbQgKv8nhuS0lDhOHSDBVglvTONFSPjBj6pNY2XB24O4tlMghNicwCBXjxGXS6xET2pHNCj46f
01l0BHXfAtSn5SMPu3KYxDnod+2/TDKoWzzX29rrvh4wvf+eKFGbEVa3/RP2yg+Mp05W5p0KZ1Z3
JvOIxc57qFLARbLg1ToAzgZ8iZXLB5tX2Ez+rVDzW4i9ZvMW40QGIP5F6KCmuWunjVyqcasQ+9V7
oxcmw4sBdn0TYckrmrDvGtKxr+at316tB9uFJzLHWIwjnROKDoFwhcBbXzoqNoU/oBWqorM8JnDS
d/8tvN+7zx+k1OgCrpu5jgCA2E9LIMqL+HO19rub4MD4RjgOufHPDbN2wv6I9bj3Tko+kBZSFxxR
1SnGvhgPAaZJxQLEM+WE8SnVMzJI0RKNctcFv/jmWTYmAdTGIiTDAcmW

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WXM4aFffz6byfeUnRWfxJR3Sbg31hpZIfhJu9O4aqVdZMRQzhrArOJ75qYkGOgZjI+35a4DA9Ohc
RMh3Tm8A5kh9XM67B45s3+7vF8pYIM5pFlzEQBSQ/OeeAi6GNLI2ACXQl1WutRpQKuwX9iboEsRb
Kc1SU6AOV6yaliF6tUt1LL4x+bC8mqlEHTk6SvN7aiA23tVDcik1QSH66CO3/+J5f88G53DHDqtY
T6w2k7pUziwTnLfirI+XpPgqYp9YYRQEv52Q7wTYJlYnVYrMyludNuTaIE27AkgPAneEkdJlrq9l
eVOgs6ZIO1DEusKG7VzkbM1sS0GnU5Zhuj1Eww==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
KJ2iLB3UgRnxezAEg3KJ/gREzXcLo8pOtacMRsDMsFCSD3vYAdGUKSARO8g71pIGFzJo6PBwogFR
MkJED/0TqwZaleoFaN2ULuSnzZGmf8vT0qKvutBGquDn8MH7T3k3wLxcNdZQLnkqisJCMj8u+71g
xMQRAkhtAQvA2cWb6TDQN6jmfByZuu/AH3X+YZ43XIDG/jymNkwyBWNNx0yzbZouJtOuzzYHhYoC
AAuKR+zfynO91P9hcrXFiExHtCmvb73DA4ICLGiOzEj+C1PMPBX9AHdhnWYy5BbQGsd727Y50yNo
xmTU1vBKL2ewwN4j/Ib2AK/Z7T+d/NunpRbCnA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eYDP9MWXRUmO05etuHvoqbEMRNQHmR5nos71kLkRxpycXrdpHxalQmyEdCdbeVoM8lN9qwxKuN0l
yQn00dSYRi3P02ygaVsHqVAsRtz2yRpIRjyGMYD7zKpnNQw476DBmK+/sCD7EH6NxSfzUNnfoURL
uIFC0sHEYpwX6Qt2bT2GdCC0OFvaGwQNimyTFdfeey7cdpg9JmsQRgLEUfRwG1Dk0iu258zTUnT+
31O5RA9OwlgZJpC+LpCvL8XAmGZJ4CCeUf2hnpppoV4KphAV4mCBUkNtUYZSJdF0a5cdHFxnxR5n
nI0ed4USMMiNvLqvP0HQgecfCvYzYx9kk0bmtA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 51680)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
