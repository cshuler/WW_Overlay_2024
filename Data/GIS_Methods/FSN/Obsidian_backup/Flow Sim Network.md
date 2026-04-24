
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