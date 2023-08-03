import unittest
from unittest.mock import patch, Mock
from main import increment_visitor_count


class TestIncrementVisitorCount(unittest.TestCase):

    @patch('main.firestore.Client')
    def test_increment_visitor_count_first_time(self, MockClient):
        MockClient().collection().get.return_value = None

        result = increment_visitor_count(None)
        self.assertEqual(result, {"count": 1})

    @patch('main.firestore.Client')
    def test_increment_visitor_count_increment(self, MockClient):
        mock_doc = Mock()
        mock_doc.get.return_value = 5

        MockClient().collection().document().get.return_value = mock_doc

        result = increment_visitor_count(None)
        self.assertEqual(result, {"count": 6})


if __name__ == '__main__':
    unittest.main()
