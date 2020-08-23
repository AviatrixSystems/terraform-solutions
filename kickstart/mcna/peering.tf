### AWS <--> Azure transit peering.
resource "aviatrix_transit_gateway_peering" "aws_azure" {
  transit_gateway_name1 = var.aws_transit_gateway.name
  transit_gateway_name2 = var.azure_transit_gateway.name
  depends_on            = [aviatrix_transit_gateway.azure_transit_gw, aviatrix_transit_gateway.aws_transit_gw]
}
