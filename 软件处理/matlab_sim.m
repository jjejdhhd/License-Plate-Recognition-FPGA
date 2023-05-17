close all;
clear;
clc;
%% 读取图片
% 实际的照片
% filename = "京L75563";
% filename = "京AF0236";
% filename = "沪CZV299";
% filename = "粤B1J2U5";
% filename = "粤B15TT2";
% filename = "粤AMT229";
% filename = "粤B2BS99"; %解决边界陡降问题
% filename = "粤B197RC"; %极端情况：车牌被完全罩起来
%-------------------------------
% filename = "桂AP8C55"; % 蓝色车
% filename = "粤BYK118"; % 红色车
filename = "粤B197RC"; % 白色车
% filename = "川XH819U"; % 川字车

im_ini = imread("C:\Users\14751\Desktop\课堂展示-基于FPGA的车牌识别\软件处理\"+filename+".jpg");

[hor_tot,ver_tot,~] = size(im_ini);
% figure;imshow(im_ini);

%% 功能一：提取车牌边框
% Cb图
% im_gray = im2gray(im_ini);
im_ycbcr = rgb2ycbcr(im_ini);
im_cb = im_ycbcr(:,:,2);
figure;axis square;
% subplot(5,4,1);imshow(im_ini);title("原图");
subplot(5,4,1);imshow(im_cb);title("Cb图");

% 二值化
% im_bina = imbinarize(im_cb, 'adaptive');
im_bina = my_imbinarize(im_cb, 130);%默认是150
im_bina = im2uint8(im_bina);
subplot(5,4,2);imshow(im_bina);title("二值化");

% 腐蚀
im_ero = imerode(im_bina,strel('disk',3));
subplot(5,4,3);imshow(im_ero);title("腐蚀");

% Sobel边缘检测
im_sobel = im2uint8(edge(im_ero,'sobel'));
subplot(5,4,4);imshow(im_sobel);title("sobel检测");

% 膨胀
im_dil = imdilate(im_sobel,strel('disk',3));
% subplot(5,4,[6,7,8,10,11,12,14,15,16]);imshow(im_dil);title("膨胀");

% 水平投影和垂直投影
hor_pixel_pre = sum(im_dil,2).'./hor_tot./255.*100;
ver_pixel_pre = sum(im_dil,1)./ver_tot./255.*100;
% figure;
subplot(5,4,[5,9,13]);plot(hor_pixel_pre,1:hor_tot);
set(gca,'YDir','reverse');
title("水平投影");ylabel("行数");xlabel("百分比（%）");
grid on;ylim([0,hor_tot]);
subplot(5,4,[18,19,20]);plot(ver_pixel_pre);
title("垂直投影");xlabel("列数");ylabel("百分比（%）");
grid on;xlim([0,ver_tot]);

% 根据边沿确定边界
hor_plate_line = zeros(1,2);
ver_plate_line = zeros(1,2);
pixel_shift = 30; % 像素偏移量-为了去除车牌的白色边框
% 确定水平投影结果
cnt = 0;
for i = 1:(hor_tot-1)
    % 第一个极大值大于30
    if(hor_pixel_pre(i)>hor_pixel_pre(i+1) && hor_pixel_pre(i)>30/480*100 && cnt==0)
        hor_plate_line(1) = i + pixel_shift;
        cnt = 1;
    end
    % 最后一个极大值大于30
    if(hor_pixel_pre(i)>hor_pixel_pre(i+1) && hor_pixel_pre(i)>30/480*100 && cnt==1)
        hor_plate_line(2) = i - pixel_shift;
    end
end
% 确定垂直投影结果
cnt = 0;
for i = 1:(ver_tot-1)
    if(ver_pixel_pre(i)>ver_pixel_pre(i+1) && ver_pixel_pre(i)>10/640*100 && cnt==0)
        ver_plate_line(1) = i + pixel_shift;
        cnt = 1;
    end
    if(ver_pixel_pre(i)>ver_pixel_pre(i+1) && ver_pixel_pre(i)>10/640*100 && cnt==1)
        ver_plate_line(2) = i - pixel_shift - 10;
    end
end
% 画出车牌边框
plate_width = 5; %车牌边框的线宽
im_dil_show = im_dil;
im_dil_show(hor_plate_line(1):(hor_plate_line(1)+plate_width-1),:) = 255*ones(plate_width,ver_tot);
im_dil_show((hor_plate_line(2)-plate_width+1):hor_plate_line(2),:) = 255*ones(plate_width,ver_tot);
im_dil_show(:,ver_plate_line(1):(ver_plate_line(1)+plate_width-1)) = 255*ones(hor_tot,plate_width);
im_dil_show(:,(ver_plate_line(2)-plate_width+1):ver_plate_line(2)) = 255*ones(hor_tot,plate_width);
subplot(5,4,[6,7,8,10,11,12,14,15,16]);imshow(im_dil_show);title("膨胀");



%% 功能二：切割字符
im_red = im_ini(:,:,1);
figure;axis square;
subplot(5,4,1);imshow(im_ini);title("原图");
subplot(5,4,2);imshow(im_red);title("red图");

% 字符区域二值化
im_plate_bi = zeros(hor_tot, ver_tot);
for i_hor = hor_plate_line(1):hor_plate_line(2)
    for i_ver = ver_plate_line(1):ver_plate_line(2)
        if(im_red(i_hor, i_ver) > 160)%默认是160
            im_plate_bi(i_hor, i_ver) = 1;
        end
    end
end
im_plate_bi = im2uint8(im_plate_bi);
subplot(5,4,3);imshow(im_plate_bi);title("二值化");

% 腐蚀
im_plate_ero = imerode(im_plate_bi,strel('disk',3));
subplot(5,4,4);imshow(im_plate_ero);title("腐蚀");

% 膨胀
im_plate_dil = imdilate(im_plate_ero,strel('disk',3));
subplot(5,4,[6,7,8,10,11,12,14,15,16]);imshow(im_plate_dil);title("膨胀");

% 水平投影
char_hor_pixel_pre = sum(im_plate_dil,2).'./hor_tot./255.*100;
char_ver_pixel_pre = sum(im_plate_dil,1)./ver_tot./255.*100;
% figure;
subplot(5,4,[5,9,13]);plot(char_hor_pixel_pre,1:hor_tot);
set(gca,'YDir','reverse');
title("水平投影");ylabel("行数");xlabel("百分比（%）");
grid on;ylim([0,hor_tot]);
subplot(5,4,[18,19,20]);plot(char_ver_pixel_pre);
title("垂直投影");xlabel("列数");ylabel("百分比（%）");
grid on;xlim([0,ver_tot]);

% 根据边沿确定边界
hor_char_line = zeros(1,2);
ver_char_line = zeros(1,14);
% 确定水平投影结果
cnt = 0;
for i = 1:(hor_tot-1)
    % 检测第一个极大值大于15或者陡升的上升沿
    if((char_hor_pixel_pre(i)>char_hor_pixel_pre(i+1) && char_hor_pixel_pre(i)>5/480*100 && cnt==0) || ...
       (char_hor_pixel_pre(i)+15/480*100<char_hor_pixel_pre(i+1) && cnt==0) ...%该条件用于检测陡升的上升沿
       )
        max_first = i;
        cnt = 1;
    end
    % 第一个极小值-后续上升趋势大于15像素
    if(char_hor_pixel_pre(i+1)>(char_hor_pixel_pre(i)+5/480*100) && cnt==1)
        hor_char_line(1) = i;
        cnt = 2;
    end
    %不断更新遇到的极小值（上升趋势大于15像素）
    if(char_hor_pixel_pre(i+1)>(char_hor_pixel_pre(i)+5/480*100) && cnt==2)
        hor_char_line(2) = i - 10;
        cnt = 3;
    end
    % 最近的极大值大于30
    if(char_hor_pixel_pre(i)>char_hor_pixel_pre(i+1) && char_hor_pixel_pre(i)>30/480*100 && cnt==3)
        max_last = i;
        cnt = 4;
    end
    % 观测是否还有新的上升趋势（上升趋势大于8像素）或者降低到0的下降沿
    if((char_hor_pixel_pre(i)<char_hor_pixel_pre(i+1) && char_hor_pixel_pre(i)>8/480*100 && cnt==4) || ...
       (char_hor_pixel_pre(i+1)==0 && char_hor_pixel_pre(i)>8/480*100 && cnt==4) ...%检测降低到0的下降沿
      )
        hor_char_line(2) = i - 10;
        cnt = 3;
    end
end
% 确定垂直投影结果
cnt = 1;
for i = 10:(ver_tot-10)
    char_posedge = ((char_ver_pixel_pre(i-5)==0) && (char_ver_pixel_pre(i)>0.5));
    char_negedge = ((char_ver_pixel_pre(i+5)==0) && (char_ver_pixel_pre(i)>0.5));
    % 汉字
    if(char_posedge && cnt==1)
        ver_char_line(1) = i;
        cnt = cnt + 1;
    elseif(char_negedge && cnt==2)
        ver_char_line(2) = i;
        cnt = cnt + 1;
    % 字母1
    elseif(char_posedge && cnt==3)
        ver_char_line(3) = i;
        cnt = cnt + 1;
    elseif(char_negedge && cnt==4)
        ver_char_line(4) = i;
        cnt = cnt + 1;
    % 点
    elseif(char_posedge && cnt==5)
        cnt = cnt + 1;
    elseif(char_negedge && cnt==6)
        cnt = cnt + 1;
    % 字符1
    elseif(char_posedge && cnt==7)
        ver_char_line(5) = i;
        cnt = cnt + 1;
    elseif(char_negedge && cnt==8)
        ver_char_line(6) = i;
        cnt = cnt + 1;
    % 字符2
    elseif(char_posedge && cnt==9)
        ver_char_line(7) = i;
        cnt = cnt + 1;
    elseif(char_negedge && cnt==10)
        ver_char_line(8) = i;
%         cnt = cnt + 1;
        if(ver_char_line(8) - ver_char_line(7) > 50)
            cnt = cnt + 1;
        end
    % 字符3
    elseif(char_posedge && cnt==11)
        ver_char_line(9) = i;
        cnt = cnt + 1;
    elseif(char_negedge && cnt==12)
        ver_char_line(10) = i;
        cnt = cnt + 1;
    % 字符4
    elseif(char_posedge && cnt==13)
        ver_char_line(11) = i;
        cnt = cnt + 1;
    elseif(char_negedge && cnt==14)
        ver_char_line(12) = i;
        cnt = cnt + 1;
    % 字符5
    elseif(char_posedge && cnt==15)
        ver_char_line(13) = i;
        cnt = cnt + 1;
    elseif(char_negedge && cnt==16)
        ver_char_line(14) = i;
        cnt = cnt + 1;
    end
end
% 画出车牌边框
char_width = 5; %字符边框的线宽
im_char_show = im_plate_dil;
im_char_show(hor_char_line(1):(hor_char_line(1)+char_width-1),:) = 255*ones(char_width,ver_tot);
im_char_show((hor_char_line(2)-char_width+1):hor_char_line(2),:) = 255*ones(char_width,ver_tot);
for i=1:7
    im_char_show(:,ver_char_line(2*i-1):(ver_char_line(2*i-1)+char_width-1)) = 255*ones(hor_tot,char_width);
    im_char_show(:,(ver_char_line(2*i)-char_width+1):ver_char_line(2*i)) = 255*ones(hor_tot,char_width);
end
subplot(5,4,[6,7,8,10,11,12,14,15,16]);imshow(im_char_show);title("膨胀");


%% 功能三：计算特征值
% 切割模板
% im_plate_dil(hor_char_line(1),:) = 255*ones(1,ver_tot);
% im_plate_dil(hor_char_line(2),:) = 255*ones(1,ver_tot);
% for i=1:14
%     im_plate_dil(:,ver_char_line(i)) = 255*ones(hor_tot,1);
% end
% figure;imshow(im_plate_dil);title("切割示意图");

% 计算特征值
ver_split = 5; %垂直分割成5份
hor_split = 8; %水平分割成8份
eigen = zeros(7, hor_split*ver_split);
figure;%展示特征值前后
subplot(3,7,[3,4,5]);imshow(im_ini(hor_plate_line(1):hor_plate_line(2),ver_plate_line(1):ver_plate_line(2),:));
for i_char = 1:7
    % 提取单个图像进行切割
    im_spec = im_plate_dil(hor_char_line(1):hor_char_line(2), ver_char_line(2*i_char-1):ver_char_line(2*i_char));
    [hor_spec,ver_spec] = size(im_spec);
    ver_border = floor(linspace(1,ver_spec,ver_split+1));
    hor_border = floor(linspace(1,hor_spec,hor_split+1));
    
    % 计算特征值
    for i=0:(ver_split*hor_split-1)
        region = im_spec(hor_border(floor(i/ver_split)+1):hor_border(floor(i/ver_split)+2), ...
                         ver_border(mod(i,ver_split)+1):ver_border(mod(i,ver_split)+2));
        region_pixel = sum(sum(region./255));
        if(region_pixel > (size(region,1)*size(region,2)*0.4))
            eigen(i_char,i+1) = 1;
        end
    end
    
    
    % 显示切割出来的图像
    im_spec_show = im_spec;
    for i=1:length(ver_border)
        im_spec_show(:,ver_border(i)) = 255*ones(hor_spec,1);
    end
    for i=1:length(hor_border)
        im_spec_show(hor_border(i),:) = 255*ones(1,ver_spec);
    end
    subplot(3,7,i_char+7);imshow(im_spec_show);
    
    % 显示涂色后的图像
    im_spec_show = zeros(size(im_spec_show));
    for i=0:(ver_split*hor_split-1)
        if(eigen(i_char,i+1)==1)
            region = ones(hor_border(floor(i/ver_split)+2)-hor_border(floor(i/ver_split)+1)+1, ...
                          ver_border(mod(i,ver_split)+2)-ver_border(mod(i,ver_split)+1)+1);
            im_spec_show(hor_border(floor(i/ver_split)+1):hor_border(floor(i/ver_split)+2), ...
                         ver_border(mod(i,ver_split)+1):ver_border(mod(i,ver_split)+2)) ...
                        = region;
        end
    end
    subplot(3,7,i_char+14);imshow(im_spec_show);

end

% 输出特征值计算结果-先输出高位
for i_char = 1:7
    % 按照比特输出
    fprintf("char%d：%d'b",i_char,hor_split*ver_split);
    for i = 1:(hor_split*ver_split)
        fprintf("%d",eigen(i_char,(hor_split*ver_split)-i+1));
        if ((mod(i,4)==0) && i<(hor_split*ver_split))
            fprintf("_");
        end
    end
    fprintf(";\n");
end


%% -------------可能会调用的函数------------------

% 实现图像的二值化
% im_in：输入一张二维图片。
% thres：判断阈值。
function im_bi = my_imbinarize(im_in, thres)
[hor_tot, ver_tot] = size(im_in);
im_bi = zeros(hor_tot, ver_tot);
im_bi(im_in>thres) = 1;
end


