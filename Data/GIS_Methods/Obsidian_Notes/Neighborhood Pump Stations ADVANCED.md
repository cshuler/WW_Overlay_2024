
**Current process**

Elements:
network with flow restricted to downhill, flat, and uphill to a max of 1% slope
parcel centroids
neighborhood collection points (usually big intersections at exits)

A)
closest facility tool to route from parcel centroids to collection points with restriction (downhill or slight uphill only)

this generates a set of flow lines and a set of gravity served parcels


B)
select remaining parcel points from A

service area tool to route outwards from these parcels to a limited distance of 1000m

C)
Generate vertex end points and dissolve those to get rid of duplicates. these are potential pump station locations



**Alternate method**
Elements:
network with flow restricted to downhill, flat, and uphill to a max of 1% slope
parcel centroids
neighborhood collection points (usually big intersections at exits)
all street intersections where 3 streets meet, or dead ends. IE degree >= 3 and degree =1 (2 is excluded because that's just where any 2 segments meet)

A) same

B) select remaining parcel points from A

location-allocation tool to route from those parcel points to intersection/dead end points

should find optimal set of NPS locations


How to do it:

Use Feature Vertices to Points tool on roads to generate start/end points of road segments. With Hawai'i state data all intersections are endpoints, and long roads are made up of shorter segments that each has a start and end
![[Pasted image 20260506125207.png]]

![[Pasted image 20260506131051.png]]

Number of overlapping points correspond to number of roads that connect at each node
![[Pasted image 20260506131218.png]]

![[Pasted image 20260506131352.png]]

Where road segments connect there are 2 points. So 2 overlapping points means there's not really a node, it's just where a new segment begins!
![[Pasted image 20260506131433.png]]

We need to use the Collect Events tool to consolidate points and get a count of the original features so we can exclude the "twos". The Dissolve tool won't work for this because it doesn't generate counts
![[Pasted image 20260506133523.png]]

ICOUNT field stores count of vertices that were "collected" into each new one
![[Pasted image 20260506133636.png]]

Select points where ICLOUD is not equal to 2
![[Pasted image 20260506133832.png]]

Export the selection, now there is a set of nodes that represent only intersections and dead ends
![[Pasted image 20260506134018.png]]


Load already-created network into new ArcGIS Pro tab, select in TOC, and create a new Location-Allocation 
![[2026May06_141319_889_0Ow1.png]]

Enable the SlopeBlock restriction so that flow is only allowed downhill, on flat segments, and up to 1% uphill slope
![[Pasted image 20260506141519.png]]

Analysis methods:
![[2026May06_151446_719_s7jo.png]]


Import road nodes (NO TWOS) to Facilities
![[Pasted image 20260506151637.png]]

Import NONGRAVITY parcel points as Demand Points
![[Pasted image 20260506153934.png]]

Run "Solve"
![[Pasted image 20260506154126.png]]

