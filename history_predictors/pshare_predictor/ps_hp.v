module ps_hp #(
    parameter INSTR_SIZE_BYTE = 4,
    parameter BHT_ENTERIES = 16,
    parameter BTB_ENTERIES = 256,
    parameter PHP_ENTRIES = 4
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

reg [1:0] bht_entry_php_0 [0:BHT_ENTERIES-1];
reg [1:0] bht_entry_php_1 [0:BHT_ENTERIES-1];
reg [1:0] bht_entry_php_2 [0:BHT_ENTERIES-1];
reg [1:0] bht_entry_php_3 [0:BHT_ENTERIES-1];

reg [INSTR_SIZE_BYTE*8-1 :0] btb_entry [0:BTB_ENTERIES-1];
reg [21:0] btb_tag [0:BTB_ENTERIES-1];

reg [PHP_ENTRIES-1 :0] php_entry [0:PHP_ENTRIES-1];

assign out_pc_offset = btb_entry[in_fetch_pc[9:2]];
assign out_fetch_branch_taken = (((in_fetch_pc[3:2]==0)&&(bht_entry_php_0[php_entry[0]][1])) ||
                                 ((in_fetch_pc[3:2]==1)&&(bht_entry_php_1[php_entry[1]][1])) ||
                                 ((in_fetch_pc[3:2]==2)&&(bht_entry_php_2[php_entry[2]][1])) ||
                                 ((in_fetch_pc[3:2]==3)&&(bht_entry_php_3[php_entry[3]][1])) ) &&(btb_tag[in_fetch_pc[9:2]]==in_fetch_pc[31:10])&&!in_fetch_nop;



