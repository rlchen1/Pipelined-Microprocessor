module ID_pipe_stage(
    input clk, reset,
    input [9:0] pc_plus4,
    input [31:0] instr,
    input mem_wb_reg_write,
    input [4:0] mem_wb_write_reg_addr,
    input [31:0] mem_wb_write_back_data,
    input Data_Hazard,
    input Control_Hazard,
    output [31:0] reg1, reg2,
    output [31:0] imm_value,
    output [9:0] branch_address,
    output [9:0] jump_address,
    output branch_taken,
    output [4:0] destination_reg,
    output mem_to_reg,
    output [1:0] alu_op,
    output mem_read,
    output mem_write,
    output alu_src,
    output reg_write,
    output jump
    );
    
    wire branch;  //connection wires (outputs used as inputs for others)
    wire reg_dst;
    wire hazardcheck;
    wire equal;
    
    wire control_mem_to_reg;
    wire [1:0] control_alu_op;
    wire control_mem_read;
    wire control_mem_write;
    wire control_alu_src;
    wire control_reg_write;
//    wire control_jump;
    wire control_branch;
    wire control_reg_dst;
    
    wire [31:0] reg_read_data_1;
    wire [31:0] reg_read_data_2;
    
    assign hazardcheck = (!Data_Hazard) || Control_Hazard;
    assign equal = ((reg1 ^ reg2) == 32'd0) ? 1'b1: 1'b0;
    assign branch_taken = control_branch && equal;
        
    assign jump_address = instr[25:0] << 2;
    assign branch_address = (imm_value << 2) + pc_plus4;
    
     
    assign reg1 = reg_read_data_1;
    assign reg2 = reg_read_data_2;
    
    
    register_file reg_file(
        .clk(clk),
        .reset(reset),
        .reg_write_en(mem_wb_reg_write),
        .reg_write_dest(mem_wb_write_reg_addr),
        .reg_write_data(mem_wb_write_back_data),
        .reg_read_addr_1(instr[25:21]),
        .reg_read_addr_2(instr[20:16]),
        .reg_read_data_1(reg_read_data_1),
        .reg_read_data_2(reg_read_data_2)
    );
    
    mux2 #(.mux_width(32)) top_mux_mem_to_reg
    (   .a(control_mem_to_reg),
        .b(0),
        .sel(hazardcheck),
        .y(mem_to_reg)
    );
   
    mux2 #(.mux_width(32)) top_mux_alu_op
    (   .a(control_alu_op),
        .b(0),
        .sel(hazardcheck),
        .y(alu_op)
    );
        
    mux2 #(.mux_width(32)) top_mux_mem_read
    (   .a(control_mem_read),
        .b(0),
        .sel(hazardcheck),
        .y(mem_read)
    );
    mux2 #(.mux_width(32)) top_mux_mem_write
    (   .a(control_mem_write),
        .b(0),
        .sel(hazardcheck),
        .y(mem_write)
    );
    mux2 #(.mux_width(32)) top_mux_alu_src
    (   .a(control_alu_src),
        .b(0),
        .sel(hazardcheck),
        .y(alu_src)
    );
    mux2 #(.mux_width(32)) top_mux_reg_write
    (   .a(control_reg_write),
        .b(0),
        .sel(hazardcheck),
        .y(reg_write)
    );
       
    mux2 #(.mux_width(32)) top_mux_reg_dst
    (   .a(control_reg_dst),
        .b(0),
        .sel(hazardcheck),
        .y(reg_dst)
    ); 
    
    mux2 #(.mux_width(32)) bot_mux
    (   .a(instr[20:16]),
        .b(instr[15:11]),
        .sel(reg_dst),
        .y(destination_reg)
    );
    
    sign_extend sign_ex_inst 
    (   .sign_ex_in(instr[15:0]),
        .sign_ex_out(imm_value)
    );
    
    control control_unit
    (   .opcode(instr[31:26]),
        .reset(reset),
        .mem_to_reg(control_mem_to_reg),
        .alu_op(control_alu_op),
        .mem_read(control_mem_read),
        .mem_write(control_mem_write),
        .alu_src(control_alu_src),
        .reg_write(control_reg_write),
        .jump(jump),
        .branch(control_branch),
        .reg_dst(control_reg_dst)
    );
    
endmodule