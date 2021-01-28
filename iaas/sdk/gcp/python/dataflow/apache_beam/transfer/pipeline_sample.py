import re
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions

def run():
    pipeline_options = PipelineOptions([
        '--runner=DirectRunner'
    ])

    print(pipeline_options)

    with beam.Pipeline(options=pipeline_options) as p:
        lines = (p
                 | beam.Create([
                     'cat dog cow, wolf',
                     'cat dog bear'
                 ]))
        print(lines)

if __name__ == '__main__':
    run()
