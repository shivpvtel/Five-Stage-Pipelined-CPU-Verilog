`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: shiv patel
// 
// Create Date: 04/11/2022 12:25:54 AM
// Design Name: 
// Module Name: Main
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
`timescale 1ns / 1ps

/****************************************************/
module ProgramCounter(
    input wire [31:0] nextPc,
    input wire clk,
  output reg [31:0] PC
    );
    initial begin
        PC = 100;
        end
        always @(posedge clk) begin
        PC <= nextPc;
        end
    endmodule

module InstructionMemory(
  input wire [31:0] PC,
output reg [31:0] instOut
);
reg [31:0] memory [0:63];
initial begin

    memory[25] = {6'b100011, 5'b00001, 5'b00010, 5'b00000, 5'b00000, 6'b000000};
    memory[26] = {6'b100011, 5'b00001, 5'b00011, 5'b00000, 5'b00000, 6'b000100};
    memory[27] = {6'b100011, 5'b00001, 5'b00100, 5'b00000, 5'b00000, 6'b001000};
    memory[28] = {6'b100011, 5'b00001, 5'b00101, 5'b00000, 5'b00000, 6'b001100};
    memory[29] = {6'b000000, 5'b00010, 5'b01010, 5'b00110, 5'b00000, 6'b100000};
  
   /* memory[0] = 64'hA000000AA;
    memory[1] = 64'h100000011;
    memory[2] = 64'h200000022;
    memory[3] = 64'h300000033;
    memory[4] = 64'h400000044;
    memory[5] = 64'h500000055;
    memory[6] = 64'h600000066;
    memory[7] = 64'h700000077;
    memory[8] = 64'h800000088;
memory[9] = 64'h900000099;
    memory[25] = {6'b100011, 5'b1, 5'b10, 16'h0};
    memory[26] = {6'b100011, 5'b1, 5'b11, 16'h4};
    memory[27] = {6'b100011, 5'b1, 5'b100, 16'h8};
    memory[28] = {6'b100011, 5'b1, 5'b101, 16'hc};
  memory[29] = {6'b100000, 5'b10, 5'b1010, 5'b1100,5'b000,16'ha};
  memory[29] = {6'b100000, 5'b1, 5'b110, 16'ha};  add needs updated to actually be add*/
    end
    always @(*) begin
      instOut = memory[PC[7:2]];
    end
    endmodule
/****************************************************/

module DataMemory(
  input wire clk,
  input wire [31:0] mr,
  input wire [31:0] mqb,
  input wire  mwmem,
  
  output reg [31:0] mdo
);
reg [31:0] dmemory [0:511];
initial begin
    dmemory[0] = 32'hA00000AA;
    dmemory[4] = 32'h10000011;
    dmemory[8] = 32'h20000022;
    dmemory[12] = 32'h30000033;
    dmemory[16] = 32'h40000044;
    dmemory[20] = 32'h50000055;
    dmemory[24] = 32'h60000066;
    dmemory[28] = 32'h70000077;
    dmemory[32] = 32'h80000088;
    dmemory[36] = 32'h90000099;
 //   dmemory[25] = {6'b100011, 5'b1, 5'b10, 16'h0};
 //   dmemory[26] = {6'b100011, 5'b1, 5'b11, 16'h4};
    end
    always @(*) begin
      mdo <= dmemory[mr];
    end
    always @(negedge clk) begin
        if (mwmem == 1)begin
        dmemory[mr] <= mqb;
    end
    end
    endmodule

module pcAdder(
  input wire [31:0] PC,
    output reg [31:0] nextPc
    );
    always @(*) begin
        nextPc = PC + 4;
        end
    endmodule

/****************************************************/

module ifid(
    input clk,
    input wire [31:0] instOut,
    output reg [31:0] dinstOut
    );
    always @(posedge clk) begin
    dinstOut <= instOut;
    end
    endmodule
/****************************************************/


module controlUnit(

    input wire [5:0] op,
    input wire [5:0] func,
    
    input wire [4:0] rs,
    input wire [4:0] rt,
    input wire ewreg, 
    input wire em2reg,
    input wire [4:0] edestReg,
    input wire mwreg, 
    input wire mm2reg,
    input wire [4:0] mdestReg,

    
    output reg wreg,
    output reg wmem,
    output reg regrt,
    output reg m2reg,
    output reg aluimm,
    output reg [3:0] aluc,
    output reg [1:0] fwda,
    output reg [1:0] fwdb
    );
