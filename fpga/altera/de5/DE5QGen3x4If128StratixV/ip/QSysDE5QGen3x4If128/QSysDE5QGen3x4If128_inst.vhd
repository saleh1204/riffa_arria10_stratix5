	component QSysDE5QGen3x4If128 is
		port (
			drvstat_derr_cor_ext_rcv   : in  std_logic                      := 'X';             -- derr_cor_ext_rcv
			drvstat_derr_cor_ext_rpl   : in  std_logic                      := 'X';             -- derr_cor_ext_rpl
			drvstat_derr_rpl           : in  std_logic                      := 'X';             -- derr_rpl
			drvstat_dlup_exit          : in  std_logic                      := 'X';             -- dlup_exit
			drvstat_ev128ns            : in  std_logic                      := 'X';             -- ev128ns
			drvstat_ev1us              : in  std_logic                      := 'X';             -- ev1us
			drvstat_hotrst_exit        : in  std_logic                      := 'X';             -- hotrst_exit
			drvstat_int_status         : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- int_status
			drvstat_l2_exit            : in  std_logic                      := 'X';             -- l2_exit
			drvstat_lane_act           : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- lane_act
			drvstat_ltssmstate         : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- ltssmstate
			drvstat_dlup               : in  std_logic                      := 'X';             -- dlup
			drvstat_rx_par_err         : in  std_logic                      := 'X';             -- rx_par_err
			drvstat_tx_par_err         : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- tx_par_err
			drvstat_cfg_par_err        : in  std_logic                      := 'X';             -- cfg_par_err
			drvstat_ko_cpl_spc_header  : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- ko_cpl_spc_header
			drvstat_ko_cpl_spc_data    : in  std_logic_vector(11 downto 0)  := (others => 'X'); -- ko_cpl_spc_data
			mgmtclk_clk                : in  std_logic                      := 'X';             -- clk
			mgmtrst_reset              : in  std_logic                      := 'X';             -- reset
			pciecfg_hpg_ctrler         : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- hpg_ctrler
			pciecfg_tl_cfg_add         : out std_logic_vector(3 downto 0);                      -- tl_cfg_add
			pciecfg_tl_cfg_ctl         : out std_logic_vector(31 downto 0);                     -- tl_cfg_ctl
			pciecfg_tl_cfg_sts         : out std_logic_vector(52 downto 0);                     -- tl_cfg_sts
			pciecfg_cpl_err            : in  std_logic_vector(6 downto 0)   := (others => 'X'); -- cpl_err
			pciecfg_cpl_pending        : in  std_logic                      := 'X';             -- cpl_pending
			pciecoreclk_clk            : out std_logic;                                         -- clk
			pciehip_reset_status       : out std_logic;                                         -- reset_status
			pciehip_serdes_pll_locked  : out std_logic;                                         -- serdes_pll_locked
			pciehip_pld_clk_inuse      : out std_logic;                                         -- pld_clk_inuse
			pciehip_pld_core_ready     : in  std_logic                      := 'X';             -- pld_core_ready
			pciehip_testin_zero        : out std_logic;                                         -- testin_zero
			pciemsi_app_int_sts        : in  std_logic                      := 'X';             -- app_int_sts
			pciemsi_app_msi_num        : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- app_msi_num
			pciemsi_app_msi_req        : in  std_logic                      := 'X';             -- app_msi_req
			pciemsi_app_msi_tc         : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- app_msi_tc
			pciemsi_app_int_ack        : out std_logic;                                         -- app_int_ack
			pciemsi_app_msi_ack        : out std_logic;                                         -- app_msi_ack
			pcienpor_npor              : in  std_logic                      := 'X';             -- npor
			pcienpor_pin_perst         : in  std_logic                      := 'X';             -- pin_perst
			pciepld_clk                : in  std_logic                      := 'X';             -- clk
			pcierefclk_clk             : in  std_logic                      := 'X';             -- clk
			pcieserial_rx_in0          : in  std_logic                      := 'X';             -- rx_in0
			pcieserial_rx_in1          : in  std_logic                      := 'X';             -- rx_in1
			pcieserial_rx_in2          : in  std_logic                      := 'X';             -- rx_in2
			pcieserial_rx_in3          : in  std_logic                      := 'X';             -- rx_in3
			pcieserial_tx_out0         : out std_logic;                                         -- tx_out0
			pcieserial_tx_out1         : out std_logic;                                         -- tx_out1
			pcieserial_tx_out2         : out std_logic;                                         -- tx_out2
			pcieserial_tx_out3         : out std_logic;                                         -- tx_out3
			pciestat_derr_cor_ext_rcv  : out std_logic;                                         -- derr_cor_ext_rcv
			pciestat_derr_cor_ext_rpl  : out std_logic;                                         -- derr_cor_ext_rpl
			pciestat_derr_rpl          : out std_logic;                                         -- derr_rpl
			pciestat_dlup              : out std_logic;                                         -- dlup
			pciestat_dlup_exit         : out std_logic;                                         -- dlup_exit
			pciestat_ev128ns           : out std_logic;                                         -- ev128ns
			pciestat_ev1us             : out std_logic;                                         -- ev1us
			pciestat_hotrst_exit       : out std_logic;                                         -- hotrst_exit
			pciestat_int_status        : out std_logic_vector(3 downto 0);                      -- int_status
			pciestat_l2_exit           : out std_logic;                                         -- l2_exit
			pciestat_lane_act          : out std_logic_vector(3 downto 0);                      -- lane_act
			pciestat_ltssmstate        : out std_logic_vector(4 downto 0);                      -- ltssmstate
			pciestat_rx_par_err        : out std_logic;                                         -- rx_par_err
			pciestat_tx_par_err        : out std_logic_vector(1 downto 0);                      -- tx_par_err
			pciestat_cfg_par_err       : out std_logic;                                         -- cfg_par_err
			pciestat_ko_cpl_spc_header : out std_logic_vector(7 downto 0);                      -- ko_cpl_spc_header
			pciestat_ko_cpl_spc_data   : out std_logic_vector(11 downto 0);                     -- ko_cpl_spc_data
			reconfigpldclk_clk         : in  std_logic                      := 'X';             -- clk
			reconfigrefclk_clk         : in  std_logic                      := 'X';             -- clk
			reconfigrst_reset          : in  std_logic                      := 'X';             -- reset
			rx_st_startofpacket        : out std_logic_vector(0 downto 0);                      -- startofpacket
			rx_st_endofpacket          : out std_logic_vector(0 downto 0);                      -- endofpacket
			rx_st_error                : out std_logic_vector(0 downto 0);                      -- error
			rx_st_valid                : out std_logic_vector(0 downto 0);                      -- valid
			rx_st_empty                : out std_logic_vector(1 downto 0);                      -- empty
			rx_st_ready                : in  std_logic                      := 'X';             -- ready
			rx_st_data                 : out std_logic_vector(127 downto 0);                    -- data
			tx_st_startofpacket        : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- startofpacket
			tx_st_endofpacket          : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- endofpacket
			tx_st_error                : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- error
			tx_st_valid                : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- valid
			tx_st_empty                : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- empty
			tx_st_ready                : out std_logic;                                         -- ready
			tx_st_data                 : in  std_logic_vector(127 downto 0) := (others => 'X')  -- data
		);
	end component QSysDE5QGen3x4If128;

	u0 : component QSysDE5QGen3x4If128
		port map (
			drvstat_derr_cor_ext_rcv   => CONNECTED_TO_drvstat_derr_cor_ext_rcv,   --        drvstat.derr_cor_ext_rcv
			drvstat_derr_cor_ext_rpl   => CONNECTED_TO_drvstat_derr_cor_ext_rpl,   --               .derr_cor_ext_rpl
			drvstat_derr_rpl           => CONNECTED_TO_drvstat_derr_rpl,           --               .derr_rpl
			drvstat_dlup_exit          => CONNECTED_TO_drvstat_dlup_exit,          --               .dlup_exit
			drvstat_ev128ns            => CONNECTED_TO_drvstat_ev128ns,            --               .ev128ns
			drvstat_ev1us              => CONNECTED_TO_drvstat_ev1us,              --               .ev1us
			drvstat_hotrst_exit        => CONNECTED_TO_drvstat_hotrst_exit,        --               .hotrst_exit
			drvstat_int_status         => CONNECTED_TO_drvstat_int_status,         --               .int_status
			drvstat_l2_exit            => CONNECTED_TO_drvstat_l2_exit,            --               .l2_exit
			drvstat_lane_act           => CONNECTED_TO_drvstat_lane_act,           --               .lane_act
			drvstat_ltssmstate         => CONNECTED_TO_drvstat_ltssmstate,         --               .ltssmstate
			drvstat_dlup               => CONNECTED_TO_drvstat_dlup,               --               .dlup
			drvstat_rx_par_err         => CONNECTED_TO_drvstat_rx_par_err,         --               .rx_par_err
			drvstat_tx_par_err         => CONNECTED_TO_drvstat_tx_par_err,         --               .tx_par_err
			drvstat_cfg_par_err        => CONNECTED_TO_drvstat_cfg_par_err,        --               .cfg_par_err
			drvstat_ko_cpl_spc_header  => CONNECTED_TO_drvstat_ko_cpl_spc_header,  --               .ko_cpl_spc_header
			drvstat_ko_cpl_spc_data    => CONNECTED_TO_drvstat_ko_cpl_spc_data,    --               .ko_cpl_spc_data
			mgmtclk_clk                => CONNECTED_TO_mgmtclk_clk,                --        mgmtclk.clk
			mgmtrst_reset              => CONNECTED_TO_mgmtrst_reset,              --        mgmtrst.reset
			pciecfg_hpg_ctrler         => CONNECTED_TO_pciecfg_hpg_ctrler,         --        pciecfg.hpg_ctrler
			pciecfg_tl_cfg_add         => CONNECTED_TO_pciecfg_tl_cfg_add,         --               .tl_cfg_add
			pciecfg_tl_cfg_ctl         => CONNECTED_TO_pciecfg_tl_cfg_ctl,         --               .tl_cfg_ctl
			pciecfg_tl_cfg_sts         => CONNECTED_TO_pciecfg_tl_cfg_sts,         --               .tl_cfg_sts
			pciecfg_cpl_err            => CONNECTED_TO_pciecfg_cpl_err,            --               .cpl_err
			pciecfg_cpl_pending        => CONNECTED_TO_pciecfg_cpl_pending,        --               .cpl_pending
			pciecoreclk_clk            => CONNECTED_TO_pciecoreclk_clk,            --    pciecoreclk.clk
			pciehip_reset_status       => CONNECTED_TO_pciehip_reset_status,       --        pciehip.reset_status
			pciehip_serdes_pll_locked  => CONNECTED_TO_pciehip_serdes_pll_locked,  --               .serdes_pll_locked
			pciehip_pld_clk_inuse      => CONNECTED_TO_pciehip_pld_clk_inuse,      --               .pld_clk_inuse
			pciehip_pld_core_ready     => CONNECTED_TO_pciehip_pld_core_ready,     --               .pld_core_ready
			pciehip_testin_zero        => CONNECTED_TO_pciehip_testin_zero,        --               .testin_zero
			pciemsi_app_int_sts        => CONNECTED_TO_pciemsi_app_int_sts,        --        pciemsi.app_int_sts
			pciemsi_app_msi_num        => CONNECTED_TO_pciemsi_app_msi_num,        --               .app_msi_num
			pciemsi_app_msi_req        => CONNECTED_TO_pciemsi_app_msi_req,        --               .app_msi_req
			pciemsi_app_msi_tc         => CONNECTED_TO_pciemsi_app_msi_tc,         --               .app_msi_tc
			pciemsi_app_int_ack        => CONNECTED_TO_pciemsi_app_int_ack,        --               .app_int_ack
			pciemsi_app_msi_ack        => CONNECTED_TO_pciemsi_app_msi_ack,        --               .app_msi_ack
			pcienpor_npor              => CONNECTED_TO_pcienpor_npor,              --       pcienpor.npor
			pcienpor_pin_perst         => CONNECTED_TO_pcienpor_pin_perst,         --               .pin_perst
			pciepld_clk                => CONNECTED_TO_pciepld_clk,                --        pciepld.clk
			pcierefclk_clk             => CONNECTED_TO_pcierefclk_clk,             --     pcierefclk.clk
			pcieserial_rx_in0          => CONNECTED_TO_pcieserial_rx_in0,          --     pcieserial.rx_in0
			pcieserial_rx_in1          => CONNECTED_TO_pcieserial_rx_in1,          --               .rx_in1
			pcieserial_rx_in2          => CONNECTED_TO_pcieserial_rx_in2,          --               .rx_in2
			pcieserial_rx_in3          => CONNECTED_TO_pcieserial_rx_in3,          --               .rx_in3
			pcieserial_tx_out0         => CONNECTED_TO_pcieserial_tx_out0,         --               .tx_out0
			pcieserial_tx_out1         => CONNECTED_TO_pcieserial_tx_out1,         --               .tx_out1
			pcieserial_tx_out2         => CONNECTED_TO_pcieserial_tx_out2,         --               .tx_out2
			pcieserial_tx_out3         => CONNECTED_TO_pcieserial_tx_out3,         --               .tx_out3
			pciestat_derr_cor_ext_rcv  => CONNECTED_TO_pciestat_derr_cor_ext_rcv,  --       pciestat.derr_cor_ext_rcv
			pciestat_derr_cor_ext_rpl  => CONNECTED_TO_pciestat_derr_cor_ext_rpl,  --               .derr_cor_ext_rpl
			pciestat_derr_rpl          => CONNECTED_TO_pciestat_derr_rpl,          --               .derr_rpl
			pciestat_dlup              => CONNECTED_TO_pciestat_dlup,              --               .dlup
			pciestat_dlup_exit         => CONNECTED_TO_pciestat_dlup_exit,         --               .dlup_exit
			pciestat_ev128ns           => CONNECTED_TO_pciestat_ev128ns,           --               .ev128ns
			pciestat_ev1us             => CONNECTED_TO_pciestat_ev1us,             --               .ev1us
			pciestat_hotrst_exit       => CONNECTED_TO_pciestat_hotrst_exit,       --               .hotrst_exit
			pciestat_int_status        => CONNECTED_TO_pciestat_int_status,        --               .int_status
			pciestat_l2_exit           => CONNECTED_TO_pciestat_l2_exit,           --               .l2_exit
			pciestat_lane_act          => CONNECTED_TO_pciestat_lane_act,          --               .lane_act
			pciestat_ltssmstate        => CONNECTED_TO_pciestat_ltssmstate,        --               .ltssmstate
			pciestat_rx_par_err        => CONNECTED_TO_pciestat_rx_par_err,        --               .rx_par_err
			pciestat_tx_par_err        => CONNECTED_TO_pciestat_tx_par_err,        --               .tx_par_err
			pciestat_cfg_par_err       => CONNECTED_TO_pciestat_cfg_par_err,       --               .cfg_par_err
			pciestat_ko_cpl_spc_header => CONNECTED_TO_pciestat_ko_cpl_spc_header, --               .ko_cpl_spc_header
			pciestat_ko_cpl_spc_data   => CONNECTED_TO_pciestat_ko_cpl_spc_data,   --               .ko_cpl_spc_data
			reconfigpldclk_clk         => CONNECTED_TO_reconfigpldclk_clk,         -- reconfigpldclk.clk
			reconfigrefclk_clk         => CONNECTED_TO_reconfigrefclk_clk,         -- reconfigrefclk.clk
			reconfigrst_reset          => CONNECTED_TO_reconfigrst_reset,          --    reconfigrst.reset
			rx_st_startofpacket        => CONNECTED_TO_rx_st_startofpacket,        --          rx_st.startofpacket
			rx_st_endofpacket          => CONNECTED_TO_rx_st_endofpacket,          --               .endofpacket
			rx_st_error                => CONNECTED_TO_rx_st_error,                --               .error
			rx_st_valid                => CONNECTED_TO_rx_st_valid,                --               .valid
			rx_st_empty                => CONNECTED_TO_rx_st_empty,                --               .empty
			rx_st_ready                => CONNECTED_TO_rx_st_ready,                --               .ready
			rx_st_data                 => CONNECTED_TO_rx_st_data,                 --               .data
			tx_st_startofpacket        => CONNECTED_TO_tx_st_startofpacket,        --          tx_st.startofpacket
			tx_st_endofpacket          => CONNECTED_TO_tx_st_endofpacket,          --               .endofpacket
			tx_st_error                => CONNECTED_TO_tx_st_error,                --               .error
			tx_st_valid                => CONNECTED_TO_tx_st_valid,                --               .valid
			tx_st_empty                => CONNECTED_TO_tx_st_empty,                --               .empty
			tx_st_ready                => CONNECTED_TO_tx_st_ready,                --               .ready
			tx_st_data                 => CONNECTED_TO_tx_st_data                  --               .data
		);

