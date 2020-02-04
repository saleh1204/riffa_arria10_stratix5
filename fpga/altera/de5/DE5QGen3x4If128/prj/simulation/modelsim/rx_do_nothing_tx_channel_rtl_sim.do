transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work
variable HDL_DIR "../../../hdl"

vlog -reportprogress 300 -work gate_work $HDL_DIR/fifo.v
vlog -reportprogress 300 -work gate_work $HDL_DIR/rx_do_nothing_tx_channel.v
vlog -reportprogress 300 -work gate_work rx_do_nothing_tx_channel_test.vt

vsim -t 1ps -L work -L twentynm_ver -L altera_ver -L altera_lnsim_ver -L lpm_ver -L altera_mf_ver work.rx_do_nothing_tx_channel_test

###add wave *
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -label CLK clk 
add wave -noupdate -format Logic -label RST reset 
add wave -noupdate -format Logic -label CHNL_RX chnl_rx 
add wave -noupdate -format Logic -label CHNL_RX_VALID chnl_rx_data_valid 
add wave -noupdate -format Literal -radix hex -label CHNL_RX_DATA chnl_rx_data 
add wave -noupdate -format Literal -radix unsigned -label CHNL_RX_LEN chnl_rx_len
add wave -noupdate -format Logic -label CHNL_TX chnl_tx 
add wave -noupdate -format Logic -label CHNL_TX_ACK chnl_tx_ack
add wave -noupdate -format Logic -label CHNL_TX_DATA_VALID chnl_tx_data_valid
add wave -noupdate -format Logic -label CHNL_TX_DATA_REN chnl_tx_data_ren
add wave -noupdate -format Literal -radix hex -label CHNL_TX_DATA chnl_tx_data
add wave -noupdate -format Literal -radix unsigned -label CHNL_TX_LEN chnl_tx_len
#add wave -noupdate -format Logic -label push_r c1/push_r
#add wave -noupdate -format Logic -label pop_r c1/pop_r
#add wave -noupdate -format Logic -label push_s c1/push_s
#add wave -noupdate -format Logic -label pop_s c1/pop_s
#add wave -noupdate -format Literal -radix hex -label rDout c1/rDout
#add wave -noupdate -format Literal -radix hex -label sDin c1/sDin
view structure
view signals 
run -all