initial begin
        fwda <= 2'b00;
        fwdb <= 2'b00;
    end 
    
    always@ (*) begin
        fwda <= 2'b00;
        fwdb <= 2'b00;
        
        if (rs == edestReg)
        
        begin
        case(op) 6'b000000:
        begin
            fwda <= 2'b01;
            end
            
        6'b100011:
        begin
            fwda <= 2'b11;
            end
        endcase
     end
     
     if(rt == edestReg)
     begin
        case(op) 6'b000000:
        begin
            fwdb <= 2'b01;
            end
        6'b100011:
        begin
            fwdb <= 2'b11;
            end
        endcase
     end
     
     if(rs == mdestReg)
     begin
        case (op) 6'b000000:
        begin
            fwda <= 2'b10;
            end
        6'b100011:
        begin
            fwda <= 2'b11;
            end
        endcase
     end
            
     if(rt == mdestReg)
     begin
        case(op) 6'b000000: 
        begin
            fwdb <= 2'b10;
            end
        6'b100011:
        begin
            fwdb <= 2'b11;
            end
        endcase
     end
     
     case(op) 6'b000000:
     begin
        case(func) 6'b100000: 
        begin
            wmem <= 1'b0;
            wreg <= 1'b1;
            m2reg <= 1'b0;
            aluimm <= 1'b0;
            aluc <= 4'b0010;
            regrt <= 1'b0;
            end
            
        6'b100010:
        begin    
            wmem <= 1'b0;
            wreg <= 1'b1;
            m2reg <= 1'b0;
            aluimm <= 1'b0;
            aluc <= 4'b0110;
            regrt <= 1'b0; 
            end
            
        6'b100100:
        begin
            wmem <= 1'b0;
            wreg <= 1'b1;
            m2reg <= 1'b0;
            aluimm <= 1'b0;
            aluc <= 4'b0000;
            regrt <= 1'b0; 
            end
            
        6'b100101:
        begin
            wmem <= 1'b0;
            wreg <= 1'b1;
            m2reg <= 1'b0;
            aluimm <= 1'b0;
            aluc <= 4'b0001;
            regrt <= 1'b0; 
            end
            
        6'b100110:
        begin
            wmem <= 1'b0;
            wreg <= 1'b1;
            m2reg <= 1'b0;
            aluimm <= 1'b0;
            aluc <= 4'b1001;
            regrt <= 1'b0; 
            end
        endcase
    end
    
    6'b100011: 
    begin
        wmem <= 1'b0;
        wreg <= 1'b1;
        m2reg <= 1'b1;
        aluimm <= 1'b1;
        aluc <= 4'b0010;
        regrt <= 1'b1; 
        end    
    
    default:
    begin
        wmem <= 1'bX;
        wreg <= 1'bX;
        m2reg <= 1'bX;
        aluimm <= 1'bX;
        aluc <= 4'bXXXX;
        regrt <= 1'bX; 
        end 
     endcase  
  end
  endmodule

/****************************************************/

module regRTmux(
    input wire regrt,
    input wire[4:0] rd,
    input wire [4:0] rt,
    output reg [4:0] destReg
    );
        always @(*) begin
        if (regrt==0) begin
            destReg <= rd;
        end
        else begin
            destReg <= rt;
            end
        end
    endmodule

/****************************************************/

module registerFile(
    input wire [4:0] rt,
    input wire [4:0] rs,
    input wire [4:0] wdestReg,
    input wire [31:0] wbData,
    input wire wwreg,
    input wire clk,
    output reg [31:0] qa,
    output reg [31:0] qb
    );
    reg [31:0] registers [0:31];
    integer i;
    initial begin
        for(i=0; i<32; i = i+1)
            begin
                registers[i] = 32'b0;
             end
        end
         always @(*) begin
             qa <= registers[rs];
             qb <= registers[rt];
            end
         always @(negedge clk) begin
            if (wwreg ==1) begin
                registers[wdestReg] <= wbData;
            end
         end
         endmodule

/****************************************************/

module idexe(

    input wire clk,
    input wire wmem, 
    input wire wreg,
    input wire m2reg,
    input wire aluimm,

    input wire [3:0] aluc,
    input wire [31:0] imm32,
    input wire [4:0] destReg,
      input wire [31:0] Fwda_MuxOut,
    input wire [31:0] Fwdb_MuxOut,
   
    output reg ewmem,
    output reg ewreg,
    output reg em2reg,
    output reg ealuimm,
    output reg [31:0] eqa,
    output reg [31:0] eqb,
    output reg [3:0] ealuc,
    output reg [31:0] eimm32,
    output reg [4:0] edestReg
    );

    always @(posedge clk) begin
        ewmem <= wmem;
        ewreg <= wreg;
        em2reg <= m2reg;
        ealuimm <= aluimm;
        eqa <= Fwda_MuxOut;
        eqb <= Fwdb_MuxOut;
        ealuc <= aluc;
        eimm32 <= imm32;
        edestReg <= destReg;
        end