always@(posedge clk or negedge rst_n) begin
    if(rst_n) begin
        if(!in_exe_nop) begin
            if(in_exe_pc[3:2]==0)
                php_entry[0] <= {php_entry[0][2:0],in_exe_branch_taken};
            else if(in_exe_pc[3:2]==1)
                php_entry[1] <= {php_entry[1][2:0],in_exe_branch_taken};
            else if(in_exe_pc[3:2]==2)
                php_entry[2] <= {php_entry[2][2:0],in_exe_branch_taken};
            else if(in_exe_pc[3:2]==3)
                php_entry[3] <= {php_entry[3][2:0],in_exe_branch_taken};
            if(in_exe_branch_taken) begin
                btb_entry[in_exe_pc[9:2]]  <=  in_exe_branch_offset;
                btb_tag[in_exe_pc[9:2]]    <=  in_exe_pc[31:10];
                if(in_exe_pc[3:2]==0)
                    bht_entry_php_0[php_entry[0]]  <= (bht_entry_php_0[php_entry[0]]==2'b11) ? bht_entry_php_0[php_entry[0]] : bht_entry_php_0[php_entry[0]] + 1'b1   ;
                else if(in_exe_pc[3:2]==1)
                    bht_entry_php_1[php_entry[1]]  <= (bht_entry_php_1[php_entry[1]]==2'b11) ? bht_entry_php_1[php_entry[1]] : bht_entry_php_1[php_entry[1]] + 1'b1   ;
                else if(in_exe_pc[3:2]==2)
                    bht_entry_php_2[php_entry[2]]  <= (bht_entry_php_2[php_entry[2]]==2'b11) ? bht_entry_php_2[php_entry[2]] : bht_entry_php_2[php_entry[2]] + 1'b1   ;
                else if(in_exe_pc[3:2]==3)
                    bht_entry_php_3[php_entry[3]]  <= (bht_entry_php_3[php_entry[3]]==2'b11) ? bht_entry_php_3[php_entry[3]] : bht_entry_php_3[php_entry[3]] + 1'b1   ;
            end
            else if(!in_exe_branch_taken) begin
                if(in_exe_pc[3:2]==0)
                    bht_entry_php_0[php_entry[0]]  <= (bht_entry_php_0[php_entry[0]]==2'b00) ? bht_entry_php_0[php_entry[0]] : bht_entry_php_0[php_entry[0]] - 1'b1   ;
                else if(in_exe_pc[3:2]==1)
                    bht_entry_php_1[php_entry[1]]  <= (bht_entry_php_1[php_entry[1]]==2'b00) ? bht_entry_php_1[php_entry[1]] : bht_entry_php_1[php_entry[1]] - 1'b1   ;
                else if(in_exe_pc[3:2]==2)
                    bht_entry_php_2[php_entry[2]]  <= (bht_entry_php_2[php_entry[2]]==2'b00) ? bht_entry_php_2[php_entry[2]] : bht_entry_php_2[php_entry[2]] - 1'b1   ;
                else if(in_exe_pc[3:2]==3)
                    bht_entry_php_3[php_entry[3]]  <= (bht_entry_php_3[php_entry[3]]==2'b00) ? bht_entry_php_3[php_entry[3]] : bht_entry_php_3[php_entry[3]] - 1'b1   ;
            end
        end
    end
    else if(!rst_n) begin
        php_entry[0] <=0;
        php_entry[1] <= 0;
        php_entry[2] <= 0;
        php_entry[3] <= 0;
        bht_entry_php_0[0]  <=   0 ;bht_entry_php_0[1]  <=   0 ;bht_entry_php_0[2]  <=   0 ;bht_entry_php_0[3]  <=   0 ;bht_entry_php_0[4]  <=   0 ;bht_entry_php_0[5]  <=   0 ;bht_entry_php_0[6]  <=   0 ;bht_entry_php_0[7]  <=   0 ;bht_entry_php_0[8]  <=   0 ;bht_entry_php_0[9]  <=   0 ;
        bht_entry_php_0[10]  <=   0 ;bht_entry_php_0[11]  <=   0 ;bht_entry_php_0[12]  <=   0 ;bht_entry_php_0[13]  <=   0 ;bht_entry_php_0[14]  <=   0 ;bht_entry_php_0[15]  <=   0 ;bht_entry_php_1[0]  <=   0 ;bht_entry_php_1[1]  <=   0 ;bht_entry_php_1[2]  <=   0 ;bht_entry_php_1[3]  <=   0 ;bht_entry_php_1[4]  <=   0 ;bht_entry_php_1[5]  <=   0 ;bht_entry_php_1[6]  <=   0 ;bht_entry_php_1[7]  <=   0 ;bht_entry_php_1[8]  <=   0 ;bht_entry_php_1[9]  <=   0 ;
        bht_entry_php_1[10]  <=   0 ;bht_entry_php_1[11]  <=   0 ;bht_entry_php_1[12]  <=   0 ;bht_entry_php_1[13]  <=   0 ;bht_entry_php_1[14]  <=   0 ;bht_entry_php_1[15]  <=   0 ;bht_entry_php_2[0]  <=   0 ;bht_entry_php_2[1]  <=   0 ;bht_entry_php_2[2]  <=   0 ;bht_entry_php_2[3]  <=   0 ;bht_entry_php_2[4]  <=   0 ;bht_entry_php_2[5]  <=   0 ;bht_entry_php_2[6]  <=   0 ;bht_entry_php_2[7]  <=   0 ;bht_entry_php_2[8]  <=   0 ;bht_entry_php_2[9]  <=   0 ;
        bht_entry_php_2[10]  <=   0 ;bht_entry_php_2[11]  <=   0 ;bht_entry_php_2[12]  <=   0 ;bht_entry_php_2[13]  <=   0 ;bht_entry_php_2[14]  <=   0 ;bht_entry_php_2[15]  <=   0 ;bht_entry_php_3[0]  <=   0 ;bht_entry_php_3[1]  <=   0 ;bht_entry_php_3[2]  <=   0 ;bht_entry_php_3[3]  <=   0 ;bht_entry_php_3[4]  <=   0 ;bht_entry_php_3[5]  <=   0 ;bht_entry_php_3[6]  <=   0 ;bht_entry_php_3[7]  <=   0 ;bht_entry_php_3[8]  <=   0 ;bht_entry_php_3[9]  <=   0 ;
        bht_entry_php_3[10]  <=   0 ;bht_entry_php_3[11]  <=   0 ;bht_entry_php_3[12]  <=   0 ;bht_entry_php_3[13]  <=   0 ;bht_entry_php_3[14]  <=   0 ;bht_entry_php_3[15]  <=   0 ;
        btb_entry[0]  <=   0;btb_tag[0]    <=   0;btb_entry[1]  <=   0;btb_tag[1]    <=   0;btb_entry[2]  <=   0;btb_tag[2]    <=   0;btb_entry[3]  <=   0;btb_tag[3]    <=   0;btb_entry[4]  <=   0;btb_tag[4]    <=   0;btb_entry[5]  <=   0;btb_tag[5]    <=   0;btb_entry[6]  <=   0;btb_tag[6]    <=   0;btb_entry[7]  <=   0;btb_tag[7]    <=   0;btb_entry[8]  <=   0;btb_tag[8]    <=   0;btb_entry[9]  <=   0;btb_tag[9]    <=   0;
        btb_entry[10]  <=   0;btb_tag[10]    <=   0;btb_entry[11]  <=   0;btb_tag[11]    <=   0;btb_entry[12]  <=   0;btb_tag[12]    <=   0;btb_entry[13]  <=   0;btb_tag[13]    <=   0;btb_entry[14]  <=   0;btb_tag[14]    <=   0;btb_entry[15]  <=   0;btb_tag[15]    <=   0;btb_entry[16]  <=   0;btb_tag[16]    <=   0;btb_entry[17]  <=   0;btb_tag[17]    <=   0;btb_entry[18]  <=   0;btb_tag[18]    <=   0;btb_entry[19]  <=   0;btb_tag[19]    <=   0;
        btb_entry[20]  <=   0;btb_tag[20]    <=   0;btb_entry[21]  <=   0;btb_tag[21]    <=   0;btb_entry[22]  <=   0;btb_tag[22]    <=   0;btb_entry[23]  <=   0;btb_tag[23]    <=   0;btb_entry[24]  <=   0;btb_tag[24]    <=   0;btb_entry[25]  <=   0;btb_tag[25]    <=   0;btb_entry[26]  <=   0;btb_tag[26]    <=   0;btb_entry[27]  <=   0;btb_tag[27]    <=   0;btb_entry[28]  <=   0;btb_tag[28]    <=   0;btb_entry[29]  <=   0;btb_tag[29]    <=   0;
        btb_entry[30]  <=   0;btb_tag[30]    <=   0;btb_entry[31]  <=   0;btb_tag[31]    <=   0;btb_entry[32]  <=   0;btb_tag[32]    <=   0;btb_entry[33]  <=   0;btb_tag[33]    <=   0;btb_entry[34]  <=   0;btb_tag[34]    <=   0;btb_entry[35]  <=   0;btb_tag[35]    <=   0;btb_entry[36]  <=   0;btb_tag[36]    <=   0;btb_entry[37]  <=   0;btb_tag[37]    <=   0;btb_entry[38]  <=   0;btb_tag[38]    <=   0;btb_entry[39]  <=   0;btb_tag[39]    <=   0;
        btb_entry[40]  <=   0;btb_tag[40]    <=   0;btb_entry[41]  <=   0;btb_tag[41]    <=   0;btb_entry[42]  <=   0;btb_tag[42]    <=   0;btb_entry[43]  <=   0;btb_tag[43]    <=   0;btb_entry[44]  <=   0;btb_tag[44]    <=   0;btb_entry[45]  <=   0;btb_tag[45]    <=   0;btb_entry[46]  <=   0;btb_tag[46]    <=   0;btb_entry[47]  <=   0;btb_tag[47]    <=   0;btb_entry[48]  <=   0;btb_tag[48]    <=   0;btb_entry[49]  <=   0;btb_tag[49]    <=   0;
        btb_entry[50]  <=   0;btb_tag[50]    <=   0;btb_entry[51]  <=   0;btb_tag[51]    <=   0;btb_entry[52]  <=   0;btb_tag[52]    <=   0;btb_entry[53]  <=   0;btb_tag[53]    <=   0;btb_entry[54]  <=   0;btb_tag[54]    <=   0;btb_entry[55]  <=   0;btb_tag[55]    <=   0;btb_entry[56]  <=   0;btb_tag[56]    <=   0;btb_entry[57]  <=   0;btb_tag[57]    <=   0;btb_entry[58]  <=   0;btb_tag[58]    <=   0;btb_entry[59]  <=   0;btb_tag[59]    <=   0;
        btb_entry[60]  <=   0;btb_tag[60]    <=   0;btb_entry[61]  <=   0;btb_tag[61]    <=   0;btb_entry[62]  <=   0;btb_tag[62]    <=   0;btb_entry[63]  <=   0;btb_tag[63]    <=   0;btb_entry[64]  <=   0;btb_tag[64]    <=   0;btb_entry[65]  <=   0;btb_tag[65]    <=   0;btb_entry[66]  <=   0;btb_tag[66]    <=   0;btb_entry[67]  <=   0;btb_tag[67]    <=   0;btb_entry[68]  <=   0;btb_tag[68]    <=   0;btb_entry[69]  <=   0;btb_tag[69]    <=   0;
        btb_entry[70]  <=   0;btb_tag[70]    <=   0;btb_entry[71]  <=   0;btb_tag[71]    <=   0;btb_entry[72]  <=   0;btb_tag[72]    <=   0;btb_entry[73]  <=   0;btb_tag[73]    <=   0;btb_entry[74]  <=   0;btb_tag[74]    <=   0;btb_entry[75]  <=   0;btb_tag[75]    <=   0;btb_entry[76]  <=   0;btb_tag[76]    <=   0;btb_entry[77]  <=   0;btb_tag[77]    <=   0;btb_entry[78]  <=   0;btb_tag[78]    <=   0;btb_entry[79]  <=   0;btb_tag[79]    <=   0;
        btb_entry[80]  <=   0;btb_tag[80]    <=   0;btb_entry[81]  <=   0;btb_tag[81]    <=   0;btb_entry[82]  <=   0;btb_tag[82]    <=   0;btb_entry[83]  <=   0;btb_tag[83]    <=   0;btb_entry[84]  <=   0;btb_tag[84]    <=   0;btb_entry[85]  <=   0;btb_tag[85]    <=   0;btb_entry[86]  <=   0;btb_tag[86]    <=   0;btb_entry[87]  <=   0;btb_tag[87]    <=   0;btb_entry[88]  <=   0;btb_tag[88]    <=   0;btb_entry[89]  <=   0;btb_tag[89]    <=   0;
        btb_entry[90]  <=   0;btb_tag[90]    <=   0;btb_entry[91]  <=   0;btb_tag[91]    <=   0;btb_entry[92]  <=   0;btb_tag[92]    <=   0;btb_entry[93]  <=   0;btb_tag[93]    <=   0;btb_entry[94]  <=   0;btb_tag[94]    <=   0;btb_entry[95]  <=   0;btb_tag[95]    <=   0;btb_entry[96]  <=   0;btb_tag[96]    <=   0;btb_entry[97]  <=   0;btb_tag[97]    <=   0;btb_entry[98]  <=   0;btb_tag[98]    <=   0;btb_entry[99]  <=   0;btb_tag[99]    <=   0;
        btb_entry[100]  <=   0;btb_tag[100]    <=   0;btb_entry[101]  <=   0;btb_tag[101]    <=   0;btb_entry[102]  <=   0;btb_tag[102]    <=   0;btb_entry[103]  <=   0;btb_tag[103]    <=   0;btb_entry[104]  <=   0;btb_tag[104]    <=   0;btb_entry[105]  <=   0;btb_tag[105]    <=   0;btb_entry[106]  <=   0;btb_tag[106]    <=   0;btb_entry[107]  <=   0;btb_tag[107]    <=   0;btb_entry[108]  <=   0;btb_tag[108]    <=   0;btb_entry[109]  <=   0;btb_tag[109]    <=   0;
        btb_entry[110]  <=   0;btb_tag[110]    <=   0;btb_entry[111]  <=   0;btb_tag[111]    <=   0;btb_entry[112]  <=   0;btb_tag[112]    <=   0;btb_entry[113]  <=   0;btb_tag[113]    <=   0;btb_entry[114]  <=   0;btb_tag[114]    <=   0;btb_entry[115]  <=   0;btb_tag[115]    <=   0;btb_entry[116]  <=   0;btb_tag[116]    <=   0;btb_entry[117]  <=   0;btb_tag[117]    <=   0;btb_entry[118]  <=   0;btb_tag[118]    <=   0;btb_entry[119]  <=   0;btb_tag[119]    <=   0;
        btb_entry[120]  <=   0;btb_tag[120]    <=   0;btb_entry[121]  <=   0;btb_tag[121]    <=   0;btb_entry[122]  <=   0;btb_tag[122]    <=   0;btb_entry[123]  <=   0;btb_tag[123]    <=   0;btb_entry[124]  <=   0;btb_tag[124]    <=   0;btb_entry[125]  <=   0;btb_tag[125]    <=   0;btb_entry[126]  <=   0;btb_tag[126]    <=   0;btb_entry[127]  <=   0;btb_tag[127]    <=   0;btb_entry[128]  <=   0;btb_tag[128]    <=   0;btb_entry[129]  <=   0;btb_tag[129]    <=   0;
        btb_entry[130]  <=   0;btb_tag[130]    <=   0;btb_entry[131]  <=   0;btb_tag[131]    <=   0;btb_entry[132]  <=   0;btb_tag[132]    <=   0;btb_entry[133]  <=   0;btb_tag[133]    <=   0;btb_entry[134]  <=   0;btb_tag[134]    <=   0;btb_entry[135]  <=   0;btb_tag[135]    <=   0;btb_entry[136]  <=   0;btb_tag[136]    <=   0;btb_entry[137]  <=   0;btb_tag[137]    <=   0;btb_entry[138]  <=   0;btb_tag[138]    <=   0;btb_entry[139]  <=   0;btb_tag[139]    <=   0;
        btb_entry[140]  <=   0;btb_tag[140]    <=   0;btb_entry[141]  <=   0;btb_tag[141]    <=   0;btb_entry[142]  <=   0;btb_tag[142]    <=   0;btb_entry[143]  <=   0;btb_tag[143]    <=   0;btb_entry[144]  <=   0;btb_tag[144]    <=   0;btb_entry[145]  <=   0;btb_tag[145]    <=   0;btb_entry[146]  <=   0;btb_tag[146]    <=   0;btb_entry[147]  <=   0;btb_tag[147]    <=   0;btb_entry[148]  <=   0;btb_tag[148]    <=   0;btb_entry[149]  <=   0;btb_tag[149]    <=   0;
        btb_entry[150]  <=   0;btb_tag[150]    <=   0;btb_entry[151]  <=   0;btb_tag[151]    <=   0;btb_entry[152]  <=   0;btb_tag[152]    <=   0;btb_entry[153]  <=   0;btb_tag[153]    <=   0;btb_entry[154]  <=   0;btb_tag[154]    <=   0;btb_entry[155]  <=   0;btb_tag[155]    <=   0;btb_entry[156]  <=   0;btb_tag[156]    <=   0;btb_entry[157]  <=   0;btb_tag[157]    <=   0;btb_entry[158]  <=   0;btb_tag[158]    <=   0;btb_entry[159]  <=   0;btb_tag[159]    <=   0;
        btb_entry[160]  <=   0;btb_tag[160]    <=   0;btb_entry[161]  <=   0;btb_tag[161]    <=   0;btb_entry[162]  <=   0;btb_tag[162]    <=   0;btb_entry[163]  <=   0;btb_tag[163]    <=   0;btb_entry[164]  <=   0;btb_tag[164]    <=   0;btb_entry[165]  <=   0;btb_tag[165]    <=   0;btb_entry[166]  <=   0;btb_tag[166]    <=   0;btb_entry[167]  <=   0;btb_tag[167]    <=   0;btb_entry[168]  <=   0;btb_tag[168]    <=   0;btb_entry[169]  <=   0;btb_tag[169]    <=   0;
        btb_entry[170]  <=   0;btb_tag[170]    <=   0;btb_entry[171]  <=   0;btb_tag[171]    <=   0;btb_entry[172]  <=   0;btb_tag[172]    <=   0;btb_entry[173]  <=   0;btb_tag[173]    <=   0;btb_entry[174]  <=   0;btb_tag[174]    <=   0;btb_entry[175]  <=   0;btb_tag[175]    <=   0;btb_entry[176]  <=   0;btb_tag[176]    <=   0;btb_entry[177]  <=   0;btb_tag[177]    <=   0;btb_entry[178]  <=   0;btb_tag[178]    <=   0;btb_entry[179]  <=   0;btb_tag[179]    <=   0;
        btb_entry[180]  <=   0;btb_tag[180]    <=   0;btb_entry[181]  <=   0;btb_tag[181]    <=   0;btb_entry[182]  <=   0;btb_tag[182]    <=   0;btb_entry[183]  <=   0;btb_tag[183]    <=   0;btb_entry[184]  <=   0;btb_tag[184]    <=   0;btb_entry[185]  <=   0;btb_tag[185]    <=   0;btb_entry[186]  <=   0;btb_tag[186]    <=   0;btb_entry[187]  <=   0;btb_tag[187]    <=   0;btb_entry[188]  <=   0;btb_tag[188]    <=   0;btb_entry[189]  <=   0;btb_tag[189]    <=   0;
        btb_entry[190]  <=   0;btb_tag[190]    <=   0;btb_entry[191]  <=   0;btb_tag[191]    <=   0;btb_entry[192]  <=   0;btb_tag[192]    <=   0;btb_entry[193]  <=   0;btb_tag[193]    <=   0;btb_entry[194]  <=   0;btb_tag[194]    <=   0;btb_entry[195]  <=   0;btb_tag[195]    <=   0;btb_entry[196]  <=   0;btb_tag[196]    <=   0;btb_entry[197]  <=   0;btb_tag[197]    <=   0;btb_entry[198]  <=   0;btb_tag[198]    <=   0;btb_entry[199]  <=   0;btb_tag[199]    <=   0;
        btb_entry[200]  <=   0;btb_tag[200]    <=   0;btb_entry[201]  <=   0;btb_tag[201]    <=   0;btb_entry[202]  <=   0;btb_tag[202]    <=   0;btb_entry[203]  <=   0;btb_tag[203]    <=   0;btb_entry[204]  <=   0;btb_tag[204]    <=   0;btb_entry[205]  <=   0;btb_tag[205]    <=   0;btb_entry[206]  <=   0;btb_tag[206]    <=   0;btb_entry[207]  <=   0;btb_tag[207]    <=   0;btb_entry[208]  <=   0;btb_tag[208]    <=   0;btb_entry[209]  <=   0;btb_tag[209]    <=   0;
        btb_entry[210]  <=   0;btb_tag[210]    <=   0;btb_entry[211]  <=   0;btb_tag[211]    <=   0;btb_entry[212]  <=   0;btb_tag[212]    <=   0;btb_entry[213]  <=   0;btb_tag[213]    <=   0;btb_entry[214]  <=   0;btb_tag[214]    <=   0;btb_entry[215]  <=   0;btb_tag[215]    <=   0;btb_entry[216]  <=   0;btb_tag[216]    <=   0;btb_entry[217]  <=   0;btb_tag[217]    <=   0;btb_entry[218]  <=   0;btb_tag[218]    <=   0;btb_entry[219]  <=   0;btb_tag[219]    <=   0;
        btb_entry[220]  <=   0;btb_tag[220]    <=   0;btb_entry[221]  <=   0;btb_tag[221]    <=   0;btb_entry[222]  <=   0;btb_tag[222]    <=   0;btb_entry[223]  <=   0;btb_tag[223]    <=   0;btb_entry[224]  <=   0;btb_tag[224]    <=   0;btb_entry[225]  <=   0;btb_tag[225]    <=   0;btb_entry[226]  <=   0;btb_tag[226]    <=   0;btb_entry[227]  <=   0;btb_tag[227]    <=   0;btb_entry[228]  <=   0;btb_tag[228]    <=   0;btb_entry[229]  <=   0;btb_tag[229]    <=   0;
        btb_entry[230]  <=   0;btb_tag[230]    <=   0;btb_entry[231]  <=   0;btb_tag[231]    <=   0;btb_entry[232]  <=   0;btb_tag[232]    <=   0;btb_entry[233]  <=   0;btb_tag[233]    <=   0;btb_entry[234]  <=   0;btb_tag[234]    <=   0;btb_entry[235]  <=   0;btb_tag[235]    <=   0;btb_entry[236]  <=   0;btb_tag[236]    <=   0;btb_entry[237]  <=   0;btb_tag[237]    <=   0;btb_entry[238]  <=   0;btb_tag[238]    <=   0;btb_entry[239]  <=   0;btb_tag[239]    <=   0;
        btb_entry[240]  <=   0;btb_tag[240]    <=   0;btb_entry[241]  <=   0;btb_tag[241]    <=   0;btb_entry[242]  <=   0;btb_tag[242]    <=   0;btb_entry[243]  <=   0;btb_tag[243]    <=   0;btb_entry[244]  <=   0;btb_tag[244]    <=   0;btb_entry[245]  <=   0;btb_tag[245]    <=   0;btb_entry[246]  <=   0;btb_tag[246]    <=   0;btb_entry[247]  <=   0;btb_tag[247]    <=   0;btb_entry[248]  <=   0;btb_tag[248]    <=   0;btb_entry[249]  <=   0;btb_tag[249]    <=   0;
        btb_entry[250]  <=   0;btb_tag[250]    <=   0;btb_entry[251]  <=   0;btb_tag[251]    <=   0;btb_entry[252]  <=   0;btb_tag[252]    <=   0;btb_entry[253]  <=   0;btb_tag[253]    <=   0;btb_entry[254]  <=   0;btb_tag[254]    <=   0;btb_entry[255]  <=   0;btb_tag[255]    <=   0;
    end
end

endmodule