import json

def output_json(dict_data,output_file):
    with open(output_file, 'w') as output_path:
        json.dump(dict_data, output_path)
