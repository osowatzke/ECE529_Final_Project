% Author: O. Sowatzke
%
% Updated: 11/18/2023
%
% Subject: Base class for direction of arrival estimator
%
classdef doa_estimator < key_value_constructor

    % Public class properties
    properties

        % Element spacing in the uniform linear array
        % expressed in terms of lambda
        element_spacing;

        % Look angle in degrees 
        look_angle;
    end
end