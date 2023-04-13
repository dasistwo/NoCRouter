export MAX_CORE=8
export SYN_FREQ="1000.0"
#export ASAP7_TARGET_LIB="LVT_TT"
export TH_VT="LVT"
export CORNER="TT"
export ASAP7_TARGET_LIB="${TH_VT}_${CORNER}"

rm -rf run__.sh

# Edit the list in for-loops below to tune parameters

# 1. Tune transistor type
# Generally, Lower voltage threshold means faster response (higher performance)
# at the cost of more power & more area
# SLVT (Super Low Voltage Threshold)  -- lowest Vth
# LVT (Low Voltage Threshold)
# RVT (Regular Voltatge Threshold)
# SRAM                                -- highest Vth
for TH_VT in SLVT LVT RVT SRAM
do
  # 2. Select tech corner (variance in performance of a transistor)
  # For architectural analysis (macro-scale), TT is usually used,
  # and for analyzing real chip's timing, etc, SS should be considered.
  # FF (Fast-Fast)
  # TT (Typical-Typical)
  # SS (Slow-Slow)
  for CORNER in FF TT SS
  do
    # 3. Select target operating clock frequency (MHz)
    for SYN_FREQ in 125.0 250.0 500.0 1000.0 1500.0
    do
      echo "mkdir -p log/asap7/${TH_VT}_${CORNER}/$SYN_FREQ;\
            export TH_VT=$TH_VT;\
            export CORNER=$CORNER;\
            export SYN_FREQ=$SYN_FREQ;\
            export LIB_AO="asap7sc7p5t_24_AO_${TH_VT}_${CORNER}.db";\
            export LIB_INVBUF="asap7sc7p5t_24_INVBUF_${TH_VT}_${CORNER}.db";\
            export LIB_OA="asap7sc7p5t_24_OA_${TH_VT}_${CORNER}.db";\
            export LIB_SEQ="asap7sc7p5t_24_SEQ_${TH_VT}_${CORNER}.db";\
            export LIB_SIMPLE="asap7sc7p5t_24_SIMPLE_${TH_VT}_${CORNER}.db";\
            dc_shell-xg-t -f ../tcl_files/synthesis_asap7.tcl -no_gui > log/asap7/${TH_VT}_${CORNER}/$SYN_FREQ/dc_shell.log"\
      >> run__.sh
    done
  done
done

./run_multiprog.py --process $MAX_CORE --script run__.sh
rm -rf run__.sh

