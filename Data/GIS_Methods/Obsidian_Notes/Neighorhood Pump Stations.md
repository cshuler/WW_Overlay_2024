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

Generate start points
![[Pasted image 20260430182221.png]]

Create text field called LINEPOS and calculate value as "START"
![[Pasted image 20260430184535.png]]

Do same for END points
![[Pasted image 20260430184150.png]]

Calculate LINEPOS value to "END"
![[Pasted image 20260430184915.png]]

Use **merge** tool to combine start and end points
![[Pasted image 20260430185132.png]]

Every small segment of routes emanating from parcels will have both a start and end
![[Pasted image 20260430185554.png]]

Add STARTCOUNT and ENDCOUNT fields with type Long integer
![[Pasted image 20260430185846.png]]

Select all where LINEPOS = 'START'
![[Pasted image 20260430190016.png]]

Calculate those to 1s and 0s
![[Pasted image 20260430190045.png]]
![[Pasted image 20260430190557.png]]
Switch the selection and do the opposite for the end points
![[Pasted image 20260430191012.png]]

Use Collect Events to combine coincident points
![[Pasted image 20260501140817.png]]

Spatial Join both Start and End points back to "collected" points with appropriately named join count fields

![[Pasted image 20260501141844.png]]

Spatial join will take a long time. The result shows points with no out-flow as 0 start points, in other words no flow line is starting at those locations
![[Pasted image 20260501151124.png]]

Examples of points with 0 starting flows
![[Pasted image 20260501154220.png]]


Additional analyses can be done. Eg. lengths of gravity and nongravity sections can be calculated as lengths and then added up within clusters
![[Pasted image 20260501182155.png]]

![[Pasted image 20260501182854.png]]


Or cluster IDs can be assigned to flow segments using Spatial Join and calculating UIDs into a new field
![[Pasted image 20260501185315.png]]
![[Pasted image 20260501184735.png]]

