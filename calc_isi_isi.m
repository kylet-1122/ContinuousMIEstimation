classdef calc_isi_isi < mi_analysis
    %Each of these objects sets the stage to calculate the mutual
    %information between spike count and behavior and stores the results of
    %the calculation. 
    %   Detailed explanation goes here
    
    properties
        isi_cutoff % ms
        isi_offset % number of ISIs to offset
    end
    
    methods


        function obj = calc_isi_isi(objData, vars, isi_offset, isi_cutoff, verbose)
            % var1 is a positive integer to indicate neuron number
            
            % BC 20190124: ADD CHECK TO SEE IF vars INCLUDES NEURONS FROM objData
            
            if nargin < 3; isi_offset = 1; end
            if nargin < 4; isi_cutoff = 200; end
            if nargin < 5; verbose = 1; end
            
            if length(vars) > 1
                error('Expected one variable specified.');
            end
            
            obj@mi_analysis(objData, vars);
            obj.isi_offset = isi_offset;
            obj.isi_cutoff = isi_cutoff;
            obj.verbose = verbose;            
        end
        
        function buildMIs(obj, verbose)
            % So I propose that we use this method to prep the
            % count_behavior data for the MI core and go ahead and run MI
            % core from here. Then we can use the output of MI core to fill
            % in the MI, kvalue, and errors.
            
            if nargin == 1
                verbose = obj.verbose;
            end
            
            % First, get spike times from neuron
            spikeTimes = obj.objData.neurons{obj.vars(1)};
            
            % BC-20190129: DO WE NEED TO REWRITE THIS CODE FOR INCREASED FLEXIBILITY...
            % WE CAN REWRITE IT SO THAT IT CAN TAKE THE MI BETWEEN ANY TWO SERIES OF ISI... ?
            % For example:
            % - interspike intervals within same spike train but with varying time delays
            % --> ISI_n | ISI_n+1
            % --> ISI_n | ISI_n+2
            % --> ISI_n | ISI_n+3
            
            % Find ISIs from spike times
            ISIs = diff(spikeTimes);
            % Check ISIs against cutoff. 
            ISIs = ISIs(find(ISIs < obj.isi_cutoff));
            
            offset = obj.isi_offset;
            % Make a vector of the first ISIs
            x = ISIs(1:end-offset);
            xGroups{1,1} = x;
            
            % Make a vector of the second ISIs
            y = ISIs(offset+1:end);
            yGroups{1,1} = y;
            
            coeffs = {1};
            
            buildMIs@mi_analysis(obj, {xGroups yGroups coeffs}, verbose);
        end
    end
end

