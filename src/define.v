//Operation codes
`define     IHALT           4'H0 
`define     INOP            4'H1
`define     ICMOVQ          4'H2
`define     IRRMOVQ         4'H2
`define     IIRMOVQ         4'H3
`define     IRMMOVQ         4'H4
`define     IMRMOVQ         4'H5
`define     IOPQ            4'H6
`define     IJXX            4'H7
`define     ICALL           4'H8
`define     IRET            4'H9
`define     IPUSHQ          4'HA
`define     IPOPQ           4'HB

//Function codes
`define     ALUADD           4'H0
`define     ALUSUB           4'H1
`define     ALUAND           4'H2
`define     ALUXOR           4'H3

`define     C_YES           4'H0
`define     C_E           4'H1
`define     C_NE           4'H2
`define     C_S           4'H3
`define     C_NS           4'H5
`define     C_G           4'H6
`define     C_GE           4'H7
`define     C_L           4'H8
`define     C_LE           4'H8

`define     STAT_AOK       3'b000// 正常执行
`define     STAT_INS       3'b001// 非法指令
`define     STAT_ADR       3'b010// 内存错误

// 状态码定义
`define SADR 4'h1  // 地址错误（指令存储器错误）
`define SINS 4'h2  // 无效指令
`define SHLT 4'h3  // 停机
`define SAOK 4'h4  // 正常执行

`define RRSP 4'h4
`define RNONE 4'hF  // 无寄存器