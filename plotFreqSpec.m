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
%% File      plotFreqSpec.m          
%% Author    Mitch Richling http://www.mitchr.me/
%% Std       octave matlab_2022b           
%% Usage 
%%  Description
%%    Plot samples & FFT of samples with linear & logarithmic scales
%%  Calling Forms
%%                  plotFreqSpec(samples, samp_period, winfun)  -- Results in a plot.
%%     mag        = plotFreqSpec(samples, samp_period, winfun)  -- No plot is produced
%%    [mag, freq] = plotFreqSpec(samples, samp_period, winfun)  -- No plot is produced
%%  Inputs
%%    - samples ....... a vector/matrix of numeric sample points. 
%%                      Expected to be regularly spaced in time.
%%    - samp_period ... The time between sample points (1/samp_freq)
%%    - winfun ........ a vector/matrix of numeric window weights
%%  Outputs
%%    - mag ........... Vector of FFT magnitudes (y-axis points)
%%    - freq .......... Vector of frequency markers (x-axis points)
%%  Details
%%    I mostly use this for oscilloscope waveform captures and SPICE simulation results.
%%    The MATLAB function pspectrum is very similar.
%%  Examples
%%    Example 1
%%      t = (0:0.001:1)';
%%      y = sin(2*pi*50*t) + 2*sin(2*pi*120*t);
%%      plotFreqSpec(y, 0.001)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.H.E.%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = plotFreqSpec(samples, samp_period, window_weights)
  validateattributes(samples, {'numeric'}, {'nonempty'});                        % Check first argument
  if (nargin > 3)                                                                % Check argument count
    error("plotFreqSpec: Expecting at most three arguments!");                   %
  end                                                                            %
  if (nargin < 2)                                                                % Set default for samp_period
    samp_period = 1;                                                             %  Default is 1
  end                                                                            %
  validateattributes(samp_period, {'numeric'}, {'scalar', 'real', 'positive' }); % Check samp_period value
  num_samp            = numel(samples);                                          % Length of signal
  if (num_samp < 3)                                                              % Check that samples has enough data
    error("plotFreqSpec: Expecting more samples!");                              %
  end                                                                            %
  if mod(num_samp, 2) == 1                                                       % Signal midpoint index
    num_half          = (num_samp + 1) / 2;                                      %   Odd length case
  else                                                                           %
    num_half          = (num_samp / 2) + 1;                                      %   Even length case
  end                                                                            %
  samp_freq           = 1/samp_period;                                           % Sampling frequency                    
  time_points         = samp_period*(0:(num_samp-1));                            % Time vector
  if (nargin == 3)                                                               % we have a winfun
    validateattributes(window_weights, {'numeric'}, {'nonempty'});               %   Check weight argumetns
    fft_vals          = fft(samples .* window_weights);                          %   FFT values
    win_scale         = (num_samp / sum(window_weights))^2;                      %   Scale factor for windwos
  else                                                                           % we do *not* have a winfun
    fft_vals          = fft(samples);                                            %   FFT values
    win_scale         = 1;                                                       %   Scale factor for windwos
  end                                                                            %
  fft_sclAbs          = abs(fft_vals(1:num_half)) / num_samp;                    % Scaled absolute value FFT
  fft_sclAbs(2:end-1) = (2/sqrt(2))*fft_sclAbs(2:end-1)*win_scale;               %   Scale interpoints to RMS
  fft_sclSqr          = fft_sclAbs.^2;                                           % Squared values (new var as I might want Abs in the future)
  freq_points         = linspace(0, samp_freq/2, num_half);                      % Frequency points
  if (nargout >= 1)                                                              % Process first return on request
    varargout{1} = fft_sclSqr;                                                   %  
    if (nargout >= 2)                                                            % Process first return on request
      varargout{2} = freq_points;                                                %
    end                                                                          %
  else                                                                           %
    subplot(3,1,1)                                                               % Draw time-domain graph
    plot(time_points, samples)                                                   %   Draw the plot
    title("Time Domain Domain")                                                  %   Set the main plot title
    xlabel("Time")                                                               %   Set the x axis title
    ylabel("V")                                                                  %   Set the y axis title (V for lack of a better name)
    subplot(3,1,2)                                                               % Draw frequency-domain graph
    plot(freq_points, fft_sclSqr)                                                %   Draw the plot
    title("Single-Sided Amplitude Spectrum (linear scale)")                      %   Set the main plot title
    xlabel("Frequency")                                                          %   Set the x axis title
    ylabel("(RMS)^2")                                                            %   Set the y axis title
    subplot(3,1,3)                                                               % Draw frequency-domain graph
    semilogy(freq_points, fft_sclSqr)                                            %   Draw the plot
    title("Single-Sided Amplitude Spectrum (log scale)")                         %   Set the main plot title
    xlabel("Frequency")                                                          %   Set the x axis title
    ylabel("(V RMS)^2")                                                          %   Set the y axis title
  end                                                                            %
end                                                                              %
