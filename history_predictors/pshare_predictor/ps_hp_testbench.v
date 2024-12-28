/*
MIT License

Copyright (c) 2024 Elsie Rezinold Y

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

`timescale 1ns/1ps
`include "ps_hp.v"
module ps_hp_testbench;
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
integer l,bht_pass,bht_fail,btb_pass,btb_fail,detailedresult,finalresult,branch_accurate,branch_not_accurate,branch_offset_accurate,branch_offset_not_accurate;
integer branch_taken,branch_mispredict,branch_predict_true,m,n,j1,j2,j3,j4,j5,j6,j7,prediction_true,prediction_false;
integer i,j;
reg [3:0] k [0:3];
reg [1:0] k1,k2;
reg [63:0] test_vector[0:3];
ps_hp uut
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
    $dumpfile("ps_hp.vcd");
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
    k[0] = 4'b1000;
    k[1] = 4'b0100;
    k[2] = 4'b0010;
    k[3] = 4'b0001;
    k1=0;
    k2=0;
    #10;
    @(posedge clk);
    rst_n=0;
    @(posedge clk);
    rst_n=1;
    #30;
    
    for(m=0;m<128;m++) begin
        for(i=0;i<4;i=i+1) begin
            @(posedge clk);
            in_fetch_pc = test_vector[i][63:32]; 
            in_fetch_nop = 0;
            #1;
            $fdisplay(detailedresult,"############## CHECK PHASE START ###########");
            $fdisplay(detailedresult,"For address %h branch is %h and offset is %h",in_fetch_pc,out_fetch_branch_taken,out_pc_offset);
            if (out_fetch_branch_taken==k[in_fetch_pc[3:2]][k2]) begin
                if((out_fetch_branch_taken && out_pc_offset==i)||!out_fetch_branch_taken) begin
                    $fdisplay(detailedresult,"Prediction is right for address %h",in_fetch_pc);
                    prediction_true+=1;
                end        
                else begin
                    $fdisplay(detailedresult,"Prediction is NOT right for address %b",in_fetch_pc);
                    prediction_false+=1;
                end
            end
            else begin
                    $fdisplay(detailedresult,"Prediction is NOT right for address %b",in_fetch_pc);
                    prediction_false+=1;
            end
            $fdisplay(detailedresult,"############## CHECK PHASE END ###########\n");
        end
        k2+=1;
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
    for(l=0;l<128;l++) begin
        for(j=0;j<4;j=j+1) begin
            @(posedge clk);
            in_exe_pc             = test_vector[j][63:32]; 
            in_exe_branch_taken   = k[in_exe_pc[3:2]][k1];

            in_exe_branch_offset  = j;
            in_exe_nop            = 0;
        end
        k1 += 1;
    end
    in_exe_nop=1;
        
    $fdisplay(finalresult,"branch predict true=%d,branch predict false=%d",prediction_true,prediction_false);
    $display("branch predict true=%d,branch predict false=%d",prediction_true,prediction_false);
    $fclose(detailedresult);
    $fclose(finalresult);
    $finish;
end
endmodule


