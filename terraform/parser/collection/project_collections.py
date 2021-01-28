import pandas as pd
import pathlib
from resource_collections import ResourceCollections

class ProjectCollections(ResourceCollections):
    def __init__(self,path):
        super().__init__(path)
        self.file_path = pathlib.Path(self.path + '/project.csv').resolve()
        self.__collections = pd.read_csv(self.file_path)

    @property
    def collections(self):
        return self.__collections