endmodule

/****************************************************/

module exeMem(
    input clk, 
    input ewreg, 
    input em2reg, 
    input ewmem,
    input [4:0] edestReg, 
    input [31:0] r, 
    input [31:0] eqb, 
    
    output reg mwreg, 
    output reg mm2reg, 
    output reg  mwmem, 
    output reg [4:0] mdestReg, 
    output reg [31:0] mr, 
    output reg [31:0] mqb
);
always @(posedge clk) begin
        mwmem <= ewmem;
        mwreg <= ewreg;
        mm2reg <= em2reg;
        mqb <= eqb;
        mr <= r;
        mdestReg <= edestReg;
        end
    endmodule

/****************************************************/
    
module memWB(
    input mwreg,
    input  mm2reg, 
    input [4:0] mdestReg, 
    input [31:0] mr, 
    input [31:0] mdo,
    input clk,
    output reg wwreg, 
    output reg wm2reg, 
    output reg [4:0] wdestReg, 
    output reg [31:0] wr, 
    output reg [31:0] wdo
    
);
always @(posedge clk) begin
        wwreg <= mwreg;
        wm2reg <= mm2reg;
        wdo <= mdo;
        wr <= mr;
        wdestReg <= mdestReg;
        end
    endmodule
    
/****************************************************/

module immExtend(
 input wire [15:0] imm,
 output reg [31:0] imm32
 );
 always @(*) begin
     imm32 <= {{16{imm[15]}},imm};
 end
 endmodule

/****************************************************/

module aluMux(
input wire [31:0] eqb,
input wire [31:0] eimm32,
input wire ealuimm,
output reg [31:0] b
);
        always @(*) begin
        if (ealuimm==0) begin
            b <= eqb;
        end
        else begin
            b <= eimm32;
            end
        end
endmodule

/****************************************************/

