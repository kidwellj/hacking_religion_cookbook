require(sf) # simplefeature data class, supercedes sp in many ways, also includes gdal functions

# Data is open access, but there isn't a static link that seems to be readily 
# accessible so I would advise that users download this directly from 
# https://osdatahub.os.uk/downloads/open/OpenMapLocal
# Select area: "All of Great Britain" and data format: GeoPackage
# Fair warning, this will produce a massive file, around 3.5gb compressed and over 7gb uncompressed

# This operation currently fails, but am keeping it here just for later modification

if (file.exists(here("data", "opmplc_gb.gpkg", "data", "opmplc_gpkg_gb")) == FALSE) {  download.file("https://omseprd1stdstordownload.blob.core.windows.net/downloads/OpenMapLocal/2023-04/allGB/Geopackage/opmplc_gpkg_gb.zip?sv=2022-11-02&spr=https&se=2023-10-09T19%3A23%3A07Z&sr=b&sp=r&sig=83IzfszzgJxmkGGS3N7oxnpmdKvUD3JLpPQERXv0WTM%3D", destfile = here("data", "opmplc_gpkg_gb.zip"))}
unzip("data/opmplc_gpkg_gb.zip", exdir = "data")

# For academics in the UK, an alternative is to use the DigiMap service, which also provides an enhanced
# PointX database. Sadly, this dataset is paywalled by digimap, though most academic researchers 
# should be able to aquire it through an institutional subscription from Digimap, Ordnance Survey Data Download. 
# The POI set is located under "Boundary and Location Data" under "Points of Interest," "select visible area" 
# for whole UK then download.

# Load in data, specifying the layer "important_building"
# We're going to use a more sophisticated st_read command which can filter this very large file
# h/t to https://gis.stackexchange.com/questions/341718/how-do-i-read-a-layer-from-a-gpkg-file-whilst-selecting-on-an-attribute for this approach

# The feature_code for places of worship in the OpenMap product is Feature Code: 15025. This is equivalent to PointX "6340459"


os_openmap_pow <- st_read(here("data", "opmplc_gpkg_gb", "data", "opmplc_gb.gpkg"),
                          layer="important_building",
                          query= "SELECT * FROM important_building WHERE feature_code = '15025';")

st_write(os_openmap_pow, dsn = con, layer = "ecs",
         overwrite = FALSE, append = FALSE)


# These features are stored as polygons by OS so we can't export to a file as point data 
# so CSV will end up with a blank column. FYI, if this weren't the case, here's how you'd export to CSV
st_write(os_openmap_pow, here("data", "os_openmap_pow.csv"), layer_options = "GEOMETRY=AS_XY")

# Here's how you'd export to (yuck!) shapefile:
st_write(os_openmap_pow, here("data", "os_openmap_pow.shp"), delete_layer = TRUE)

# St_wrte can also write to sql databases, and if you are working with massive complex datasets
# it can soemtimes be more efficient to load the dataset into a PostGRES database with PostGIS extensions
# loaded. You can then run queries from R on that database drawing in specific subsets of data using 
# geospatial sql operations. I give an example of this in the `openstreetmapparse.R` file in this repo

# And ultimately, st_write is a wrapper for GDAL, so you can export to a wide range of file types
# including geoJSON, gpx etc etc.