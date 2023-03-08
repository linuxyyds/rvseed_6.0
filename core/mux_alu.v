// +FHDR----------------------------------------------------------------------------

// Filename      : mux_alu.v

// -FHDR----------------------------------------------------------------------------
`include "rvseed_defines.v"

module mux_alu ( 
    input      [`ALU_SRC_WIDTH-1:0] alu_src_sel,// reg or imm to alu

    input      [`CPU_WIDTH-1:0]     reg1_rdata, // register 1 read data
    input      [`CPU_WIDTH-1:0]     reg2_rdata, // register 2 read data
    input      [`CPU_WIDTH-1:0]     imm,        // immediate
    input      [`CPU_WIDTH-1:0]     curr_pc,    // current pc addr

    output reg [`CPU_WIDTH-1:0]     alu_src1,   // alu source 1
    output reg [`CPU_WIDTH-1:0]     alu_src2    // alu source 2
);

always @(*) begin
    alu_src1 = reg1_rdata;     // defalut select reg1 data
    alu_src2 = reg2_rdata;     // default select reg2 data
    case (alu_src_sel)
        `ALU_SRC_REG: 
            alu_src2 = reg2_rdata; // select reg2 data
        `ALU_SRC_IMM: 
            alu_src2 = imm;        // select immediate 
        `ALU_SRC_FOUR_PC: begin
            alu_src1 = `CPU_WIDTH'h4; // pc + 4 
            alu_src2 = curr_pc;       //
        end
        `ALU_SRC_IMM_PC: begin //select imm and pc
            alu_src1 = imm;
            alu_src2 = curr_pc;
        end
    endcase
end
endmodule
