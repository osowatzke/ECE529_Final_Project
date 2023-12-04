% Author: O. Sowatzke
%
% Updated: 12/05/2023
%
% Subject: Class initializes class properties using a list of
% key value pairs.
%
classdef key_value_constructor < handle
    methods
        function self = key_value_constructor(varargin)
            for i = 1:2:nargin
                self.(varargin{i}) = varargin{i+1};
            end
        end
    end
end