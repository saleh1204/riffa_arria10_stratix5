
module QSysDE5QGen3x4If128 (
	drvstat_derr_cor_ext_rcv,
	drvstat_derr_cor_ext_rpl,
	drvstat_derr_rpl,
	drvstat_dlup_exit,
	drvstat_ev128ns,
	drvstat_ev1us,
	drvstat_hotrst_exit,
	drvstat_int_status,
	drvstat_l2_exit,
	drvstat_lane_act,
	drvstat_ltssmstate,
	drvstat_dlup,
	drvstat_rx_par_err,
	drvstat_tx_par_err,
	drvstat_cfg_par_err,
	drvstat_ko_cpl_spc_header,
	drvstat_ko_cpl_spc_data,
	mgmtclk_clk,
	mgmtrst_reset,
	pciecfg_hpg_ctrler,
	pciecfg_tl_cfg_add,
	pciecfg_tl_cfg_ctl,
	pciecfg_tl_cfg_sts,
	pciecfg_cpl_err,
	pciecfg_cpl_pending,
	pciecoreclk_clk,
	pciehip_reset_status,
	pciehip_serdes_pll_locked,
	pciehip_pld_clk_inuse,
	pciehip_pld_core_ready,
	pciehip_testin_zero,
	pciemsi_app_int_sts,
	pciemsi_app_msi_num,
	pciemsi_app_msi_req,
	pciemsi_app_msi_tc,
	pciemsi_app_int_ack,
	pciemsi_app_msi_ack,
	pcienpor_npor,
	pcienpor_pin_perst,
	pciepld_clk,
	pcierefclk_clk,
	pcieserial_rx_in0,
	pcieserial_rx_in1,
	pcieserial_rx_in2,
	pcieserial_rx_in3,
	pcieserial_tx_out0,
	pcieserial_tx_out1,
	pcieserial_tx_out2,
	pcieserial_tx_out3,
	pciestat_derr_cor_ext_rcv,
	pciestat_derr_cor_ext_rpl,
	pciestat_derr_rpl,
	pciestat_dlup,
	pciestat_dlup_exit,
	pciestat_ev128ns,
	pciestat_ev1us,
	pciestat_hotrst_exit,
	pciestat_int_status,
	pciestat_l2_exit,
	pciestat_lane_act,
	pciestat_ltssmstate,
	pciestat_rx_par_err,
	pciestat_tx_par_err,
	pciestat_cfg_par_err,
	pciestat_ko_cpl_spc_header,
	pciestat_ko_cpl_spc_data,
	reconfigpldclk_clk,
	reconfigrefclk_clk,
	reconfigrst_reset,
	rx_st_startofpacket,
	rx_st_endofpacket,
	rx_st_error,
	rx_st_valid,
	rx_st_empty,
	rx_st_ready,
	rx_st_data,
	tx_st_startofpacket,
	tx_st_endofpacket,
	tx_st_error,
	tx_st_valid,
	tx_st_empty,
	tx_st_ready,
	tx_st_data);	

	input		drvstat_derr_cor_ext_rcv;
	input		drvstat_derr_cor_ext_rpl;
	input		drvstat_derr_rpl;
	input		drvstat_dlup_exit;
	input		drvstat_ev128ns;
	input		drvstat_ev1us;
	input		drvstat_hotrst_exit;
	input	[3:0]	drvstat_int_status;
	input		drvstat_l2_exit;
	input	[3:0]	drvstat_lane_act;
	input	[4:0]	drvstat_ltssmstate;
	input		drvstat_dlup;
	input		drvstat_rx_par_err;
	input	[1:0]	drvstat_tx_par_err;
	input		drvstat_cfg_par_err;
	input	[7:0]	drvstat_ko_cpl_spc_header;
	input	[11:0]	drvstat_ko_cpl_spc_data;
	input		mgmtclk_clk;
	input		mgmtrst_reset;
	input	[4:0]	pciecfg_hpg_ctrler;
	output	[3:0]	pciecfg_tl_cfg_add;
	output	[31:0]	pciecfg_tl_cfg_ctl;
	output	[52:0]	pciecfg_tl_cfg_sts;
	input	[6:0]	pciecfg_cpl_err;
	input		pciecfg_cpl_pending;
	output		pciecoreclk_clk;
	output		pciehip_reset_status;
	output		pciehip_serdes_pll_locked;
	output		pciehip_pld_clk_inuse;
	input		pciehip_pld_core_ready;
	output		pciehip_testin_zero;
	input		pciemsi_app_int_sts;
	input	[4:0]	pciemsi_app_msi_num;
	input		pciemsi_app_msi_req;
	input	[2:0]	pciemsi_app_msi_tc;
	output		pciemsi_app_int_ack;
	output		pciemsi_app_msi_ack;
	input		pcienpor_npor;
	input		pcienpor_pin_perst;
	input		pciepld_clk;
	input		pcierefclk_clk;
	input		pcieserial_rx_in0;
	input		pcieserial_rx_in1;
	input		pcieserial_rx_in2;
	input		pcieserial_rx_in3;
	output		pcieserial_tx_out0;
	output		pcieserial_tx_out1;
	output		pcieserial_tx_out2;
	output		pcieserial_tx_out3;
	output		pciestat_derr_cor_ext_rcv;
	output		pciestat_derr_cor_ext_rpl;
	output		pciestat_derr_rpl;
	output		pciestat_dlup;
	output		pciestat_dlup_exit;
	output		pciestat_ev128ns;
	output		pciestat_ev1us;
	output		pciestat_hotrst_exit;
	output	[3:0]	pciestat_int_status;
	output		pciestat_l2_exit;
	output	[3:0]	pciestat_lane_act;
	output	[4:0]	pciestat_ltssmstate;
	output		pciestat_rx_par_err;
	output	[1:0]	pciestat_tx_par_err;
	output		pciestat_cfg_par_err;
	output	[7:0]	pciestat_ko_cpl_spc_header;
	output	[11:0]	pciestat_ko_cpl_spc_data;
	input		reconfigpldclk_clk;
	input		reconfigrefclk_clk;
	input		reconfigrst_reset;
	output	[0:0]	rx_st_startofpacket;
	output	[0:0]	rx_st_endofpacket;
	output	[0:0]	rx_st_error;
	output	[0:0]	rx_st_valid;
	output	[1:0]	rx_st_empty;
	input		rx_st_ready;
	output	[127:0]	rx_st_data;
	input	[0:0]	tx_st_startofpacket;
	input	[0:0]	tx_st_endofpacket;
	input	[0:0]	tx_st_error;
	input	[0:0]	tx_st_valid;
	input	[1:0]	tx_st_empty;
	output		tx_st_ready;
	input	[127:0]	tx_st_data;
endmodule
