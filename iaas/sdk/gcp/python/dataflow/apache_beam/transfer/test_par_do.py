from unittest import TestCase

import apache_beam as beam
from apache_beam.testing.test_pipeline import TestPipeline
from apache_beam.testing.util import assert_that, equal_to

class ComputeWordLength(beam.DoFn):

    def __init__(self):
        super(ComputeWordLength, self).__init__()

    def process(self, element):
        yield len(element)

class TestParDo(TestCase):

    def test_par_do(self):
        expected = [5,4,7,7,5]

        inputs = ['Alice', 'Bob', 'Cameron', 'Daniele', 'Ellen']

        with TestPipeline() as p:
            actual = (p
                      | beam.Create(inputs)
                      | beam.ParDo(ComputeWordLength()))

            assert_that(actual, equal_to(expected))
