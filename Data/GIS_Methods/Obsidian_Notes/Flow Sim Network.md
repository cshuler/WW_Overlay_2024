![[Pasted image 20260424092730.png]]
Step 0.1: Create file geodatabase in convenient location and a Dataset with coordinate system UTM 4N Meters
![[2026April23_185815_839_wsBE.png]]

Step 0.2: Create Feature Dataset with coordinate system UTM 4N
![[2026April23_190201_839_8VUk.png]]
![[Pasted image 20260423190453.png]]


Step 1: Download road shapefiles for each county
![[Pasted image 20260423180352.png]]
Step 2: Unzip and add to ArcGIS Pro
![[Pasted image 20260423180736.png]]
![[Pasted image 20260423180827.png]]

Step 3: Make sure all counties have **fullname** text field 40 characters long
![[Pasted image 20260423181812.png]]

Step 4 (optional): Add field for island name or county name for easier identification later
![[Pasted image 20260423182820.png|697]]

Step 5: Rename layers in table of contents to simpler forms
![[Pasted image 20260423183327.png]]

Step 5: Run Merge tool
![[Pasted image 20260423183424.png]]

Step 6: Choose input datasets, set output feature class name
![[Pasted image 20260423183634.png]]

Step 6: Set **Field Matching Mode** to "Use the field map to..." and check "Add source info..."
![[Pasted image 20260423183725.png]]

Step 6: Remove unnecessary fields from field map. All could be removed because they aren't necessary for network analysis but may be useful as a reference later. I kept fullname and st_lengths because those exist in all 4 county datasets
![[Pasted image 20260423184004.png]]

Step 7: Run Merge and check output. There is a MERGE_SRC field with names taken from TOC layer names
![[Pasted image 20260423184900.png|697]]

Step 8: Create new long integer field called **RoadID** and calculate object ID into it so this can be used as a permanent unique ID
![[Pasted image 20260423201038.png]]
![[Pasted image 20260423201137.png]]



Step 9: Export merged roads to the Feature Dataset in the file geodatabase
![[Pasted image 20260423194602.png]]

Step 9: Create point layers for start and end points of road segments
![[Pasted image 20260423195708.png]] 
![[Pasted image 20260423195800.png]]


Start and endpoints coincide where road segments meet
![[Pasted image 20260423201927.png]]

Add elevation raster to ArcGIS Pro project
![[Pasted image 20260423202238.png]]

Use Extract Multi Values to Points to assign raster elevation to each Start point with fieldname **StartZ** with Bilinear interpolation enabled to smooth out values and prevent stairsteps at pixel edges
![[Pasted image 20260423202607.png]]

Use Extract Multi Values to Points to assign raster elevation to each End point with fieldname **EndZ** with Bilinear interpolation enabled to smooth out values and prevent stairsteps at pixel edges
![[Pasted image 20260423202637.png]]

Use Join Field to add StartZ and EndZ to HI_Roads using RoadID as the unique key
![[Pasted image 20260423203205.png]]

![[Pasted image 20260423203448.png]]


Now each road segment has a StartZ and EndZ value in meters
![[Pasted image 20260423203827.png]]


Add a Double field called LenMeters to store length 
![[Pasted image 20260423204112.png]]

Use Calculate Geometry to populate length in meters using the UTM 4N coordinate system
![[Pasted image 20260423204208.png]]

Create new  Double field called RiseMeters to store difference from StartZ to EndZ
![[Pasted image 20260423204344.png]]

Calculate RiseMeters = !EndZ! - !StartZ!
![[Pasted image 20260423204435.png]]

There will probably a few Null values because of gaps in elevation raster. Select these and calculate only those to 0
![[Pasted image 20260423204901.png]]

Negative RiseMeters means downhill, 0 means flat, and positive means uphill
![[Pasted image 20260423205113.png]]

Add Double field SlopePct to store slope percent values
![[Pasted image 20260423205320.png]]

Calculate SlopePct = !RiseMeters! / !LenMeters! * 100
![[Pasted image 20260423210218.png]]

A few will be Null if there's missing geometry. I set the SlopePct and LenMeters to 0 for these. Deleting them might be OK
![[Pasted image 20260423205632.png]]

