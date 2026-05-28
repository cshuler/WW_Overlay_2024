
Starting dataset is TMK centroids snapped to network

![[Pasted image 20260512121953.png]]

New fields
![[Pasted image 20260512122357.png]]

Select TMK points that intersect gravity flow to neighborhood collector
![[Pasted image 20260512122451.png]]

![[Pasted image 20260512125339.png]]

Switch selection and calculate 1s for Remainder
![[Pasted image 20260512132637.png]]

Select points using the flow lines from "remainder" points to NPS candidate locations
![[Pasted image 20260512142510.png]]

**Replace NULLS on the new fields with 0s making them essentially boolean yes/no as 1/0**
![[Pasted image 20260512153759.png]]


Select **Remainder** parcels that were not able to connect to neighborhood pump stations and calculate these to 1 in the **InaccToNPS** field
![[Pasted image 20260513103050.png]]

![[Pasted image 20260513103121.png]]

