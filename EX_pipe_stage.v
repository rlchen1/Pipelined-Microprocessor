module EX_pipe_stage(
    input [31:0] id_ex_instr,
    input [31:0] reg1, reg2,
    input [31:0] id_ex_imm_value,
    input [31:0] ex_mem_alu_result,
    input [31:0] mem_wb_write_back_result,
    input id_ex_alu_src,
    input [1:0] id_ex_alu_op,
    input [1:0] Forward_A, Forward_B,
    output [31:0] alu_in2_out,
    output [31:0] alu_result
    );
    
    wire [31:0] output3;
    wire [31:0] output4;
    wire [3:0] ALU_Control;
    
    
    mux4 #(.mux_width(32)) EX_top_mux
    (   .a(reg1),
        .b(mem_wb_write_back_result),
        .c(ex_mem_alu_result),
        .sel(Forward_A),
        .y(output3)
    );
    
    mux4 #(.mux_width(32)) EX_bot_mux
    (   .a(reg2),
        .b(mem_wb_write_back_result),
        .c(ex_mem_alu_result),
        .sel(Forward_B),
        .y(alu_in2_out)
    );
    
    mux2 #(.mux_width(32)) EX_mid_mux
    (   .a(alu_in2_out),
        .b(id_ex_imm_value),
        .sel(id_ex_alu_src),
        .y(output4)
    );
    
    ALUControl alu_control_inst
    (   .Function(id_ex_instr[5:0]),
        .ALUOp(id_ex_alu_op),
        .ALU_Control(ALU_Control)
    );
    
    ALU alu_inst
    (   .a(output3),
        .b(output4),
        .alu_control(ALU_Control),
        .alu_result(alu_result)
    );
endmodule