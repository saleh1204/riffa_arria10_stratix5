


INPUT PCIE_REFCLK;
INPUT PCIE_RESET_N;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_common_pld_pcs_interface_rbc:inst_sv_hssi_common_pld_pcs_interface|pldnfrzdrv;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|pldlccmurstbout;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|pldtxiqclkout;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|pldtxpmasyncpfbkpout;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_common_pld_pcs_interface_rbc:inst_sv_hssi_common_pld_pcs_interface|pldnfrzdrv;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|pldlccmurstbout;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|pldtxiqclkout;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|pldtxpmasyncpfbkpout;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_common_pld_pcs_interface_rbc:inst_sv_hssi_common_pld_pcs_interface|pldnfrzdrv;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|pldlccmurstbout;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|pldtxiqclkout;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|pldtxpmasyncpfbkpout;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_common_pld_pcs_interface_rbc:inst_sv_hssi_common_pld_pcs_interface|pldnfrzdrv;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|pldlccmurstbout;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|pldtxiqclkout;
INPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|pldtxpmasyncpfbkpout;
INPUT OSC_BANK3D_50MHZ;
INPUT PCIE_RX_IN[3];
INPUT PCIE_RX_IN[2];
INPUT PCIE_RX_IN[1];
INPUT PCIE_RX_IN[0];
INPUT PCIE_REFCLK(n);
INPUT PCIE_RX_IN[3](n);
INPUT PCIE_RX_IN[2](n);
INPUT PCIE_RX_IN[1](n);
INPUT PCIE_RX_IN[0](n);
OUTPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain;
OUTPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain;
OUTPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain;
OUTPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain;
OUTPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain;
OUTPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain;
OUTPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain;
OUTPUT QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain;
OUTPUT PCIE_TX_OUT[0];
OUTPUT PCIE_TX_OUT[0](n);
OUTPUT PCIE_TX_OUT[1];
OUTPUT PCIE_TX_OUT[1](n);
OUTPUT PCIE_TX_OUT[2];
OUTPUT PCIE_TX_OUT[2](n);
OUTPUT PCIE_TX_OUT[3];
OUTPUT PCIE_TX_OUT[3](n);
OUTPUT LED[0];
OUTPUT LED[1];
OUTPUT LED[2];
OUTPUT LED[3];
OUTPUT LED[4];
OUTPUT LED[5];
OUTPUT LED[6];
OUTPUT LED[7];

/*Arc definitions start here*/
pos_PCIE_REFCLK__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) PCIE_REFCLK QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain ;
pos_PCIE_REFCLK__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) PCIE_REFCLK QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain ;
pos_PCIE_REFCLK__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) PCIE_REFCLK QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain ;
pos_PCIE_REFCLK__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) PCIE_REFCLK QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain ;
pos_PCIE_REFCLK__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) PCIE_REFCLK QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain ;
pos_PCIE_REFCLK__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) PCIE_REFCLK QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain ;
pos_PCIE_REFCLK__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) PCIE_REFCLK QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain ;
pos_PCIE_REFCLK__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) PCIE_REFCLK QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain ;
pos_pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain ;
pos_pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain ;
pos_pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain ;
pos_pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[1].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain ;
pos_pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain ;
pos_pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[2].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain ;
pos_pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_rx_pld_pcs_interface_rbc:inst_sv_hssi_rx_pld_pcs_interface|asynchdatain ;
pos_pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv__QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain__delay:		DELAY (POSEDGE) pcie_system_inst|pciegen3x4if128|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|observablecoreclkdiv QSysDE5QGen3x4If128:pcie_system_inst|altpcie_sv_hip_ast_hwtcl:pciegen3x4if128|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|sv_xcvr_pipe_native:g_xcvr.sv_xcvr_pipe_native|sv_xcvr_native:inst_sv_xcvr_native|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[3].inst_sv_pcs_ch|sv_hssi_tx_pld_pcs_interface_rbc:inst_sv_hssi_tx_pld_pcs_interface|asynchdatain ;

ENDMODEL