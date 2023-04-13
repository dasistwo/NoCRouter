import os, stat
 
ASAP7_STD_CELL = '/share/DB/ASAP7/asap7-ccsa/' 
BASE_DIR = os.getcwd()

SRC_DIR = BASE_DIR + '/../src'
LOG_DIR = BASE_DIR + '/log'
REPORT_DIR = BASE_DIR + '/report'

TCL_FILE = BASE_DIR + '/tcl_files/syn_asap7'
SAIF_FILE = BASE_DIR + '/../sim/tb_router_worst.saif'
TOP_MODULE = "router"

# Find through any SystemVerilog files in the src directory
SRC_FILE_LIST = []
for root, dirs, files in os.walk(SRC_DIR):
  for file in files:
    if file.endswith(".v") or file.endswith(".sv"):
      SRC_FILE_LIST.append(os.path.join(root, file))

# If noc.sv exists in SRC_FILE_LIST, then move it to the first of the list
if SRC_FILE_LIST.count(SRC_DIR + '/noc.sv') > 0:
  SRC_FILE_LIST.remove(SRC_DIR + '/noc.sv')
  SRC_FILE_LIST.insert(0, SRC_DIR + '/noc.sv')

# make SRC_FILE_LIST into a string
SRC_FILES = "\""
for file in SRC_FILE_LIST:
  SRC_FILES += file + " "
SRC_FILES += "\""

# If script file exists, remove it and create a new one
if os.path.exists("run_asap7_{}_.sh".format(TOP_MODULE)):
  os.remove("run_asap7_{}_.sh".format(TOP_MODULE))
script_file = open("run_asap7_{}_.sh".format(TOP_MODULE), "w");

# Edit the list in for-loops below to tune parameters

# 1. Tune transistor type
# Generally, Lower voltage threshold means faster response (higher performance)
# at the cost of more power & more area
# SLVT (Super Low Voltage Threshold)  -- lowest Vth
# LVT (Low Voltage Threshold)
# RVT (Regular Voltatge Threshold)
# SRAM                                -- highest Vth
for TH_VT in ["LVT", "SLVT", "RVT", "SRAM"]:
  # 2. Select tech corner (variance in performance of a transistor)
  # For architectural analysis (macro-scale), TT is usually used,
  # and for analyzing real chip's timing, etc, SS should be considered.
  # FF (Fast-Fast)
  # TT (Typical-Typical)
  # SS (Slow-Slow)
  for CORNER in ["TT", "FF", "SS"]:
    DEVICE_TYPE = "asap7_{}_{}_new".format(TH_VT, CORNER)
    ASAP7_AO_LIB = "asap7sc7p5t_AO_{}_{}_ccsa.db".format(TH_VT, CORNER)
    ASAP7_INVBUF_LIB = "asap7sc7p5t_INVBUF_{}_{}_ccsa.db".format(TH_VT, CORNER)
    ASAP7_OA_LIB = "asap7sc7p5t_OA_{}_{}_ccsa.db".format(TH_VT, CORNER)
    ASAP7_SEQ_LIB = "asap7sc7p5t_SEQ_{}_{}_ccsa.db".format(TH_VT, CORNER)
    ASAP7_SIMPLE_LIB = "asap7sc7p5t_SIMPLE_{}_{}_ccsa.db".format(TH_VT, CORNER)
    
    INV_FO4 = "INVx4_ASAP7_75t_"
    
    if TH_VT == "LVT":
      INV_FO4 += "L"
    elif TH_VT == "SLVT":
      INV_FO4 += "SL"
    elif TH_VT == "RVT":
      INV_FO4 += "R"
    elif TH_VT == "SRAM":
      INV_FO4 += "SRAM"

    for SYN_FREQ in [125.0, 250.0, 500.0, 1000.0, 1500.0]:
      line = ""
      line += "mkdir -p {}/{}/{}/{}\n ".format(LOG_DIR, DEVICE_TYPE, TOP_MODULE, SYN_FREQ)
      line += "export BASE_DIR={}\n ".format(BASE_DIR)
      line += "export REPORT_DIR={}/{}\n ".format(REPORT_DIR, DEVICE_TYPE)
      line += "export SRC_FILES={}\n ".format(SRC_FILES)
      line += "export ASAP7_STD_CELL={}\n ".format(ASAP7_STD_CELL)
      line += "export SYN_FREQ={}\n ".format(SYN_FREQ)
      line += "export ASAP7_AO_LIB={}\n ".format(ASAP7_AO_LIB)
      line += "export ASAP7_INVBUF_LIB={}\n ".format(ASAP7_INVBUF_LIB)
      line += "export ASAP7_OA_LIB={}\n ".format(ASAP7_OA_LIB)
      line += "export ASAP7_SEQ_LIB={}\n ".format(ASAP7_SEQ_LIB)
      line += "export ASAP7_SIMPLE_LIB={}\n ".format(ASAP7_SIMPLE_LIB)
      line += "export INV_FO4={}\n ".format(INV_FO4)
      line += "export SAIF_FILE={}\n ".format(SAIF_FILE)
      line += "export TOP_MODULE={}\n ".format(TOP_MODULE)
      line += "dc_shell-xg-t -f {} -no_gui 2>&1 | tee {}/{}/{}/{}/dc_shell.log".format(TCL_FILE + '_' +  TOP_MODULE + '.tcl', LOG_DIR, DEVICE_TYPE, TOP_MODULE, SYN_FREQ)
      script_file.write(line + '\n')
script_file.close();

st = os.stat("run_asap7_{}_.sh".format(TOP_MODULE))
os.chmod("run_asap7_{}_.sh".format(TOP_MODULE), st.st_mode | stat.S_IEXEC)
