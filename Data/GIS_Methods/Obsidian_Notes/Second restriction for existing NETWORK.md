
Add Restriction called Downhill in addition to the existing SlopeBlock
![[Pasted image 20260506203559.png]]****

Set usage type to -1. Set (Along) to Field Script with !SlopePct! >= 0 which will block flow if slope is flat or even slightly uphill.
Set (Against) t o True which will always block flow. This prevents flow from going backward and circumventing the restriction.
![[Pasted image 20260506203951.png]]

Build the network again
![[Pasted image 20260506204151.png]]

When an analysis is created from the network, make sure only one of the restrictions is enabled
![[Pasted image 20260506210907.png]]


Previous routing to collection points already done.... Remainder NONGRAVITY parcels can be loaded as facilities in service area network with DownhillOnly restriction
![[Pasted image 20260507112655.png]]