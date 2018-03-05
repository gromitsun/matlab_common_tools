function plot_cmap(cmap)

imagesc(repmat(reshape(cmap,1,size(cmap,1),3),[2,1,1]))