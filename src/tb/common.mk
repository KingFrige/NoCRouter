DEP_SRCS =

SRCS = $(TOP_SRC) $(DEP_SRCS)

RTL_NOC_DIR = ../../rtl/noc
RTL_INPUT_PORT_DIR = ../../rtl/input_port
RTL_ALLOCATORS_DIR = ../../rtl/allocators
RTL_CROSSBAR_DIR = ../../rtl/crossbar
RTL_ROUTER_DIR = ../../rtl/router
IF_DIR = ../../if

SRC_FLIST = $(RTL_NOC_DIR)/*.sv \
					 $(RTL_INPUT_PORT_DIR)/*.sv \
					 $(RTL_ALLOCATORS_DIR)/*.sv \
					 $(RTL_CROSSBAR_DIR)/*.sv \
					 $(RTL_ROUTER_DIR)/*.sv \
					 $(IF_DIR)/*.sv

DW_DIR = $(SYNOPSYS)/dw/sim_ver

VCS_FLAGS += -full64 -sverilog +lint=all +libext+.sv +lint=all,noVCDE +v2k +libext+.v -Mupdate
VCS_FLAGS += -timescale=1ns/1ps -l vcs.log 
VCS_FLAGS += -debug_access+all
#VCS_FLAGS += -kdb +vcs+fsdbon

SIMV_ARGS += +vcs+lic+wait -l simv.log -ucli -do $(PROJECT_DIR)/src/tb/dump.tcl
# SIMV_ARGS += +fsdb+struct=on +fsdb+packedmda=on +fsdbfile+dump.fsdb

INT_CTRL=

all:simv

simv: $(SRCS) $(SRC_FLIST)
	vcs -o simv $(VCS_FLAGS) $(INT_CTRL) -f ../flist.f $(TOP_SRC)
	./simv $(SIMV_ARGS)

simvfast: $(SRCS) $(SRC_FLIST)
	vcs -o simvfast +rad $(VCS_FLAGS) $(INT_CTRL) -f ../flist.f $(TOP_SRC)
	./simvfast $(SIMV_ARGS)

clean:
	rm -rf work simv simvfast simv.daidir simvfast.daidir transcript *.vcd *.vpd *.fsdb ucli.key vcs.key run.args csrc DVEfiles .vcsmx_rebuild *~ *.log verdiLog/ novas.*

verdi:
	verdi -sv -f ../flist.f -top $(TOP) $(TOP_SRC) -ssf dump.fsdb &

