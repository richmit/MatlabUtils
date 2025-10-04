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
%% File      plotCurveFile.m          
%% Author    Mitch Richling http://www.mitchr.me/
%% Date      2025-07-01        
%% Std       octave matlab_2022b           
%% Usage 
%%  Description
%%    Read a file, plot it as a curve using each row as a point, and return read data as a matrix.
%%  Calling Forms
%%    [nrow, fmat] = plotCurveFile(filename)
%%    [nrow, fmat] = plotCurveFile(filename, delimiter)
%%    [nrow, fmat] = plotCurveFile(filename, delimiter, skiplines)
%%  Inputs
%%    - filename ...... Name of a file (Char/String)
%%    - columns ....... Columns to plot.
%%                      Default: [1, 2, 3]
%%                      If set 0, the default will be used instead
%%    - delimiter ..... Delimiter to separate values.  
%%                      Default: ','
%%                      If set to the empty string, '', then it will be set to ','.
%%                      See dlmread() for more details.
%%    - skiplines ..... Number of lines to discard at start of file.  
%%                      Default: 1
%%                      See dlmread() for more details.
%%  Outputs
%%    - nrow ... The number of rows read from the file
%%    - fmat ... The data read from the file
%%  Details
%%    The type of graph is determined by the number of columns being plotted:
%%      - 1 column ........... A 2D, X-Y curve with the row index as the X variable.
%%      - 2 columns .......... A 2D parametric curve
%%      - 3 or more columns .. A 3D parametric space curve from the first 3 columns
%%    I plot a lot of curves from CSV files, and this little function saves me quite a bit of typing.  My primary
%%    motivation is drawing 3D strange attractors in one variable -- I frequently produce, via simulation or
%%    oscilloscope waveform capture, such curves as a CSV.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.H.E.%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [nrow, fmat] = plotCurveFile(filename, columns, delimiter, skiplines)
  validateattributes(filename,  {'char', 'string'}, {'nonempty'});
  if nargin < 2
    columns   = [1, 2, 3]
  elseif columns == 0
    columns   = [1, 2, 3]
  end
  if nargin < 3
    delimiter = ',';
  end
  if nargin < 4
    skiplines = 1;
  end
  validateattributes(columns, {'numeric'}, {'positive', 'integer', 'nonempty', 'row'});
  validateattributes(delimiter, {'char', 'string'}, {'nonempty'});
  validateattributes(skiplines, {'numeric'}, {'scalar', 'nonnegative'});
  if (delimiter == '')
    delimiter = ',';
  end

  fmat = dlmread(filename, delimiter, skiplines, 0);
  fsiz = size(fmat);
  nrow = fsiz(1);
  nplt = min(fsiz(2), length(columns));
  if (nplt == 1) 
    plot(fmat(:,columns(1)))
  elseif (nplt == 2) 
    plot(fmat(:,columns(1)), fmat(:,columns(2)))
  elseif (nplt >= 3) 
    plot3(fmat(:,columns(1)), fmat(:,columns(2)), fmat(:,columns(3)))
  else
    error("plotCurveFile: File has no data?!")
  end  
end
