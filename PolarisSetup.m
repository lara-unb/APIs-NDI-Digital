polaris_device = PolarisDriver('/dev/ttyUSB0');
if(polaris_present)    
    polaris_device.openSerialPort();
    polaris_device.init();
    polaris_device.detectAndAssignPortHandles();
    polaris_device.initPortHandleAll();
    polaris_device.enablePortHandleDynamicAll();
    polaris_device.startTracking();
    polaris_device.BEEP('1');
end
