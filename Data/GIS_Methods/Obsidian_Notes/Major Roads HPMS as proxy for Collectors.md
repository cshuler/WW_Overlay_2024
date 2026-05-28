HPMS roadways available from state geoportal
https://geoportal.hawaii.gov/datasets/d90ec964a6a54cb397a58a584243f3ab_12/explore?location=19.650892%2C-155.149027%2C13

Download and use Feature Vertices to Points to generate points to act as collection points
![[Pasted image 20260508171153.png]]


Use Collect Events to combine coincident points
![[Pasted image 20260508172226.png]]

HPMS lines are messy and don't always meet at intersections. One way to get cleaner points is to compute start/end vertices of all roads and then select those within a certain distance of the HMPS roads. Tried 2 meter but excludes some that are offset
![[Pasted image 20260508172627.png]]

10m is OK
![[Pasted image 20260508172940.png]]
![[Pasted image 20260508173128.png]]![[Pasted image 20260508175622.png]]

Export to geodatabase
![[Pasted image 20260508180046.png]]

Create Closest Facility analysis layer and enable SlopeBlock restriction (flow allowed downhill and up to 1% uphill)
![[Pasted image 20260508181123.png]]

Load the street nodes close to HPMS as the facilities
![[Pasted image 20260508181220.png]]

Load TMK centroids with 0m snapping so they all snap directly to the network. The search tolerance can be reduced to 1000m to exclude the huge parcels
![[Pasted image 20260508182656.png]]


![[Pasted image 20260508182304.png]]


Loading takes a long time. Parcel points and collection points should all be snapped to network. Then you can Solve
![[Pasted image 20260508184752.png]]

It should take about 20 minutes 
![[Pasted image 20260508190759.png]]


Result will be lines created between parcels and the main roads in places where they can flow downhill or where uphill slope is up to 1%
![[Pasted image 20260508194751.png]]

Select the facilities that intersect routes so these can be extracted for future use as generated Neighborhood Collection Points





Select the remaining "incidents" using the previously created paths and "invert spatial relationship". This selects the ones that don't align with downhill flow paths to main roads
![[Pasted image 20260508194919.png]]

Export the selected incidents to a new feature layer. I use the term "nongravity" for these because they can't rely only on gravity flow
![[Pasted image 20260511132535.png]]

![[Pasted image 20260511132800.png]]

Export the gravity ones too so they can be used later
![[Pasted image 20260511134917.png]]

Hawai'i Island example-- Large areas aren't downhill or slightly uphill (1% slope) to allow gravity only to main roads. These places would be conducive to building large centralized pump stations or new treatment facilities
![[Pasted image 20260511142024.png]]


## Next step is to calculate flow paths from these NONGRAVITY points to neighorhood pump stations

New method: Use roadway nodes as destinations for network analysis. Nodes can be created by generating start/end vertices of all road segments. There will be many coincident points. Get rid of ones where 2 road segments meet because these aren't true nodes. If 3 or more roads meet, that's an intersection, or if a road terminates there is only 1 point. These are true nodes
![[Pasted image 20260511152629.png]]


Create a Service Area analysis and load nodes as facilities. A short search and no snap should work because these are already aligned with the network. But enabling snap can't hurt
![[Pasted image 20260511153123.png]]

Set cutoff to 1 meter
![[Pasted image 20260511153902.png]]

Set restriction to DownhillOnly
![[Pasted image 20260511153944.png]]

Run the analysis. This will create outgoing lines from every Node but only downhill
![[Pasted image 20260511154343.png]]

![[Pasted image 20260511154404.png]]

![[Pasted image 20260511154500.png]]


Select nodes that don't intersect with any flow lines. These are "sinks" that flow can't go out of, IE good NPS locations
![[Pasted image 20260511154630.png]]

Export to new feature class. I use the name "Terminal" to describe these nodes
![[Pasted image 20260511154750.png]]

We can already get a sense of sites for NPS
![[Pasted image 20260511155850.png]]

Create a Closest Facility analysis layer, load Terminal Nodes as facilities
![[Pasted image 20260511160808.png]]
![[Pasted image 20260511160907.png]]

Set restriction to SlopeBlock. This is the restriction that allows flow downhill, on flat segments, and slightly uphill at 1% grade
![[Pasted image 20260511161025.png]]

Load NONGRAVITY points as incidents
![[Pasted image 20260511161118.png]]
![[Pasted image 20260511161132.png]]


Ready to run
![[Pasted image 20260511161449.png]]

![[Pasted image 20260511161651.png]]


The paths generated should make sense
![[Pasted image 20260511162434.png]]

Each line has a FacilityID assigned
![[Pasted image 20260511165952.png]]

The facility name is a unique identifier because we used objectID when added them to the analysis. In the routes layer we need to extract these IDs in order to count them
![[Pasted image 20260511171354.png]]

Make a new field in the Routes layer to store just the facility names
![[Pasted image 20260511172025.png]]


Python code for field calc:
`!Name!.split(" - ")[1]`

![[Pasted image 20260511172121.png]

![[Pasted image 20260511172157.png]]

![[Pasted image 20260511172222.png]]

Use Summary Statistics to compute number of lines corresponding to each terminal node

![[Pasted image 20260511172420.png]]

![[Pasted image 20260511172443.png]]

Join the counts to the terminal nodes
![[Pasted image 20260511172610.png]]

Only some terminal nodes should have corresponding counts. In this case about half. The others are unused
![[Pasted image 20260511172736.png]]

Once joined they can be used for labels
![[Pasted image 20260511173238.png]]

Some parcel points are still excluded because the path to an NPS candidate site is too steep uphill, IE greater than 1% grade so gravity sewer can't be built. We can select those by using an inverse select by location
![[Pasted image 20260512114853.png]]

These can be exported for future reference
![[Pasted image 20260512115227.png]]

OOPS
There are some points that don't have a route to the NPS because they're at the same location, eg at the tip of a dead end. these need to be selected too. Probably easier to use a full set of TMKs and assign values with additional fields