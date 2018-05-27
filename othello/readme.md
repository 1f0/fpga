# 黑白棋

## 项目结构

* code/: Verilog代码
* coe/: 用到的coe
* test/: 测试代码
* asm/: 汇编代码
  * .s文件和机器语言的bin文件。

## 使用方法

* 先将switch[0]（最右边的那个）拨为低电平
* 然后用digilent adept将写入Cellular RAM中，然后下载bit到Nexys3开发板
* 稍等片刻然后将switch[0]拨到高电平，则程序启动。
