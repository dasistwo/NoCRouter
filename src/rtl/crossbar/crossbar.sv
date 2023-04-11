`timescale 1ns / 1ps
import noc_params::*;

module crossbar #(
)(
    input_block2crossbar.crossbar ib_if,
    switch_allocator2crossbar.crossbar sa_if,
    output flit_t data_o [PORT_NUM-1:0]
);

    // output register buffer to crossbar
    reg [$bits(flit_t)-1:0] data_o_reg [PORT_NUM-1:0];
    
    /*
    Combinational logic:
    on each output, propagate the corresponding input
    according to the current selection
    Added buffer to meet timing
    */
    always_comb
    begin
        for(int ip = 0; ip < PORT_NUM; ip = ip + 1)
        begin
            data_o[ip] <= data_o_reg[ip];
        end

        for(int ip = 0; ip < PORT_NUM; ip = ip + 1)
        begin
            data_o_reg[ip] <= ib_if.flit[sa_if.input_vc_sel[ip]];
        end
        
        // for(int ip = 0; ip < PORT_NUM; ip = ip + 1)
        // begin
        //     data_o[ip] <= ib_if.flit[sa_if.input_vc_sel[ip]];
        // end
    end

endmodule