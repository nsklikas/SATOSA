import logging

from .base import RequestMicroService


logger = logging.getLogger(__name__)


class RequestedAttributesAdder(RequestMicroService):

    def __init__(self, config, *args, **kwargs):
        """
        :param config: mapping from requester identifier to
        backend module name under the key 'requester_mapping'
        :type config: Dict[str, Dict[str, str]]
        """
        super().__init__(*args, **kwargs)
        self.mapping = config['attributes_mapping']

    def process(self, context, data):
        """
        Will modify the context.target_backend attribute based on the requester
        identifier.

        :param context: request context
        :param data: the internal request
        """
        for attr in data.attributes:
            if attr in self.mapping:
                data.attributes.extend(self.mapping[attr])

        return super().process(context, data)
