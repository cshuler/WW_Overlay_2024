Input data:
Same network as neighborhood analysis
Statewide sewer main nodes
HPMS (main roads) nodes that have neighborhood flow going to them

Statewide mains dissolve dataset -> Multipart to Singlepart (lines segmented where they meet) -> Feature Vertices to points START + END points
![[Pasted image 20260514141419.png]]

Gravity routes from parcels to HPMS with source and destination values separated
![[Pasted image 20260514143003.png]]

HPMS nodes with original name field (generated from original ObjectID)
![[Pasted image 20260514143133.png]]

Join on name field and destination field
![[Pasted image 20260514144106.png]]


Start points for conveyances can be actual collection points. But that can get complex if there are multiple. Simpler method is using centroids of clusters
![[Pasted image 20260514195656.png]]

Closest Facility analysis with no restrictions will generate shortest routes from centroids to existing sewer nodes
![[Pasted image 20260514195939.png]]

Load existing sewer nodes as facilities
![[Pasted image 20260514200052.png]]

Import cluster centroids as incidents with UID as the Name
![[Pasted image 20260514200947.png]]


Run the analysis to generate routes
![[Pasted image 20260514200708.png]]

The resulting lines have a name with the source and destination name separated by " - "
![[Pasted image 20260514201136.png]]

The routes must be exported and a new field added to store the relevant UID part of the Name
![[Pasted image 20260514202021.png]]

Code to split the combined Name by " - " and use the first (0th) value:
`!Name!.split(" - ")[0]` 

For the second value:
`!Name!.split(" - ")[1]`

![[Pasted image 20260514202236.png]]

Calculate lengths
![[Pasted image 20260514203605.png]]

