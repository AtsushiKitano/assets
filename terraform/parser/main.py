import pathlib
from collection import vpc_network_collections as nw
from collection2module_object import network_parser as np
from output import json_output as jo

input_path="./input"
output_path="../gcp/samples/files/network_object.json"

vpc_nw = nw.VPCNetworkCollections(input_path)
subnet = nw.SubnetworkCollections(input_path)
fw = nw.FirewallCollections(input_path)
network_object = np.parse_network_object(vpc_nw.networks,subnet.subnetworks,fw.firewalls)
jo.output_json(network_object,pathlib.Path(output_path).resolve())
