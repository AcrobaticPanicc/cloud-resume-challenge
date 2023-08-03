import unittest
from unittest.mock import patch
from main import app


class TestCloudRunIntegration(unittest.TestCase):

    def setUp(self):
        app.testing = True
        self.client = app.test_client()

    @patch('main.requests.get')
    def test_hello_endpoint(self, MockGet):
        MockGet.return_value.text = '5'

        response = self.client.get('/hello')
        self.assertEqual(response.data.decode(), '5')


if __name__ == '__main__':
    unittest.main()
