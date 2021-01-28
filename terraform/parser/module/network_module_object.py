import vpc_network_collections as nw

class NetworkMobuleObject():
    def __init__(self,path):
        self.__vpc_network_collections = nw.VPCNetworkCollections(path)
        self.__subnetwork_collections = nw.SubnetworkCollections(path)
        self.__firewall_collections = nw.FirewallCollections(path)

    @property
    def network_module_object(self):

