npixels = 2000;
windowSize = 600;
barWidth = 50;
centerDiameter = 200;

template = zeros([windowSize,npixels]);
barStart = 1:barWidth*2:npixels;

for i = 1:length(barStart)
    template(:, barStart(i):barStart(i)+barWidth) = 1;
end



windowStart = npixels/2-windowSize/2;
windowEnd =  npixels/2+windowSize/2;

[x,y] = meshgrid(1:npixels, 1:windowSize);
x = x - npixels/2;
y = y - windowSize/2;
dist = sqrt( x.^2 + y.^2 );
isCircle = dist < centerDiameter/2;

figure(1)
imagesc(template)
pbaspect([1 1 1])
axis off

%%%%%%%%%%%%%%%%%%%%%% Object motion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% object motion - object shift slightly right
objectShift = -30;
backgroundShift = 0;
background = template(:, windowStart+backgroundShift:windowEnd+backgroundShift-1);
centerGratings = template(:, windowStart+objectShift:windowEnd+objectShift-1);
centerPosition = isCircle(:, windowStart+objectShift:windowEnd+objectShift-1);
finalImg = background;
finalImg(centerPosition) = centerGratings(centerPosition);

figure(2)
%subplot(2,2,1)
clf
imagesc(finalImg)
pbaspect([1 1 1])
axis off
colormap gray
I0 = getframe;
imwrite(I0.cdata,'oms1.png')

%% object motion - object shift left
objectShift = 170;
backgroundShift = 20;
background = template(:, windowStart+backgroundShift:windowEnd+backgroundShift-1);
centerGratings = template(:, windowStart+objectShift:windowEnd+objectShift-1);
centerPosition = isCircle(:, windowStart+objectShift:windowEnd+objectShift-1);
finalImg = background;
finalImg(centerPosition) = centerGratings(centerPosition);

figure(2)
%subplot(2,2,3)
clf
imagesc(finalImg)
pbaspect([1 1 1])
axis off
colormap gray
I0 = getframe;
imwrite(I0.cdata,'oms2.png')

%% object motion (global)
backgroundShift = 0;
background = template(:, windowStart+backgroundShift:windowEnd+backgroundShift-1);

figure(2)
%subplot(2,2,2)
clf
imagesc(background)
pbaspect([1 1 1])
axis off
colormap gray
I0 = getframe;
imwrite(I0.cdata,'global1.png')

%% object motion (global)
backgroundShift = 20;
background = template(:, windowStart+backgroundShift:windowEnd+backgroundShift-1);

figure(2)
%subplot(2,2,4)
clf
imagesc(background)
pbaspect([1 1 1])
axis off
colormap gray
I0 = getframe;
imwrite(I0.cdata,'global2.png')

%%%%%%%%%%%%%%%%%%%%%% Differential motion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% grating shift slightly right
objectShift = -30;
backgroundShift = 0;
background = template(:, windowStart+backgroundShift:windowEnd+backgroundShift-1);
centerGratings = template(:, windowStart+objectShift:windowEnd+objectShift-1);
centerPosition = isCircle(:, windowStart:windowEnd-1);
finalImg = background;
finalImg(centerPosition) = centerGratings(centerPosition);

figure(3)
%subplot(2,2,1)
clf
imagesc(finalImg)
pbaspect([1 1 1])
axis off
colormap gray
I0 = getframe;
imwrite(I0.cdata,'differential1.png')

%% object motion - object shift left
objectShift = 40;
backgroundShift = 20;
background = template(:, windowStart+backgroundShift:windowEnd+backgroundShift-1);
centerGratings = template(:, windowStart+objectShift:windowEnd+objectShift-1);
centerPosition = isCircle(:, windowStart:windowEnd-1);
finalImg = background;
finalImg(centerPosition) = centerGratings(centerPosition);

figure(3)
%subplot(2,2,3)
clf
imagesc(finalImg)

pbaspect([1 1 1])
axis off
colormap gray
I0 = getframe;
imwrite(I0.cdata,'differential2.png')


%% object motion (global)
backgroundShift = 0;
background = template(:, windowStart+backgroundShift:windowEnd+backgroundShift-1);

figure(3)
%subplot(2,2,2)
clf
imagesc(background)
pbaspect([1 1 1])
axis off
colormap gray
I0 = getframe;
imwrite(I0.cdata,'global1.png')

%% object motion (global)
backgroundShift = 20;
background = template(:, windowStart+backgroundShift:windowEnd+backgroundShift-1);

figure(3)
%subplot(2,2,4)
clf
imagesc(background)
pbaspect([1 1 1])
axis off
colormap gray
I0 = getframe;
imwrite(I0.cdata,'global2.png')


%%%%%%%%%%%%%%%%%%%%%%  reversing contrast %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% center on 
objectShift = barWidth;
backgroundShift = 0;
background = template(:, windowStart+backgroundShift:windowEnd+backgroundShift-1);
centerGratings = template(:, windowStart+objectShift:windowEnd+objectShift-1);
centerPosition = isCircle(:, windowStart:windowEnd-1);
finalImg = background;
finalImg(centerPosition) = centerGratings(centerPosition);

figure(4)
%subplot(2,2,1)
clf
imagesc(finalImg)
pbaspect([1 1 1])
axis off
colormap gray
I0 = getframe;
imwrite(I0.cdata,'center1.png')

%% center off
backgroundShift = 0;
background = template(:, windowStart+backgroundShift:windowEnd+backgroundShift-1);

figure(4)
%subplot(2,2,3)
clf
imagesc(background)
pbaspect([1 1 1])
axis off
colormap gray
I0 = getframe;
imwrite(I0.cdata,'center2.png')

%% center off
backgroundShift = 0;
background = template(:, windowStart+backgroundShift:windowEnd+backgroundShift-1);

figure(4)
%subplot(2,2,2)
clf
imagesc(background)
pbaspect([1 1 1])
axis off
colormap gray
I0 = getframe;
imwrite(I0.cdata,'global1.png')

%% everything invert
backgroundShift = barWidth;
background = template(:, windowStart+backgroundShift:windowEnd+backgroundShift-1);

figure(4)
%subplot(2,2,4)
clf
imagesc(background)
pbaspect([1 1 1])
axis off
colormap gray
I0 = getframe;
imwrite(I0.cdata,'global2.png')
%%
%%%%%%%%%%%%%%%%%%%%%%%% SMS small spot %%%%%%%%%%%%%%%%%%%%%%%%%%%%
spot = isCircle(:, windowStart:windowEnd-1);
background = zeros(size(spot));
figure(5)
axis off
colormap gray
pbaspect([1 1 1]) 

%% all black
clf
imagesc(background, [0,1])
axis off
colormap gray
pbaspect([1 1 1])
I0 = getframe;
imwrite(I0.cdata,'background.png')

%% all white
clf
imagesc(background+1, [0,1])

axis off
colormap gray
pbaspect([1 1 1])
I0 = getframe;
imwrite(I0.cdata,'white.png')

%% spot
clf
imagesc(spot, [0,1])

axis off
axis('off', 'image');
colormap gray
pbaspect([1 1 1])

I0 = getframe;
imwrite(I0.cdata,'spot.png')

