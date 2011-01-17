function featureVector = extractFeatures(img, numOfGridSquares, numberOfFeatures)
    [height,width] = size(img(:,:,1));
    sqH = floor(height/numOfGridSquares);
    sqW = floor(width/numOfGridSquares);
    lst = double(img);
    
    lst(:,:,1) = (lst(:,:,1)+lst(:,:,2)+lst(:,:,3)); % l
    lst(:,:,2) = (lst(:,:,1)-lst(:,:,3));             % s
    lst(:,:,3) = (lst(:,:,1)-2*lst(:,:,2)+lst(:,:,3)); % t
    
    featureVector=zeros(1,numberOfFeatures);
    
    index = 1;
    
    for i = 1:numOfGridSquares
        for j = 1:numOfGridSquares
            
            row1 = floor((sqH)*(i-1))+1;
            row2 = floor((sqH)*i);
            col1 = floor((sqW)*(i-1))+1;
            col2 = floor((sqW)*i);
            
            for k = 1:3 %number of channels in LST
                region = lst(row1:row2,col1:col2,k);
                avg = mean(region(:));
                featureVector(1,index) = avg;
                index = index + 1;
                featureVector(1,index) = sqrt(sum(sum((region-avg).^2))/...
                    (size(region,1)*size(region,2)));
                index = index +1;
            end
        end
    end
end