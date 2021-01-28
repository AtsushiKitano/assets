import re
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions


def run():
    pipeline_options = PipelineOptions([
        '--runner=DirectRunner'
    ])

    with beam.Pipeline(options=pipeline_options) as p:
        lines = (p
                 | beam.Create([
                    'cat dog cow, wolf',
                    'cat dog bear',
                    'dog ape elephant']))

        def print_wc(word_count):
            (word, count) = word_count
            print(word, count)
            
        (lines
         | beam.FlatMap(lambda x: re.findall(r'[A-Za-z\']+', x))
         | beam.Map(lambda x: (x, 1))
         | beam.CombinePerKey(sum)
         | beam.Map(print_wc)
         )


if __name__ == '__main__':
    run()
