module IF_pipe_stage(
    input clk, reset,
    input en,
    input [9:0] branch_address,
    input [9:0] jump_address,
    input branch_taken,
    input jump,
    output [9:0] pc_plus4,
    output [31:0] instr
    );    
    
    wire [9:0] output1; //added
    wire [9:0] output2; //added
    reg [9:0] pc;       //added
    
    always @(posedge clk or posedge reset)  
    begin   
         if(reset)   
              pc <= 10'b0000000000;  
         else if(en) // en is the output of Hazard_detection.v
              pc <= output2; 
//         else  // if not enable
//              pc <= pc;
    end  
    
    assign pc_plus4 = pc + 10'b0000000100;
    
    instruction_mem inst_mem (
            .read_addr(pc),
            .data(instr)
    );
    
    mux2 #(.mux_width(32)) branch_mux
    (   .a(pc_plus4),
        .b(branch_address),
        .sel(branch_taken),
        .y(output1)
    );
    
    mux2 #(.mux_width(32)) jump_mux
     (   .a(output1),
         .b(jump_address),
         .sel(jump),
         .y(output2)
     );
     
endmodule