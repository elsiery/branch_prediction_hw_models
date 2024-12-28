`timescale 1ns/1ps
`include "gs_hp.v"
module gs_hp_testbench;
parameter BHT_ENTERIES    = 256;
parameter BTB_ENTERIES    = 256;
parameter INSTR_SIZE_BYTE = 4;

reg clk;
reg rst_n;
reg in_fetch_nop;
reg [INSTR_SIZE_BYTE*8-1 :0] in_fetch_pc;
reg in_exe_nop;
reg [INSTR_SIZE_BYTE*8-1 :0] in_exe_pc,dummy_address;
reg in_exe_branch_taken;
reg [INSTR_SIZE_BYTE*8-1 :0] in_exe_branch_offset;
reg [4:0] dummy_btb_addres;
reg [31:0] flag;
reg [7:0] ind,gh;
wire [INSTR_SIZE_BYTE*8-1 :0] out_pc_offset;
wire out_fetch_branch_taken;
reg no_branch_taken;
integer i,k,j,l,bht_pass,bht_fail,btb_pass,btb_fail,detailedresult,finalresult,branch_accurate,branch_not_accurate,branch_offset_accurate,branch_offset_not_accurate;
integer branch_taken,branch_mispredict,branch_predict_true,m,n,j1,j2,j3,j4,j5,j6,j7,prediction_true,prediction_false;
reg [63:0] test_vector[0:255];
gs_hp uut
(
    clk,
    rst_n,
    in_fetch_pc,
    in_fetch_nop,
    in_exe_pc,
    in_exe_nop,
    in_exe_branch_taken,
    in_exe_branch_offset,
    out_pc_offset,
    out_fetch_branch_taken
);
always
#5 clk = ~clk;

initial  
begin 
    $readmemh("block", test_vector);
    finalresult = $fopen("final_result.txt");
    detailedresult = $fopen("detailed_result.txt");
end


initial begin
    $dumpfile("gs_hp.vcd");
    $dumpvars();
end


initial begin
    clk = 0;
    rst_n = 1;
    in_fetch_nop=1;
    in_fetch_pc=0;
    in_exe_branch_offset=0;
    in_exe_branch_taken=0;
    in_exe_pc=0;
    in_exe_nop=1;
    btb_fail=0;
    btb_pass=0;
    bht_pass =0;
    bht_fail=0;
    prediction_true=0;
    prediction_false=0;
    branch_accurate=0;
    branch_not_accurate=0;
    branch_offset_accurate=0;
    branch_offset_not_accurate=0;
    branch_taken=0;
    branch_mispredict=0;
    branch_predict_true=0;
    #10;
    @(posedge clk);
    rst_n=0;
    @(posedge clk);
    rst_n=1;
    #30;
    
    for(i=0;i<256;i=i+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[i][63:32]; 
        in_fetch_nop = 0;
    end
    for(i=0;i<256;i=i+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[i][63:32]; 
        in_fetch_nop = 0;
    end
    for(i=0;i<256;i=i+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[i][63:32]; 
        in_fetch_nop = 0;
        #1;
        $fdisplay(detailedresult,"############## CHECK PHASE START ###########");
        $fdisplay(detailedresult,"For address %h branch is %h and offset is %h",in_fetch_pc,out_fetch_branch_taken,out_pc_offset);
        if((out_fetch_branch_taken==test_vector[i][0])) begin
            if ((out_pc_offset==i)&&out_fetch_branch_taken) begin
                $fdisplay(detailedresult,"Prediction is right for address %h",in_fetch_pc);
                prediction_true+=1;
            end
        end
        else begin
            $fdisplay(detailedresult,"Prediction is NOT right for address %h",in_fetch_pc);
            prediction_false+=1;
        end
        $fdisplay(detailedresult,"############## CHECK PHASE END ###########\n");
    end
    
    in_fetch_nop=1;
        
end

initial begin
    #10;
    @(posedge clk);
    @(posedge clk);
    #30;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    
    for(j=0;j<256;j=j+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j][63:32]; 
        in_exe_branch_taken   = | test_vector[j][31:0];
        in_exe_branch_offset  = j;
        in_exe_nop            = 0;
        ind                   = uut.gshr_entry^in_exe_pc[9:2];
        #1;
        if((j>=0)&&(in_exe_branch_taken)) begin
            $fdisplay(detailedresult,"########## UPDATING PHASE 1 START ###########");
            $fdisplay(detailedresult,"GHSR_PATTERN is %b",uut.gshr_entry);
            $fdisplay(detailedresult,"BHT_ENTRY is %b and add is %d",uut.bht_entry[ind],ind);
            $fdisplay(detailedresult,"########## UPDATING PHASE 1 END ###########\n");
            //$fdisplay(detailedresult,"BTB_ENTRY is %d and add is %d",uut.btb_entry[test_vector[j-1][63:32]],test_vector[j-1][63:32]);
            //$fdisplay(detailedresult,"BRANCH TAKEN is %b",|test_vector[j-1][31:0]);
            //$fdisplay(detailedresult,"\n");
        end
    end
    for(j=0;j<256;j=j+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j][63:32]; 
        in_exe_branch_taken   = | test_vector[j][31:0];
        in_exe_branch_offset  = j;
        in_exe_nop            = 0;
        ind                   = uut.gshr_entry^in_exe_pc[9:2];
        #1;
        if((j>=0)&&(in_exe_branch_taken)) begin
            $fdisplay(detailedresult,"##########UPDATING PHASE 2 ###########");
            $fdisplay(detailedresult,"GHSR_PATTERN is %b",uut.gshr_entry);
            $fdisplay(detailedresult,"BHT_ENTRY is %b and add is %d",uut.bht_entry[ind],ind);
            $fdisplay(detailedresult,"###################################\n");
            //$fdisplay(detailedresult,"BTB_ENTRY is %d and add is %d",uut.btb_entry[test_vector[j-1][63:32]],test_vector[j-1][63:32]);
            //$fdisplay(detailedresult,"BRANCH TAKEN is %b",|test_vector[j-1][31:0]);
            //$fdisplay(detailedresult,"\n");
        end
    end
    for(j=0;j<256;j=j+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j][63:32]; 
        in_exe_branch_taken   = | test_vector[j][31:0];
        in_exe_branch_offset  = j;
        in_exe_nop            = 0;
        ind                   = uut.gshr_entry^in_exe_pc[9:2];
        #1;
        if((j>=0)&&(in_exe_branch_taken)) begin
            $fdisplay(detailedresult,"##########UPDATING PHASE 3 ###########");
            $fdisplay(detailedresult,"GHSR_PATTERN is %b",uut.gshr_entry);
            $fdisplay(detailedresult,"BHT_ENTRY is %b and add is %d",uut.bht_entry[ind],ind);
            $fdisplay(detailedresult,"###################################\n");
            //$fdisplay(detailedresult,"BTB_ENTRY is %d and add is %d",uut.btb_entry[test_vector[j-1][63:32]],test_vector[j-1][63:32]);
            //$fdisplay(detailedresult,"BRANCH TAKEN is %b",|test_vector[j-1][31:0]);
            //$fdisplay(detailedresult,"\n");
        end
    end
    
    in_exe_nop=1;
    
    
    $fdisplay(finalresult,"branch predict true=%d,branch predict false=%d",prediction_true,prediction_false);
    $display("branch predict true=%d,branch predict false=%d",prediction_true,prediction_false);
    $fclose(detailedresult);
    $fclose(finalresult);
    $finish;
end
endmodule


