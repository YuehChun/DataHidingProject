function y=calic8de(BitStream,Nrow,Ncol)
rawWrite(BitStream,'in.raw');

[s,w]=dos('calic8d in.raw out.dat');
if nargin > 1
   y = rawRead('out.dat',Nrow,Ncol);
else
   y = rawRead('out.dat'); 
end
!del out.dat
!del in.raw

function y = rawRead(rawFile,Nrow,Ncol)
% rawRead: Read a binary .raw file (e.g., for those dumped from AP170)
%	Usage: y = rawRead(rawFile)

fid=fopen(rawFile, 'r');
y=uint8(fread(fid, 'uchar'));
if nargin > 1
   y=reshape(y,Nrow,Ncol);
end
fclose(fid);

function rawWrite(img,outputFile)
% rawWrite: Output a binary .raw file 
%	Usage: raw = rawWrite(lena512,'lena.raw')

fid=fopen(outputFile, 'w');
fwrite(fid,img, 'uint8');

fclose(fid);