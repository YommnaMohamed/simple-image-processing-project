RGB = imread('C:\Users\yommn\OneDrive\Desktop\yommna_mohamed_hafez_section_4\22.png');
 %RGB = imresize(RGB, 0.5);
figure,imshow(RGB); 
%threshold
I = rgb2gray(RGB);
threshold = graythresh(I); 
bw = im2bw(I,threshold);
figure,imshow(bw)
%Edge detection 
 bb= edge(bw,'canny');
 figure,imshow(bb),title('with edge detection'), 
%remove noise
% remove all object containing fewer than 30 pixels
bw1 = bwareaopen(bw,30);
% fill a gap in the pen's cap
se = strel('disk',3);
bw2 = imclose(bw1,se); 
% fill any holes 
bw3 = imfill(bw2,'holes');
figure,imshow(bw3) 
[B,L] = bwboundaries(bw3,'noholes');
% Display the label matrix and draw each boundary 
 figure,imshow(label2rgb(L, @hsv, [.5 .5 .5]))
hold on 
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end
stats = regionprops(L,'Area','Centroid','BoundingBox'); 
 
% loop over the boundaries
for k = 1:length(B)
    % obtain (X,Y) boundary coordinates corresponding to label 'k' 
    boundary = B{k}; 
      % compute a simple estimate of the object's perimeter
      delta_sq = diff(boundary).^2; 
      perimeter = sum(sqrt(sum(delta_sq,2))); 
      % obtain the area calculation corresponding to label 'k'
      area = stats(k).Area; 
      % compute the roundness metric
      metric = 4*pi*area/perimeter^2; 
      % display the results 
      metric_string = sprintf('%2.2f',metric); 
       % mark objects above the threshold with a black circle
       if metric > 0.85
           centroid = stats(k).Centroid;
           plot(centroid(1),centroid(2),'ko');
           bbox=stats(k).BoundingBox;
           rectangle('Position', [bbox(1)-5,bbox(2)-5,bbox(3)+15,bbox(4)+15],... 
           'EdgeColor','r','LineWidth',2 )
       end 

  
  text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
       'FontSize',14,'FontWeight','bold') 
         
end
         title('Metrics closer to 1 indicate that the object is approximately round') 