from socket import *
import sys

class Webhook:
  def __init__(self):
    self.data = []

  def start(self):
    print "Starting webhook listen server"
    self.server = socket(AF_INET, SOCK_STREAM)
    self.server.bind(("", 17010))
    self.server.listen(5)
    print "Webhook listening..."

    conn, addr = self.server.accept()
    print "Connection from: " + addr.client_address[0]

    conn.close()

def main():
  print "foo"
  wh = Webhook()
  wh.start()

if __name__ == '__main__':
  sys.exit(main())