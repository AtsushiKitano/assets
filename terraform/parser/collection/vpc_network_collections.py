import pandas as pd
from .resource_collections import ResourceCollections

import sys
sys.path.append('../')
from object.project_object import VPCNetworkObject
from object.project_object import SubnetworkObject
from object.project_object import FirewallObject

class VPCNetworkCollections(ResourceCollections):
    def __init__(self,path):
        super().__init__(path)
        self.__file_path = super().get_file_path(path,'vpc_network.csv')
        self.__collections = pd.read_csv(self.__file_path)
        self.__networks = self.create_vpc_network_objects()


    def create_vpc_network_objects(self):
        networks = []
        for index,item in self.__collections.iterrows():
            networks.append(VPCNetworkObject(item['name'],item['project']))
        return networks

    @property
    def networks(self):
        return self.__networks

class SubnetworkCollections(ResourceCollections):
    def __init__(self,path):
        super().__init__(path)
        self.__file_path = super().get_file_path(path,'subnetwork.csv')
        self.__collections = pd.read_csv(self.__file_path)
        self.__subnetworks = self.create_subnetwork_objects()

    def create_subnetwork_objects(self):
        subnetworks = []
        for index, item in self.__collections.iterrows():
            subnetworks.append(SubnetworkObject(item['name'],item['project'],item['vpc_network'],item['cidr'],item['region']))
        return subnetworks

    @property
    def subnetworks(self):
        return self.__subnetworks

class FirewallCollections(ResourceCollections):
    def __init__(self,path):
        super().__init__(path)
        self.__file_path = super().get_file_path(path,'firewall.csv')
        self.__collections = pd.read_csv(self.__file_path)
        self.__firewalls = self.create_fw_objects()

    def create_fw_objects(self):
        firewalls = []
        for index, item in self.__collections.iterrows():
            firewalls.append(FirewallObject(item['name'],item['network'],item['project'],item['direction'],item['tags'],item['ranges'],item['priority'],item['rules_type'],item['rules_protocol'],item['rules_ports']))
        return firewalls

    @property
    def firewalls(self):
        return self.__firewalls
