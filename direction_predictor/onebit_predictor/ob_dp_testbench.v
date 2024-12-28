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
`include "ob_dp.v"
module ob_dp_testbench;
parameter BHT_ENTERIES    = 128;
parameter BTB_ENTERIES    = 32;
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
wire [INSTR_SIZE_BYTE*8-1 :0] out_pc_offset;
wire out_fetch_branch_taken;
reg no_branch_taken;
integer i,k,j,l,bht_pass,bht_fail,btb_pass,btb_fail,detailedresult,finalresult,branch_accurate,branch_not_accurate,branch_offset_accurate,branch_offset_not_accurate;
integer branch_taken,branch_mispredict,branch_predict_true,m,n,j1,j2,j3,j4,j5,j6,j7;
reg [63:0] test_vector[0:127];
ob_dp uut
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
    detailedresult = $fopen("detailed_result.txt");
end


initial begin
    $dumpfile("ob_dp.vcd");
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
    for(i=0;i<128;i=i+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[i][63:32]; 
        in_fetch_nop = 0;
        #1;
        //compulsary branch mis-prediction for first time.
        if(test_vector[i][0]==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==i)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
    end
//    @(posedge clk);
//    in_fetch_nop=1;
    $fdisplay(detailedresult,"************* FIRST ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* FIRST ITERATION IN THE SEQUENCE TTTTNNNN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* FIRST ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* FIRST ITERATION IN THE SEQUENCE TTTTNNNN\n *************");
    for(k=0;k<128;k=k+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[k][63:32]; 
        in_fetch_nop = 0;
        #1;
        if(test_vector[k][0]==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==k)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* SECOND ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* SECOND ITERATION IN THE SEQUENCE TTTTNNNN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* SECOND ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* SECOND ITERATION IN THE SEQUENCE TTTTNNNN\n *************");
    for(l=0;l<128;l=l+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[l][63:32]; 
        in_fetch_nop = 0;
        #1;
        if(test_vector[l][0]==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==l)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* THIRD ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* THIRD ITERATION IN THE SEQUENCE TTTTNNNN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* THIRD ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* THIRD ITERATION IN THE SEQUENCE TTTTNNNN\n *************");
    for(m=0;m<128;m=m+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[m][63:32]; 
        in_fetch_nop = 0;
        #1;
        if(test_vector[m][0]==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==m)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* FOURTH ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* FOURTH ITERATION IN THE SEQUENCE TTTTNNNN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* FOURTH ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* FOURTH ITERATION IN THE SEQUENCE TTTTNNNN\n *************");
    for(n=0;n<128;n=n+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[n][63:32]; 
        in_fetch_nop = 0;
        no_branch_taken=0;
        #1;
        if(no_branch_taken==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==n)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
        else if(no_branch_taken==0) begin
            if((out_fetch_branch_taken == 1)) begin
                branch_mispredict += 1;
            end
            else if(((n== 0)||(n==17)||(n==18)||(n==19))) begin
                branch_predict_true += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* FIFTH ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* FIFTH ITERATION IN THE SEQUENCE TTTTNNNN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* FIFTH ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* FIFTH ITERATION IN THE SEQUENCE TTTTNNNN\n *************");
    n=0;
    for(n=0;n<128;n=n+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[n][63:32]; 
        in_fetch_nop = 0;
        no_branch_taken=0;
        #1;
        if(no_branch_taken==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==n)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
        else if(no_branch_taken==0) begin
            if((out_fetch_branch_taken == 1)) begin
                branch_mispredict += 1;
            end
            else if(((n== 0)||(n==17)||(n==18)||(n==19))) begin
                branch_predict_true += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* SIXTH ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* SIXTH ITERATION IN THE SEQUENCE TTTTNNNN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* SIXTH ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* SIXTH ITERATION IN THE SEQUENCE TTTTNNNN\n *************");
    n=0;
    for(n=0;n<128;n=n+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[n][63:32]; 
        in_fetch_nop = 0;
        no_branch_taken=0;
        #1;
        if(no_branch_taken==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==n)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
        else if(no_branch_taken==0) begin
            if((out_fetch_branch_taken == 1)) begin
                branch_mispredict += 1;
            end
            else if(((n== 0)||(n==17)||(n==18)||(n==19))) begin
                branch_predict_true += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* SEVENTH ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* SEVENTH ITERATION IN THE SEQUENCE TTTTNNNN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* SEVENTH ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* SEVENTH ITERATION IN THE SEQUENCE TTTTNNNN\n *************");
    n=0;
    for(n=0;n<128;n=n+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[n][63:32]; 
        in_fetch_nop = 0;
        no_branch_taken=0;
        #1;
        if(no_branch_taken==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==n)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
        else if(no_branch_taken==0) begin
            if((out_fetch_branch_taken == 1)) begin
                branch_mispredict += 1;
            end
            else if(((n== 0)||(n==17)||(n==18)||(n==19))) begin
                branch_predict_true += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* EIGHT ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* EIGHT ITERATION IN THE SEQUENCE TTTTNNNN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* EIGHT ITERATION IN THE SEQUENCE TTTTNNNN *************");
    $display("************* EIGHT ITERATION IN THE SEQUENCE TTTTNNNN\n *************");
    branch_taken=0;branch_predict_true=0;branch_mispredict=0;
    for(i=0;i<128;i=i+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[i][63:32]; 
        in_fetch_nop = 0;
        #1;
        if(test_vector[i][0]==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==i)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
    end
//    @(posedge clk);
//    in_fetch_nop=1;
    $fdisplay(detailedresult,"************* FIRST ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* FIRST ITERATION IN THE SEQUENCE TNTNTNTN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* FIRST ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* FIRST ITERATION IN THE SEQUENCE TNTNTNTN\n *************");
    for(k=0;k<128;k=k+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[k][63:32]; 
        in_fetch_nop = 0;
        no_branch_taken=0;
        #1;
        if(no_branch_taken==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==k)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
        else if(no_branch_taken==0) begin
            if((out_fetch_branch_taken == 1)) begin
                branch_mispredict += 1;
            end
            else if(((n== 0)||(n==17)||(n==18)||(n==19))) begin
                branch_predict_true += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* SECOND ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* SECOND ITERATION IN THE SEQUENCE TNTNTNTN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* SECOND ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* SECOND ITERATION IN THE SEQUENCE TNTNTNTN\n *************");
    for(l=0;l<128;l=l+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[l][63:32]; 
        in_fetch_nop = 0;
        #1;
        if(test_vector[l][0]==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==l)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* THIRD ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* THIRD ITERATION IN THE SEQUENCE TNTNTNTN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* THIRD ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* THIRD ITERATION IN THE SEQUENCE TNTNTNTN\n *************");
    for(m=0;m<128;m=m+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[m][63:32]; 
        in_fetch_nop = 0;
        no_branch_taken=0;
        #1;
        if(no_branch_taken==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==m)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
        else if(no_branch_taken==0) begin
            if((out_fetch_branch_taken == 1)) begin
                branch_mispredict += 1;
            end
            else if(((n== 0)||(n==17)||(n==18)||(n==19))) begin
                branch_predict_true += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* FOURTH ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* FOURTH ITERATION IN THE SEQUENCE TNTNTNTN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* FOURTH ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* FOURTH ITERATION IN THE SEQUENCE TNTNTNTN\n *************");
    for(l=0;l<128;l=l+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[l][63:32]; 
        in_fetch_nop = 0;
        #1;
        if(test_vector[l][0]==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==l)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* FIFTH ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* FIFTH ITERATION IN THE SEQUENCE TNTNTNTN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* FIFTH ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* FIFTH ITERATION IN THE SEQUENCE TNTNTNTN\n *************");
    n=0;
    for(n=0;n<128;n=n+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[n][63:32]; 
        in_fetch_nop = 0;
        no_branch_taken=0;
        #1;
        if(no_branch_taken==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==n)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
        else if(no_branch_taken==0) begin
            if((out_fetch_branch_taken == 1)) begin
                branch_mispredict += 1;
            end
            else if(((n== 0)||(n==17)||(n==18)||(n==19))) begin
                branch_predict_true += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* SIXTH ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* SIXTH ITERATION IN THE SEQUENCE TNTNTNTN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* SIXTH ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* SIXTH ITERATION IN THE SEQUENCE TNTNTNTN\n *************");
    n=0;
    for(l=0;l<128;l=l+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[l][63:32]; 
        in_fetch_nop = 0;
        #1;
        if(test_vector[l][0]==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==l)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* SEVENTH ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* SEVENTH ITERATION IN THE SEQUENCE TNTNTNTN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* SEVENTH ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* SEVENTH ITERATION IN THE SEQUENCE TNTNTNTN\n *************");
    n=0;
    for(n=0;n<128;n=n+1) begin
        @(posedge clk);
        in_fetch_pc = test_vector[n][63:32]; 
        in_fetch_nop = 0;
        no_branch_taken=0;
        #1;
        if(no_branch_taken==1) begin
            branch_taken += 1;
            if((out_fetch_branch_taken == 1)&&(out_pc_offset==n)) begin
                branch_predict_true += 1;
            end
            else begin
                branch_mispredict += 1;
            end
        end 
        else if(no_branch_taken==0) begin
            if((out_fetch_branch_taken == 1)) begin
                branch_mispredict += 1;
            end
            else if(((n== 0)||(n==17)||(n==18)||(n==19))) begin
                branch_predict_true += 1;
            end
        end 
    end
    $fdisplay(detailedresult,"************* EIGHT ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* EIGHT ITERATION IN THE SEQUENCE TNTNTNTN *************\n");
    $fdisplay(detailedresult,"branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d",branch_taken,branch_predict_true,branch_mispredict);
    $display("branch_taken=%d,branch_predict_true=%d, branch_mis-prediction=%d\n",branch_taken,branch_predict_true,branch_mispredict);
    $fdisplay(detailedresult,"************* EIGHT ITERATION IN THE SEQUENCE TNTNTNTN *************");
    $display("************* EIGHT ITERATION IN THE SEQUENCE TNTNTNTN\n *************");

    //$finish;
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
    for(j=0;j<128;j=j+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j][63:32]; 
        in_exe_branch_taken   = | test_vector[j][31:0];
        in_exe_branch_offset  = j;
        in_exe_nop            = 0;
    end
    for(j1=0;j1<128;j1=j1+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j1][63:32]; 
        in_exe_branch_taken   = | test_vector[j1][31:0];
        in_exe_branch_offset  = j1;
        in_exe_nop            = 0;
    end
    for(j2=0;j2<128;j2=j2+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j2][63:32]; 
        in_exe_branch_taken   = | test_vector[j2][31:0];
        in_exe_branch_offset  = j2;
        in_exe_nop            = 0;
    end
    for(j3=0;j3<128;j3=j3+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j3][63:32]; 
        in_exe_branch_taken   = | test_vector[j3][31:0];
        in_exe_branch_offset  = j3;
        in_exe_nop            = 0;
    end
    for(j4=0;j4<128;j4=j4+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j4][63:32]; 
        in_exe_branch_taken   = 0;
        in_exe_branch_offset  = j4;
        in_exe_nop            = 0;
    end
    for(j5=0;j5<128;j5=j5+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j5][63:32]; 
        in_exe_branch_taken   = 0;
        in_exe_branch_offset  = j5;
        in_exe_nop            = 0;
    end
    for(j6=0;j6<128;j6=j6+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j6][63:32]; 
        in_exe_branch_taken   = 0;
        in_exe_branch_offset  = j6;
        in_exe_nop            = 0;
    end
    for(j7=0;j7<128;j7=j7+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j7][63:32]; 
        in_exe_branch_taken   = 0;
        in_exe_branch_offset  = j7;
        in_exe_nop            = 0;
    end
    for(j=0;j<128;j=j+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j][63:32]; 
        in_exe_branch_taken   = | test_vector[j][31:0];
        in_exe_branch_offset  = j;
        in_exe_nop            = 0;
    end
    for(j1=0;j1<128;j1=j1+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j1][63:32]; 
        in_exe_branch_taken   = 0;
        in_exe_branch_offset  = j1;
        in_exe_nop            = 0;
    end
    for(j2=0;j2<128;j2=j2+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j2][63:32]; 
        in_exe_branch_taken   = | test_vector[j2][31:0];
        in_exe_branch_offset  = j2;
        in_exe_nop            = 0;
    end
    for(j3=0;j3<128;j3=j3+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j3][63:32]; 
        in_exe_branch_taken   = 0;
        in_exe_branch_offset  = j3;
        in_exe_nop            = 0;
    end
    for(j4=0;j4<128;j4=j4+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j4][63:32]; 
        in_exe_branch_taken   = | test_vector[j4][31:0];
        in_exe_branch_offset  = j4;
        in_exe_nop            = 0;
    end
    for(j5=0;j5<128;j5=j5+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j5][63:32]; 
        in_exe_branch_taken   = 0;
        in_exe_branch_offset  = j5;
        in_exe_nop            = 0;
    end
    for(j6=0;j6<128;j6=j6+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j6][63:32]; 
        in_exe_branch_taken   = | test_vector[j6][31:0];
        in_exe_branch_offset  = j6;
        in_exe_nop            = 0;
    end
    for(j7=0;j7<128;j7=j7+1) begin
        @(posedge clk);
        in_exe_pc             = test_vector[j7][63:32]; 
        in_exe_branch_taken   = 0;
        in_exe_branch_offset  = j7;
        in_exe_nop            = 0;
    end
    $fclose(detailedresult);
    $finish;

end
endmodule


