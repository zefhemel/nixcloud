import pika

class Queue(object):
    def __init__(self):
        self.connection = pika.BlockingConnection()
        self.channel = self.connection.channel()
        self.declare_queues()

    def declare_queues(self):
        self.channel.queue_declare(queue='activate')

    def publish(self, queue_name, body):
        self.channel.basic_publish(exchange='', routing_key=queue_name, body=body)

    def receive_loop(self, queue_name, callback):
        self.channel.basic_consume(callback, queue=queue_name)
        self.channel.start_consuming()
