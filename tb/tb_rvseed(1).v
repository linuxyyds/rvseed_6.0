// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : tb_rvseed.v
// Author        : Rongye
// Created On    : 2022-03-25 04:18
// Last Modified : 2022-04-11 19:34
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
`timescale 1ns / 1ps
`include "rvseed_defines.v"

module tb_rvseed ();

reg                  clk;
reg                  rst_n;
reg [5*8-1:0]        inst_name;

// register file
wire [`CPU_WIDTH-1:0] zero_x0  = u_rvseed_0. u_reg_file_0. reg_f[0];
wire [`CPU_WIDTH-1:0] ra_x1    = u_rvseed_0. u_reg_file_0. reg_f[1];
wire [`CPU_WIDTH-1:0] sp_x2    = u_rvseed_0. u_reg_file_0. reg_f[2];
wire [`CPU_WIDTH-1:0] gp_x3    = u_rvseed_0. u_reg_file_0. reg_f[3];
wire [`CPU_WIDTH-1:0] tp_x4    = u_rvseed_0. u_reg_file_0. reg_f[4];
wire [`CPU_WIDTH-1:0] t0_x5    = u_rvseed_0. u_reg_file_0. reg_f[5];
wire [`CPU_WIDTH-1:0] t1_x6    = u_rvseed_0. u_reg_file_0. reg_f[6];
wire [`CPU_WIDTH-1:0] t2_x7    = u_rvseed_0. u_reg_file_0. reg_f[7];
wire [`CPU_WIDTH-1:0] s0_fp_x8 = u_rvseed_0. u_reg_file_0. reg_f[8];
wire [`CPU_WIDTH-1:0] s1_x9    = u_rvseed_0. u_reg_file_0. reg_f[9];
wire [`CPU_WIDTH-1:0] a0_x10   = u_rvseed_0. u_reg_file_0. reg_f[10];
wire [`CPU_WIDTH-1:0] a1_x11   = u_rvseed_0. u_reg_file_0. reg_f[11];
wire [`CPU_WIDTH-1:0] a2_x12   = u_rvseed_0. u_reg_file_0. reg_f[12];
wire [`CPU_WIDTH-1:0] a3_x13   = u_rvseed_0. u_reg_file_0. reg_f[13];
wire [`CPU_WIDTH-1:0] a4_x14   = u_rvseed_0. u_reg_file_0. reg_f[14];
wire [`CPU_WIDTH-1:0] a5_x15   = u_rvseed_0. u_reg_file_0. reg_f[15];
wire [`CPU_WIDTH-1:0] a6_x16   = u_rvseed_0. u_reg_file_0. reg_f[16];
wire [`CPU_WIDTH-1:0] a7_x17   = u_rvseed_0. u_reg_file_0. reg_f[17];
wire [`CPU_WIDTH-1:0] s2_x18   = u_rvseed_0. u_reg_file_0. reg_f[18];
wire [`CPU_WIDTH-1:0] s3_x19   = u_rvseed_0. u_reg_file_0. reg_f[19];
wire [`CPU_WIDTH-1:0] s4_x20   = u_rvseed_0. u_reg_file_0. reg_f[20];
wire [`CPU_WIDTH-1:0] s5_x21   = u_rvseed_0. u_reg_file_0. reg_f[21];
wire [`CPU_WIDTH-1:0] s6_x22   = u_rvseed_0. u_reg_file_0. reg_f[22];
wire [`CPU_WIDTH-1:0] s7_x23   = u_rvseed_0. u_reg_file_0. reg_f[23];
wire [`CPU_WIDTH-1:0] s8_x24   = u_rvseed_0. u_reg_file_0. reg_f[24];
wire [`CPU_WIDTH-1:0] s9_x25   = u_rvseed_0. u_reg_file_0. reg_f[25];
wire [`CPU_WIDTH-1:0] s10_x26  = u_rvseed_0. u_reg_file_0. reg_f[26];
wire [`CPU_WIDTH-1:0] s11_x27  = u_rvseed_0. u_reg_file_0. reg_f[27];
wire [`CPU_WIDTH-1:0] t3_x28   = u_rvseed_0. u_reg_file_0. reg_f[28];
wire [`CPU_WIDTH-1:0] t4_x29   = u_rvseed_0. u_reg_file_0. reg_f[29];
wire [`CPU_WIDTH-1:0] t5_x30   = u_rvseed_0. u_reg_file_0. reg_f[30];
wire [`CPU_WIDTH-1:0] t6_x31   = u_rvseed_0. u_reg_file_0. reg_f[31];

integer r;
initial begin
    wait(s10_x26 == 32'b1)   // wait sim end, when x26 == 1
        #(`SIM_PERIOD * 1 + 1)
        if (s11_x27 == 32'b1) begin
            $display("~~~~~~~~~~~~~~~~~~~ %s PASS ~~~~~~~~~~~~~~~~~~~",inst_name);
            #(`SIM_PERIOD * 1);
        end 
        else begin
            $display("~~~~~~~~~~~~~~~~~~~ %s FAIL ~~~~~~~~~~~~~~~~~~~~",inst_name);
            $display("fail testnum = %2d", gp_x3);
            #(`SIM_PERIOD * 1);
            $stop;
            for (r = 0; r < 32; r = r + 1)
                $display("x%2d = 0x%x", r, u_rvseed_0. u_reg_file_0. reg_f[r]);
        end
end

initial begin
    #(`SIM_PERIOD/2);
    clk       = 1'b0;
    rst_n     = 1'b0;

    inst_name = "ADD";
    inst_load(inst_name);
    
    #(`SIM_PERIOD * 1);
    rst_n = 1'b1;
    #(`SIM_PERIOD * 1000);
    $stop;
end

initial begin
    #(`SIM_PERIOD * 50000);
    $display("Time Out");
    $finish;
end

always #(`SIM_PERIOD/2) clk = ~clk;

task reset;                // reset 1 clock
    begin
        rst_n = 0; 
        #(`SIM_PERIOD * 1);
        rst_n = 1;
    end
endtask

task inst_load;
    input [5*8-1:0] inst_name;
    begin
        $readmemh (inst_name, u_rvseed_0. u_inst_mem_0. inst_mem_f);
    end
endtask

rvseed u_rvseed_0(
    .clk                            ( clk                           ),
    .rst_n                          ( rst_n                         )
);

// iverilog 
initial begin
    $dumpfile("sim_out.vcd");
    $dumpvars;
end

endmodule
