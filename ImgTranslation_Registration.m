%% Image Translation followed by image registration
close all
clc
I=load('knee_ct.mat');
A=I.knee_ct;
figure;
imagesc(A); colormap gray
title('Reference image');

background = zeros(100);
A_ref = imref2d(size(A));

tx=linspace(-50,50,30);
theta=linspace(-30,30,30);
% for n=1:10
%Rotation matrix
R = [cosd(theta(n)) sind(theta(n)) 0;-sind(theta(n)) cosd(theta(n)) 0;0 0 1];
tform_r = affine2d(R);
% Translation matrix
T = [1 0 0;0 1 0;tx(n) 0 1];
tform_t = affine2d(T);

TR = T*R;
tform_tr = affine2d(TR);
[out,out_ref] = imwarp(A,A_ref,tform_tr);
imshowpair(out,out_ref,background,imref2d(size(background)))
% imshowpair(A, out,'Scaling','joint');
imagesc(out);
fig=gcf;
% fname='C:\Users\Sumana\Documents\MATLAB\Spring 2020\New folder\New folder\Transformed images\New folder';
% filename=fullfile(fname,strcat("transformed image",string(n),".jpg"));
saveas(fig,filename);

% Registration
fixed=A;
moving=out;

figure
imshowpair(fixed, moving,'Scaling','joint');

optimizer = registration.optimizer.OnePlusOneEvolutionary;
metric = registration.metric.MattesMutualInformation

optimizer.InitialRadius = 0.009;
optimizer.Epsilon = 1.5e-4;
optimizer.GrowthFactor = 1.01;
optimizer.MaximumIterations = 300;

movingRegistered = imregister(moving,fixed,'affine',optimizer,metric);
figure
imshowpair(fixed, movingRegistered,'Scaling','joint');

fig=gcf;
% fname='C:\Users\Sumana\Documents\MATLAB\Spring 2020\New folder\New folder\Registered images';
% filename=fullfile(fname,strcat("Registered image",string(n),".jpg"));
saveas(fig,filename);









