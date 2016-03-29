classdef PortHandle < handle
    
    %
    %   This class represents simultaneously one port handle of the Aurora
    %   SCU and the tool conected to it.
    %
    
    % Author: André Augusto Geraldes
    % Email: andregeraldes@lara.unb.br
    % July 2015; Last revision:
    
    % Constants
    properties (Constant)
        
        % Handle Status (source: Aurora_API_Guide page 13)
        SENSOR_STATUS_VALID    = '01';
        SENSOR_STATUS_MISSING  = '02';
        SENSOR_STATUS_DISABLED = '04';
    end
        
    % Member variables
    properties (GetAccess = public, SetAccess = private)
        % Port Handle ID, given as a 2 character hex number (string)
        id;          
        
        % Port Handle status variables (source: Aurora_API_Guide page 34)
        occupied;
        initialized;
        enabled;
        gpio_line1_closed;
        gpio_line2_closed;
        gpio_line3_closed;
        out_of_volume;
        partial_out_of_volume;
        sensor_broken;        
        
        % Handle Status (source: Aurora_API_Guide page 13)
        sensor_status;
        
        % Last registered tool data
        trans;
        rot;
        error;
        frame_number;
    end
    
    
    % Public methods
    methods (Access = public)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %             CONSTRUCTOR              %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = PortHandle(id, status)
            % OBS: I need to know what informations will be available when
            % the object is initialized
            
            obj.id = id;
            obj.updateStatus(status);
            obj.out_of_volume         = 0;
            obj.partial_out_of_volume = 0;
            obj.sensor_broken         = 0;
            obj.sensor_status = obj.SENSOR_STATUS_DISABLED;
            
            % Last registered tool data
            obj.trans = [0.0 0.0 0.0];
            obj.rot = [0.0 0.0 0.0 0.0];
            obj.error = 0.0;
            obj.frame_number = 0;
        end
        
        function updateStatus(obj, status)
            status_value = hex2dec(status);
            obj.occupied          = bitget(status_value, 1);
            obj.gpio_line1_closed = bitget(status_value, 2);
            obj.gpio_line2_closed = bitget(status_value, 3);
            obj.gpio_line3_closed = bitget(status_value, 4);
            obj.initialized       = bitget(status_value, 5);
            obj.enabled           = bitget(status_value, 6);            
        end
        
        function updateStatusComplete(obj, status)
            status_value = hex2dec(status);
            obj.occupied              = bitget(status_value, 1);
            obj.gpio_line1_closed     = bitget(status_value, 2);
            obj.gpio_line2_closed     = bitget(status_value, 3);
            obj.gpio_line3_closed     = bitget(status_value, 4);
            obj.initialized           = bitget(status_value, 5);
            obj.enabled               = bitget(status_value, 6);
            obj.out_of_volume         = bitget(status_value, 7);
            obj.partial_out_of_volume = bitget(status_value, 8);
            obj.sensor_broken         = bitget(status_value, 9);
        end
        
        function updateSensorStatus(obj, sensor_status)
            obj.sensor_status = sensor_status;
        end
        
        function updateTrans(obj, trans)
            obj.trans = trans;
        end
        
        function updateRot(obj, rot)
            obj.rot = rot;
        end        
        
        function updateError(obj, error)
            obj.error = error;
        end        
        
        function updateFrameNumber(obj, frame_number)
            obj.frame_number = frame_number;
        end        
    end
end