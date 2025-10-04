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
%% File      simplifyCurveEuc.m          
%% Author    Mitch Richling http://www.mitchr.me/
%% Std       octave matlab_2022b           
%% Usage 
%%  Description
%%    Simplify a curve by removing adjacent points that are close together.  
%%  Calling Forms
%%    [outMat] = simplifyCurveEuc(inMat, cols, minD)
%%  Inputs
%%    - inMat ......... Matrix with each row containing a curve point
%%    - cols .......... The columns containing point data
%%    - minD .......... Minimum Distance
%%  Outputs
%%    - outMat ........ Result matrix (all columns of inMat are present, not just those in cols)
%%  Details
%%    Simplify a curve by removing adjacent points that are close together. The metric for "close" is Euclidean
%%    distance.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.H.E.%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outMat] = simplifyCurveEuc(inMat, cols, minD)
  %% Check arguments
  validateattributes(inMat,  {'numeric'}, {'nonempty'});
  validateattributes(cols,   {'numeric'}, {'nonempty', 'positive', 'integer', '<=', size(inMat, 2)});
  validateattributes(minD,   {'numeric'}, {'scalar', 'positive'});
  %% Initialize the output array
  outMat = zeros(size(inMat));
  %% Now zip down array copying only elements we want -- start with 2.
  outMat(1,:) = inMat(1,:);
  tstIndex = 1;
  for curIndex = 2:size(inMat, 1)
    if (vecnorm(inMat(curIndex, cols) - inMat(tstIndex, cols)) > minD) 
      tstIndex = tstIndex + 1;
      outMat(tstIndex,:) = inMat(curIndex,:);
    end
  end
  outMat = outMat(1:tstIndex,:);
end
