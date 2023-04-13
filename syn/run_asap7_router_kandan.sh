mkdir -p /home/jychoi/NoCRouter/syn/log/asap7_LVT_TT_new/router/1000.0
 export BASE_DIR=/home/jychoi/NoCRouter/syn
 export REPORT_DIR=/home/jychoi/NoCRouter/syn/report/asap7_LVT_TT_new
 export SRC_FILES=" /home/jychoi/NoCRouter/syn/../src/rtl/noc/noc.sv /home/jychoi/NoCRouter/syn/../src/if/input_block2crossbar.sv /home/jychoi/NoCRouter/syn/../src/if/input_block2switch_allocator.sv /home/jychoi/NoCRouter/syn/../src/if/input_block2vc_allocator.sv /home/jychoi/NoCRouter/syn/../src/if/router2router.sv /home/jychoi/NoCRouter/syn/../src/if/switch_allocator2crossbar.sv /home/jychoi/NoCRouter/syn/../src/rtl/allocators/round_robin_arbiter.sv /home/jychoi/NoCRouter/syn/../src/rtl/allocators/separable_input_first_allocator.sv /home/jychoi/NoCRouter/syn/../src/rtl/allocators/switch_allocator.sv /home/jychoi/NoCRouter/syn/../src/rtl/allocators/vc_allocator.sv /home/jychoi/NoCRouter/syn/../src/rtl/crossbar/crossbar.sv /home/jychoi/NoCRouter/syn/../src/rtl/input_port/circular_buffer.sv /home/jychoi/NoCRouter/syn/../src/rtl/input_port/input_block.sv /home/jychoi/NoCRouter/syn/../src/rtl/input_port/input_buffer.sv /home/jychoi/NoCRouter/syn/../src/rtl/input_port/input_port.sv /home/jychoi/NoCRouter/syn/../src/rtl/input_port/rc_unit.sv /home/jychoi/NoCRouter/syn/../src/rtl/noc/node_link.sv /home/jychoi/NoCRouter/syn/../src/rtl/noc/router_link.sv /home/jychoi/NoCRouter/syn/../src/rtl/noc/mesh.sv /home/jychoi/NoCRouter/syn/../src/rtl/router/router.sv "
 export ASAP7_STD_CELL=/share/DB/ASAP7/asap7-ccsa/
 export SYN_FREQ=1000.0
 export ASAP7_AO_LIB=asap7sc7p5t_AO_LVT_TT_ccsa.db
 export ASAP7_INVBUF_LIB=asap7sc7p5t_INVBUF_LVT_TT_ccsa.db
 export ASAP7_OA_LIB=asap7sc7p5t_OA_LVT_TT_ccsa.db
 export ASAP7_SEQ_LIB=asap7sc7p5t_SEQ_LVT_TT_ccsa.db
 export ASAP7_SIMPLE_LIB=asap7sc7p5t_SIMPLE_LVT_TT_ccsa.db
 export INV_FO4=INVx4_ASAP7_75t_L
 export SAIF_FILE=/home/jychoi/NoCRouter/syn/../sim/vcd_saif/tb_router_worst.saif
 export TOP_MODULE=router
 dc_shell-xg-t -f /home/jychoi/NoCRouter/syn/tcl_files/syn_asap7_router.tcl -no_gui 2>&1 | tee /home/jychoi/NoCRouter/syn/log/asap7_LVT_TT_new/router/1000.0/dc_shell.log
