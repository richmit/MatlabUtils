% -*- Mode:octave; Coding:us-ascii-unix; fill-column:120 -*-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.H.S.%%
%% Copyright (c) 2025, Mitchell Jay Richling <http://www.mitchr.me/> All rights reserved.
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
%% File      applyToRows.m          
%% Author    Mitch Richling http://www.mitchr.me/
%% Date      2025-07-14        
%% Keywords  apply margin function                
%% Std       octave matlab_2022b           
%% Usage 
%%  Description
%%    Apply a function to the rows of a matrix, and return a vector of the results.
%%  Calling Forms
%%    y = applyToRows(func, x)
%%  Inputs
%%    - func .......... A function handle
%%    - x ............. A matrix
%%  Outputs
%%    - out .......... A vector of function results
%%  Details
%%    This function provides a simple interface for applying a function to the rows of a matrix.  
%%   
%%    Note many built-in functions operate on "margins".  For example, we can obtain row sums for a matrix
%%    using the built-in sum function like this:
%%       - sum(a, 2)
%%    The result is almost identical (sum returns a column vector and applyToRows returns a row vector):
%%       - applyToRows(@sum, a)
%%    We can also use cellfun/mat2cell: 
%%       - cellfun(@sum, mat2cell(a, repmat(1, 1, size(a, 1))))
%%  Examples
%%    Example 1: Compute the length of a 2D curve from points in rows
%%      sum(applyToRows(@(x) vecnorm(x(3:4)), dat(1:(end-1),:)-dat(2:end,:)))
%%    Example 2: Same as Example 1, but we limit the columns on input rather than in the anonymous function
%%      sum(applyToRows(@vecnorm, dat(1:(end-1),3:4)-dat(2:end,3:4)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.H.E.%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y] = applyToRows(func, x)
  validateattributes(func,  {'function_handle'}, {'nonempty'});
  validateattributes(x,     {'numeric'}, {'nonempty'});
  y = zeros(size(x, 1), 1);
  for i = 1:size(x,1)
	y(i) = func(x(i,1:end));
  end
end
