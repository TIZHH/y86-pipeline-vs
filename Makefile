# Makefile for Verilog project

# 变量定义
VERILOG_FILES = $(wildcard src/*.v)   # 所有 Verilog 源文件
TB_FILES = $(wildcard sim/*.v)        # 测试平台文件
OUTPUT_DIR = build                     # 编译输出文件夹
OUTPUT = $(OUTPUT_DIR)/simulation.vvp  # 仿真输出文件

# 默认目标
all: $(OUTPUT)

# 编译目标：将所有 Verilog 文件编译成仿真文件
$(OUTPUT): $(VERILOG_FILES) $(TB_FILES)
	# 创建输出目录（如果不存在）
	mkdir -p $(OUTPUT_DIR)
	iverilog -o $(OUTPUT) $(VERILOG_FILES) $(TB_FILES)

# 运行仿真
run: $(OUTPUT)
	vvp $(OUTPUT)

# 清理目标：删除编译生成的文件
clean:
	rm -rf $(OUTPUT_DIR)
