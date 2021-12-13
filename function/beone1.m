function xy=beone1(xy1)
for i=1:size(xy1,1)
   xy(i,:)=xy1(i,:)-mean(xy1,1) ;
end

end