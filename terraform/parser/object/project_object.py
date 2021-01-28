class ProjectObject():
    def __init__(self,name,project):
        self.__project = project
        self.__name = name

    @property
    def project(self):
        return self.__project

    @property
    def name(self):
        return self.__name

class VPCNetworkObject(ProjectObject):
    def __init__(self,name,project):
        super().__init__(name,project)

class SubnetworkObject(ProjectObject):
    def __init__(self,name,project,vpc_network,cidr,region):
        super().__init__(name,project)
        self.__region = region
        self.__cidr = cidr
        self.__vpc_network = vpc_network

    @property
    def region(self):
        return self.__region

    @property
    def cidr(self):
        return self.__cidr

    @property
    def vpc_network(self):
        return self.__vpc_network

class FirewallObject(ProjectObject):
    def __init__(self,name,network,project,direction,tags,ranges,priority,rules_type,rules_protocol,rules_ports):
        super().__init__(name,project)
        self.__direction = direction
        self.__tags = str(tags).split(" ")
        self.__ranges = str(ranges).split(" ")
        self.__priority = priority
        self.__rules_type = rules_type
        self.__rules_protocol = rules_protocol
        self.__rules_ports = rules_ports
        self.__rules = self.set_rules()
        self.__vpc_network = network

    @property
    def direction(self):
        return self.__direction

    @property
    def tags(self):
        return self.__tags

    @property
    def ranges(self):
        return self.__ranges

    @property
    def priority(self):
        return self.__priority

    @property
    def rules(self):
        return self.__rules

    @property
    def vpc_network(self):
        return self.__vpc_network

    def set_rules(self):
        rules = []
        rule = {
            "type" : self.__rules_type,
            "protocol" : self.__rules_protocol,
            "ports" : self.__rules_ports.split(" ")
        }
        rules.append(rule)
        return rules
