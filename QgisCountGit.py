import os
for file in os.listdir("C:/Users"):
    if file.endswith(".shp"):
        processing.runAndLoadResults("native:countpointsinpolygon", {'POLYGONS':os.path.join("C:/Users", file),'POINTS':'delimitedtext://file:///C:/Users/File.csv?type=csv&maxFields=10000&detectTypes=yes&xField=location/lng&yField=location/lat&crs=EPSG:4326&spatialIndex=no&subsetIndex=no&watchFile=no','WEIGHT':'','CLASSFIELD':'','FIELD':'NUMPOINTS','OUTPUT':'TEMPORARY_OUTPUT'})
