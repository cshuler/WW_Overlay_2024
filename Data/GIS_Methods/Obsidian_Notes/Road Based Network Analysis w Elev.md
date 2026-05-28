
Road Network statewide -> 
extract start and end point for each segment w unique ID common to roads -> 
assign raster elevations to start and end points using Extract Multi Values to Poiints  ->
join start and end point elevations back to roads using unique ID ->
FLIP all roads where start point elev < end point elev -> result is all downhill or flat ->
Copy all roads to new layer ->
flip all roads ->
merge original roads and flipped roads -> now every road goes both ways

Roads come from state geoportal

Datasets combined with common name field and reprojected to UTM 4N because planar makes calculations easier

HI_Z_Simple_EndV

most fields deleted

new fields
RdSgInt long integer calculated from objectID
RdName 64 char calculated from FullName
RdIsland assigned based on island K, O, M, H, Mo, L

min_z lowest elevation for each segment
max_z highest elevation for each segment

maybe not useful just reference ^

next steps

**Feature Vertices to Points generate Start vertices**
HI_Z_Simple_StartV

arcpy.management.FeatureVerticesToPoints(
    in_features="HI_Z_Simple",
    out_feature_class=r"C:\GIS\Act217\WWOL_4\WWOL_4.gdb\HI_Z_Simple_StartV",
    point_location="START"
)

**Feature Vertices to Points generate End vertices**
HI_Z_Simple_EndV

arcpy.management.FeatureVerticesToPoints(
    in_features="HI_Z_Simple",
    out_feature_class=r"C:\GIS\Act217\WWOL_4\WWOL_4.gdb\HI_Z_Simple_EndV",
    point_location="END"
)


**New fields for StartV and EndV**
StartZ and EndZ



**Add Surface Information Z to StartV and EndV**

arcpy.ddd.AddSurfaceInformation(
    in_feature_class="HI_Z_Simple_StartV",
    in_surface="USGS_ALL_HI_DEM_UTM4N.tif",
    out_property="Z",
    method="BILINEAR",
    sample_distance=None,
    z_factor=1,
    pyramid_level_resolution=0,
    noise_filtering=""
)

arcpy.ddd.AddSurfaceInformation(
    in_feature_class="HI_Z_Simple_EndV",
    in_surface="USGS_ALL_HI_DEM_UTM4N.tif",
    out_property="Z",
    method="BILINEAR",
    sample_distance=None,
    z_factor=1,
    pyramid_level_resolution=0,
    noise_filtering=""
)


**Calculate new Z fields into StartZ and EndZ created before**

arcpy.management.CalculateField(
    in_table="HI_Z_Simple_StartV",
    field="StartZ",
    expression="!Z!",
    expression_type="PYTHON3",
    code_block="",
    field_type="TEXT",
    enforce_domains="NO_ENFORCE_DOMAINS"
)

arcpy.management.CalculateField(
    in_table="HI_Z_Simple_EndV",
    field="EndZ",
    expression="!Z!",
    expression_type="PYTHON3",
    code_block="",
    field_type="TEXT",
    enforce_domains="NO_ENFORCE_DOMAINS"
)



**Join point Z values back to road segments**


arcpy.management.JoinField(
    in_data="HI_Z_Simple",
    in_field="RdSegInt",
    join_table="HI_Z_Simple_StartV",
    join_field="RdSegInt",
    fields="StartZ",
    fm_option="NOT_USE_FM",
    field_mapping=None,
    index_join_fields="NO_INDEXES"
)

arcpy.management.JoinField(
    in_data="HI_Z_Simple",
    in_field="RdSegInt",
    join_table="HI_Z_Simple_EndV",
    join_field="RdSegInt",
    fields="EndZ",
    fm_option="NOT_USE_FM",
    field_mapping=None,
    index_join_fields="NO_INDEXES"
)

**New field in HI_Z_Simple roads attribute table**
Incline

If StartZ > EndZ = Downhill
If StartZ < EndZ = Uphill
If  StartZ = End = Flat

**Flip direction of all UPHILL road segments.** 
IE all high ends become start so every road segment is downhill or flat. This means the direction of each segment is always downhill which will allow restricting network analysis to only allow downhill "flow"

**Select "Uphill" and then...**
`arcpy.edit.FlipLine(`
    `in_features="HI_Z_Simple"`
`)`

**Switch StartZ and EndZ using temporary fields** and field calculator

**New fields for length just in case needed**
LenM LenFt
`(!StartZ! - !EndZ!) / !LenM! * 100`

**Double up road segments that allow flow both ways (flat)**
Select all with Incline = Flat 
or use SlopePct = 0

Export to new feature class
Run Flip Line on the new feature class
`arcpy.edit.FlipLine(`
    `in_features="HI_Z_Simple_Flat_Roads"`
`)`

Recalculate Incline field in new feature class to "FlippedDoubler"

Append new feature class back to main HI_Z_Simple feature class



**Create new network dataset.... Complicated and difficult**

New file geoDB
New Feature Dataset with UTM 4N coord system
Import HI_Z_Simple to Feature Dataset
Right click on FD and choose New -> Network Dataset
Select Hi_Z_Simple and turn OFF elevation

In Catalog right click Network Dataset and **choose BUILD**

Now network almost ready

**Set direction restriction**

Right click ND in catalog and choose Properties

Go to Travel Attributes -> Restrictions tab

Click three bars, NEW +
Choose a name like Downhill

Edges (Along) set to Constant and False
Edges (Against) set to Constant and True

This makes restrictions work only against flow direction

![[Pasted image 20260421203144.png]]

**Create Closest Facility Analysis Layer**
Go to Analysis tab at top
Look for Workflows ribbon
Select dropdown on big Network Analysis icon
Choose Closest Facility


**Import facilities and incidents**
Click new Closest Facility Tab

On left use Import Facilities to add **WWTP** OR **Collection Points at neighborhood exits**
Snap to network with **0 meter** so they go directly to centerlines

Use Import Incidents to add cesspools (in this case TMK centroids)
Snap to network with 0 meter so they go directly to centerlines

**Enable Restriction in Closest Facility Analysis Layer**
Right click Closest Facility in TOC, properties
Travel Mode item on left
Expand Restrictions
Check "DownHillOnly" restriction

**Run**
On Closest Facility Tab Ribbon, click Run to generate the routes

***Now there are paths going from parcel points downhill to collection points***

**Analyze paths from remaining TMKs**

Create ***service area layer*** and enable same direction restriction as before

Select TMK points that do NOT intersect with existing flow paths
Add these remaining TMK points as "facilities"
Set max distance like 1000m or whatever makes sense so lines don't go forever
Set restriction to the SAME as the Closest Facility so flow only goes **downhill**

***Now there are flow lines coming out from the remaining points so you can see where they converge and where they dead end, IE places to put NPS***



