% [3D] shows the image sequence I as a movie.
%
% To play a matlab movie file, as an alternative to movie, use:
%   playmovie(movie2images(M));
%
% USAGE
%  playmovie( I, [fps], [loop] )
%
% INPUTS
%  I       - MxNxT or MxNx1xT or MxNx3xT array (of images)
%  fps     - [100] maximum number of frames to display per second
%            use fps==0 to introduce no pause and have the movie play as
%            fast as possible
%  loop    - [0] number of time to loop video (may be inf),
%            if neg plays video forward then backward then forward etc.
%
% OUTPUTS
%
% EXAMPLE
%  load( 'images.mat' );
%  playmovie( videos(:,:,:,1) );
%  playmovie( video(:,:,1:3), [], -50 );
%
% DATESTAMP
%  17-May-2007
%
% See also MONTAGE2, PLAYMOVIES, MAKEMOVIE, MOVIE2IMAGES, MOVIE

% Piotr's Image&Video Toolbox      Version 1.03
% Written and maintained by Piotr Dollar    pdollar-at-cs.ucsd.edu
% Please email me if you find bugs, or have suggestions or questions!

function playmovie( I, fps, loop )

if( nargin<2 || isempty(fps)); fps = 100; end
if( nargin<3 || isempty(loop)); loop = 1; end

nd=ndims(I); siz=size(I); nframes=siz(end);
if( iscell(I) ); error('cell arrays not supported.'); end
if( ~(nd==3 || (nd==4 && any(size(I,3)==[1 3]))) )
  error('unsupported dimension of I'); end;
inds={':'}; inds=inds(:,ones(1,nd-1));
clim = [min(I(:)),max(I(:))];

h=gcf; colormap gray; figure(h); % bring to focus
for nplayed = 1 : abs(loop)
  if( loop<0 && mod(nplayed,2)==1 )
    order = nframes:-1:1;
  else
    order = 1:nframes;
  end
  for i=order
    tic; try geth=get(h); catch return; end
    imagesc(I(inds{:},i),clim); axis('image');
    title(sprintf('frame %d of %d',i,nframes));
    if(fps>0); pause(1/fps - toc); else pause(eps); end
  end
end
