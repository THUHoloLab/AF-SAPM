%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aberration-free synthetic aperture phase microscopy based on alternating direction method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation for this code and algorithm:
% Zhengzhong Huang and Liangcai Cao
% "Aberration-free synthetic aperture phase microscopy based on alternating direction method",
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The code is written by Zhengzhong Huang, 2022
% The version of Matlab for this code is R2016b

clc
clear all
close all

%% Simulation for raw phase object

image=imread('resChart.tif');% Raw data
image=1.5.*im2double(image);

m0=1000;
n0=1000;
image=imresize(image,[m0 n0]);
for i=1:m0
    for j=1:n0
        if image(i,j)<0
            image(i,j)=0;
        end
    end
end
figure(1),subplot('position',[0 0 1 1]),imshow((image),[])
colorbar('location','EastOutside','FontSize',16)
%% Aberration
Z=Zer_Pro(m0,n0,0.9.*10^(-6),1000,24); % The matrix of Zernike polynomials Z
x=[0.5;4;2;4;5;6;-5;1;1.5;1;...
  1.5;2;1;1;1;1;1;1;1;1;1;1;1;1];% Zernike Coefficients

y0=Z*x;% Aberration
z11=reshape(y0,m0,n0,1);% Transform 1D to 2D
object=exp(1i.*z11);% 2D aberration

figure(2),subplot('position',[0 0 1 1]),imshow(angle(object),[])
colorbar('location','EastOutside','FontSize',16)
%% ADM

[m, n] = size(Z);
object=image(:);
y = y0+object;% Unwrapped measured phase
object1=reshape(y,m0,n0,1);% 2D unwrapped measured phase
object1_wrap=exp(1i.*object1);% 2D wrapped phase of measured phase

[a]=ADMP2(Z,y);
recons1=Z*a;% 2D unwrapped measured phase
aberra1=reshape(recons1,m0,n0,1);% 2D unwrapped aberration from ADM
recons2=object1-aberra1;% 2D phase of object by eliminating the aberration
aberra1_wrap=exp(1i.*aberra1);% 2D wrapped phase of aberration

MSE1=(sum(sum((abs(recons2)-abs(image)).^2)))./(m0*n0);

figure(3),subplot('position',[0 0 1 1]),imshow(angle(object1_wrap),[])
colorbar('location','EastOutside','FontSize',16)
figure(4),subplot('position',[0 0 1 1]),imshow(angle(aberra1_wrap),[])
colorbar('location','EastOutside','FontSize',16)
figure(5),subplot('position',[0 0 1 1]),imshow((recons2),[])
colorbar('location','EastOutside','FontSize',16)

%%

m1=m0;
n1=n0;
xmax=n1.*5.86./20;
ymax=m1.*5.86./20;
%xmax=n;ymax=m;
x=linspace(-xmax./2,xmax./2,n0);
y=linspace(-ymax./2,ymax./2,m0);
[X,Y] = meshgrid(x,y);
figure(6),mesh(X,Y,flipud((aberra1)))
view([-18,70])
axis([-xmax./2 xmax./2 -ymax./2 ymax./2 -20 15])
set(gca,'FontSize',18)



