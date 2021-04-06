`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2020 02:10:56 PM
// Design Name: 
// Module Name: mips_32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mips_32(
    input clk, reset,  
    output[31:0] result
    );
    
    wire reg_dst, reg_write, alu_src, pc_src, mem_read, mem_write, mem_to_reg;
    wire [3:0] ALU_Control;
    wire [5:0] inst_31_26, inst_5_0;
    wire [1:0] alu_op;
    //added
    wire branch, jump, branch_taken;
    wire [9:0] pc;
    wire en;
    wire [9:0] branch_address, jump_address, pc_plus4;
    wire [31:0] instr;
    wire reg_write_dest;
  
    //ID instantiation
    //wire [139:0] d; //variable size
    //wire [139:0] q; //variable size
    wire [9:0] if_id_pc_plus4;
    wire [31:0] if_id_instr;
    wire Data_Hazard;
    wire Control_Hazard;
    wire [4:0] destination_reg;
    wire [31:0] reg1;
    wire [31:0] reg2;
    wire [31:0] imm_value;
    wire [41:0] if_id_out;
    
    //ID-->EX instantiation
    wire [31:0] id_ex_instr;
    wire [31:0] id_ex_reg1;
    wire [31:0] id_ex_reg2;
    wire [31:0] id_ex_imm_value;
    wire [4:0] id_ex_destination_reg;
    wire id_ex_mem_to_reg;
    wire [1:0] id_ex_alu_op;
    wire id_ex_mem_read;
    wire id_ex_mem_write;
    wire id_ex_alu_src;
    wire id_ex_reg_write;
    wire [139:0] id_ex_out;
    
    //HazardDetection instantiation
    wire [4:0] if_id_rs;
    wire [4:0] if_id_rt;
    wire IF_Flush;
    
    //EX instantiation
    wire [31:0] ex_mem_alu_result;
    wire [31:0] mem_wb_write_back_result;
    wire [31:0] alu_in2_out;
    wire [31:0] alu_result;
    wire [1:0] Forward_A;
    wire [1:0] Forward_B;
    
    //Forwarding instantiation
    wire ex_mem_reg_write;
    wire [4:0] ex_mem_write_reg_addr;
    wire [4:0] id_ex_instr_rs;
    wire [4:0] id_ex_instr_rt;
    wire [104:0] ex_mem_out;
    
    //Data Memory instantiation
    wire ex_mem_mem_write;
    wire ex_mem_mem_read;
    wire [31:0] ex_mem_instr;
    wire [4:0] ex_mem_destination_reg;
    wire ex_mem_mem_to_reg;
    wire [31:0] ex_mem_alu_in2_out;
    wire [31:0] mem_read_data;
    
    //Write Back instantiation
    wire [31:0] mem_wb_alu_result;
    wire [31:0]mem_wb_mem_read_data;
    wire mem_wb_mem_to_reg;
    wire [4:0] mem_wb_destination_reg;
    wire [31:0] write_back_data;
    wire mem_wb_reg_write;
    wire [4:0] mem_wb_write_reg_addr;
    wire [31:0] mem_wb_write_back_data;
    wire [70:0] mem_wb_out;
    
    //extract values from q (IF --> ID reg)
//    assign if_id_out = {pc_plus4, instr[31:0]};
    assign if_id_pc_plus4 = if_id_out[41:32];
    assign if_id_instr = if_id_out[31:0];
    
    //extract values from q (ID --> EX reg)
    assign id_ex_instr           = id_ex_out[139:108]; //32
    assign id_ex_reg1            = id_ex_out[107:76]; //32
    assign id_ex_reg2            = id_ex_out[75:44];  //32
    assign id_ex_imm_value       = id_ex_out[43:12];  //32
    assign id_ex_destination_reg = id_ex_out[11:7];   //5
    assign id_ex_mem_to_reg      = id_ex_out[6];      //1
    assign id_ex_alu_op          = id_ex_out[5:4];   //2
    assign id_ex_mem_read        = id_ex_out[3];     //1
    assign id_ex_mem_write       = id_ex_out[2];     //1
    assign id_ex_alu_src         = id_ex_out[1];     //1
    assign id_ex_reg_write       = id_ex_out[0];     //1
    
    //extract values from q (EX --> MEM reg)
    assign ex_mem_instr           = ex_mem_out[104:73]; //32
    assign ex_mem_destination_reg = ex_mem_out[72:68]; //5
    assign ex_mem_alu_result      = ex_mem_out[67:36];  //32
    assign ex_mem_alu_in2_out     = ex_mem_out[35:4];   //32
    assign ex_mem_mem_to_reg      = ex_mem_out[3];     //1
    assign ex_mem_mem_read        = ex_mem_out[2];     //1
    assign ex_mem_mem_write       = ex_mem_out[1];     //1
    assign ex_mem_reg_write       = ex_mem_out[0];     //1
    
    //extract values from q (MEM --> WB reg)
    assign mem_wb_alu_result       = mem_wb_out[70:39];  //32  
    assign mem_wb_mem_read_data    = mem_wb_out[38:7];  //32
    assign mem_wb_mem_to_reg       = mem_wb_out[6];  //1
    assign mem_wb_reg_write        = mem_wb_out[5];   //1
    assign mem_wb_destination_reg  = mem_wb_out[4:0];   //5
     
//    datapath datapath_unit(
//        .clk(clk), 
//        .reset(reset), 
//        .reg_dst(reg_dst), 
//        .reg_write(reg_write),
//        .alu_src(alu_src), 
//        .pc_src(pc_src), 
//        .mem_read(mem_read), 
//        .mem_write(mem_write),
//        .mem_to_reg(mem_to_reg), 
//        .ALU_Control(ALU_Control), 
//        .datapath_result(result),
//        .inst_31_26(inst_31_26), 
//        .branch(branch),
//        .jump(jump),
//        .inst_5_0(inst_5_0));
                  
    IF_pipe_stage IF_pipe_stage_unit(
        .clk(clk),
        .reset(reset),
        .en(Data_Hazard),
        .branch_address(branch_address),
        .jump_address(jump_address),
        .branch_taken(branch_taken),
        .jump(jump),
        .pc_plus4(pc_plus4),
        .instr(instr)
    );
    
    ID_pipe_stage ID_pipe_stage_unit(
        .clk(clk),
        .reset(reset),
        .instr(if_id_instr),
        .pc_plus4(if_id_pc_plus4),
        .mem_wb_reg_write(mem_wb_reg_write),
        .mem_wb_write_reg_addr(mem_wb_destination_reg),
        .mem_wb_write_back_data(write_back_data),
        .Data_Hazard(Data_Hazard),
        .Control_Hazard(IF_Flush),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .jump(jump),
        .jump_address(jump_address),
        .branch_address(branch_address),
        .branch_taken(branch_taken),
        .reg1(reg1),
        .reg2(reg2),
        .imm_value(imm_value),
        .destination_reg(destination_reg)
    );
    
    pipe_reg_en #(.WIDTH(42)) IF_ID_register( //only reg to need 'en'
        .clk(clk),
        .reset(reset),
        .en(Data_Hazard),
        .flush(IF_Flush),
        .d({pc_plus4, instr}),
        .q(if_id_out) 
    );
    
    //ID-->EX register
    pipe_reg #(.WIDTH(140)) ID_EX_register(
        .clk(clk),
        .reset(reset),
        .d({if_id_instr,reg1,reg2,imm_value,destination_reg,mem_to_reg,alu_op,mem_read,mem_write,alu_src,reg_write}),
        .q(id_ex_out)
    );         
    
    Hazard_detection Hazard_detection_unit(
        .id_ex_mem_read(id_ex_mem_read),
        .id_ex_destination_reg(id_ex_destination_reg),
        .if_id_rs(if_id_instr[25:21]),
        .if_id_rt(if_id_instr[20:16]),
        .branch_taken(branch_taken),
        .jump(jump),
        .Data_Hazard(Data_Hazard),
        .IF_Flush(IF_Flush)
    );
    
    EX_pipe_stage EX_pipe_stage_unit(
        .id_ex_instr(id_ex_instr),
        .reg1(id_ex_reg1),
        .reg2(id_ex_reg2),
        .id_ex_imm_value(id_ex_imm_value),
        .ex_mem_alu_result(ex_mem_alu_result),
        .mem_wb_write_back_result(write_back_data),
        .id_ex_alu_src(id_ex_alu_src),
        .id_ex_alu_op(id_ex_alu_op),
        .Forward_A(Forward_A),
        .Forward_B(Forward_B),
        .alu_in2_out(alu_in2_out),
        .alu_result(alu_result)    
    );

    Forwarding_unit Forwarding_unit_unit(
        .ex_mem_reg_write(ex_mem_reg_write),
        .ex_mem_write_reg_addr(ex_mem_destination_reg),
        .id_ex_instr_rs(instr[25:21]),
        .id_ex_instr_rt(instr[20:16]), //id_ex_reg2
        .mem_wb_reg_write(mem_wb_reg_write),
        .mem_wb_write_reg_addr(mem_wb_destination_reg),
        .Forward_A(Forward_A),
        .Forward_B(Forward_B)
    );
    
    //EX-->MEM register
    pipe_reg #(.WIDTH(105)) EX_MEM_register
    (
        .clk(clk),
        .reset(reset),
        .d({id_ex_instr, id_ex_destination_reg, alu_result, alu_in2_out, id_ex_mem_to_reg, id_ex_mem_read, id_ex_mem_write, id_ex_reg_write}),
        .q(ex_mem_out)
    );        
        
    data_memory data_memory_unit(
        .mem_write_en(ex_mem_mem_write),
        .mem_read_en(ex_mem_mem_read),
        .mem_write_data(ex_mem_alu_in2_out), //ex_mem_alu_in2_out = reg2 = 32bit data
        .mem_access_addr(ex_mem_alu_result), //ex_mem_alu_result = id_ex_imm_value = 32bit access addr
        .mem_read_data(mem_read_data)
    );
    
    //MEM-->WB register 
    pipe_reg #(.WIDTH(71)) MEM_WB_register
    (
        .clk(clk),
        .reset(reset),
        .d({ex_mem_alu_result, mem_read_data, ex_mem_mem_to_reg, ex_mem_reg_write, ex_mem_destination_reg}),
        .q(mem_wb_out)
    );        
    
    mux2 #(.mux_width(32)) wb_mux
    (   .a(mem_wb_alu_result),
        .b(mem_wb_mem_read_data),
        .sel(mem_wb_mem_to_reg),
        .y(write_back_data)
    );
    
//    control control_unit(
//        .reset(reset),
//        .opcode(inst_31_26),
//        .reg_dst(reg_dst), 
//        .mem_to_reg(mem_to_reg),
//        .alu_op(alu_op),
//        .mem_read(mem_read),  
//        .mem_write(mem_write),
//        .alu_src(alu_src),
//        .reg_write(reg_write),
//        .jump(jump),
//        .branch(branch)); 

    assign result = write_back_data; //result comes from wb_mux
endmodule