module alu(
input wire [31:0] eqa,
input wire [31:0] b,
input wire [3:0] ealuc,
output reg [31:0] r
);

        always @(*) begin
        if (ealuc == 4'b0110) begin
            r <= eqa - b;
            end
        else if (ealuc == 4'b0010) begin
            r <= b + eqa;
            end
         else if (ealuc == 4'b0001) begin
            r <= eqa|b;
            end
         else if (ealuc == 4'b1001) begin
            r <= eqa^b;
            end
        else if (ealuc == 4'b0000) begin
            r <= eqa & b;
            end
        end
endmodule

/****************************************************/

module WbMux(
  
input wire [31:0] wr,
input wire [31:0] wdo,
input wire wm2reg,
output reg [31:0] wbData
  
);
        always @(*) begin
        if (wm2reg==0) begin
            wbData <= wr;
        end
        else begin
            wbData <= wdo;
            end
        end
endmodule

/****************************************************/

module FwdaMux(
    input wire [31:0] qa,  
    input wire [31:0] r,
    input wire [31:0] mr,
    input wire [31:0] mdo,
    input wire [1:0] fwda,
    output reg [31:0] Fwda_MuxOut
    );
    always @(*) begin
        case (fwda)
            2'b00:
            begin
                Fwda_MuxOut <= qa;
            end
            2'b01:
            begin
                Fwda_MuxOut <= r;
            end
            2'b10:
            begin
                Fwda_MuxOut <= mr;
            end
            2'b11:
            begin
                Fwda_MuxOut <= mdo;
            end
        endcase
    end
endmodule

/****************************************************/

module FwdbMux(
    input wire [31:0] qb,     
    input wire [31:0] r,
    input wire [31:0] mr,
    input wire [31:0] mdo,
    input wire [1:0] fwdb,
    output reg [31:0] Fwdb_MuxOut
    );
    always @(*) begin
        case (fwdb)
            2'b00:
            begin
                Fwdb_MuxOut <= qb;
            end
            2'b01:
            begin
                Fwdb_MuxOut <= r;
            end
            2'b10:
            begin
                Fwdb_MuxOut <= mr;
            end
            2'b11:
            begin
                Fwdb_MuxOut <= mdo;
            end
        endcase
    end
endmodule

/****************************************************/

module datapathModule(



    input clk,
    output wire [31:0] PC,
    output wire [31:0] dinstOut,
    output wire ewreg,
    output wire em2reg,
    output wire ewmem,
    output wire [3:0] ealuc,
    output wire ealuimm,
    output wire [4:0] edestReg,
    output wire [31:0] eqa,
    output wire [31:0] eqb,
    output wire [31:0] eimm32,
    output wire mwreg,
    output wire mm2reg,
    output wire mwmem,
    output wire [4:0] mdestReg,
    output wire [31:0] mr,
    output wire [31:0] mqb,
    output wire wwreg,
    output wire wm2reg,
    output wire [4:0] wdestReg,
    output wire [31:0] wr,
    output wire [31:0] wdo,
    output wire [4:0] rs,
    output wire [4:0] rt,
    output wire [31:0] wbData,
    output wire [31:0] qa,
    output wire [31:0] qb
    );

    wire [31:0] nextPC;
    pcAdder pcAdder(PC, nextPC);
    
    ProgramCounter ProgramCounter(nextPC, clk, PC);
    
    wire[31:0] instOut;
    InstructionMemory InstructionMemory(PC, instOut);
    
    ifid ifid(clk, instOut, dinstOut);
    
    wire [5:0] instr = dinstOut[31:26];
    assign rs = dinstOut[25:21]; // might be assign
    assign rt = dinstOut[20:16]; // might be assign
    wire [4:0] rd = dinstOut[15:11]; 
    wire [5:0] func = dinstOut[5:0];
    wire [15:0] imm = dinstOut[15:0];
    wire wreg, m2reg, aluimm, wmem, regrt;
    wire [3:0] aluc;
    
    wire [1:0] fwda;
    wire [1:0] fwdb;

    controlUnit controlUnit(instr, func, rs, rt, ewreg, em2reg, edestReg, mwreg, mm2reg, mdestReg, wreg, wmem, regrt, m2reg, aluimm, aluc,
    fwda, fwdb);

    wire [4:0] destReg;

  regRTmux regRTmux(regrt, rd, rt, destReg);
 
    //wire [31:0] wbData;
    //wire [31:0] qa;
    //wire [31:0] qb;
  registerFile registerFile(rt, rs, wdestReg, wbData, wwreg, clk, qa, qb);
   
    wire [31:0] imm32;
    immExtend immExtend(imm, imm32);

    idexe idexe (clk, wmem, wreg, m2reg, aluimm, aluc, imm32, destReg, Fwda_MuxOut, Fwdb_MuxOut, ewmem, ewreg, em2reg, ealuimm, eqa, eqb, ealuc, eimm32, edestReg);
        
       
  
    wire [31:0] b;
    aluMux aluMux(eqb, eimm32, ealuimm, b);
  
    wire [31:0] r;
    alu alu(eqa, b, ealuc, r);
  
    exeMem exeMem(clk, ewreg, em2reg, ewmem, edestReg, r, eqb, mwreg, mm2reg, mwmem, mdestReg, mr, mqb);
  
    wire [31:0] mdo;
    DataMemory DataMemory(clk, mr, mqb, mwmem, mdo);

    memWB memWB(mwreg, mm2reg, mdestReg, mr, mdo, clk, wwreg,  wm2reg, wdestReg, wr, wdo);  
    
    //wire [31:0] wbData;
    
    WbMux WbMux(wr, wdo, wm2reg, wbData);
    
    //wire [31:0] r;
    //wire [31:0] mdo;
    

    FwdaMux FwdaMux(qa, r, mr, mdo, fwda, Fwda_MuxOut);

    FwdbMux FwdbMux(qb, r, mr, mdo, fwdb, Fwdb_MuxOut);

/*    //inputs
    input wire clk,
    input wire wmem, 
    input wire wreg,
    input wire m2reg,
    input wire aluimm,
    input wire [31:0] qa,
    input wire [31:0] qb,
    input wire [3:0] aluc,
    input wire [31:0] imm32,
    input wire [4:0] destReg,
    //outputs
    output reg ewmem,
    output reg ewreg,
    output reg em2reg,
    output reg ealuimm,
    output reg [31:0] eqa,
    output reg [31:0] eqb,
    output reg [3:0] ealuc,
    output reg [31:0] eimm32,
    output reg [4:0] edestReg
    );*/





   
 /* ProgramCounter pc_datapathmodule(nextPC,clk,PC);
  pcAdder pcAdder_datapathmodule(PC,nextPC);
  InstMem InstMen_datapathmodule(PC,instOut);
ifidPipeline ifidPipeline_datapathmodule(instOut,clk,dinstOut);*/
endmodule

