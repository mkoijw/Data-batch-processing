function lla_data = itrf2lla(intf_data)

lla_data = ecef2lla([intf_data*1000],'WGS84');


