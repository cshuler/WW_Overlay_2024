Prerequisites:
Road network without slope restriction (or restriction turned off for analysis)
Sewer main line data
Neighborhood collection points

Load existing sewer main network (no laterals) to ArcGIS Pro
![[Pasted image 20260429165750.png]]

Use Feature Vertices to Points tool to generates points at **all vertices** of the existing sewer lines
![[Pasted image 20260429165921.png]]

![[Pasted image 20260429170113.png]]

Load previously created road network. We don't need slope restrictions because we just need to generate paths but those can be disabled without rebuilding the network
![[Pasted image 20260429170601.png]]

Load neighborhood collection points (manually drawn at low points that make sense)
![[Pasted image 20260429170919.png]]

Create a Closest Facility analysis
![[2026April29_171204_428_L9X3.png]]

Import Facilities and choose the sewer main line vertices (that will let the existing sewers act as destinations for flow). 
![[Pasted image 20260429172100.png]]

Enable Snap to Network with 0m offset
![[Pasted image 20260429172211.png]]

It will take a long time because there are so many points
![[Pasted image 20260429172316.png]]

![[Pasted image 20260429173427.png]]

Load neighborhood collection points as Incidents
![[Pasted image 20260429173645.png]]

![[Pasted image 20260429173731.png]]

Make sure SlopeBlock is disabled
![[Pasted image 20260429205728.png]]

Run to solve the network!



Conveyance line starts can be turned into points to enable easier spatial joins back to clusters
![[Pasted image 20260501171545.png]]

Spatial join on Closest with a distance limiter so only actual path starts will work
![[Pasted image 20260501172104.png]]

