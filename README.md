# 基于FPGA进行车牌识别

[TOC]


本项目的原理讲解视频已经上传到B站“[基于FPGA进行车牌识别](https://www.bilibili.com/video/BV1rM4y1t7Gi/)”。

***

## 1. 文件说明

**1. 工程及源代码**
里面包含了大磊FPGA的源代码，以及我自己的源代码。

其中，大磊FPGA的源代码包括一些的数字图像处理的模块。我自己的源代码则直接将Vivado 2022.1工程“ov5640_fun4_lcd_up3”放了上去，同时将工程中的```比特流```、```源代码及硬件约束文件``` 单独拿了出来，需要的同学可以快速查看。


**2. 软件处理**
里面包括整个开发过程所用到的图片库，以及我自己写的MATLAB仿真源代码。这些汽车图片都是我在校园里拍的。

**3. 基于FPGA的车牌识别.pdf**
就是我在B站演示的PPT，需要自取。

**4. 图库**
本markdown文档中用到的图片，大家基本用不到所以不用看。

## 2. 程序移植说明
本人在开发时使用到的硬件：
> - FPGA开发工具：Vivado 2022.1。
> - 开发板：正点原子达芬奇PRO。
> - 摄像头：正点原子OV5640。
> - LCD显示屏：正点原子800*480显示屏。

首先，如果使用的硬件和本人一样，那么就可以直接打开Vivado下载比特流（开源文件夹中“```工程及源代码\我自己的工程备份\比特流备份\ov5640_fun4_lcd.bit```”），就可以看到我在视频中所演示的现象。

若配件不一样，或者使用其他版本的Vivado或者Altera那边的Quartus，可能打不开这个工程，就需要工程迁移。但好在本项目几乎用的都是纯Verilog，以及一些常见的IP核(clk、BRAM、FIFO、MIG)，所以我直接将所有的源代码和约束文件都提取出来放在了“```.\工程及源代码\我自己的工程备份\源代码及约束文件```”，并且我下面将给出各个IP核的配置界面，以供大家参考。


<div align=center>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-1clk_wiz_0%E9%85%8D%E7%BD%AE1.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-1clk_wiz_0%E9%85%8D%E7%BD%AE2.png" width=49%>
</div><div align=center>
1-1 时钟模块-clk_wiz_0配置
</div>

<div align=center>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-2mig_7series_0%E9%85%8D%E7%BD%AE1.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-2mig_7series_0%E9%85%8D%E7%BD%AE2.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-2mig_7series_0%E9%85%8D%E7%BD%AE3.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-2mig_7series_0%E9%85%8D%E7%BD%AE4.png" width=49%>
</div><div align=center>
1-2 DDR3模块-mig_7series_0配置
</div>

> - 第一页默认。
> - 第三页默认。
> - 第四页选DDR3。
> - 第八页默认。
> - 第九页：Fixed Pin Out.
> - 第十页：选择“Read XDC/UDF”，然后选取工程文件夹中的“ddr3_xdc.ucf”，再点击“Validate”即可。
> - 第十一页及之后就按照默认选项“同意”即可。

<div align=center>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-3rd_fifo%E9%85%8D%E7%BD%AE1.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-3rd_fifo%E9%85%8D%E7%BD%AE2.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-3rd_fifo%E9%85%8D%E7%BD%AE3.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-3rd_fifo%E9%85%8D%E7%BD%AE4.png" width=49%>
</div><div align=center>
1-3 DDR3模块-rd_fifo配置
</div>

> - DDR3模块-wr_fifo配置：与rd_fifo一样，只不过名称不一样。

<div align=center>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-4blk_mem_gen_0%E9%85%8D%E7%BD%AE1.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-4blk_mem_gen_0%E9%85%8D%E7%BD%AE2.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-4blk_mem_gen_0%E9%85%8D%E7%BD%AE3.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-4blk_mem_gen_0%E9%85%8D%E7%BD%AE4.png" width=49%>
</div><div align=center>
1-4 数字图像处理模块-blk_mem_gen_0配置
</div>

<div align=center>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-5cordic%E9%85%8D%E7%BD%AE1.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-5cordic%E9%85%8D%E7%BD%AE2.png" width=49%>
</div><div align=center>
1-5 Sobel边缘检测模块-cordic配置
</div>

<div align=center>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-6projection_ram%E9%85%8D%E7%BD%AE1.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-6projection_ram%E9%85%8D%E7%BD%AE2.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-6projection_ram%E9%85%8D%E7%BD%AE3.png" width=49%>
<img src="https://raw.githubusercontent.com/jjejdhhd/License-Plate-Recognition-FPGA/main/%E5%9B%BE%E5%BA%93/1-6projection_ram%E9%85%8D%E7%BD%AE4.png" width=49%>
</div><div align=center>
1-6 水平投影模块-projection_ram配置
</div>

## 3. 小小的编程感想

> 1. 摄像头的信号。场同步信号是低电平有效，clken和href左对齐，且clken每两个时钟周期才有效一次（这是因为摄像头一次只能传输8bit数据，但是一个像素的数据为RGB565共16bit）。
> 2. 卡了很久的bug。原来是没有给模块输入正常的时钟信号...
