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

module tb_dp #(
    parameter BHT_ENTERIES    = 128,
    parameter BTB_ENTERIES    = 32,
    parameter INSTR_SIZE_BYTE = 4
) 
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


input clk;
input rst_n;
input in_fetch_nop;
input [INSTR_SIZE_BYTE*8-1 :0] in_fetch_pc;
input in_exe_nop;
input [INSTR_SIZE_BYTE*8-1 :0] in_exe_pc;
input in_exe_branch_taken;
input [INSTR_SIZE_BYTE*8-1 :0] in_exe_branch_offset;
output [INSTR_SIZE_BYTE*8-1 :0] out_pc_offset;
output out_fetch_branch_taken;

reg [1:0] bht_entry [0:BHT_ENTERIES-1];
reg [INSTR_SIZE_BYTE*8-1 :0] btb_entry [0:BTB_ENTERIES-1];
reg [24:0] btb_tag [0:BTB_ENTERIES-1];


assign out_pc_offset = btb_entry[in_fetch_pc[6:2]];
assign out_fetch_branch_taken = bht_entry[in_fetch_pc[8:2]][1]&&(btb_tag[in_fetch_pc[6:2]]==in_fetch_pc[31:7]);
//Updating bht & btb

always@(posedge clk or negedge rst_n) begin
    if(rst_n) begin
        if(!in_exe_nop) begin
            if(in_exe_branch_taken) begin
                bht_entry[in_exe_pc[8:2]]  <= (bht_entry[in_exe_pc[8:2]]==2'b11) ? bht_entry[in_exe_pc[8:2]] : bht_entry[in_exe_pc[8:2]] + 1'b1   ;
                btb_entry[in_exe_pc[6:2]]  <=  in_exe_branch_offset;
                btb_tag[in_exe_pc[6:2]]    <=  in_exe_pc[31:7];
            end
            else if(!in_exe_branch_taken) begin
                bht_entry[in_exe_pc[8:2]]  <= (bht_entry[in_exe_pc[8:2]]==2'b00) ? bht_entry[in_exe_pc[8:2]] : bht_entry[in_exe_pc[8:2]] - 1'b1   ;
            end
        end
    end
    else if(!rst_n) begin
        bht_entry[0]  <=   0 ;bht_entry[1]  <=   0 ;bht_entry[2]  <=   0 ;bht_entry[3]  <=   0 ;bht_entry[4]  <=   0 ;bht_entry[5]  <=   0 ;bht_entry[6]  <=   0 ;bht_entry[7]  <=   0 ;bht_entry[8]  <=   0 ;bht_entry[9]  <=   0 ;
        bht_entry[10]  <=   0 ;bht_entry[11]  <=   0 ;bht_entry[12]  <=   0 ;bht_entry[13]  <=   0 ;bht_entry[14]  <=   0 ;bht_entry[15]  <=   0 ;bht_entry[16]  <=   0 ;bht_entry[17]  <=   0 ;bht_entry[18]  <=   0 ;bht_entry[19]  <=   0 ;
        bht_entry[20]  <=   0 ;bht_entry[21]  <=   0 ;bht_entry[22]  <=   0 ;bht_entry[23]  <=   0 ;bht_entry[24]  <=   0 ;bht_entry[25]  <=   0 ;bht_entry[26]  <=   0 ;bht_entry[27]  <=   0 ;bht_entry[28]  <=   0 ;bht_entry[29]  <=   0 ;
        bht_entry[30]  <=   0 ;bht_entry[31]  <=   0 ;bht_entry[32]  <=   0 ;bht_entry[33]  <=   0 ;bht_entry[34]  <=   0 ;bht_entry[35]  <=   0 ;bht_entry[36]  <=   0 ;bht_entry[37]  <=   0 ;bht_entry[38]  <=   0 ;bht_entry[39]  <=   0 ;
        bht_entry[40]  <=   0 ;bht_entry[41]  <=   0 ;bht_entry[42]  <=   0 ;bht_entry[43]  <=   0 ;bht_entry[44]  <=   0 ;bht_entry[45]  <=   0 ;bht_entry[46]  <=   0 ;bht_entry[47]  <=   0 ;bht_entry[48]  <=   0 ;bht_entry[49]  <=   0 ;
        bht_entry[50]  <=   0 ;bht_entry[51]  <=   0 ;bht_entry[52]  <=   0 ;bht_entry[53]  <=   0 ;bht_entry[54]  <=   0 ;bht_entry[55]  <=   0 ;bht_entry[56]  <=   0 ;bht_entry[57]  <=   0 ;bht_entry[58]  <=   0 ;bht_entry[59]  <=   0 ;
        bht_entry[60]  <=   0 ;bht_entry[61]  <=   0 ;bht_entry[62]  <=   0 ;bht_entry[63]  <=   0 ;bht_entry[64]  <=   0 ;bht_entry[65]  <=   0 ;bht_entry[66]  <=   0 ;bht_entry[67]  <=   0 ;bht_entry[68]  <=   0 ;bht_entry[69]  <=   0 ;
        bht_entry[70]  <=   0 ;bht_entry[71]  <=   0 ;bht_entry[72]  <=   0 ;bht_entry[73]  <=   0 ;bht_entry[74]  <=   0 ;bht_entry[75]  <=   0 ;bht_entry[76]  <=   0 ;bht_entry[77]  <=   0 ;bht_entry[78]  <=   0 ;bht_entry[79]  <=   0 ;
        bht_entry[80]  <=   0 ;bht_entry[81]  <=   0 ;bht_entry[82]  <=   0 ;bht_entry[83]  <=   0 ;bht_entry[84]  <=   0 ;bht_entry[85]  <=   0 ;bht_entry[86]  <=   0 ;bht_entry[87]  <=   0 ;bht_entry[88]  <=   0 ;bht_entry[89]  <=   0 ;
        bht_entry[90]  <=   0 ;bht_entry[91]  <=   0 ;bht_entry[92]  <=   0 ;bht_entry[93]  <=   0 ;bht_entry[94]  <=   0 ;bht_entry[95]  <=   0 ;bht_entry[96]  <=   0 ;bht_entry[97]  <=   0 ;bht_entry[98]  <=   0 ;bht_entry[99]  <=   0 ;
        bht_entry[100]  <=   0 ;bht_entry[101]  <=   0 ;bht_entry[102]  <=   0 ;bht_entry[103]  <=   0 ;bht_entry[104]  <=   0 ;bht_entry[105]  <=   0 ;bht_entry[106]  <=   0 ;bht_entry[107]  <=   0 ;bht_entry[108]  <=   0 ;bht_entry[109]  <=   0 ;
        bht_entry[110]  <=   0 ;bht_entry[111]  <=   0 ;bht_entry[112]  <=   0 ;bht_entry[113]  <=   0 ;bht_entry[114]  <=   0 ;bht_entry[115]  <=   0 ;bht_entry[116]  <=   0 ;bht_entry[117]  <=   0 ;bht_entry[118]  <=   0 ;bht_entry[119]  <=   0 ;
        bht_entry[120]  <=   0 ;bht_entry[121]  <=   0 ;bht_entry[122]  <=   0 ;bht_entry[123]  <=   0 ;bht_entry[124]  <=   0 ;bht_entry[125]  <=   0 ;bht_entry[126]  <=   0 ;bht_entry[127]  <=   0 ;
        btb_entry[0]  <=   0;
        btb_tag[0]    <=   0;
        btb_entry[1]  <=   0;
        btb_tag[1]    <=   0;
        btb_entry[2]  <=   0;
        btb_tag[2]    <=   0;
        btb_entry[3]  <=   0;
        btb_tag[3]    <=   0;
        btb_entry[4]  <=   0;
        btb_tag[4]    <=   0;
        btb_entry[5]  <=   0;
        btb_tag[5]    <=   0;
        btb_entry[6]  <=   0;
        btb_tag[6]    <=   0;
        btb_entry[7]  <=   0;
        btb_tag[7]    <=   0;
        btb_entry[8]  <=   0;
        btb_tag[8]    <=   0;
        btb_entry[9]  <=   0;
        btb_tag[9]    <=   0;
        btb_entry[10]  <=   0;
        btb_tag[10]    <=   0;
        btb_entry[11]  <=   0;
        btb_tag[11]    <=   0;
        btb_entry[12]  <=   0;
        btb_tag[12]    <=   0;
        btb_entry[13]  <=   0;
        btb_tag[13]    <=   0;
        btb_entry[14]  <=   0;
        btb_tag[14]    <=   0;
        btb_entry[15]  <=   0;
        btb_tag[15]    <=   0;
        btb_entry[16]  <=   0;
        btb_tag[16]    <=   0;
        btb_entry[17]  <=   0;
        btb_tag[17]    <=   0;
        btb_entry[18]  <=   0;
        btb_tag[18]    <=   0;
        btb_entry[19]  <=   0;
        btb_tag[19]    <=   0;
        btb_entry[20]  <=   0;
        btb_tag[20]    <=   0;
        btb_entry[21]  <=   0;
        btb_tag[21]    <=   0;
        btb_entry[22]  <=   0;
        btb_tag[22]    <=   0;
        btb_entry[23]  <=   0;
        btb_tag[23]    <=   0;
        btb_entry[24]  <=   0;
        btb_tag[24]    <=   0;
        btb_entry[25]  <=   0;
        btb_tag[25]    <=   0;
        btb_entry[26]  <=   0;
        btb_tag[26]    <=   0;
        btb_entry[27]  <=   0;
        btb_tag[27]    <=   0;
        btb_entry[28]  <=   0;
        btb_tag[28]    <=   0;
        btb_entry[29]  <=   0;
        btb_tag[29]    <=   0;
        btb_entry[30]  <=   0;
        btb_tag[30]    <=   0;
        btb_entry[31]  <=   0;
        btb_tag[31]    <=   0;
    end
end
endmodule
