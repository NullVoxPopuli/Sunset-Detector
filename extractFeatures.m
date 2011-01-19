function featureVector = extractFeatures(img, numOfGridSquares, numberOfFeatures)
    [height,width] = size(img(:,:,1));
    sqH = floor(height/numOfGridSquares);
    sqW = floor(width/numOfGridSquares);
    lst = double(img);
    ofsetH = floor(sqH/4)*0;
    ofsetW = floor(sqW/4)*0;
    lst(:,:,1) = (lst(:,:,1)+lst(:,:,2)+lst(:,:,3)); % l
    lst(:,:,2) = (lst(:,:,1)-lst(:,:,3)); % s
    lst(:,:,3) = (lst(:,:,1)-2*lst(:,:,2)+lst(:,:,3)); % t
    
    featureVector=zeros(1,numberOfFeatures);
    
    index = 1;
    
    for i = 1:numOfGridSquares
        for j = 1:numOfGridSquares
            
            row1 = floor((sqH)*(i-1)) - ofsetH;
            row2 = floor((sqH)*i) + ofsetH;
            col1 = floor((sqW)*(j-1)) - ofsetW;
            col2 = floor((sqW)*j) + ofsetH;
            
            if row1 <= 0
                row1 = 1;
            end
            if col1 <= 0
                col1 = 1;
            end
            if row2 >= height
                row2 = height;
            end
            if col2 >= width
                col2 = width;
            end
                    
            
            for k = 1:3 %number of channels in LST
                region = lst(row1:row2,col1:col2,k);
                avg = mean(region(:));
                featureVector(1,index) = avg;
                index = index + 1;
                featureVector(1,index) = std2(region);
                index = index +1;
            end
        end
    end
end