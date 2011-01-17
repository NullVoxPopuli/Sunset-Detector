function featureVector = extractFeatures(img)
    [height,width] = size(img(:,:,1));
    sqH = floor(height/7);
    sqW = floor(width/7);
    lst = double(img);
    lst(:,:,1) = (lst(:,:,1)+lst(:,:,2)+lst(:,:,3)); % l
    lst(:,:,2) = (lst(:,:,1)-lst(:,:,3));             % s
    lst(:,:,3) = (lst(:,:,1)-2*lst(:,:,2)+lst(:,:,3)); % t
    featureVector=zeros(1,294);
    index = 1;
    for i = 1:7
        for j = 1:7
            row1 = floor((sqH)*(i-1))+1;
            row2 = floor((sqH)*i);
            col1 = floor((sqW)*(i-1))+1;
            col2 = floor((sqW)*i);
            for k = 1:3
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