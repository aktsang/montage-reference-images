%% montage refs
% A. Tsang 2019-08-27
% Quick and dirty ref montage; auto adjust images and montage
% Intended to be used immediately after finding cells and writing
% positions to check for major errors.

refList = dir('/Volumes/genie/GeviScreenData/NeuronData/20181218_ArcLight96f/P1a-20181203_ArcLight96f/AutoFocusRef2*');

for i = 1:size(refList,1)
    
    % delimit underscores and dashes to find well name.
    % well name (e.g. 'A02') follows the first dash.
    % ROI name (e.g. 'a') follows the third underscore
    
    refName = string(refList(i).name);
    underscorepos = strfind(refName, '_');
    dashpos = strfind(refName, '-');
    wellName = extractBefore(refName,underscorepos(2));
    wellName = extractAfter(wellName,dashpos(1));
    roiName = extractBefore(refName,underscorepos(4));
    roiName = extractAfter(roiName,underscorepos(3));
    positionName = cell(1,1);
    positionName{1} = char(strcat(wellName, roiName));
    
    % Read images
    
    currentImage = fullfile(refList(i).folder, refList(i).name);
    imageArray = imread(currentImage);
    adjImage{i} = imadjust(imageArray);
    
    % insert position name using a method below:
    
    % insertText can be used to label the image (requires computer vision toolbox)
    textPos = [1 1];
    adjImage{i} = insertText(adjImage{i},textPos, positionName, 'BoxOpacity', 0.0, 'FontSize',40, 'TextColor', 'blue');
    
    % alternatively, use:
    %    figure%('Visible','off');
    %    imshow(adjImage{i});
    %    text(10,30,'A01a','Color','blue','FontSize',32);
    %   getframe() <- creates a movie frame from figure object
    %   frame2im(...) <- creates an array from the frame
    %    close;
    
end

todaysdate = datetime;
todaysdate.Format = 'yyyyMMdd';
filedate = string(todaysdate);

slashes = strfind(outputName, '\');
slashsize = size(slashes,2);
platenum = extractAfter(outputName, slashes(slashsize));
periodloc = strfind(platenum,'.');
platenumber = extractBefore(platenum, periodloc(1));

outputname = strcat(filedate, '_', 'plate', platenumber,'.tif');

figure('Name','Quick and dirty Ref Image Montage')
montage(adjImage, 'ThumbnailSize', [128 128])
title('Montage of all reference images taken - Autoscaled for contrast')

print('-r300', outputname, '-dtiff');