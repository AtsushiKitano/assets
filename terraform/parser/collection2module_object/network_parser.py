def parse_network_object(networks,subnetworks,firewalls):
    network_objects = []
    for nw in networks :
        network_object = {}
        network_object["name"] = nw.name
        network_object["project"] = nw.project
        network_object["subnetworks"] = []
        network_object["firewalls"] = []

    for subnet in subnetworks:
        if subnet.vpc_network == network_object["name"] and subnet.project == network_object["project"]:
            sb = {}
            sb["name"] = subnet.name
            sb["cidr"] = subnet.cidr
            sb["region"] = subnet.region
            network_object["subnetworks"].append(sb)

    for firewall in firewalls:
        if firewall.vpc_network == network_object["name"] and firewall.project == network_object["project"]:
            fw = {}
            fw["name"] = firewall.name
            fw["priority"] = firewall.priority
            fw["direction"] = firewall.direction
            fw["ranges"] = firewall.ranges
            fw["tags"] = firewall.tags
            fw["rules"] = firewall.rules
            network_object["firewalls"].append(fw)

    network_objects.append(network_object)

    return network_objects
