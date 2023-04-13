set base_dir [getenv "BASE_DIR"]
set report_dir [getenv "REPORT_DIR"]

# This tcl file uses SAIF file to do timing analysis, not using set_switching_activity
set saif_file [getenv "SAIF_FILE"]

#/* All verilog files, separated by spaces         */
set my_verilog_files [getenv "SRC_FILES"]

#/* Top-level Module                               */
set my_toplevel [getenv "TOP_MODULE"]

#/* Target frequency in MHz for optimization       */
set my_clk_freq_MHz [getenv "SYN_FREQ"]
# clock frequency in ns
set clk_period [expr ((1000000 / $my_clk_freq_MHz))]

#/* The name of the clock pin. If no clock-pin     */
#/* exists, pick anything                          */
set my_clock_pin clk
set my_reset_pin rstn

set clk_uncertainty [expr $clk_period*0.01]

#/* Delay of input signals (Clock-to-Q, Package etc.)  */
# 0.6 / 0.2
set input_delay_max [expr $clk_period*0.6]
set input_delay_min [expr $clk_period*0.2]

#/* Reserved time for output signals (Holdtime etc.)   */
# 0.2 / 0.05
set output_delay_max [expr $clk_period*0.2]
set output_delay_min [expr $clk_period*0.05]

#/* Libraries   */
set ASAP7_STD_CELL [getenv "ASAP7_STD_CELL"]
set search_path [concat  $search_path $ASAP7_STD_CELL]
set alib_library_analysis_path $ASAP7_STD_CELL

set ASAP7_AO_LIB [getenv "ASAP7_AO_LIB"]
set ASAP7_INVBUF_LIB [getenv "ASAP7_INVBUF_LIB"]
set ASAP7_OA_LIB [getenv "ASAP7_OA_LIB"]
set ASAP7_SEQ_LIB [getenv "ASAP7_SEQ_LIB"]
set ASAP7_SIMPLE_LIB [getenv "ASAP7_SIMPLE_LIB"]
set target_library [format "%s %s %s %s %s" [getenv "ASAP7_AO_LIB"] [getenv "ASAP7_INVBUF_LIB"] [getenv "ASAP7_OA_LIB"] [getenv "ASAP7_SEQ_LIB"] [getenv "ASAP7_SIMPLE_LIB"]]
set link_library [concat [list $ASAP7_AO_LIB $ASAP7_INVBUF_LIB $ASAP7_OA_LIB $ASAP7_SEQ_LIB $ASAP7_SIMPLE_LIB] [list dw_foundation.sldb]]

#/* Set Parameters   */

define_design_lib WORK -path ./WORK_ASAP7
remove_design -all
set verilogout_show_unconnected_pins "true"
set compile_fix_multiple_port_nets "true"

analyze -format sverilog $my_verilog_files

elaborate $my_toplevel

current_design $my_toplevel

link
uniquify

check_design

set find_clock [ find port [list $my_clock_pin] ]
if {  $find_clock != [list] } {
   set clk_name $my_clock_pin
   create_clock -period $clk_period $clk_name
} else {
   set clk_name vclk
   create_clock -period $clk_period -name $clk_name
}

#set_option -pipe 2

#set_ideal_network $clk_name
set_clock_uncertainty -setup $clk_uncertainty [get_clocks $clk_name]
set_dont_touch_network $clk_name

set inv_fo4 [getenv "INV_FO4"]
set_driving_cell -no_design_rule -lib_cell $inv_fo4 [all_inputs]

set_input_delay -max $input_delay_max -clock $clk_name [remove_from_collection [all_inputs] $my_clock_pin]
set_input_delay -min $input_delay_min -clock $clk_name [remove_from_collection [all_inputs] $my_clock_pin]
set_output_delay -max $output_delay_max -clock $clk_name [all_outputs]
set_output_delay -min $output_delay_min -clock $clk_name [all_outputs]

set_false_path -from $my_reset_pin -to $clk_name

#set_max_fanout 16.0 $my_toplevel

set power_default_toggle_rate 0.5
set power_default_static_probability 0.5

read_saif -input $saif_file -instance_name $my_toplevel

set_optimize_registers -justification_effort high

#set_max_area 0
#compile -ungroup_all -map_effort medium
#compile -incremental_mapping -map_effort medium
#compile_ultra -no_auto_ungroup
compile_ultra -retime

check_design
report_constraint -all_violators

set output_path "$report_dir/$my_toplevel/$my_clk_freq_MHz"

exec mkdir -p $output_path

set filename [format "%s%s"  $my_toplevel "_syn.v"]
write -f verilog -output $output_path/$filename

set filename [format "%s%s"  $my_toplevel "_syn.sdc"]
write_sdc $output_path/$filename

set filename [format "%s%s"  $my_toplevel "_syn.sdf"]
write_sdf $output_path/$filename

redirect $output_path/area.rep {report_area -hier}
redirect $output_path/timing.rep { report_timing }
redirect $output_path/cell.rep { report_cell }
redirect $output_path/power.rep { report_power -analysis_effort high }
redirect $output_path/saif.rep { report_saif -hierarchy -rtl_saif -missing}

quit
