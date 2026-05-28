This process creates routes from NPS points to previously generated gravity routes

Create Closest Facility Analysis and don't set any restriction
![[Pasted image 20260511190150.png]]

Select street nodes (points where 1, 3, or more street segments meet) using gravity routes
![[Pasted image 20260511191128.png]]

Export these selected nodes
![[Pasted image 20260511191205.png]]

Import these nodes as facilities for the Closest Facility analysis
![[Pasted image 20260511191706.png]]
![[Pasted image 20260511194221.png]]

Load the terminal nodes as incidents. I'm using filtered ones because I have a definition query for NOT NULL
![[Pasted image 20260511194449.png]]


Ready to solve
![[Pasted image 20260511194640.png]]

![[Pasted image 20260511194704.png]]


Now we have pressure lines from NPS to gravity flow areas
![[Pasted image 20260511194751.png]]

HPMS nodes that are actually used would be a useful dataset. The routes to these nodes store their destination as a text field but it's combined with the source name. Eg:
![[Pasted image 20260513155609.png]]

So we have to make a new field and calculate just the destination into them. We might as well also make a source field:
![[Pasted image 20260513155713.png]]

Calculate TMK source with code
`!Name!.split(" - ")[0]`

Calculate Node destination with code
`!Name!.split(" - ")[1]`

![[Pasted image 20260513164723.png]]
![[Pasted image 20260513164759.png]]