Symbology can be assigned to SlopPct to see what results look like. Whether slope is negative or positive depends on direction the line segment was originally drawn
![[Pasted image 20260423210503.png]]

Every downhill is also an uphill in the other direction, and vice versa. We need to double up every road segment. 

Export the entire HI_Roads to a new feature class called HI_Roads_Flip in the same Feature Dataset
![[Pasted image 20260423211023.png]]

Calculate RoadID = !RoadID! + 1,000,000 to make the unique key different from the original HI_Roads
![[Pasted image 20260423211352.png]]

![[Pasted image 20260423211535.png]]

Run Flip Line on HI_Roads_Flip to reverse the direction of all those lines
![[Pasted image 20260423211740.png]]

Create new Double fields to store inverted numbers: FlipStartZ, FlipEndZ, FlipRiseMeters, FlipSLopePct
![[Pasted image 20260423212220.png]]

Calculate into new fields. FlipStartZ gets populated with original EndZ, FlipEndZ gets original StartZ. RiseMeters and SlopePct are multiplied by -1
![[Pasted image 20260423212359.png]]
![[Pasted image 20260423212515.png]]
![[Pasted image 20260423212545.png]]
![[Pasted image 20260423212631.png]]

Now HI_Roads_Flip has its own opposite values to match flipped line direction
![[Pasted image 20260423212856.png]]

Create new text field 32 char long in both layers called Version to make it easier to track which roads are original and which are flipped
![[Pasted image 20260424091713.png]]

![[Pasted image 20260424091857.png]]

Calculate flipped values (negative or start and end switched) back to original fields. I deleted these before because I forgot I would need them again, so I had to re-add!
![[Pasted image 20260424093122.png]]

