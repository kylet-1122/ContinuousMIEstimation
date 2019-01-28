classdef analysis_count_behavior < MI_KSG_data_analysis
    %Each of these objects sets the stage to calculate the mutual
    %information between spike count and behavior and stores the results of
    %the calculation. 
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
       function obj = analysis_count_behavior(objData,var1,var2, verbose)
            % Construct an instance of this class
            %   Detailed explanation goes here
            obj =  MI_KSG_data_analysis(objData, var1, var2);
            [xGroups,yGroups, Coeffs] = setParams(obj,pressureLength, verbose);
            obj.arrMIcore{1,2} = Coeffs;
            obj.findMIs(xGroups,yGroups,Coeffs,verbose);

        end
        
        function [xGroups, yGroups, Coeffs] = setParams(obj, pressureLength, verbose)
            % So I propose that we use this method to prep the
            % count_behavior data for the MI core and go ahead and run MI
            % core from here. Then we can use the output of MI core to fill
            % in the MI, kvalue, and errors.
            
            % First, segment neural data into breath cycles
            x = objData.getCount(var1,verbose);
            
            xGroups{1,1} = x;
            
            % Next segment pressure data into cycles
            y = objData.getPressure(pressureLength,verbose);
            yGroups{1,1} = y;
            
            Coeffs = {1};
            
            
            
        end
    end
end
