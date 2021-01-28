import pathlib

class ResourceCollections():
    def __init__(self, path):
        self.path = path

    def get_file_path(self,path,file_name):
        return pathlib.Path(self.path + '/' + file_name).resolve()