![[Pasted image 20260424092409.png]
![[Pasted image 20260424092614.png|312]]
![[Pasted image 20260424092730.png|264]]![[Pasted image 20260424092911.png|280]]

Now HI_Roads_Flip attribute table should look like this
![[Pasted image 20260424093325.png]]

Flip temp fields can be deleted or hidden
![[Pasted image 20260424093356.png]]


Create new Feature Dataset in the FlowSimNet.gdb geodatabase called DoubledRoads_DS. Set coordinate system to the same UTM Zone 4N as before. New FDS helps with keeping things tidy[[Pasted image 20260424103524.png]]

![[Pasted image 20260424103719.png]]

Merge HI_Roads and HI_Roads_Flip to a new dataset within DoubledRoads_DS. Check that every field exists for both input layers indicated by (2). Add source info to output is optional because we already created a Version field identifying which set each feature comes from. Field length errors are a mystery because everything matches
![[Pasted image 20260424103958.png]]

Click Edit and open Field Properties to check and change field types but this shouldn't be needed
![[Pasted image 20260424104338.png]]


DoubledRoads contains every road with both original drawn direction and flipped direction, with appropriate rise and slope numbers
![[Pasted image 20260424105432.png]]

Some road segments have 0 slope but doubling is still important because having both directions allows network analysis methods to "flow" either way
![[Pasted image 20260424105727.png]]![[Pasted image 20260424110420.png]]


Graduated Colors and Advanced Symbology can be used to show 0 slope values separately
![[Pasted image 20260424114342.png|410]]
![[Pasted image 20260424114823.png|697]]

Check for null geometry by creating a new len_test field and calculating length. If nulls seem to not be actual roads, they can be deleted
![[Pasted image 20260424144051.png]]

For easier display and symbology, create a Double field cdalled AbsSlopePct and calculate absolute slope values (all positive) using abs(!SlopePct!) ![[Pasted image 20260424172013.png]]


## Create Network Dataset!!!

Right click the Feature Dataset that contains the doubled roads, right click-> new -> Network Dataset
![[2026April24_174927_899_kvQR.png]]

Choose DoubledRoads as the source feature class and set No Elevation (that's for road connectivity eg bridges being separate from surface roads). Name the new network dataset Doubled_Network
![[Pasted image 20260424175152.png]]

Right click the new layer Doubled_Network and choose Build
![[2026April24_175358_893_KIVk.png]]

![[Pasted image 20260424180211.png]]

Remove Doubled_Network layer from table of contents so it can be edited
![[2026April24_181920_448_nthb.png]]

Right click Doubled_Network in ArcCatalog and open properties
![[2026April24_181657_406_Mlib.png]]

Click Travel Attributes tab on left, then Restrictions tab on upper right. Click menu icon on top right and choose New+
![[2026April24_182011_186_8IHP.png]]

Set name to SlopBlock with Usage type -1, then add parameter called MaxSlope type double with default value 1 (1% slope uphill is the upper limit). Because it's a parameter, it can be changed easily later and set to 0%, 2%, 0.5%, or whatever value
![[Pasted image 20260424182940.png]]

in Evalulators section set Type to Field Script then click script icon to edit the script. Put in `!SlopePct! > MaxSlope`
![[Pasted image 20260427141022.png]]
![[Pasted image 20260427141057.png]]

Restriction of flow in only the direction of each road segment is possible but not necessary because of how the network evaluator works

Right click on the network with the squiggle and choose **Build**
![[2026April26_205110_430_GRE0.png]]



Doubled_Network will show up in table of contents
![[Pasted image 20260426211230.png]]

Open Analysis tab, then click Network Analysis tile and choose Closest Facility. This tool lets us set neighborhood collection points as "facilities" and parcel centroids as "incidents". The names for the features are based on more common uses like calculating the closest hospital to take a patient to
![[ed2026April26_211439_103_dMKO.png]]

Open properties for Closest Facilities layer, go to Travel Mode tab on left, open Restrictions, and check SlopeBlock
![[Pasted image 20260426211918.png]]

Add neighborhood collection points and parcel centroids to map
![[Pasted image 20260426212840.png]]

Go to Closest Facility Layer ribbon and select Import Facilities
![[Pasted image 20260426213054.png]]

Make sure everything is in UTM 4N Meters
![[Pasted image 20260426214611.png]]

Choose ObjectID as field name or another unique value field. Enable Snap to Network and 0m snap which will put every point on the road network
![[Pasted image 20260426213309.png]]

Run time depends on number of points
![[Pasted image 20260426213351.png]]



**ALTERNATE RESTRICTION METHOD**

Create new short integer field called Restrict_Slope and calculate value like this:
`1 if !SlopePct! > max_slope else 0`
![[Pasted image 20260427150929.png|690]]![[Pasted image 20260427152222.png]]

Create network dataset using the doubled roads and then set up restrictions

For (Along) use Field Script and set value to 1
For (Against) use Constant and set value to True
![[Pasted image 20260427185428.png]]



Build
![[Pasted image 20260427154051.png]]

Every road is doubled and should be traversable one way and prohibited the other way, or for gentle slops traversable both ways
![[Pasted image 20260427154358.png]]


Create Closest Facility layer and make sure restriction is enabled
![[Pasted image 20260427154832.png]]

Add neighborhood collection point locations
![[Pasted image 20260427155006.png]]

Select parcel points or OSDS by cluster polygons
![[Pasted image 20260427155726.png]]

Import Incidents and choose selected centroids or OSDS
![[Pasted image 20260427155924.png]]



![[Pasted image 20260427161234.png]]

Now there are both facilities for collection points and incidents for parcels
![[Pasted image 20260427161753.png]]

Run the solve
![[Pasted image 20260427161832.png]]

Results should look like this where each collection point gets a "tree" pattern of roads flowing into it by gravity, but areas that aren't 100% downhill to the collection point are excluded
![[Pasted image 20260427200540.png]]

Select by Location the remaining parcel points that don't intersect with one of the gravity routes we just generated
![[Pasted image 20260427202516.png]]

Export these non-gravity TMK points. The location doesn't matter much but I put them into the same feature dataset as the network
![[Pasted image 20260427202755.png]]

Create a new Service Area (not closest facility) analysis layer from the network and add the non-gravity points as **facilities**
![[Pasted image 20260427203136.png]]

![[Pasted image 20260427203209.png]]

Make sure to enable the restriction in properties for the Service Area layer
![[Pasted image 20260427203737.png]]

Set a "service area" distance in meters. This is the distance that lines will be drawn outward from TMK points to visualize where flow can go from each of them. 1000m is usually a good value but may need to be further depending on the area
![[Pasted image 20260427203535.png]]

Display as arrows to see flow direction. These indicate possible Neighborhood Pump Station locations. IE flow can go down, then get pumped back up to the "gravity" lines ![[Pasted image 20260427204503.png]]

