% -*- Mode:octave; Coding:us-ascii-unix; fill-column:120 -*-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.H.S.%%
%% Copyright (c) 2023, Mitchell Jay Richling <http://www.mitchr.me/> All rights reserved.
%% 
%% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
%% following conditions are met:
%% 
%% 1. Redistributions of source code must retain the above copyright notice, this list of conditions, and the
%%    following disclaimer.
%% 
%% 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the
%%    following disclaimer in the documentation and/or other materials provided with the distribution.
%% 
%% 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote
%%    products derived from this software without specific prior written permission.
%% 
%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
%% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
%% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
%% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
%% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
%% WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
%% USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%%
%% File      hist2d.m          
%% Author    Mitch Richling http://www.mitchr.me/
%% Keywords                    
%% Std       octave matlab_2022b           
%% Usage 
%%  Description
%%    Compute a bivariate histogram
%%  Calling Forms
%%    [hMat, binsX, binsY] = hist2d(inX, inY, breaksX, breaksY) 
%%  Inputs
%%    - inX  .......... Vector of x coordinates for the points. 
%%                      If breaksX & breaksY are integers, then inX will be recycled if inY is longer.
%%    - inY ........... Vector of y coordinates for the points
%%    - breaksX ....... histogram breaks for the x coordinates
%%                      May be vector of the same type as inX, or a single integer.
%%    - breaksY ....... histogram breaks for the y coordinates
%%                      May be vector of the same type as inY, or a single integer.
%%  Outputs
%%    - hMat .......... A matrix of histogram counts
%%    - binsX ......... Center pionts of the x coordinate histogram bins
%%    - binsY ......... Center pionts of the x coordinate histogram bins
%%  Details
%%    The breaks arguments work as they do in R.  When scalar, they are interpreted as the number of bins to use.  When
%%    vector, they are interpreted as the breaks between bins.  If breaksX is missing, it is set to 20. If breaksY is
%%    missing, it is set to breaksX.  Note the function is orders of magnitude faster when both breaksX & breaksY are
%%    scalars. Note this function computes the histogram buckets and counts, and returns them as matrices.  For a plot
%%    of the results, consider the surfc() and imagesc() functions.
%%  Examples
%%    One normally plots the resulting histogram.  
%%    Example 1:
%%      %% First we create some data
%%        y=reshape(randn(500),[],1);
%%        x=reshape(randn(500),[],1);
%%      %% Compute a histogram with a quarter of a million buckets (500^2), and use it to draw an image.
%%        [ch, xh, yh]=hist2d(x, y, 500, 500);
%%        figure()
%%        imagesc(xh, yh, ch)
%%      %% The number of buckets in the previous call is too high for a nice surface plot.
%%      %% Compute a histogram with a 2500 buckets, and use it to draw a surface.
%%        [ch, xh, yh]=hist2d(x, y, 50, 50);
%%        figure()
%%        surfc(xh, yh, ch)
%%      %% MATLAB NOTE:  With MATLAB we can use the smoothdata2() function to smooth the high resolution histogram.  
%%      %%   We can then draw a %%   surface so long as we remove the mesh lines with a call to shading().  The sequence
%%      %%   looks something like this:
%%        [ch, xh, yh]=hist2d(x, y, 500, 500);
%%        chs=smoothdata2(ch, "gaussian", 20);
%%        figure()
%%        surfc(xh, yh, chs)
%%        shading INTERP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.H.E.%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hMat, binsX, binsY] = hist2d(inX, inY, breaksX, breaksY)
  validateattributes(inX,  {'numeric'}, {'nonempty'});
  validateattributes(inY,  {'numeric'}, {'nonempty'});
  %% Check argument count and set missing arguments
  if nargin < 3
    breaksX = 20;
    breaksY = 20;
  elseif nargin < 4
    breaksY = breaksX;
  elseif nargin > 4
    error('hist2d: Too many arguments!')
  end
  %% Compute histogram
  if (isscalar(breaksX) && isscalar(breaksY))
    %% Compute bin centers
    binsX = conv(linspace(min(inX), max(inX), breaksX+1), [0.5, 0.5], "valid");
    binsY = conv(linspace(min(inY), max(inY), breaksY+1), [0.5, 0.5], "valid");
    %% Compute constants for histogram computation
    lenX = length(inX);
    [minX, maxX] = bounds(inX);
    [minY, maxY] = bounds(inY);
    deltaX = (maxX-minX)/breaksX;
    deltaY = (maxY-minY)/breaksY;
    %% Initialize histogram
    hMat = zeros(breaksY, breaksX);
    %% Fill in histogram
    for idxY = 1:length(inY)
      idxX = mod(idxY-1, lenX)+1;
      intX  = round((inX(idxX) - minX) / deltaX) + 1;
      intY  = round((inY(idxY) - minY) / deltaY) + 1;
      if ((intX >= 1) && (intY >= 1) && (intX <= breaksX) && (intY <= breaksY))
        hMat(intY, intX) = hMat(intY, intX) + 1;
      end
    end
  else
    %% In this case, inX & inY must be the same length
    if numel(inX) ~= numel(inY)
      error('hist2d: inX & inY must be the same length!')
    end
    %% If breaksX or breaksY is a scalar, then construct a vector
    if isscalar(breaksX)
      breaksX = linspace(min(inX), max(inX), breaksX+1);
    end
    if isscalar(breaksY)
      breaksY = linspace(min(inY), max(inY), breaksY+1);
    end
    %% Compute bin centers
    binsX = conv(breaksX, [0.5, 0.5], "valid")
    binsY = conv(breaksY, [0.5, 0.5], "valid")
    %% Initialize our histogram matrix
    hMat = zeros(length(binsY), length(binsX));
    %% Fill the buckets
    for i = 1:size(hMat,1)
	  bolY = (inY >= breaksY(i) & inY < breaksY(i+1));
	  for j = 1:size(hMat,2)
	    hMat(i, j) = sum(inX(bolY) >= breaksX(j) & inX(bolY) < breaksX(j+1));
	  end
    end
  end
end
