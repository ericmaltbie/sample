%modified from fc_only_3d to make example for github class 11/24/20
%this program processes the data and makes fc maps based on correlation
%with a seed region
%all subroutines are found in the subs folder

close all; clear all;
addpath('subs');

%set up scan parameters
DimX=64;
DimY=64;
DimZ=15;
DimTime=300;
tr=0.5;
cutpt=0.2; %low pass cutoff in Hz
seedsize=3; %in voxels, one side length of square seed
start=10; %lets you skip scans at beginning if nonequilibrium
ccthresh=0.2; %empirical
imgthresh=400; %empirical
seedslice=10;
pix=[15,20];

dim=[DimX DimY DimZ DimTime];

dat0=readbruker(dim); %reads in data
dat(:,:,:,1:(DimTime-start))=dat0(:,:,:,(start+1):DimTime); %discards transients
dim=[DimX DimY DimZ DimTime-start];
dat1=thresholdimage(dat,imgthresh); %removes areas with low signal
dat1=smoothimage(dat1);  %smoothes image
figure (1)
imagesc(dat1(:,:,seedslice)); colormap gray
dat2=lpfilterimage(dat1,tr,cutpt, dim); %low pass filter

%pix=getloc(seedsize); %select seed on image using crosshairs
reftimecourse=average_tc(dat2,pix, seedslice); % get time course from seed
cc=corr_with_reftc(reftimecourse, dat2); %calc corr between seed and rest

anatcc=combine_anatcc(dat1,cc, ccthresh, imgthresh); %overlay corrmap on anatomical

load skfmrimap;

figure(2);
colormap(c4);
imagesc(anatcc(:,:,seedslice));axis image;



