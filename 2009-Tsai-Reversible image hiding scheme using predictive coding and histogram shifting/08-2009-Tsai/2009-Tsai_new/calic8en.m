function y=calic8en(Img)
depth=8;
rawWrite(Img,'in.raw',depth);
[row col]=size(Img);
str=['calic8e in.raw ',num2str(row),' ',num2str(col),' ', num2str(depth),' 0 ','out.dat'];
[s m]=dos(str);
y = rawRead('out.dat',depth);
!del out.dat
!del in.raw

function y = rawRead(rawFile,depth,Nrow,Ncol)
% rawRead: Read a binary .raw file (e.g., for those dumped from AP170)
%	Usage: y = rawRead(rawFile)

fid=fopen(rawFile, 'r');
y=fread(fid, ['ubit' num2str(depth)]);
if depth==8
    y=uint8(y);
elseif depth==1
    y=logical(y);
end

if nargin > 2
   y=reshape(y,Nrow,Ncol);
end
fclose(fid);

function rawWrite(img,outputFile,depth)
% rawWrite: Output a binary .raw file 
%	Usage: raw = rawWrite(lena512,'lena.raw')

fid=fopen(outputFile, 'w');
fwrite(fid,img, ['ubit' num2str(depth)]);

fclose(fid);


% calic8e: encoder
% calic8d: decoder
% 
% The encoder receives 8-bits raw image data stored in raster scan order.
% 
% Usage:
%    calic8e [*.raw] [width] [height] [depth] [Peak Absolute Error] [comressed file name]
% 
% example
%    calic8e lena.raw 512 512 8 0 coded.dat      (lossless case) 
%    calic8e lena.raw 512 512 8 3 coded.dat      (nearlossless: pae=3)
% 
%    calic8d coded.dat recon.raw                 